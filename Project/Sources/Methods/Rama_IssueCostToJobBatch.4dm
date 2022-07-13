//%attributes = {}

// Method: Rama_IssueCostToJobBatch ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 01/12/15, 10:47:45
// ----------------------------------------------------
// Description
// look for shipments to rama and make sure that freight costs have been issued to job
// issue the amount that was put in-transit (FG:AV-@)
// ----------------------------------------------------

C_DATE:C307($date; $1)
C_DATE:C307($yearAgo; $today)
$today:=Current date:C33
$yearAgo:=Add to date:C393($today; -1; (-1*Month of:C24($today)); (-1*Day of:C23($today)))  //tack on a little extra
C_LONGINT:C283($i; $numElements)
C_BOOLEAN:C305($rtn; $needsIssue; RAMA_PROJECT)
RAMA_PROJECT:=CUST_isRamaProject(""; "")
If (Count parameters:C259=1)
	$date:=$1
Else 
	$date:=Date:C102(Request:C163("fg transactions from which date?"; String:C10(Current date:C33; System date short:K1:1)))
	$date:=!2014-12-29!  //debugging
	distributionList:="mel.bohince@arkay.com"
End if 

//Rama_Find_CPNs_On_Server ("client-side")  //populate aCPN so that it can be used in subquery below
// not needed: (SELECT distinct(productcode) from Customers_ReleaseSchedules where (Shipto='01666' or Shipto='02563') and Sched_Date >= :$yearAgo)
ARRAY TEXT:C222($aJobform; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY LONGINT:C221($aSkids; 0)
Begin SQL
	select jobform, sum(qty), count(Skid_number) from Finished_Goods_Transactions where XactionDate = :$date and Location like 'FG:AV-R%'
	group by jobform into :$aJobform, :$aQty, :$aSkids;
End SQL

$numElements:=Size of array:C274($aJobform)
If ($numElements>0)
	
	$reOpen:=""
	$issuesTo:=""
	//$date:=!01/02/2015!
	
	uThermoInit($numElements; "Issuing Freight")
	For ($i; 1; $numElements)
		If ($aQty{$i}>0)
			$jobform:=$aJobform{$i}
			$rtn:=Rama_IssueCostToJob("anticipate"; "mix"; $aQty{$i}; "Roanoke"; String:C10($aSkids{$i})+" skids"; $jobform; $date; "9999")
			
			$totalWant:=0  //get the want qty of the items on this job which appear to be PR bound
			Begin SQL
				select sum(Qty_Want) from Job_Forms_Items where JobForm = :$jobform and 
				ProductCode in (SELECT distinct(productcode) from Customers_ReleaseSchedules where (Shipto='01666' or Shipto='02563') and Sched_Date >= :$yearAgo)
				into :$totalWant
			End SQL
			
			$totalIssued:=0  // see what we've issued so far
			Begin SQL
				select sum(Qty) from Raw_Materials_Transactions where JobForm = :$jobform and  ReceivingNum = 9999 into :$totalIssued
			End SQL
			
			$percentIssued:=Round:C94(((-1*$totalIssued)/$totalWant*100); 1)
			$issuesTo:=$issuesTo+$jobform+"   "+String:C10($percentIssued; "#,##0.0 %")+Char:C90(13)
			
			SET QUERY DESTINATION:C396(Into variable:K19:4; $isClosed)
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform; *)  //reopen job if necessary?
			QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6="Closed")
			If ($isClosed>0)
				$reOpen:=$reOpen+$jobform+Char:C90(13)
			End if   //closed
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		End if   //qty>0
		uThermoUpdate($i)
	End for 
	uThermoClose
	
End if 

If (Length:C16($issuesTo)>0)
	xText:="Freight Issues made to the following jobs:"+Char:C90(13)+$issuesTo
	
	xText:=xText+Char:C90(13)+"Jobs that near 100% are candidates for closing."+Char:C90(13)
	If (Length:C16($reOpen)>0)
		xText:=xText+Char:C90(13)+"The following jobs should be reclosed:"+Char:C90(13)
	End if 
	
	EMAIL_Sender("Rama Issues on Transit"; ""; xText; distributionList)
End if 


//QUERY([Finished_Goods_Transactions];[Finished_Goods_Transactions]XactionDate=$date;*)
//QUERY([Finished_Goods_Transactions]; & ;[Finished_Goods_Transactions]Location="FG:AV-@")
//If (Records in selection([Finished_Goods_Transactions])>0)
//DISTINCT VALUES([Finished_Goods_Transactions]JobForm;$aJobforms)
//$numElements:=Size of array($aJobforms)
//
//uThermoInit ($numElements;"Processing Array")
//For ($i;1;$numElements)
//$needsIssue:=Rama_IssueCostToJob ("test";$aJobforms{$i})
//If ($needsIssue)
//QUERY([Job_Forms_Items];[Job_Forms_Items]JobForm=$aJobforms{$i})
//If (Records in selection([Job_Forms_Items])>0)
//$wantQty:=Sum([Job_Forms_Items]Qty_Want)
//If ($wantQty>0)
//$rtn:=Rama_IssueCostToJob ("anticipate";"allitems";$wantQty;"Roanoke";"all pallets";$aJobforms{$i};$date;"9999")
//End if 
//End if 
//End if 
//uThermoUpdate ($i)
//End for 
//uThermoClose 
//
//End if 

