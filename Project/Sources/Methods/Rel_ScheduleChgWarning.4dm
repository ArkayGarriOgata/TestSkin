//%attributes = {}

// Method: Rel_ScheduleChgWarning ( old_date;new_date )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 12/10/13, 10:39:42
// ----------------------------------------------------
// Description
// send email alert is a release scheduled within 
// the planning fence is delayed or has been brought in
// further refine based on inventory status
//
// ----------------------------------------------------
// Modified by: Mel Bohince (12/12/13) ignore if already shipped, buffer, forecast, or n/a shipto; don't tally invnetory if date is beyond planning fence
// Modified by: Mel Bohince (12/13/13) closed the query on line 40, daaa
// Modified by: Mel Bohince (12/18/13) only email if short, in dock or examinging


C_DATE:C307($old_date; $1; $new_date; $2; $planning_fence)
$old_date:=$1
$new_date:=$2
$planning_fence:=4D_Current_date  //+1
C_TEXT:C284($subject; $body; $from; $distribution_list)
$subject:=""

Case of   //decide whether to exclude
	: (True:C214)  //
		//skip, no one gives a shit
		
	: ([Customers_ReleaseSchedules:46]Shipto:10="N/A")  //skip to get buffer qty
	: ([Customers_ReleaseSchedules:46]Actual_Qty:8>0)  //skip already shipped
	: ([Customers_ReleaseSchedules:46]CustomerRefer:3="<F@")  //skip forcast
	: ([Customers_ReleaseSchedules:46]CustomerRefer:3="<b@")  //skip buffer
		
	Else 
		
		If ($old_date#$new_date)  //Schedule changed      //| ((Old([Customers_ReleaseSchedules]Shipto)="N/A") & ([Customers_ReleaseSchedules]Shipto#"N/A"))  & ($old_date#!00/00/00!) 
			//thought it was today or tomorrow
			If ($old_date<=$planning_fence) | ($new_date<=$planning_fence)
				
				//determine state of the inventory
				$qty_docked:=0
				$qty_onhand:=0
				$qty_xc:=0
				$qty_qa:=0
				
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11)
				SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aBin; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
				For ($i; 1; Size of array:C274($aBin))
					Case of 
						: ($aBin{$i}="FG:R_SHIPPED") | ($aBin{$i}="FG:V_SHIPPED")
							$qty_docked:=$qty_docked+$aQty{$i}
							
						: (Position:C15("FG"; $aBin{$i})>0)
							$qty_onhand:=$qty_onhand+$aQty{$i}
							
						: (Position:C15("XC"; $aBin{$i})>0)
							$qty_xc:=$qty_xc+$aQty{$i}
							
						Else   //cc?
							$qty_qa:=$qty_qa+$aQty{$i}
					End case 
				End for 
				
				distributionList:="mel.bohince@arkay.com"
				If ($qty_docked>0)
					//distributionList:=distributionList+"david.clapsaddle@arkay.com"
				End if 
				If ($qty_xc>0)
					//distributionList:=distributionList+"john.sheridan@arkay.com"
				End if 
				
				Case of 
					: ($old_date=!00-00-00!)  //not scheduled prior go easy
						If ($new_date<=$planning_fence)  //bang suprize
							If (($qty_onhand+$qty_xc)>=[Customers_ReleaseSchedules:46]Sched_Qty:6)
								$subject:=""  //"Rel Chg - Zero Day Lead--OK "+[Customers_ReleaseSchedules]ProductCode
							Else 
								$subject:="Rel Chg - Zero Day Lead--SHORT "+[Customers_ReleaseSchedules:46]ProductCode:11
								//distributionList:=distributionList+"Kristopher.Koertge@arkay.com"//"craig.bradley@arkay.com"
							End if 
						End if 
						
					: ($old_date<4D_Current_date)  //this was a missed release
						$subject:=""  //"Rel Chg - Try again "+[Customers_ReleaseSchedules]ProductCode
						
					: ($old_date<=$planning_fence)  //thought it was today or tomorrow
						If ($old_date<$new_date)
							If ($qty_docked>0)
								$subject:="Rel Chg - Delayed & Docked "+[Customers_ReleaseSchedules:46]ProductCode:11
							End if 
							If ($qty_xc>0)
								$subject:="Rel Chg - Delayed & Examining "+[Customers_ReleaseSchedules:46]ProductCode:11
							End if 
						End if 
						If ($old_date>$new_date)
							If (($qty_onhand+$qty_xc)<[Customers_ReleaseSchedules:46]Sched_Qty:6)
								$subject:="Rel Chg - Sooner Short "+[Customers_ReleaseSchedules:46]ProductCode:11
							End if 
							
						End if 
						
					: ($old_date>$planning_fence)  //thought it was the after tomorrow
						If ($new_date<=$planning_fence)  //moved into planning fence
							If (($qty_onhand+$qty_xc)<[Customers_ReleaseSchedules:46]Sched_Qty:6)
								$subject:="Rel Chg - Expedited Short "+[Customers_ReleaseSchedules:46]ProductCode:11
							End if 
						End if 
				End case 
				
				
				If (Length:C16($subject)>0)  //send an email
					$body:="Check release number: "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+" changed by "+<>zResp+". "
					
					$body:=$body+". Was: "+String:C10(Old:C35([Customers_ReleaseSchedules:46]Sched_Date:5); System date short:K1:1)+" Now: "+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+". "+Char:C90(13)
					$body:=$body+" Quantity released is "+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6)+Char:C90(13)
					$body:=$body+String:C10($qty_docked)+" in FG:?_SHIPPED, "+String:C10($qty_xc)+" in XC, "+String:C10($qty_onhand)+" Onhand, "+String:C10($qty_qa)+" CC"+Char:C90(13)
					//If (Old([Customers_ReleaseSchedules]Shipto)#[Customers_ReleaseSchedules]Shipto)
					//$body:=$body+". ShipTo was: "+Old([Customers_ReleaseSchedules]Shipto)+" Now: "+ADDR_getCity ([Customers_ReleaseSchedules]Shipto)+". "
					//End if 
					$from:=Email_WhoAmI
					EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
				End if 
				
			End if 
		End if   //schedule changed
		
		
End case 