//%attributes = {}
// -------
// Method: trigger_Internal_BOL   ( ) ->
// By: Mel Bohince @ 10/31/18, 15:35:52
// Description
// 
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=0  //assume granted


Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		$id_str:=fGetNextLongInt(->[WMS_InternalBOLs:163])
		[WMS_InternalBOLs:163]bol_number:2:="BOL"+String:C10($id_str; "000000")  //+Barcode_UPC_ChkDigit ($id)
		[WMS_InternalBOLs:163]bol_encoded:8:=BarCode_128auto([WMS_InternalBOLs:163]bol_number:2)
		[WMS_InternalBOLs:163]when_inserted:5:=TS_ISO_String_TimeStamp
		[WMS_InternalBOLs:163]when_touched:7:=TS_ISO_String_TimeStamp
		[WMS_InternalBOLs:163]modWho:6:=User_GetInitials(Current user:C182)
		[WMS_InternalBOLs:163]loaded:9:=False:C215
		[WMS_InternalBOLs:163]canPurge:10:=False:C215
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[WMS_InternalBOLs:163]when_touched:7:=TS_ISO_String_TimeStamp
		[WMS_InternalBOLs:163]modWho:6:=User_GetInitials(Current user:C182)
		
		If ([WMS_InternalBOLs:163]number_of_cases:4>0)  //tag so we know it was used at some point, #cases will get set (refreshed) when printed
			[WMS_InternalBOLs:163]loaded:9:=True:C214
		End if 
		
		If ([WMS_InternalBOLs:163]loaded:9) & ([WMS_InternalBOLs:163]number_of_cases:4=0)  //a bol that had been used is now empty so not necesssary to keep
			[WMS_InternalBOLs:163]canPurge:10:=True:C214
		End if 
		
		
End case 