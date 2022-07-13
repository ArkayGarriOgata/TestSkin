//%attributes = {"publishedWeb":true}
//uJobCostsNew
//  based on uGetJobCosts3
//•1/28/97 cs - speed processing of report(s) using this procedure
//  ◊aOrdKey - custid+":"+CPN, other ◊aOrd arrays filled in BatchOrdCalc
//  ◊aFgKey - custid+":"+CPN, and qty_Fg & qty_CC arrays filled in BatchFgInventor
//  al1 - FgOn hand qty for excess from rCostInvtRpt
//  aJobFrmItem - Jobform+job form item in Fg_loc filled in rCostInvtRpt
//  arNum1 - percent yeild from fg_loc filled in rCostInvtRpt
//  $11 - Pointer to CPN ID field
//  $12 - pointer to Cust ID field
//•072998  MLB  use actual costs if job is closed

// ******* Verified  - 4D PS - January  2019 ********
//this method need to be rewrited
// ******* Verified  - 4D PS - January 2019 (end) *********

C_POINTER:C301($1; $2; $3; $4; $5; $6; $7; $8; $9; $10; $11; $12)  //•1/31/97 added parameters 11 & 12
C_REAL:C285($thousand; $yield)
C_LONGINT:C283($openDemand; $onHandFG; $i; $OrdIndex; $FgIndex; $FgLocOnHand; $FgLocIndex)
C_TEXT:C284($FgKey)
C_TEXT:C284($CurrentCPN)
C_TEXT:C284($CurrentCust)

$CurrentCPN:=$11->  //Finished goods fields
$CurrentCust:=$12->
$FGKey:=$CurrentCust+":"+$CurrentCPN  //fgKey for lookups

$OrdIndex:=Find in array:C230(<>aOrdKey; $FGKey)  // lookup fgKey in Orderline roll up array (see BatchOrdCalc)
If ($OrdIndex>0)  //if there was an occurance of fgKey in orderline array
	$OpenDemand:=<>aQty_Open{$OrdIndex}+<>aQty_ORun{$OrdIndex}  //get open quantty & amount of over run
Else   //no element in orderline array zero quantities open/overrun
	$OpenDemand:=0
End if 

$FgIndex:=Find in array:C230(<>aFgKey; $FGKey)  //locate fgkey in Finished goods arrrays
If ($FgIndex>0)  //if the fgkey exists get  quantities
	$OnHandFg:=<>aQty_Fg{$FgIndex}+<>aQty_CC{$FgIndex}  //add onhand qtys for CC,FG populled in BatchFGINventor     
Else   //zero onhand quanntities
	$OnHandFg:=0
End if 
$openDemand:=$openDemand-$OnHandFG

$FgLocIndex:=Find in array:C230(aFgKey; $FgKey)  //find fgkey in FG Locations arrays
If ($FgLocIndex>0)  //if t was found locate JobMakeItem record(s) pending production
	$fBuild:=False:C215
	For ($i; 1; Size of array:C274(aFgKey))
		Case of 
			: ($FgLocIndex+1>Size of array:C274(aFgKey))  //no next item in array
				If ($fBuild)  //if we have found those JMIs for the current FgKey, close built search selection
					QUERY SELECTION:C341([Job_Forms_Items:44];  | ; [Job_Forms_Items:44]JobForm:1=Substring:C12(aJobFrmItem{$FgLocIndex}; 1; 8))
				Else   //search JMI file for the specific job/item recorded in Fg_Location
					QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=Substring:C12(aJobFrmItem{$FgLocIndex}; 1; 8); *)
					QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ItemNumber:7=Num:C11(Substring:C12(aJobFrmItem{$FgLocIndex}; 9)))
				End if 
				$i:=Size of array:C274(aFgKey)+1  //exit for loop        
			: (aFgKey{$FgLocIndex+1}=$Fgkey)  //next item in array is same fgkey, different jobit
				If ($fBuild)  //if we have found those JMIs for the current FgKey, build search selection
					QUERY SELECTION:C341([Job_Forms_Items:44];  | ; [Job_Forms_Items:44]JobForm:1=Substring:C12(aJobFrmItem{$FgLocIndex}; 1; 8); *)
				Else   //locate all jmis for this fgkey & start a build search selection for fg_location 
					QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]CustId:15=$CurrentCust; *)
					QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=$CurrentCpn)
					QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=Substring:C12(aJobFrmItem{$FgLocIndex}; 1; 8); *)
				End if 
				$fBuild:=True:C214
				$fgLocIndex:=$FgLocIndex+1  //do next fg_loc record
			Else   //Fgkey changes, close search
				If ($fBuild)  //if we have found those JMIs for the current FgKey, close built search selection
					QUERY SELECTION:C341([Job_Forms_Items:44];  | ; [Job_Forms_Items:44]JobForm:1=Substring:C12(aJobFrmItem{$FgLocIndex}; 1; 8))
				Else   //search JMI file for the specific job/item recorded in Fg_Location
					QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=Substring:C12(aJobFrmItem{$FgLocIndex}; 1; 8); *)
					QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ItemNumber:7=Num:C11(Substring:C12(aJobFrmItem{$FgLocIndex}; 9)))
				End if 
				$i:=Size of array:C274(aFgKey)+1  //exit for loop
		End case 
	End for 
