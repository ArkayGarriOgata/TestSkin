//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:50:46
// ----------------------------------------------------
// Method: trigger_WMS_WarehouseOrders()  --> 
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[WMS_WarehouseOrders:146]DateEntered:9:=4D_Current_date
		[WMS_WarehouseOrders:146]TimeEntered:10:=4d_Current_time
		[WMS_WarehouseOrders:146]EnteredBy:11:=User_GetInitials
End case 