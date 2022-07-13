//%attributes = {}

// Method: x_Rama_IssueCostToJobRetro ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 01/13/15, 15:07:51
// ----------------------------------------------------
// Description
// based on Rama_IssueCostToJobBatch
// look for shipments to rama and make sure that freight costs have been issued to job
// care is taken not to stack the cost when prior issues are found.
// look-back is July 2014
// ----------------------------------------------------


C_DATE:C307($date; $yearAgo)
$date:=!2014-07-01!  //this is when the .24 charge changed
$issueDate:=!2015-01-02!
$yearAgo:=!2014-07-01!
C_LONGINT:C283($i; $numElements)
C_BOOLEAN:C305($rtn; $needsIssue)
distributionList:="mel.bohince@arkay.com"

ARRAY TEXT:C222($aJobform; 0)  //this will be all the jobs that have made shipments to rama
ARRAY LONGINT:C221($aQty; 0)
ARRAY LONGINT:C221($aSkids; 0)
Begin SQL
	select jobform, sum(qty), count(Skid_number) from Finished_Goods_Transactions where XactionDate >= :$date and Location like 'FG:AV-R%'  
	group by jobform into :$aJobform, :$aQty, :$aSkids;
End SQL

$numElements:=Size of array:C274($aJobform)
If ($numElements>0)
	
	$reOpen:=""
	$issuesTo:=""
	uThermoInit($numElements; "Issuing Freight")
	For ($i; 1; $numElements)
		If ($aQty{$i}>0)
			$jobform:=$aJobform{$i}
			$testForClosed:=False:C215
			$flagIt:=""
			
			$totalPriors:=0  // see what we've issued so far
			Begin SQL
				select sum(Qty) from Raw_Materials_Transactions where JobForm = :$jobform and Raw_Matl_Code = 'RAMA Freight' into :$totalPriors
			End SQL
			$totalPriors:=$totalPriors*-1  //issues are negative so flip it for this comparison
			If ($totalPriors>0)  //some freight has been issued
				$qtyToIssue:=$aQty{$i}-$totalPriors
				If ($qtyToIssue>0)  //but not enough for new way, so issue the balance 
					$rtn:=Rama_IssueCostToJob("anticipate"; "balance"; $qtyToIssue; "Roanoke"; String:C10($aSkids{$i})+" skids"; $jobform; $issueDate; "9999")
					$testForClosed:=True:C214
					$flagIt:="+"  //marker for the email
				End if 
				
			Else   //no prior issues
				$rtn:=Rama_IssueCostToJob("anticipate"; "mix-retro"; $aQty{$i}; "Roanoke"; String:C10($aSkids{$i})+" skids"; $jobform; $issueDate; "9999")
				$testForClosed:=True:C214
			End if 
			
			If ($testForClosed)  //not sure if anyone really cares, but last chance to know
				SET QUERY DESTINATION:C396(Into variable:K19:4; $isClosed)
				QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform; *)  //don't touch closed jobs
				QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6="Closed")
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				If ($isClosed>0)  //found to be closed
					//$reOpen:=$reOpen+$jobform
					$flagIt:=$flagIt+"closed"  //marker for the email
				End if 
			End if 
			
			$totalWant:=0  //get the want qty of the items on this job which appear to be PR bound
			Begin SQL
				select sum(Qty_Want) from Job_Forms_Items where JobForm = :$jobform and 
				ProductCode in (SELECT distinct(productcode) from Customers_ReleaseSchedules where (Shipto='01666' or Shipto='02563') and Sched_Date >= :$yearAgo)
				into :$totalWant
			End SQL
			
			$totalIssued:=0  // see what we've issued so far, can't use receiving number = 9999 'cause old way used the bol# there
			Begin SQL
				select sum(Qty) from Raw_Materials_Transactions where JobForm = :$jobform and Raw_Matl_Code = 'RAMA Freight' into :$totalIssued
			End SQL
			
			$percentIssued:=Round:C94(((-1*$totalIssued)/$totalWant*100); 1)
			$issuesTo:=$issuesTo+$jobform+"   "+String:C10($percentIssued; "#,##0.0 %")+" "+$flagIt+Char:C90(13)
			
			
			
		End if   //qty>0
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	If (Length:C16($issuesTo)>0)
		xText:="Freight Issues made to the following jobs:"+Char:C90(13)+$issuesTo
		
		xText:=xText+Char:C90(13)+"Jobs that near 100% are candidates for closing."+Char:C90(13)
		//If (Length($reOpen)>0)
		//xText:=xText+Char(13)+"The following jobs may need to be reclosed:"+Char(13)+$reOpen
		//End if 
		
		EMAIL_Sender("Rama Issues on Transit Retro"; ""; xText; distributionList)
	End if 
	
End if 