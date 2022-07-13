//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getAMSTransactions - Created v0.1.0-JJG (05/16/16)
// Modified by: Mel Bohince (10/21/16) do type conversion on transaction time
// Modified by: Mel Bohince (11/30/18) add $st3FromSkidID to get from_skid_id
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumElements; $i; $xlTransID)
C_TEXT:C284($1; $txType)
C_TEXT:C284($ttSQL; $ttPostTime)
C_DATE:C307($dPost)
ARRAY LONGINT:C221($sxlTransID; 0)
ARRAY LONGINT:C221($sxlTypeCode; 0)
ARRAY TEXT:C222($st0StateIndicator; 0)
ARRAY DATE:C224($sdTransDate; 0)
ARRAY TEXT:C222($st1TransTime; 0)
ARRAY LONGINT:C221($tTransTime; 0)  // Modified by: Mel Bohince (10/21/16) 
ARRAY TEXT:C222($st0Inits; 0)
ARRAY LONGINT:C221($sxlBOL; 0)
ARRAY LONGINT:C221($sxlRelease; 0)
ARRAY TEXT:C222($sttJobit; 0)
ARRAY TEXT:C222($st3BinID; 0)
ARRAY LONGINT:C221($sxlActQty; 0)
ARRAY TEXT:C222($st3ToAMSLoc; 0)
ARRAY TEXT:C222($st3FromAMSLoc; 0)
ARRAY TEXT:C222($st3SkidNumber; 0)
ARRAY TEXT:C222($st3CaseID; 0)
ARRAY INTEGER:C220($sxiNumCases; 0)
ARRAY TEXT:C222($st3FromBinID; 0)
ARRAY DATE:C224($sdPost; 0)
ARRAY TEXT:C222($st1PostTime; 0)
ARRAY TEXT:C222($st3FromSkidID; 0)  // Modified by: Mel Bohince (11/30/18) 

If (Count parameters:C259>0)
	$txType:=$1
Else 
	$txType:=""
End if 
$xlNumElements:=0

If (WMS_API_4D_DoLogin)
	SQL EXECUTE:C820(WMS_API_4D_getAMSTransSQL($txType); $sxlTransID; $sxlTypeCode; $st0StateIndicator; $sdTransDate; $tTransTime; $st0Inits; $sxlBOL; $sxlRelease; $sttJobit; $st3BinID; $sxlActQty; $st3ToAMSLoc; $st3FromAMSLoc; $st3SkidNumber; $st3CaseID; $sxiNumCases; $st3FromBinID; $st3FromSkidID)
	
	If (OK=1)
		If (Not:C34(SQL End selection:C821))
			SQL LOAD RECORD:C822(SQL all records:K49:10)
		End if 
		SQL CANCEL LOAD:C824
		
		$xlNumElements:=Size of array:C274($sxlTransID)
		If ($xlNumElements>0)
			
			WMS_API_4D_getAMSTransPost($xlNumElements; ->$sdPost; ->$st1PostTime; ->$st1TransTime; ->$tTransTime)  // Modified by: Mel Bohince (10/21/16) do type conversion on transaction time
			
			REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
			ARRAY TO SELECTION:C261($sxlTransID; [WMS_aMs_Exports:153]id:1; $sxlTypeCode; [WMS_aMs_Exports:153]TypeCode:2; $st0StateIndicator; [WMS_aMs_Exports:153]StateIndicator:3; $sdTransDate; [WMS_aMs_Exports:153]TransDate:4; $st1TransTime; [WMS_aMs_Exports:153]TransTime:5; $st0Inits; [WMS_aMs_Exports:153]ModWho:6; $sxlBOL; [WMS_aMs_Exports:153]BOL_Number:7; $sxlRelease; [WMS_aMs_Exports:153]Release_Number:8; $sttJobit; [WMS_aMs_Exports:153]Jobit:9; $st3BinID; [WMS_aMs_Exports:153]BinId:10; $sxlActQty; [WMS_aMs_Exports:153]ActualQty:11; $st3ToAMSLoc; [WMS_aMs_Exports:153]To_aMs_Location:12; $st3FromAMSLoc; [WMS_aMs_Exports:153]From_aMs_Location:13; $st3SkidNumber; [WMS_aMs_Exports:153]Skid_number:14; $st3CaseID; [WMS_aMs_Exports:153]case_id:15; $sxiNumCases; [WMS_aMs_Exports:153]number_of_cases:16; $st3FromBinID; [WMS_aMs_Exports:153]from_Bin_id:17; $sdPost; [WMS_aMs_Exports:153]PostDate:18; $st1PostTime; [WMS_aMs_Exports:153]PostTime:19; $st3FromSkidID; [WMS_aMs_Exports:153]from_skid_id:21)
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				UNLOAD RECORD:C212([WMS_aMs_Exports:153])
				REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
				
			Else 
				
				REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
				
			End if   // END 4D Professional Services : January 2019 
			
			WMS_API_4D_getAMSTransUpdate(->$sxlTransID)
			
		Else 
			//BEEP
			zwStatusMsg("IMPORTING"; "There are no transactions to import: "+$txType)
		End if 
		
	End if 
	
	WMS_API_4D_DoLogout
End if 

$0:=$xlNumElements