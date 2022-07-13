// _______
// Method: [MaintRepairSupply_Bins].ControlCenter   ( ) ->
// By: Mel Bohince @ 07/03/19, 15:52:02
// _______
// based on: app_form_Mgmt   ( ) ->
// By: Mel Bohince @ 04/23/20, 09:40:50
// Description
// 
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		Form:C1466.bin:=New object:C1471
		
		//Form.listBoxName:="ListBoxBins"
		C_OBJECT:C1216(masterClass; subClass)
		masterClass:=Form:C1466.masterClass
		subClass:=Form:C1466.subClass
		C_TEXT:C284(editorGroup; noticeText)
		editorGroup:=Form:C1466.editorGroup
		
		If (User in group:C338(Current user:C182; editorGroup))
			OBJECT SET ENABLED:C1123(*; "member@"; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(*; "member@"; False:C215)
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Form:C1466.bin#Null:C1517)
			
			If (User in group:C338(Current user:C182; editorGroup))
				OBJECT SET ENABLED:C1123(*; "member@"; True:C214)
				OBJECT SET ENABLED:C1123(*; "memberValidate1"; Form:C1466.bin.touched())  //only enable if change was made
			Else 
				OBJECT SET ENABLED:C1123(*; "member@"; False:C215)
			End if 
			
		Else   //null
			OBJECT SET ENABLED:C1123(*; "member@"; False:C215)
		End if   //null
		
End case 