//%attributes = {}
// -------
// Method: PS_PrintGoalGluing   ( ) ->
// By: Mel Bohince @ 11/10/16, 11:03:36
// Description
// see also PS_PrintGoal used as a model but GlueSchedule doesn't support same technique
// so put them in priority order and go out a week's worth of duration, see [Job_Forms_Items]GlueDuration.
// ----------------------------------------------------

C_LONGINT:C283($todayIs)
C_DATE:C307($sunday; $next_saturday; $pastSunday)
C_BOOLEAN:C305($showTP; $break)
C_LONGINT:C283($i; $numJMI; $hit; $totalCartons; $totalThruput)

$currentDate:=Current date:C33
//$weekFromNow:=Add to date($currentDate;0;0;6)
$hoursInWorkWeek:=(5*16)+0+0
//$currentDate:=!10/03/2016!

If (Count parameters:C259>=1)
	$group:=$1
	$showTP:=(Count parameters:C259=2)
Else 
	$group:="Gluing"
	$showTP:=False:C215
End if 

If (Current user:C182="Designer")
	//$showTP:=True
End if 

////////////
//$numJMI:=PSG_MasterArray ("load")
READ ONLY:C145([Job_Forms_Items:44])  // Modified by: Mel Bohince (5/6/15) was read write 
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!; *)  //get all the uncompleted items
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Gluer:47#"NOT"; *)  //see PSG_NotGlued
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Gluer:47#""; *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]GlueRate:52#0)

$numJMI:=PSG_MasterArray("size"; Records in selection:C76([Job_Forms_Items:44]))  //size it now so supplimental arrays are built at the same time

SELECTION TO ARRAY:C260([Job_Forms_Items:44]; aRecNum; [Job_Forms_Items:44]Gluer:47; aGluer; [Job_Forms_Items:44]Priority:48; aPrior; [Job_Forms_Items:44]ProductCode:3; aCPN; [Job_Forms_Items:44]Jobit:4; aJobit; [Job_Forms_Items:44]SubFormNumber:32; aSubForm; [Job_Forms_Items:44]CustId:15; aCustID; [Job_Forms_Items:44]Qty_Want:24; aQtyPlnd; [Job_Forms_Items:44]MAD:37; aHRD; [Job_Forms_Items:44]GlueStyle:51; aStyle; [Job_Forms_Items:44]OutlineNumber:43; aOutline; [Job_Forms_Items:44]Separate:49; aSeparate; [Job_Forms_Items:44]GluerComment:50; aComment; [Job_Forms_Items:44]GlueRate:52; aDurationHrs; [Job_Forms_Items:44]Cases:44; aCasesOrdered; [Job_Forms_Items:44]CasesMade:55; aCasesMade; [Job_Forms_Items:44]CashFlow:58; aCashFlow)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
////////////


////////////
//$numJMI:=PSG_MasterArray ("consolidate")
// PROBLEM: MAY NOT BE PRIORITY OR GLUER ON SECOND SUBFORM OF AN ITEM
// MAYBE CONSOLIDATE, THEN GO BACK AND MAKE SURE THE GLUER AND PRIORITY GETS PUT INTO THE ARRAYS
$sortOrder:=PSG_MasterArray("sort"; 6)
$lastJobit:="start"
For ($i; 1; $numJMI)  //Consolidate subforms and set up hashtable for cache of related tables
	//$checksum:=$checksum+aQtyPlnd{$i}
	If (aJobit{$i}="97920.02.10")
		
	End if 
	If (aJobit{$i}=$lastJobit)
		aQtyPlnd{$i-1}:=aQtyPlnd{$i-1}+aQtyPlnd{$i}
		aDurationHrs{$i-1}:=aDurationHrs{$i-1}+aDurationHrs{$i}
		aQtyPlnd{$i}:=0
		aDurationHrs{$i}:=0
	Else 
		$lastJobit:=aJobit{$i}
	End if 
	
	If (aHRD{$i}=!00-00-00!)
		aHRD{$i}:=<>MAGIC_DATE  //Move way out so they don't screw up the sorting
	End if 
End for   //consolidating subform qty's

//now clear out the ones that aren't needed after consolidation
$rtn:=PSG_MasterArray("sort"; 3)  //descending by planned qty
$hit:=Find in array:C230(aQtyPlnd; 0)
If ($hit>-1)
	$numJMI:=PSG_MasterArray("size"; ($hit-1))
