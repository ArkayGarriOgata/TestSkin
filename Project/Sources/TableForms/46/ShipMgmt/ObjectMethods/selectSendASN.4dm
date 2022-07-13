// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.selectSendASN   ( ) ->
// By: Mel Bohince @ 10/14/20, 17:34:28
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (10/15/20) validate earliest pickup date
// Modified by: Mel Bohince (1/14/21) allow an epd of today, the rule is 24 hours before shipment, but hey...
//           the alternative could be a delayed shipment when the transit time can easily obsorb a few hours.
// Modified by: Mel Bohince (2/12/21) need to add a consolidation per asn

If (Form:C1466.selected.length>0)
	// Modified by: Mel Bohince (10/14/20) user specified epd
	C_DATE:C307(epd; $horizon)
	epd:=Add to date:C393(Current date:C33; 0; 0; 6)
	$horizon:=Add to date:C393(Current date:C33; 0; 0; 21)
	epd:=util_DateNotWeekend(epd)
	
	C_TEXT:C284($epd_t)
	$epd_t:=Request:C163("Earliest Pickup Date?"; String:C10(epd; System date short:K1:1); "Ok"; "Cancel")
	If (ok=1)
		epd:=Date:C102($epd_t)
		If (epd>=Current date:C33) & (epd<$horizon)  // Modified by: Mel Bohince (10/15/20) test date
			
			C_TEXT:C284(consolidationType)  // Modified by: Mel Bohince (2/12/21) need to add a consolidation per asn
			uYesNoCancel("How do you want this consolidated?\rPer ASN will use PO# and fractional pallet counts, \rParcel will leave blank and 0 pallets\rShipto will build a load with a number you choose."; "Per Shipto"; "Parcel"; "Per ASN")
			Case of 
				: (bAccept=1)
					consolidationType:="PerShipto"
				: (bNo=1)
					consolidationType:="Parcel"
				Else 
					consolidationType:="PerASN"  //canceled    
			End case 
			
			Form:C1466.listBoxEntities:=EDI_DESADV_get_PO_Calloffs("Send ASN"; Form:C1466.selected)
			Form:C1466.message:="ASN's sent for these PO's"
			asQueryTypes{0}:="Quick search..."
			OBJECT SET ENABLED:C1123(*; "select@"; False:C215)
			Release_ShipMgmt_calcFooters
			
		Else 
			uConfirm("Pickup must be greater than today and before "+String:C10($horizon); "Try again"; "Shucks")
		End if   //date check
		
	Else 
		BEEP:C151
	End if   //ok
	
Else 
	uConfirm("Please select the releases that should be considered."; "Ok"; "Help")
End if 