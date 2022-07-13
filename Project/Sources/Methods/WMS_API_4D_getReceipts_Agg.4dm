//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getReceipts_Agg - Created v0.1.0-JJG (05/16/16)
// Modified by: JJG  (3/18/17) 

//If (<>fDebug)
//DODEBUG (Current method name)
//End if 

//C_LONGINT($0;$i;$xlAggregates)
//C_DATE($dDate;$dNow)
//C_TIME($hTime;$hNow)
//ARRAY LONGINT($sxlTransactionID;0)
//ARRAY TEXT($sttJobit;0)
//ARRAY TEXT($sttBinID;0)
//ARRAY TEXT($sttTransInits;0)
//ARRAY LONGINT($sxlActQtySum;0)
//ARRAY TEXT($sttSkidNum;0)
//ARRAY INTEGER($sxiNumCases;0)
//ARRAY TEXT($sttFromBinID;0)
//TS2DateTime (TSTimeStamp ;->$dDate;->$hTime)  //becomes time of import, not time of scan
//$xlAggregates:=0

//SQL EXECUTE(WMS_API_4D_getReceipts_AggSQL ;$sxlTransactionID;$sttJobit;$sttBinID;$sttTransInits;$sxlActQtySum;$sttSkidNum;$sxiNumCases;$sttFromBinID)
//If (OK=1)
//If (Not(SQL End selection))
//SQL LOAD RECORD(SQL all records)
//$xlAggregates:=Size of array($sxlTransactionID)

//ARRAY LONGINT($sxlCode;$xlAggregates)
//ARRAY TEXT($sttState;$xlAggregates)
//ARRAY DATE($sdDate;$xlAggregates)
//ARRAY TEXT($sttTime;$xlAggregates)
//ARRAY LONGINT($sxlBOL;$xlAggregates)
//ARRAY LONGINT($sxlRel;$xlAggregates)
//ARRAY TEXT($sttTo;$xlAggregates)
//ARRAY TEXT($sttFrom;$xlAggregates)
//ARRAY TEXT($sttCaseID;$xlAggregates)
//ARRAY DATE($sdPost;$xlAggregates)
//ARRAY TEXT($sttPostTime;$xlAggregates)
//$dNow:=4D_Current_date
//$hNow:=4d_Current_time

//For ($i;1;$xlAggregates)
//$sxlCode{$i}:=100
//$sttState{$i}:="S"
//$sdDate{$i}:=$dDate
//$sttTime{$i}:=String($hTime;HH MM SS)
//$sttTo{$i}:="CC"
//$sttFrom{$i}:="WiP"
//$sttCaseID{$i}:=""
//$sdPost{$i}:=$dNow
//$sttPostTime{$i}:=String($hNow;HH MM SS)
//End for 

//REDUCE SELECTION([WMS_aMs_Exports];0)
//ARRAY TO SELECTION($sxlTransactionID;[WMS_aMs_Exports]id;$sxlCode;[WMS_aMs_Exports]TypeCode;$sttState;[WMS_aMs_Exports]StateIndicator;$sdDate;[WMS_aMs_Exports]TransDate;$sttTime;[WMS_aMs_Exports]TransTime;$sttTransInits;[WMS_aMs_Exports]ModWho;$sxlBOL;[WMS_aMs_Exports]BOL_Number;$sxlRel;[WMS_aMs_Exports]Release_Number;$sttJobit;[WMS_aMs_Exports]Jobit;$sttBinID;[WMS_aMs_Exports]BinId;$sxlActQtySum;[WMS_aMs_Exports]ActualQty;$sttTo;[WMS_aMs_Exports]To_aMs_Location;$sttFrom;[WMS_aMs_Exports]From_aMs_Location;$sttSkidNum;[WMS_aMs_Exports]Skid_number;$sttCaseID;[WMS_aMs_Exports]case_id;$sxiNumCases;[WMS_aMs_Exports]number_of_cases;$sttFromBinID;[WMS_aMs_Exports]from_Bin_id;$sdPost;[WMS_aMs_Exports]PostDate;$sttPostTime;[WMS_aMs_Exports]PostTime)
//UNLOAD RECORD([WMS_aMs_Exports])
//REDUCE SELECTION([WMS_aMs_Exports];0)

//End if 
//SQL CANCEL LOAD

//End if 

//If ($xlAggregates=0)
//BEEP
//zwStatusMsg ("IMPORTING";"There are no transactions to import: code = 100")
//End if 

//$0:=$xlAggregates

