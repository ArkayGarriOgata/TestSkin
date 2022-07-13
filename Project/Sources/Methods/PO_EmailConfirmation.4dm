//%attributes = {}
// Method: PO_EmailConfirmation () -> 
// ----------------------------------------------------
// by: mel: 11/25/03, 15:41:24
// ----------------------------------------------------
// Description:
// email that the po has been confirmed

C_TEXT:C284(distributionList; $body; $subject; $from)
C_TEXT:C284($t; $cr)

$t:=Char:C90(9)
$cr:=Char:C90(13)

distributionList:=""

If ([Purchase_Orders:11]ConfirmingOrder:29)
	If (Not:C34(Old:C35([Purchase_Orders:11]ConfirmingOrder:29)))
		$subject:="PO "+[Purchase_Orders:11]PONo:1+" Confirmed (Req "+[Purchase_Orders:11]ReqNo:5+")"
		distributionList:=Email_WhoAmI("initials"; [Purchase_Orders:11]ReqBy:6)+$t  //+"mel.bohince@arkay.com"+$t
		//distributionList:="mel.bohince@arkay.com"+$t
		$body:="Your Requisition "+[Purchase_Orders:11]ReqNo:5+" has been confirmed."+$cr
		$body:=$body+"Vendor: "+[Purchase_Orders:11]VendorName:42+$cr
		$body:=$body+"Required: "+String:C10([Purchase_Orders:11]Required:27; System date short:K1:1)+$cr
		$body:=$body+"Shipto: "+[Purchase_Orders:11]ShipTo2:35+$cr
		$body:=$body+"ConfirmedDate: "+String:C10([Purchase_Orders:11]ConfirmingDate:24; System date short:K1:1)+$cr
		$body:=$body+"ConfirmedBy: "+[Purchase_Orders:11]ConfirmingBy:23+$cr
		$body:=$body+"ConfirmedTo: "+[Purchase_Orders:11]ConfirmingTo:22+$cr
		$body:=$body+"Confirming Notes: "+[Purchase_Orders:11]ConfirmingNotes:25+$cr
		$body:=$body
		$from:=Email_WhoAmI
		EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
		//zwStatusMsg ("EMail";"MAD change has been sent to "+distributionList)
	End if 
End if 