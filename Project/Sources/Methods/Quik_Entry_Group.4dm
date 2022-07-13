//%attributes = {}
//Method:  Quik_Entry_Group
//Description:  This method handles the Group popup

If (True:C214)  //Initialize
	
	C_TEXT:C284($tGroup)
	C_BOOLEAN:C305($bPushPopRecord)
	
	$tGroup:=Quik_atEntry_Group{Quik_atEntry_Group}
	
	$bPushPopRecord:=(Quik_tEntry_QuickKey#CorektBlank)
	
End if   //Done initialize

If ($bPushPopRecord)
	PUSH RECORD:C176([Quick:85])
End if 

QUERY:C277([Quick:85]; [Quick:85]Group:3=$tGroup)

Compiler_Quik_Array(Current method name:C684; 0)

DISTINCT VALUES:C339([Quick:85]Category:4; Quik_atEntry_Category)

If ($bPushPopRecord)
	POP RECORD:C177([Quick:85])
End if 

Quik_Entry_Manager