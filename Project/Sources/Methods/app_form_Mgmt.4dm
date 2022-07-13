//%attributes = {}
// _______
// Method: app_form_Mgmt   ( ) ->
// By: Mel Bohince @ 04/23/20, 09:40:50
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (10/29/20) respect Form.windowTitle if defined
// Modified by: Mel Bohince (2/23/21) use Form.editEntity#Null instead of OB Is Empty

Case of 
	: (Form event code:C388=On Load:K2:1)
		Form:C1466.listBoxName:="ListBox1"
		C_TEXT:C284(editorGroup; noticeText)
		editorGroup:=Form:C1466.editorGroup
		
		If (User in group:C338(Current user:C182; editorGroup))
			OBJECT SET ENABLED:C1123(*; "member@"; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(*; "member@"; False:C215)
			OBJECT SET ENTERABLE:C238(*; "@"; False:C215)
		End if 
		
		OBJECT SET ENABLED:C1123(*; "memberValidate1"; False:C215)  //only enable if change was made, but you can delete
		
		If (OB Is defined:C1231(Form:C1466; "windowTitle"))  // Modified by: Mel Bohince (10/29/20) 
			SET WINDOW TITLE:C213(Form:C1466.windowTitle; Current form window:C827)
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Form:C1466.editEntity#Null:C1517)  //(Not(OB Is empty(Form.editEntity)))  //tried it both ways, #Null seems more robust
			
			If (User in group:C338(Current user:C182; editorGroup))
				OBJECT SET ENABLED:C1123(*; "member@"; True:C214)
				OBJECT SET ENABLED:C1123(*; "memberValidate1"; Form:C1466.editEntity.touched())  //only enable if change was made
			Else 
				OBJECT SET ENABLED:C1123(*; "member@"; False:C215)
			End if 
			
		Else   //null
			OBJECT SET ENABLED:C1123(*; "member@"; False:C215)
		End if   //null
		
End case 
