//%attributes = {}
// _______
// Method: app_form_Detail   ( ) ->
// By: Mel Bohince @ 04/23/20, 09:42:37
// Description
// 
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)  //simulate being in the listbox mode
		Form:C1466.editEntity:=Form:C1466.ent
		Form:C1466.listBoxEntities:=Form:C1466.list
		Form:C1466.position:=Form:C1466.listPosition
		Form:C1466.noticeText:=app_form_Notice_Text(Form:C1466.noticeText_c; Form:C1466.editEntity)
		SET WINDOW TITLE:C213(Form:C1466.noticeText; Current form window:C827)
		
		editorGroup:=Form:C1466.editorGroup  // Modified by: Mel Bohince (5/12/20) 
		If (User in group:C338(Current user:C182; editorGroup))
			OBJECT SET ENABLED:C1123(*; "member@"; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(*; "member@"; False:C215)
			OBJECT SET ENTERABLE:C238(*; "@"; False:C215)
		End if 
		
		OBJECT SET ENABLED:C1123(*; "memberValidate1"; False:C215)  //only enable if change was made, but you can delete
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Form:C1466.editEntity#Null:C1517)
			
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
