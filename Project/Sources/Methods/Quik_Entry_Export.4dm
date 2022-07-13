//%attributes = {}
//Method:  Quik_Entry_Export
//Description:  This method will export the query.4df and the quickreport.4qr

If (True:C214)  //Initialize
	
	C_TEXT:C284($tPathDesktop)
	
	C_OBJECT:C1216($oAsk)
	$oAsk:=New object:C1471()
	
	$tPathDesktop:=System folder:C487(Desktop:K41:16)
	
	$oAsk.tMessage:="Documents are on your desktop."
	
End if   //Done Initialize

BLOB TO DOCUMENT:C526($tPathDesktop+Quik_tEntry_Name+CorektPeriod+Corekt4DExtnQuery; Quik_lEntry_Query)

BLOB TO DOCUMENT:C526($tPathDesktop+Quik_tEntry_Name+CorektPeriod+Corekt4DExtnQuickReport; Quik_lEntry_QuickReport)

Core_Dialog_Alert($oAsk)
