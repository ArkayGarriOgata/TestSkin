//%attributes = {}
// _______
// Method: app_form_ListBox   ( ) ->
// By: Mel Bohince @ 04/23/20, 09:44:18
// Description
// 
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		
	: (Form event code:C388=On Selection Change:K2:29)
		Form:C1466.editEntity:=Form:C1466.clicked
		
	: (Form event code:C388=On Double Clicked:K2:5)
		If (Form:C1466.clicked#Null:C1517)
			Form:C1466.editEntity:=Form:C1466.clicked
			
			Form:C1466.noticeText:=app_form_Notice_Text(Form:C1466.noticeText_c; Form:C1466.editEntity)
			
			OBJECT SET ENABLED:C1123(*; "memberValidate1"; Form:C1466.editEntity.touched())  //only enable if change was made
			
			$openMulti:=OBJECT Get pointer:C1124(Object named:K67:5; "OpenMulti")
			If ($openMulti->=1)
				
				C_LONGINT:C283($winRef; $parentWinRef)
				$parentWinRef:=Current form window:C827  //for the call back
				
				$xy:=OpenFormWindowCoordinates("get")
				
				C_POINTER:C301($table_ptr)
				$table_ptr:=Table:C252(Form:C1466.masterTable)
				$winRef:=Open form window:C675($table_ptr->; Form:C1466.detailForm; Plain form window:K39:10; $xy.x; $xy.y)
				
				C_OBJECT:C1216($form_o)  //give the child some parental advice
				$form_o:=New object:C1471
				$form_o.ent:=Form:C1466.editEntity
				$form_o.list:=Form:C1466.listBoxEntities
				$form_o.listPosition:=Form:C1466.position
				$form_o.deleteAction:=Form:C1466.deleteAction  // or "delete" if you want the record deleted on user's perogative
				$form_o.noticeText_c:=Form:C1466.noticeText_c  //in case of navigating to another record
				$form_o.noticeText:=Form:C1466.noticeText  //give the child form its own copy of this
				$form_o.editorGroup:=Form:C1466.editorGroup
				
				$form_o.parentForm:=$parentWinRef  //call back is changes are saved
				
				DIALOG:C40($table_ptr->; Form:C1466.detailForm; $form_o; *)
				
			Else 
				FORM GOTO PAGE:C247(2)
			End if 
			
		Else 
			BEEP:C151
		End if 
		
End case 