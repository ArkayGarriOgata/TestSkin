//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: MoveMulti_dio_Move_4D_AMSProc - Created v0.1.0-JJG (05/06/16)
//trick ams into processing transaction
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($1; $xlIndex; $xlPosSpace; $xlNumCases)
$xlIndex:=$1
$xlNumCases:=wmss_MoveMulti_4D_NumRows($xlIndex)

CREATE RECORD:C68([WMS_aMs_Exports:153])
[WMS_aMs_Exports:153]id:1:=Sequence number:C244([WMS_aMs_Exports:153])*-1
[WMS_aMs_Exports:153]TypeCode:2:=200
[WMS_aMs_Exports:153]StateIndicator:3:="S"
[WMS_aMs_Exports:153]TransDate:4:=4D_Current_date
[WMS_aMs_Exports:153]TransTime:5:=String:C10(4d_Current_time; HH MM SS:K7:1)
[WMS_aMs_Exports:153]ModWho:6:=<>zResp
[WMS_aMs_Exports:153]Jobit:9:=rft_jobit{$xlIndex}
[WMS_aMs_Exports:153]BinId:10:=sToBin
[WMS_aMs_Exports:153]from_Bin_id:17:=rft_Bin{$xlIndex}
If (Position:C15("cases"; rft_Case{$xlIndex})>0)
	$xlPosSpace:=Position:C15(" "; rft_Case{$xlIndex})
	[WMS_aMs_Exports:153]ActualQty:11:=Num:C11(Substring:C12(rft_Case{$xlIndex}; 1; $xlPosSpace))
Else 
	[WMS_aMs_Exports:153]ActualQty:11:=Num:C11(WMS_CaseId(rft_Case{$xlIndex}; "qty"))
End if 
[WMS_aMs_Exports:153]To_aMs_Location:12:=ams_location
[WMS_aMs_Exports:153]From_aMs_Location:13:=sFrom
[WMS_aMs_Exports:153]Skid_number:14:=sToSkid
[WMS_aMs_Exports:153]case_id:15:=rft_Case{$xlIndex}
[WMS_aMs_Exports:153]number_of_cases:16:=$xlNumCases

[WMS_aMs_Exports:153]PostDate:18:=4D_Current_date
[WMS_aMs_Exports:153]PostTime:19:=String:C10(4d_Current_time; HH MM SS:K7:1)
SAVE RECORD:C53([WMS_aMs_Exports:153])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	UNLOAD RECORD:C212([WMS_aMs_Exports:153])
	REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
	
Else 
	
	REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
	
End if   // END 4D Professional Services : January 2019 
