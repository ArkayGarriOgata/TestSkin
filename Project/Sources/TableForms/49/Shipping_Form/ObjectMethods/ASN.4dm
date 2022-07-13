// _______
// Method: [Customers_Bills_of_Lading].Shipping_Form.ASN   ( ) ->
// By: Mel Bohince @ 11/12/19, 09:33:22
// Description
// send asn by BOL#
// ----------------------------------------------------
// Modified by: Mel Bohince (2/15/20) prevent double asn'g

If ([Customers_Bills_of_Lading:49]WasBilled:29)
	$alreadyDone:=Position:C15("ASNs"; [Customers_Bills_of_Lading:49]DockAppointment:21)  // Modified by: Mel Bohince (2/15/20) prevent double asn'g
	If ($alreadyDone=0)
		$numberOfASNs:=EDI_AdvanceShipNotice([Customers_Bills_of_Lading:49]ShipDate:20; 0; [Customers_Bills_of_Lading:49]ShippersNo:1)
		[Customers_Bills_of_Lading:49]DockAppointment:21:="ASNs: "+String:C10($numberOfASNs)+" "+[Customers_Bills_of_Lading:49]DockAppointment:21
		SAVE RECORD:C53([Customers_Bills_of_Lading:49])
	Else 
		uConfirm("Appears ASN was already done, clear the 'ASNs' from the DockAppointment field to resend."; "Ok"; "Help")
	End if 
Else 
	uConfirm("This BOL needs to be billed before an ASN can be generated."; "Gotcha"; "Ok")
End if 


