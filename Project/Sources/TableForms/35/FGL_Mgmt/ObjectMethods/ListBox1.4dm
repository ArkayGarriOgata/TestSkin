// _______
// Method: [Finished_Goods_Locations].FGL_Mgmt.ListBox1   ( ) ->
// By: Mel Bohince @ 09/23/20, 14:35:40
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (12/9/20) get a lock on edit entity

Case of 
		
	: (Form event code:C388=On Selection Change:K2:29)
		
		If (Form:C1466.clicked#Null:C1517)
			
			Form:C1466.editEntity:=Form:C1466.clicked
			C_OBJECT:C1216($status_o)
			
			$status_o:=Form:C1466.editEntity.lock()  //make sure we can save any changes
			If ($status_o.success)
				
				If (Not:C34(OB Is empty:C1297(Form:C1466.editEntity)))  // Modified by: Mel Bohince (12/8/20) test is something clicked
					Form:C1466.origEntity:=Form:C1466.editEntity.clone()
					GOTO OBJECT:C206(*; "memberEditQuantity")
				End if 
				
				OBJECT SET VISIBLE:C603(*; "memberBtn@"; False:C215)
				If (User in group:C338(Current user:C182; editorGroup))
					OBJECT SET ENTERABLE:C238(*; "memberEdit@"; True:C214)
				Else 
					OBJECT SET ENTERABLE:C238(*; "memberEdit@"; False:C215)
				End if 
				
				FGLc_Mgmt_Reason(CorektPhaseInitialize)
				
			Else   //can't get the lock
				If ($status_o.status=dk status locked:K85:21)  // Modified by: Mel Bohince (12/8/20) 
					uConfirm("Record Locked by "+$status_o.lockInfo.user_name; "Ok"; "Cancel")
					Form:C1466.editEntity:=New object:C1471
				End if 
				
				BEEP:C151
				zwStatusMsg("FAIL"; "CHANGES NOT SAVED")
			End if 
			
		Else 
			Form:C1466.editEntity:=New object:C1471
		End if   //click not empty
		
		
End case 
