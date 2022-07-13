//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/17/07, 16:54:53
// ----------------------------------------------------
// Method: BOL_ReleaseNumberEntered()  --> 
// Description
// find the inventory that can be used to fill a release
// if the release matches others on this bol
//
// ----------------------------------------------------

C_LONGINT:C283($numLocations; std_case_count; std_cases_skid; std_wgt_case; $1)
C_BOOLEAN:C305($doQuery)
C_TEXT:C284($r)
C_REAL:C285(pricePerM)  // Modified by: Mel Bohince (11/2/19) get the price once doing the search so declared value can be calc'd
pricePerM:=0  //will be used by Add to BOL# btn

$r:=Char:C90(13)

If (Count parameters:C259=1)
	release_number:=$1
End if 

If (release_number>0)
	$doQuery:=True:C214  //used to link a pre-entered pallet to a release
	
	If (Length:C16(pallet_id)>0)  //option to link release to pallet
		If (Size of array:C274(aLocation)>0)
			uConfirm("Are you shipping Skid# "+pallet_id+" against release "+String:C10(release_number); "Yes"; "No")
			If (OK=1)  //don't blow out pallet entered information
				$doQuery:=False:C215
			End if 
		End if 
	End if 
	
	If ($doQuery)  //otherwise the query was done by the pallet_id method
		pallet_id:=""
		
		If (BOL_AcceptableRelease(release_number))  //billto,dest,type and readiness of the release to ship on this bol
			pricePerM:=[Customers_Order_Lines:41]Price_Per_M:8
			
			$msg:="Release#: "+String:C10(release_number)+$r
			$msg:=$msg+"   "+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6; "#,###,###,##0")+" cartons "+$r
			$msg:=$msg+"   "+"Scheduled for "+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date abbreviated:K1:2)+$r
			
			$msg:=$msg+$r+"Enter number of cases, packing quantity, and weight per case."+$r
			$msg:=$msg+"Click 'Add to BOL#' to include on this shipment."+$r
			
			$numLocations:=BOL_PickRelease(release_number)
			
			//these will be used to validate input into the arrays
			std_case_count:=PK_getCaseCount(FG_getOutline([Customers_ReleaseSchedules:46]ProductCode:11))
			std_cases_skid:=PK_getCasesPerSkid(FG_getOutline([Customers_ReleaseSchedules:46]ProductCode:11))
			std_wgt_case:=PK_getWeightPerCase(FG_getOutline([Customers_ReleaseSchedules:46]ProductCode:11))
			max_ship_quantity:=[Customers_ReleaseSchedules:46]Sched_Qty:6
			If (std_case_count>0)
				Case of 
					: ([Customers_ReleaseSchedules:46]Sched_Qty:6<std_case_count)
						max_ship_quantity:=std_case_count
						
					Else 
						$whole_cases:=[Customers_ReleaseSchedules:46]Sched_Qty:6\std_case_count
						$partial_cases:=[Customers_ReleaseSchedules:46]Sched_Qty:6%std_case_count
						If ($partial_cases>0)
							max_ship_quantity:=($whole_cases*std_case_count)+std_case_count
						End if 
				End case 
				
			Else   //don't inforce, just warn
				max_ship_quantity:=max_ship_quantity*1.05  //allow a typical 5% overrun overship mlb 08/29/07
			End if 
			$msg:=$msg+"Standard Case Count = "+String:C10(std_case_count)+" cartons"+$r
			$msg:=$msg+"Standard Skid Count = "+String:C10(std_cases_skid)+" cases"+$r
			$msg:=$msg+"Standard Weight Per Case = "+String:C10(std_wgt_case)+$r
			$msg:=$msg+"Maximum Qty to Ship = "+String:C10(max_ship_quantity)+$r
			$msg:=$msg+"Suggested # Cases = "+String:C10(Round:C94(max_ship_quantity/std_case_count; 1))+$r
			util_FloatingAlert($msg)
			
			If ($numLocations>0)
				EDIT ITEM:C870(aNumCases; 1)
			End if 
			
		Else 
			REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
			release_number:=0
			GOTO OBJECT:C206(release_number)
		End if 
	End if 
End if 