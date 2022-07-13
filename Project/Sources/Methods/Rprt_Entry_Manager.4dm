//%attributes = {}
//Method:  Rprt_Entry_Manager
//Description:  This method will manage buttons

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nBottom; $nLeft)
	C_LONGINT:C283($nMove; $nRight; $nTop)
	C_LONGINT:C283($nFormEvent)
	
	$nFormEvent:=Form event code:C388
	
End if   //Done Initialize

If ((Form:C1466.tReport_Key=CorektBlank) & ($nFormEvent=On Load:K2:1))  //New
	
	OBJECT SET VISIBLE:C603(Rprt_Entry_nDelete; False:C215)  //Delete not needed
	OBJECT GET COORDINATES:C663(Rprt_Entry_nDelete; $nLeft; $nTop; $nRight; $nBottom)
	$nMove:=$nRight-$nLeft
	OBJECT MOVE:C664(CorenCancel; $nMove; 0)
	
End if   //Done new

OBJECT SET ENABLED:C1123(Rprt_Entry_nSave; Rprt_Entry_VerifyB)
