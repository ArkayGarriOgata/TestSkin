//%attributes = {}
// Method: trigger_FG_Specification () -> 
// ----------------------------------------------------
// by: mel: 05/04/05, 16:31:01
// ----------------------------------------------------
// Description:
// Folk were missing the validation phase when printing first
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1) | (Trigger event:C369=On Saving Existing Record Event:K3:2)
		FG_PrepServiceSetStatus
		[Finished_Goods_Specifications:98]ModDate:56:=4D_Current_date
		[Finished_Goods_Specifications:98]ModWho:55:=User_GetInitials
		[Finished_Goods_Specifications:98]cust_id:77:=Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5)
		
	: (Trigger event:C369=On Deleting Record Event:K3:3)  //send to logfile
		JTB_LogJTB("DELETE"; String:C10(Table:C252(->[Finished_Goods_Specifications:98]); "000")+" ~ "+Table name:C256(->[Finished_Goods_Specifications:98])+" # "+String:C10(Record number:C243([Finished_Goods_Specifications:98])))
End case 