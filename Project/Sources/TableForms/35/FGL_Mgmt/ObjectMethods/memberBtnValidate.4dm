// _______
// Method: [Finished_Goods_Locations].FGL_Mgmt.memberBtnValidate   ( ) ->
// By: Mel Bohince @ 09/28/20, 15:49:12
// Modified by: Garri Ogata (4/14/21) changed to be Keep as default
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (4/28/21) defend against invalid skid number deletion

C_LONGINT:C283($wmsDeletes)  //
$wmsDeletes:=0


C_OBJECT:C1216($status_o; $sscc_es; $jobit_e; $fgx_es; $notDropped_es)

C_BOOLEAN:C305($isValidTransaction)
$isValidTransaction:=True:C214  //optomistic
Form:C1466.noticeText:=""
START TRANSACTION:C239

$status_o:=Form:C1466.editEntity.save(dk auto merge:K85:24)
If ($status_o.success)
	Form:C1466.noticeText:=app_form_Notice_Text(Form:C1466.noticeText_c; Form:C1466.editEntity)
	zwStatusMsg("SUCCESS"; Form:C1466.noticeText+" changes saved")
	
	//record the transaction
	$status_o:=FGX_InventoryChanged(Form:C1466.origEntity; Form:C1466.editEntity)
	If (Not:C34($status_o.success))
		$isValidTransaction:=False:C215
		Form:C1466.noticeText:=Form:C1466.noticeText+" FG transaction failure"
	End if 
	
	If (Form:C1466.editEntity.QtyOH=0) & ($isValidTransaction)  //remove the location record
		
		If (Length:C16(Form:C1466.editEntity.skid_number)>19)  // Modified by: Mel Bohince (4/28/21) defend against invalid skid number deletion, was >0 so "case" qualified, very bad
			$sscc_es:=ds:C1482.WMS_SerializedShippingLabels.query("HumanReadable = :1"; Form:C1466.editEntity.skid_number)  //Modified by: Mel Bohince (4/28/21)
			If ($sscc_es.length=1)
				
				uConfirm("Make this skid like it never happened?"; "Keep"; "Remove")  // Modified by: Garri Ogata (4/14/21) 
				If (ok=0)  // Modified by: Garri Ogata (4/14/21) 
					//remove qty from jobit
					
					$jobit_e:=ds:C1482.Job_Forms_Items.query("Jobit=:1"; Form:C1466.editEntity.Jobit).first()
					$jobit_e.Qty_Actual:=$jobit_e.Qty_Actual-Form:C1466.origEntity.QtyOH
					$status_o:=$jobit_e.save()
					If (Not:C34($status_o.success))
						$isValidTransaction:=False:C215
						Form:C1466.noticeText:=Form:C1466.noticeText+" Jobit update failure"
					End if 
					
					If ($isValidTransaction)  //remove the transactions of this skid, leaving the adjustment transaction
						
						$fgx_es:=ds:C1482.Finished_Goods_Transactions.query("Skid_number=:1"; Form:C1466.editEntity.skid_number)
						If ($fgx_es.length>0) & ($fgx_es.length<10)  //limit the distruction
							$notDropped_es:=$fgx_es.drop()
						Else 
							$notDropped_es:=$fgx_es  //don't delete any
						End if 
						
						If ($notDropped_es.length>0)
							$isValidTransaction:=False:C215
							Form:C1466.noticeText:=Form:C1466.noticeText+" FG transaction deletion failure"
						End if 
						
						If ($isValidTransaction)
							//Form.editEntity.skid_number:="00208082920003429629"  //testing
							$wmsDeletes:=WMS_Delete_Skid(Form:C1466.editEntity.skid_number)  // Modified by: Mel Bohince (5/25/18) remove cases from wms if deleting skid
							uConfirm(String:C10($wmsDeletes)+" cases deleted from WMS on skid "+Form:C1466.editEntity.skid_number; "Thanks"; "What?")
						End if   //valid after fgx delete
						
					End if   //valid after jobit update
				End if   //confirm
			End if   //skid# exists
			
		End if   //valid skid number
		
		Form:C1466.editEntity.drop()
		Form:C1466.listBoxEntities:=Form:C1466.listBoxEntities.minus(Form:C1466.editEntity)
	End if 
	//update the starting point
	Form:C1466.origEntity:=Form:C1466.editEntity.clone()
	
Else 
	$isValidTransaction:=False:C215
	Form:C1466.noticeText:=Form:C1466.noticeText+" FG location update failure"
	If ($status_o.status=dk status locked:K85:21)  // Modified by: Mel Bohince (12/8/20) 
		uConfirm("Record Locked by "+$status_o.lockInfo.user_name; "Ok"; "Cancel")
	End if 
	BEEP:C151
	zwStatusMsg("FAIL"; "CHANGES NOT SAVED")
End if 

Form:C1466.editEntity.unlock()


If ($isValidTransaction)
	VALIDATE TRANSACTION:C240
Else 
	CANCEL TRANSACTION:C241
	uConfirm("Changes not saved. Problem: "+Form:C1466.noticeText)
End if 



OBJECT SET ENABLED:C1123(*; "memberBtn@"; Form:C1466.editEntity.touched())
OBJECT SET VISIBLE:C603(*; "memberBtn@"; Form:C1466.editEntity.touched())  //cancel and save btns