End if 
C_LONGINT:C283($numJMI)
$numJMI:=Records in selection:C76([Job_Forms_Items:44])
ARRAY REAL:C219($aPldMat; $numJMI)  //move located JMIs into arrays
ARRAY REAL:C219($aPldLab; $numJMI)
ARRAY REAL:C219($aPldOhvd; $numJMI)
ARRAY LONGINT:C221($ajobItem; $numJMI)
ARRAY TEXT:C222($aJobForm; $numJMI)
ARRAY TEXT:C222($aCloseFlag; $numJMI)  //•072998  MLB  
If (<>UseActCost)  //•072998  MLB  
	For ($i; 1; $numJMI)
		$aJobForm{$i}:=[Job_Forms_Items:44]JobForm:1
		$aJobItem{$i}:=[Job_Forms_Items:44]ItemNumber:7
		If ([Job_Forms_Items:44]FormClosed:5)  //use the actual costs
			$aPldMat{$i}:=[Job_Forms_Items:44]Cost_Mat:12
			$aPldLab{$i}:=[Job_Forms_Items:44]Cost_LAB:13
			$aPldOhvd{$i}:=[Job_Forms_Items:44]Cost_Burd:14
			$aCloseFlag{$i}:="Closed"
		Else 
			$aPldMat{$i}:=[Job_Forms_Items:44]PldCostMatl:17
			$aPldLab{$i}:=[Job_Forms_Items:44]PldCostLab:18
			$aPldOhvd{$i}:=[Job_Forms_Items:44]PldCostOvhd:19
			$aCloseFlag{$i}:=""
		End if 
	End for 
	
Else   //old way  
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]PldCostMatl:17; $aPldMat; [Job_Forms_Items:44]PldCostLab:18; $aPldLab; [Job_Forms_Items:44]PldCostOvhd:19; $aPldOhvd; [Job_Forms_Items:44]JobForm:1; $aJobForm; [Job_Forms_Items:44]ItemNumber:7; $aJobItem)
End if 

For ($i; 1; Size of array:C274($aJobForm))  //for all JMIs found - sum up their quantities for report
	t3a:=t3a+"  "+$aJobForm{$i}+"."+String:C10($aJobItem{$i}; "00")+$aCloseFlag{$i}  //jobit
	
	$FgLocIndex:=Find in array:C230(aJobFrmItem; $aJobForm{$i}+String:C10($aJobItem{$i}))  //locate this specific JMI in Fg_locations  
	If ($FgLocIndex>0)  //something was found
		$yield:=arNum1{$FgLocIndex}/100  //get yield & on hand quantities
		$FgLocOnHand:=al1{$FgLocIndex}
	Else   //zero yield & onhand quantiites
		$Yeild:=0
		$FgLocOnHand:=0
	End if 
	
	//new here
	Case of 
		: ($openDemand<=0)  //none of this bin is valued
			$thousand:=($FgLocOnHand/1000)*$yield
			$6->:=$6->+($FgLocOnHand*$yield)
			$7->:=$7->+Round:C94($aPldMat{$i}*$thousand; 0)
			$8->:=$8->+Round:C94($aPldLab{$i}*$thousand; 0)
			$9->:=$9->+Round:C94($aPldOhvd{$i}*$thousand; 0)
			$openDemand:=$openDemand-($FgLocOnHand*$yield)
			
		: ($openDemand>=($FgLocOnHand*$yield))  //all of this bin is valued
			$thousand:=$FgLocOnHand/1000*$yield
			$1->:=$1->+($FgLocOnHand*$yield)
			$2->:=$2->+Round:C94($aPldMat{$i}*$thousand; 0)
			$3->:=$3->+Round:C94($aPldLab{$i}*$thousand; 0)
			$4->:=$4->+Round:C94($aPldOhvd{$i}*$thousand; 0)
			$openDemand:=$openDemand-($FgLocOnHand*$yield)
			
		: ($openDemand<($FgLocOnHand*$yield))  //some of this bin is valued
			
			$thousand:=$openDemand/1000
			$1->:=$1->+$openDemand
			$2->:=$2->+Round:C94($aPldMat{$i}*$thousand; 0)
			$3->:=$3->+Round:C94($aPldLab{$i}*$thousand; 0)
			$4->:=$4->+Round:C94($aPldOhvd{$i}*$thousand; 0)
			
			$thousand:=(($FgLocOnHand*$yield)-$openDemand)/1000
			$6->:=$6->+(($FgLocOnHand*$yield)-$openDemand)
			$7->:=$7->+Round:C94($aPldMat{$i}*$thousand; 0)
			$8->:=$8->+Round:C94($aPldLab{$i}*$thousand; 0)
			$9->:=$9->+Round:C94($aPldOhvd{$i}*$thousand; 0)
			
			$openDemand:=$openDemand-($FgLocOnHand*$yield)
			
		Else 
			BEEP:C151
			ALERT:C41("Error called by uGetJobCosts5, $openDemand test failed.")
	End case 
	//end new
	
End for 
$5->:=$5->+Round:C94($2->+$3->+$4->; 0)

If (Count parameters:C259>5)
	$10->:=$10->+Round:C94($7->+$8->+$9->; 0)
End if 
//