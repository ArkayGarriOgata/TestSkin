//%attributes = {}
// -------
// Method: trigger_RM_Labels   ( ) ->
// By: Mel Bohince @ 02/14/18, 16:30:29
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (4/17/19) added |(Is field value Null([Raw_Material_Labels]RM_Location_fk))
C_LONGINT:C283($0)

$0:=0  //assume granted


Case of 
	: ([Raw_Material_Labels:171]skipTrigger:14)  // Modified by: Mel Bohince (4/11/19) so timestamp doesnt update
		[Raw_Material_Labels:171]skipTrigger:14:=False:C215
		If ([Raw_Material_Labels:171]RM_Location_fk:13="00000000000000000000000000000000") | ([Raw_Material_Labels:171]RM_Location_fk:13="20202020202020202020202020202020") | (Is field value Null:C964([Raw_Material_Labels:171]RM_Location_fk:13))
			[Raw_Material_Labels:171]RM_Location_fk:13:=RIM_getLegacyLocationId([Raw_Material_Labels:171]POItemKey:3)  // Added by: Mel Bohince (4/11/19) 
		End if 
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		//$id_str:=String(Sequence number([Raw_Material_Labels]);"000000")
		$id_str:=fGetNextLongInt(->[Raw_Material_Labels:171])
		[Raw_Material_Labels:171]Label_id:2:="RM"+String:C10($id_str; "000000")  //+Barcode_UPC_ChkDigit ($id)
		[Raw_Material_Labels:171]Label_id_encoded:12:=BarCode_128auto([Raw_Material_Labels:171]Label_id:2)
		[Raw_Material_Labels:171]When_inserted:5:=TS_ISO_String_TimeStamp
		[Raw_Material_Labels:171]When_touched:6:=TS_ISO_String_TimeStamp
		[Raw_Material_Labels:171]When_Inventory:11:=""
		[Raw_Material_Labels:171]ModWho:7:=User_GetInitials(Current user:C182)
		[Raw_Material_Labels:171]RM_Location_fk:13:=RIM_getLegacyLocationId([Raw_Material_Labels:171]POItemKey:3)  // Added by: Mel Bohince (4/11/19) 
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Raw_Material_Labels:171]When_touched:6:=TS_ISO_String_TimeStamp
		[Raw_Material_Labels:171]ModWho:7:=User_GetInitials(Current user:C182)
		
		If ([Raw_Material_Labels:171]RM_Location_fk:13="00000000000000000000000000000000") | ([Raw_Material_Labels:171]RM_Location_fk:13="20202020202020202020202020202020") | (Is field value Null:C964([Raw_Material_Labels:171]RM_Location_fk:13))
			[Raw_Material_Labels:171]RM_Location_fk:13:=RIM_getLegacyLocationId([Raw_Material_Labels:171]POItemKey:3)  // Added by: Mel Bohince (4/11/19) 
		End if 
End case 
