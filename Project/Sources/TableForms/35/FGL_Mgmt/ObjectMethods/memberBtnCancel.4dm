// _______
// Method: [Finished_Goods_Locations].FGL_Mgmt.memberBtnCancel   ( ) ->
// By: Mel Bohince @ 09/28/20, 15:43:53
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($status_o)
Form:C1466.editEntity.unlock()
$status_o:=Form:C1466.editEntity.reload()
If ($status_o.success)
	Form:C1466.noticeText:=app_form_Notice_Text(Form:C1466.noticeText_c; Form:C1466.editEntity)
	zwStatusMsg("SUCCESS"; Form:C1466.noticeText+" reverted")
	Form:C1466.listBoxEntities:=Form:C1466.listBoxEntities  //redraw listbox
	
Else 
	BEEP:C151
	zwStatusMsg("FAIL"; "CHANGES NOT REVERTED")
End if 

OBJECT SET ENABLED:C1123(*; "memberBtn@"; Form:C1466.editEntity.touched())
OBJECT SET VISIBLE:C603(*; "memberBtn@"; Form:C1466.editEntity.touched())  //cancel and save btns