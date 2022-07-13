//%attributes = {}
//Method:  Help_Entr_Delete
//Description:  This method will delete a Help record

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($esHelp; $eHelp; $oStatus)
	C_OBJECT:C1216($oConfirm)
	
	C_TEXT:C284($tHelp; $tQuery)
	
	$esHelp:=New object:C1471()
	$eHelp:=New object:C1471()
	$oStatus:=New object:C1471()
	$oConfirm:=New object:C1471()
	
	$tHelp:=Table name:C256(->[Help:36])
	
	$tQuery:="Help_Key = "+Form:C1466.tHelp_Key
	
	$oConfirm.tMessage:="Do you want to delete"+CorektSpace+Form:C1466.tPathName+"?"
	
	$oConfirm.tDefault:="No"
	$oConfirm.tCancel:="Delete"
	
End if   //Done initialize

$esHelp:=ds:C1482[$tHelp].query($tQuery)

Case of   //Delete
		
	: ($esHelp.length#1)  //Unique
		
	: (Core_Dialog_ConfirmN($oConfirm)#CoreknCancel)
		
	Else   //Delete
		
		$eHelp:=$esHelp.first()
		
		$oStatus:=$eHelp.drop()
		
		Help_Entr_Initialize(CorektPhaseInitialize)
		
End case   //Done delete


