//%attributes = {}
//Method:  Vndr_Clairvoyance_VendorId(pVendor)
//Description:  This method will bring up a popup of vendors when a user is typing
//    to add a vendor

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pVendor)
	C_OBJECT:C1216($oClairvoyance)
	C_LONGINT:C283($nLeft; $nTop; $nRight; $nBottom)
	C_TEXT:C284($tChoice)
	C_TEXT:C284($tKey)
	
	$pVendor:=$1
	
	$tVendorID:=CorektBlank
	$tChoice:=CorektBlank
	
	OBJECT GET COORDINATES:C663($pVendor->; $nLeft; $nTop; $nRight; $nBottom)
	
	$oClairvoyance:=New object:C1471()
	
	$oClairvoyance.ptQueryValue:=$pVendor
	$oClairvoyance.tQueryMethodN:="Vndr_Query_NameN"
	$oClairvoyance.ptQueryField:=->[Vendors:7]Name:2
	$oClairvoyance.ptKeyField:=->[Vendors:7]ID:1
	$oClairvoyance.ptKeyFieldValue:=->$tVendorID
	$oClairvoyance.nLeft:=$nLeft
	$oClairvoyance.nTop:=$nTop
	$oClairvoyance.ptConcatenateField:=->[Vendors:7]ID:1
	
	READ ONLY:C145([Vendors:7])
	
End if   //Done Initialize

Case of   //Vendor
		
	: (Form event code:C388#On After Keystroke:K2:26)
	: ((Form event code:C388=On After Keystroke:K2:26) & (Character code:C91(Keystroke:C390)=Backspace:K15:36))
	: (Core_Clairvoyance_PopUpMenuT($oClairvoyance)=CorektBlank)
	: ($tVendorID=CorektBlank)
	: (Not:C34(Core_Query_UniqueRecordB(->[Vendors:7]ID:1; ->$tVendorID)))
		
	Else   //Vendor is loaded
		
		$pVendor->:=[Vendors:7]ID:1
		
		HIGHLIGHT TEXT:C210($pVendor->; Length:C16($pVendor->)+1; Length:C16($pVendor->)+1)
		
		PoVendorAssign
		
End case   //Done vendor