//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getReceipts_Agg - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $i; $xlAggregates)
C_DATE:C307($dDate; $dNow)
C_TIME:C306($hTime; $hNow)
ARRAY LONGINT:C221($sxlTransactionID; 0)
ARRAY TEXT:C222($sttJobit; 0)
ARRAY TEXT:C222($sttBinID; 0)
ARRAY TEXT:C222($sttTransInits; 0)
ARRAY LONGINT:C221($sxlActQtySum; 0)
ARRAY TEXT:C222($sttSkidNum; 0)
ARRAY INTEGER:C220($sxiNumCases; 0)
ARRAY TEXT:C222($sttFromBinID; 0)
ARRAY LONGINT:C221($sxlTime; 0)  //v1.0.3-JJG (03/13/17) - added
ARRAY DATE:C224($sdDate; 0)  //v1.0.3-JJG (03/13/17) - added
//v1.0.3-JJG (03/13/17) - removed //TS2DateTime (TSTimeStamp ;->$dDate;->$hTime)  //becomes time of import, not time of scan
$xlAggregates:=0

SQL EXECUTE:C820(WMS_API_4D_getReceipts_AggSQL; $sxlTransactionID; $sttJobit; $sttBinID; $sttTransInits; $sxlActQtySum; $sttSkidNum; $sxiNumCases; $sttFromBinID; $sdDate; $sxlTime)  //v1.0.3-JJG (03/13/17) - added $sdDate;$sttTime
If (OK=1)
	If (Not:C34(SQL End selection:C821))
		SQL LOAD RECORD:C822(SQL all records:K49:10)
		$xlAggregates:=Size of array:C274($sxlTransactionID)
		
		ARRAY LONGINT:C221($sxlCode; $xlAggregates)
		ARRAY TEXT:C222($sttState; $xlAggregates)
		//v1.0.3-JJG (03/13/17) - removed //ARRAY DATE($sdDate;$xlAggregates)
		ARRAY TEXT:C222($sttTime; $xlAggregates)
		ARRAY LONGINT:C221($sxlBOL; $xlAggregates)
		ARRAY LONGINT:C221($sxlRel; $xlAggregates)
		ARRAY TEXT:C222($sttTo; $xlAggregates)
		ARRAY TEXT:C222($sttFrom; $xlAggregates)
		ARRAY TEXT:C222($sttCaseID; $xlAggregates)
		ARRAY DATE:C224($sdPost; $xlAggregates)
		ARRAY TEXT:C222($sttPostTime; $xlAggregates)
		$dNow:=4D_Current_date
		$hNow:=4d_Current_time
		
		For ($i; 1; $xlAggregates)
			$sxlCode{$i}:=100
			$sttState{$i}:="S"
			//v1.0.3-JJG (03/13/17) - removed $sdDate{$i}:=$dDate
			$sttTime{$i}:=Time string:C180($sxlTime{$i})  //v1.0.3-JJG (03/13/17) - replaced //$sttTime{$i}:=String($hTime;HH MM SS)
			$sttTo{$i}:="CC"
			$sttFrom{$i}:="WiP"
			$sttCaseID{$i}:=""
			$sdPost{$i}:=$dNow
			$sttPostTime{$i}:=String:C10($hNow; HH MM SS:K7:1)
		End for 
		
		REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
		ARRAY TO SELECTION:C261($sxlTransactionID; [WMS_aMs_Exports:153]id:1; $sxlCode; [WMS_aMs_Exports:153]TypeCode:2; $sttState; [WMS_aMs_Exports:153]StateIndicator:3; $sdDate; [WMS_aMs_Exports:153]TransDate:4; $sttTime; [WMS_aMs_Exports:153]TransTime:5; $sttTransInits; [WMS_aMs_Exports:153]ModWho:6; $sxlBOL; [WMS_aMs_Exports:153]BOL_Number:7; $sxlRel; [WMS_aMs_Exports:153]Release_Number:8; $sttJobit; [WMS_aMs_Exports:153]Jobit:9; $sttBinID; [WMS_aMs_Exports:153]BinId:10; $sxlActQtySum; [WMS_aMs_Exports:153]ActualQty:11; $sttTo; [WMS_aMs_Exports:153]To_aMs_Location:12; $sttFrom; [WMS_aMs_Exports:153]From_aMs_Location:13; $sttSkidNum; [WMS_aMs_Exports:153]Skid_number:14; $sttCaseID; [WMS_aMs_Exports:153]case_id:15; $sxiNumCases; [WMS_aMs_Exports:153]number_of_cases:16; $sttFromBinID; [WMS_aMs_Exports:153]from_Bin_id:17; $sdPost; [WMS_aMs_Exports:153]PostDate:18; $sttPostTime; [WMS_aMs_Exports:153]PostTime:19)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			UNLOAD RECORD:C212([WMS_aMs_Exports:153])
			REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
			
		Else 
			
			REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
			
		End if   // END 4D Professional Services : January 2019 
		
	End if 
	SQL CANCEL LOAD:C824
	
End if 

If ($xlAggregates=0)
	BEEP:C151
	zwStatusMsg("IMPORTING"; "There are no transactions to import: code = 100")
End if 

$0:=$xlAggregates