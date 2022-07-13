// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.oddOK   ( ) ->
// By: Mel Bohince @ 03/04/21, 07:32:56
// Description
//  waiver to allow odd lot (partial case) shipment on this PO
// ----------------------------------------------------
C_POINTER:C301($self)

$self:=OBJECT Get pointer:C1124(Object named:K67:5; "oddOk")  //less ambiguous than Self?

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Form:C1466.editEntity.UserDefined_1="odd-OK")
			$self->:=1
		Else 
			$self->:=0
		End if 
		
	: (Form event code:C388=On Clicked:K2:4)
		If ($self->=1)
			Form:C1466.editEntity.UserDefined_1:="odd-OK"
		Else 
			Form:C1466.editEntity.UserDefined_1:=""
		End if 
		OBJECT SET ENABLED:C1123(*; "memberValidate1"; True:C214)
End case 
