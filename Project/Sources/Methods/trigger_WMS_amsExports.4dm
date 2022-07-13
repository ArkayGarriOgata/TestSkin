//%attributes = {}
// -------
// Method: trigger_WMS_amsExports   ( ) ->
// By: Mel Bohince @ 01/17/19, 15:54:30
// Description
// set date/timestamp
// ----------------------------------------------------


C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		//[WMS_aMs_Exports]transactionDateTime:=TS2iso (TSTimeStamp ([WMS_aMs_Exports]TransDate;Time([WMS_aMs_Exports]TransTime)))
		[WMS_aMs_Exports:153]transactionDateTime:22:=TS_ISO_String_TimeStamp([WMS_aMs_Exports:153]TransDate:4; Time:C179([WMS_aMs_Exports:153]TransTime:5))
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		//[WMS_aMs_Exports]transactionDateTime:=TS2iso (TSTimeStamp ([WMS_aMs_Exports]TransDate;Time([WMS_aMs_Exports]TransTime)))
		[WMS_aMs_Exports:153]transactionDateTime:22:=TS_ISO_String_TimeStamp([WMS_aMs_Exports:153]TransDate:4; Time:C179([WMS_aMs_Exports:153]TransTime:5))
End case 