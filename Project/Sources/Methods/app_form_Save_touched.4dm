//%attributes = {}
// _______
// Method: app_form_Save_touched   ( allowedGroupToMakeChanges ) ->
// By: Mel Bohince @ 04/18/20, 15:16:06
// Description
// called by app_form_button to save if changes were detected
// similar to app_form_button("save") but without the listbox positioning
// ----------------------------------------------------
// Modified by: Mel Bohince (3/9/21) provide message if can't be saved

C_TEXT:C284($editorGroup; $1)
$editorGroup:=$1

If (Form:C1466.editEntity.touched())
	
	OBJECT SET ENABLED:C1123(*; "memberValidate1"; False:C215)
	
	If (User in group:C338(Current user:C182; $editorGroup))
		uConfirm("Save changes?"; "Save"; "Abandon")
		If (ok=1)
			C_OBJECT:C1216($status_o; $formObj)
			$status_o:=Form:C1466.editEntity.save(dk auto merge:K85:24)
			If ($status_o.success)
				zwStatusMsg("SUCCESS"; " Changes saved")
				If (Form:C1466.parentForm>0)
					CALL FORM:C1391(Form:C1466.parentForm; "app_form_Refresh")
				End if 
				
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
		End if 
		
	Else   //
		uConfirm("Must be in "+$editorGroup+" group to make changes."; "Ok"; "Dang")
	End if 
	
End if 








