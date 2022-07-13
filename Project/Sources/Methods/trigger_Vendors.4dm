//%attributes = {}
// _______
// Method: trigger_Vendors   ( ) ->
// By: Mel Bohince @ 04/20/20, 10:55:05
// Description
// 
// ----------------------------------------------------


C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Vendors:7]ID:1:=app_set_id_as_string(Table:C252(->[Vendors:7]))
		[Vendors:7]ModDate:22:=4D_Current_date
		[Vendors:7]ModWho:23:=User_GetInitials
		[Vendors:7]Active:15:=True:C214
		[Vendors:7]ModTimeStamp:31:=TSTimeStamp  //•091096  MLB  take any modification as msg trigger 
		If (Length:C16([Vendors:7]Std_Terms:13)=0)
			[Vendors:7]Std_Terms:13:="Net 60"
		End if 
		If (Length:C16([Vendors:7]FOB:27)=0)
			[Vendors:7]FOB:27:="DDP"
		End if 
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Vendors:7]ModDate:22:=4D_Current_date
		[Vendors:7]ModWho:23:=User_GetInitials
		[Vendors:7]ModTimeStamp:31:=TSTimeStamp  //•091096  MLB  take any modification as msg trigger 
End case 