//%attributes = {}
//Method:  Quik_Delete({tQuick_Key}{;tName})
//Description:  This method will delete 

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tQuick_Key)
	C_TEXT:C284($2; $tName)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nConfirmButton)
	
	C_TEXT:C284($tDelete)
	
	C_OBJECT:C1216($oAsk)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tQuick_Key:=CorektBlank
	$tName:="All"
	
	If ($nNumberOfParameters>=1)
		$tQuick_Key:=$1
		If ($nNumberOfParameters>=2)
			$tName:=$2
		End if 
	End if 
	
	$oAsk:=New object:C1471()
	
	$tDelete:=Choose:C955(($tQuick_Key=CorektBlank); \
		"all the quick reports?"; \
		"the quick report "+$tName+"?")
	
	$oAsk.tMessage:="Are you sure you want to delete "+$tDelete
	$oAsk.tDefault:="Cancel"
	$oAsk.tCancel:="Delete"
	
	$nConfirmButton:=Core_Dialog_ConfirmN($oAsk)
	
End if   //Done Initialize

If ($nConfirmButton=CoreknCancel)  //Delete
	
	UNLOAD RECORD:C212([Quick:85])
	
	READ WRITE:C146([Quick:85])
	
	If ($tQuick_Key=CorektBlank)
		
		ALL RECORDS:C47([Quick:85])
		
	Else 
		
		QUERY:C277([Quick:85]; [Quick:85]Quick_Key:1=$tQuick_Key)
		
	End if 
	
	DELETE SELECTION:C66([Quick:85])
	
	FLUSH CACHE:C297
	
	READ ONLY:C145([Quick:85])
	
End if   //Done delete