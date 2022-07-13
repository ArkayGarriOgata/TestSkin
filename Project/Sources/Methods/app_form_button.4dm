//%attributes = {}
// _______
// Method: app_form_button   ( "theAction" {;multi-window-mode} ) ->
// By: Mel Bohince @ 04/15/20, 11:12:58
// Description
// record navigation on input forms
// ----------------------------------------------------
// Modified by: Mel Bohince (4/18/20) added app_form_save_if_modified
// Modified by: Mel Bohince (5/12/20) option to skip app_form_Refresh after change, coming from [PO]"input"
// Modified by: Mel Bohince (3/9/21) provide message if can't be saved

C_OBJECT:C1216($ent_e; $goto_e)
$ent_e:=New object:C1471

C_TEXT:C284($1; $2; $mode)  //existence of $2 changes mode from page2 input to free window
If (Count parameters:C259>1)  //single page mode, important for Delete, Cancel, and Save
	$mode:="multiple-window"
Else 
	$mode:="single-window"  // you're on page two showing a detail view
End if 

zwStatusMsg(Uppercase:C13($1); $mode)

Case of 
	: ($1="first")  //navigation
		app_form_Save_touched(Form:C1466.editorGroup)
		
		Form:C1466.editEntity:=Form:C1466.editEntity.first()
		Form:C1466.position:=1
		Form:C1466.noticeText:=app_form_Notice_Text(Form:C1466.noticeText_c; Form:C1466.editEntity)
		If ($mode="multiple-window")
			SET WINDOW TITLE:C213(Form:C1466.noticeText; Current form window:C827)
		End if 
		
	: ($1="previous")  //navigation
		If (Form:C1466.position>1)
			app_form_Save_touched(Form:C1466.editorGroup)
			Form:C1466.editEntity:=Form:C1466.editEntity.previous()
			Form:C1466.position:=Form:C1466.position-1
			Form:C1466.noticeText:=app_form_Notice_Text(Form:C1466.noticeText_c; Form:C1466.editEntity)
			If ($mode="multiple-window")
				SET WINDOW TITLE:C213(Form:C1466.noticeText; Current form window:C827)
			End if 
			
		Else   //don't want a null editEntity
			BEEP:C151
		End if 
		
	: ($1="next")  //navigation
		If (Form:C1466.position<Form:C1466.listBoxEntities.length)
			app_form_Save_touched(Form:C1466.editorGroup)
			Form:C1466.editEntity:=Form:C1466.editEntity.next()
			Form:C1466.position:=Form:C1466.position+1
			Form:C1466.noticeText:=app_form_Notice_Text(Form:C1466.noticeText_c; Form:C1466.editEntity)
			If ($mode="multiple-window")
				SET WINDOW TITLE:C213(Form:C1466.noticeText; Current form window:C827)
			End if 
			
		Else   //don't want a null editEntity
			BEEP:C151
		End if 
		
	: ($1="last")  //navigation
		app_form_Save_touched(Form:C1466.editorGroup)
		Form:C1466.editEntity:=Form:C1466.editEntity.last()
		Form:C1466.position:=Form:C1466.listBoxEntities.length
		Form:C1466.noticeText:=app_form_Notice_Text(Form:C1466.noticeText_c; Form:C1466.editEntity)
		If ($mode="multiple-window")
			SET WINDOW TITLE:C213(Form:C1466.noticeText; Current form window:C827)
		End if 
		
	: ($1="cancel")
		If ($mode="single-window")
			If (Form:C1466.position>0)
				LISTBOX SELECT ROW:C912(*; Form:C1466.listBoxName; Form:C1466.position)
				OBJECT SET SCROLL POSITION:C906(*; Form:C1466.listBoxName; Form:C1466.position)
			End if 
			FORM GOTO PAGE:C247(1)
		End if 
		
	: ($1="save")
		C_BOOLEAN:C305($newRec)
		$newRec:=Form:C1466.editEntity.isNew()
		
		C_OBJECT:C1216($status_o; $formObj)
		$status_o:=Form:C1466.editEntity.save(dk auto merge:K85:24)
		If ($status_o.success)
			Form:C1466.noticeText:=app_form_Notice_Text(Form:C1466.noticeText_c; Form:C1466.editEntity)
			zwStatusMsg("SUCCESS"; Form:C1466.noticeText+" changes saved")
			$ent_e:=Form:C1466.editEntity
			
		Else 
			zwStatusMsg("FAIL"; "CHANGES NOT SAVED")
			If (OB Is defined:C1231($status_o; "lockInfo"))  // Modified by: Mel Bohince (3/9/21) provide message if can't be saved
				$formObj:=$status_o.lockInfo
			Else 
				$formObj:=New object:C1471("user_name"; "Close"; "task_name"; "and"; "host_name"; "Re-Open this record")
			End if 
			$formObj.button:="Try Later"
			$formObj.message:="Changes NOT saved.\r"+$status_o.statusText
			util_EntityLocked($formObj)
		End if 
		
		If ($mode="single-window")
			If (Form:C1466.position>0)
				LISTBOX SELECT ROW:C912(*; Form:C1466.listBoxName; Form:C1466.position)
				OBJECT SET SCROLL POSITION:C906(*; Form:C1466.listBoxName; Form:C1466.position)
			End if 
			
			If ($newRec)
				Form:C1466.listBoxEntities.add(Form:C1466.editEntity)
				
				vSearch2:=$ent_e[Form:C1466.defaultQuery.value]
				Form:C1466.listBoxEntities:=Form:C1466.masterClass.query(Form:C1466.defaultQuery.criteria; vSearch2).orderBy(Form:C1466.defaultOrderBy)
				
			End if 
			
			Form:C1466.listBoxEntities:=Form:C1466.listBoxEntities
			FORM GOTO PAGE:C247(1)
			
		Else 
			OBJECT SET ENABLED:C1123(*; "memberValidate1"; False:C215)
			If (Form:C1466.parentForm>0)  // Modified by: Mel Bohince (5/12/20) 
				CALL FORM:C1391(Form:C1466.parentForm; "app_form_Refresh")
			End if 
		End if 
		
	: ($1="delete")
		If (Form:C1466.editEntity#Null:C1517)
			C_OBJECT:C1216($status_o)
			Form:C1466.noticeText:=app_form_Notice_Text(Form:C1466.noticeText_c; Form:C1466.editEntity)
			
			uConfirm("Are you sure you want to "+Form:C1466.deleteAction+" "+Form:C1466.noticeText+"?"; Form:C1466.deleteAction; "Cancel")
			If (OK=1)
				
				$ent_e:=Form:C1466.editEntity
				
				If (Form:C1466.deleteAction="delete")
					If (Form:C1466.position>0) & (Form:C1466.position<Form:C1466.listBoxEntities.length)
						$goto_e:=Form:C1466.editEntity.next()
						Form:C1466.position:=Form:C1466.position+1
					Else 
						$goto_e:=Form:C1466.editEntity.previous()
						Form:C1466.position:=Form:C1466.position-1
					End if 
					
					$status_o:=Form:C1466.editEntity.drop()
					If ($status_o.success=True:C214)
						Form:C1466.listBoxEntities:=Form:C1466.listBoxEntities.minus($ent_e).orderBy(Form:C1466.defaultOrderBy)
						
						Form:C1466.editEntity:=$goto_e
						zwStatusMsg("SUCCESS"; Form:C1466.noticeText+" has been deleted")
					Else 
						ALERT:C41("Failed to delete contact "+Form:C1466.noticeText+" "+$status_o.statusText)
					End if 
					
				Else   //save the deactivation
					Form:C1466.editEntity.Active:=False:C215
					$status_o:=Form:C1466.editEntity.save(dk auto merge:K85:24)
					If ($status_o.success)
						zwStatusMsg("SUCCESS"; " Deactivated")
					Else 
						BEEP:C151
						zwStatusMsg("FAIL"; "CHANGES NOT SAVED")
					End if 
				End if 
				
				If ($mode="single-window")
					If (Form:C1466.position>0)
						LISTBOX SELECT ROW:C912(*; Form:C1466.listBoxName; Form:C1466.position)
						OBJECT SET SCROLL POSITION:C906(*; Form:C1466.listBoxName; Form:C1466.position)
					End if 
					Form:C1466.clicked:=Form:C1466.editEntity
					
					FORM GOTO PAGE:C247(1)
					
				Else 
					CANCEL:C270
					If (Form:C1466.parentForm>0)  // Modified by: Mel Bohince (5/12/20) 
						CALL FORM:C1391(Form:C1466.parentForm; "app_form_Refresh")
					End if 
				End if 
				
			End if 
			
		Else 
			ALERT:C41("Please select a record to delete.")
		End if 
		
End case 

OBJECT SET ENABLED:C1123(*; "bFirst"; Form:C1466.position#1)
OBJECT SET ENABLED:C1123(*; "bPrevious"; Form:C1466.position#1)
OBJECT SET ENABLED:C1123(*; "bNext"; Form:C1466.position#Form:C1466.listBoxEntities.length)
OBJECT SET ENABLED:C1123(*; "bLast"; Form:C1466.position#Form:C1466.listBoxEntities.length)