End if 
$sortOrder:=PSG_MasterArray("sort"; 5)
////////////

$break:=False:C215
$totalCartons:=0
$totalThruput:=0
ARRAY TEXT:C222($aGluer; 0)
ARRAY LONGINT:C221($aNetSheets; 0)
ARRAY LONGINT:C221($aThruput; 0)
ARRAY REAL:C219($aHrsSoFar; 0)

uThermoInit($numJMI; "Updating Records")
For ($i; 1; $numJMI)
	If ($break)
		$i:=$i+$numJMI
	End if 
	
	
	If (aGluer{$i}="480")
		
	End if 
	
	If (ajobit{$i}="98195.08.42")
		
	End if 
	$hit:=Find in array:C230($aGluer; aGluer{$i})
	If ($hit=-1)
		APPEND TO ARRAY:C911($aGluer; aGluer{$i})
		APPEND TO ARRAY:C911($aNetSheets; aQtyPlnd{$i})
		APPEND TO ARRAY:C911($aThruput; aCashFlow{$i})
		APPEND TO ARRAY:C911($aHrsSoFar; aDurationHrs{$i})
		$totalCartons:=$totalCartons+aQtyPlnd{$i}
		$totalThruput:=$totalThruput+aCashFlow{$i}
	Else 
		
		Case of 
			: (($aHrsSoFar{$hit}+aDurationHrs{$i})<$hoursInWorkWeek)
				$aHrsSoFar{$hit}:=$aHrsSoFar{$hit}+aDurationHrs{$i}
				$aNetSheets{$hit}:=$aNetSheets{$hit}+aQtyPlnd{$i}
				$aThruput{$hit}:=$aThruput{$hit}+aCashFlow{$i}
				$totalCartons:=$totalCartons+aQtyPlnd{$i}
				$totalThruput:=$totalThruput+aCashFlow{$i}
				
			Else 
				$remainingHrs:=$hoursInWorkWeek-$aHrsSoFar{$hit}
				If ($remainingHrs>0)
					$portion:=$remainingHrs/aDurationHrs{$i}
					$cartonsPartial:=aQtyPlnd{$i}*$portion
					$tpPartial:=aCashFlow{$i}*$portion
					
					$aHrsSoFar{$hit}:=$aHrsSoFar+$remainingHrs
					$aNetSheets{$hit}:=$aNetSheets{$hit}+$cartonsPartial
					$aThruput{$hit}:=$aThruput{$hit}+$tpPartial
					$totalCartons:=$totalCartons+$cartonsPartial
					$totalThruput:=$totalThruput+$tpPartial
				Else 
					
				End if 
		End case 
		
	End if 
	
	uThermoUpdate($i)
End for 

uThermoClose

$tSubject:=$group+" Goal "+String:C10($totalCartons; "#,###,###,###")
$tBodyHeader:=$group+" Goal for "+String:C10($pastSunday; System date long:K1:3)+" to "+String:C10($next_saturday; System date long:K1:3)
$tBody:=""
$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$r:="</td></tr>"+Char:C90(13)
If ($showTP)
	$tBody:=$tBody+$b+"Gluer"+$t+"Cartons"+$t+"$Thru-put"+$r
Else 
	$tBody:=$tBody+$b+"Gluer"+$t+"Cartons"+$r
End if 
$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
SORT ARRAY:C229($aGluer; $aNetSheets; >)
For ($i; 1; Size of array:C274($aGluer))
	If ($showTP)
		$tBody:=$tBody+$b+$aGluer{$i}+$t+String:C10($aNetSheets{$i}; "###,###,###")+$t+String:C10($aThruput{$i}; "###,###,###")+$r
	Else 
		$tBody:=$tBody+$b+$aGluer{$i}+$t+String:C10($aNetSheets{$i}; "###,###,###")+$r
	End if 
End for 

$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"

If ($showTP)
	$tBody:=$tBody+$b+"Ttl"+$t+String:C10($totalCartons; "#,###,###,###")+$t+String:C10($totalThruput; "#,###,###,###")+$r
Else 
	$tBody:=$tBody+$b+"Ttl"+$t+String:C10($totalCartons; "#,###,###,###")+$r
End if 

If (Size of array:C274($aGluer)>0)
	//distributionList:=Email_WhoAmI// for testing
	Email_html_table($tSubject; $tBodyHeader; $tBody; 250; distributionList)
End if 
