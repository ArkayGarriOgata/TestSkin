//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_Get_Receipts - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//moved from wms_api_Get_Receipts


// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/10/08, 14:42:25
// ----------------------------------------------------
// Method: wms_api_Get_Receipts
// Description
// pull records from the wms.ams_exports table that are Receipts (type 100)
//
// Parameters - none
// Modified by: Mel Bohince (11/15/12)


// ----------------------------------------------------

C_LONGINT:C283($row; $0; $transaction_code; $cases; $aggregates)
$aggregates:=0
$cases:=0
$transaction_code:=100
//C_LONGINT($aggregate_id)
//$aggregate_id:=TSTimeStamp   `TS2iso   `used to mark the batch
C_DATE:C307($date)
C_TIME:C306($time)
TS2DateTime(TSTimeStamp; ->$date; ->$time)  //becomes time of import, not time of scan
C_BOOLEAN:C305($break)
$break:=False:C215
READ WRITE:C146([WMS_aMs_Exports:153])

//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	//set up the import from mysql
	
	//mark them as being targeted incase new ones arrive while this is running
	$sql:="UPDATE ams_exports SET transaction_state_indicator = 'T' "+"WHERE transaction_state_indicator = 'S' AND transaction_type_code = '100'"
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//$cases:=MySQL Execute ($conn_id;"";$stmt)
	If ($cases>0)
		//mysql> select bin_id, jobit, to_ams_location, sum(actual_qty) 
		//     from ams_export_archives 
		//     where transaction_type_code = 100 and transaction_state_indicator = 'S'  
		//     group by bin_id, jobit, to_ams_location;
		
		//mysql> select max(transaction_id) as id, bin_id, jobit, to_ams_location, sum(actual_qty) from ams_exports where transaction_type_code = 100 and transaction_state_indicator = 'X' group by bin_id, jobit, to_ams_location order by jobit;
		
		$sql:="SELECT  max(transaction_id) as id, jobit, bin_id, transaction_initials, "
		$sql:=$sql+"sum(actual_qty), skid_number, sum(number_of_cases), from_bin_id "
		$sql:=$sql+"FROM ams_exports "
		$sql:=$sql+"WHERE transaction_state_indicator = 'T' "  //not yet imported but Targeted this run'
		$sql:=$sql+"AND transaction_type_code = '100' "  //looking for specific types of transactions *** was <= $1  ****
		$sql:=$sql+"GROUP BY skid_number, from_bin_id"
		
		//$row_set:=MySQL Select ($conn_id;$sql)
		//$aggregates:=MySQL Get Row Count ($row_set)
		If ($aggregates>0)
			//this is the arrays for the full ams_exports records
			ARRAY LONGINT:C221($aID; 0)  //$aggregate_id
			ARRAY LONGINT:C221($aCode; 0)  //$transaction_code
			ARRAY TEXT:C222($aState; 0)  //S
			ARRAY DATE:C224($aDate; 0)  //$date
			ARRAY TEXT:C222($aTime; 0)  //$time
			ARRAY TEXT:C222($aInitials; 0)
			ARRAY LONGINT:C221($aBOL; 0)  //0
			ARRAY LONGINT:C221($aRel; 0)  //0
			ARRAY TEXT:C222($aJobit; 0)
			ARRAY TEXT:C222($aBin; 0)
			ARRAY LONGINT:C221($aQty; 0)
			ARRAY TEXT:C222($aTo; 0)
			ARRAY TEXT:C222($aFrom; 0)
			ARRAY TEXT:C222($aSkidId; 0)
			ARRAY TEXT:C222($aCaseId; 0)
			ARRAY INTEGER:C220($aNumCases; 0)
			ARRAY TEXT:C222($aFromBinID; 0)
			ARRAY DATE:C224($aPostDate; 0)
			ARRAY TEXT:C222($aPostTime; 0)
			
			
			//pull the grouped values
			//MySQL Column To Array ($row_set;"";1;$aID)
			//MySQL Column To Array ($row_set;"";2;$aJobit)
			//MySQL Column To Array ($row_set;"";3;$aBin)
			//MySQL Column To Array ($row_set;"";4;$aInitials)
			//MySQL Column To Array ($row_set;"";5;$aQty)
			//MySQL Column To Array ($row_set;"";6;$aSkidId)
			//MySQL Column To Array ($row_set;"";7;$aNumCases)
			
			//default the missing data
			//ARRAY LONGINT($aID;$aggregates)  `$aggregate_id
			ARRAY LONGINT:C221($aCode; $aggregates)  //$transaction_code
			ARRAY TEXT:C222($aState; $aggregates)  //S
			ARRAY DATE:C224($aDate; $aggregates)  //$date
			ARRAY TEXT:C222($aTime; $aggregates)  //$time
			ARRAY LONGINT:C221($aBOL; $aggregates)  //0
			ARRAY LONGINT:C221($aRel; $aggregates)  //0
			ARRAY TEXT:C222($aTo; $aggregates)
			ARRAY TEXT:C222($aFrom; $aggregates)
			ARRAY TEXT:C222($aFromBinID; $aggregates)
			ARRAY TEXT:C222($aCaseId; $aggregates)
			ARRAY DATE:C224($aPostDate; $aggregates)
			ARRAY TEXT:C222($aPostTime; $aggregates)
			$nowDate:=4D_Current_date
			$nowTime:=String:C10(4d_Current_time; HH MM SS:K7:1)  // Modified by: mel (1/7/10)
			For ($row; 1; $aggregates)
				//$aID{$row}:=$aggregate_id
				$aCode{$row}:=100
				$aState{$row}:="S"
				$aDate{$row}:=$date
				$aTime{$row}:=String:C10($time; HH MM SS:K7:1)
				$aTo{$row}:="CC"  //:"+Substring($aBin{$row};3;1)
				$aFrom{$row}:="WiP"
				$aCaseId{$row}:=""
				$aPostDate{$row}:=$nowDate
				$aPostTime{$row}:=$nowTime
			End for 
			
			//$row:=1
			//While ($row<=Size of array($aID))
			//$hit:=Find in array(aExsistingTransactions;$aID{$row})
			//If ($hit>-1)
			//DELETE FROM ARRAY($aID;$row;1)
			//DELETE FROM ARRAY($aCode;$row;1)
			//DELETE FROM ARRAY($aState;$row;1)
			//DELETE FROM ARRAY($aDate;$row;1)
			//DELETE FROM ARRAY($aTime;$row;1)
			//DELETE FROM ARRAY($aInitials;$row;1)
			//DELETE FROM ARRAY($aBOL;$row;1)
			//DELETE FROM ARRAY($aRel;$row;1)
			//DELETE FROM ARRAY($aJobit;$row;1)
			//DELETE FROM ARRAY($aBin;$row;1)
			//DELETE FROM ARRAY($aQty;$row;1)
			//DELETE FROM ARRAY($aTo;$row;1)
			//DELETE FROM ARRAY($aFrom;$row;1)
			//DELETE FROM ARRAY($aSkidId;$row;1)
			//DELETE FROM ARRAY($aCaseId;$row;1)
			//DELETE FROM ARRAY($aNumCases;$row;1)
			//DELETE FROM ARRAY($aFromBinID;$row;1)
			//DELETE FROM ARRAY($aPostDate;$row;1)
			//DELETE FROM ARRAY($aPostTime;$row;1)
			//Else 
			//$row:=$row+1
			//End if 
			//End while 
			
			REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
			ARRAY TO SELECTION:C261($aID; [WMS_aMs_Exports:153]id:1; $aCode; [WMS_aMs_Exports:153]TypeCode:2; $aState; [WMS_aMs_Exports:153]StateIndicator:3; $aDate; [WMS_aMs_Exports:153]TransDate:4; $aTime; [WMS_aMs_Exports:153]TransTime:5; $aInitials; [WMS_aMs_Exports:153]ModWho:6; $aBOL; [WMS_aMs_Exports:153]BOL_Number:7; $aRel; [WMS_aMs_Exports:153]Release_Number:8; $aJobit; [WMS_aMs_Exports:153]Jobit:9; $aBin; [WMS_aMs_Exports:153]BinId:10; $aQty; [WMS_aMs_Exports:153]ActualQty:11; $aTo; [WMS_aMs_Exports:153]To_aMs_Location:12; $aFrom; [WMS_aMs_Exports:153]From_aMs_Location:13; $aSkidId; [WMS_aMs_Exports:153]Skid_number:14; $aCaseId; [WMS_aMs_Exports:153]case_id:15; $aNumCases; [WMS_aMs_Exports:153]number_of_cases:16; $aFromBinID; [WMS_aMs_Exports:153]from_Bin_id:17; $aPostDate; [WMS_aMs_Exports:153]PostDate:18; $aPostTime; [WMS_aMs_Exports:153]PostTime:19)
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				UNLOAD RECORD:C212([WMS_aMs_Exports:153])
				REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
				
			Else 
				
				REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
				
			End if   // END 4D Professional Services : January 2019 
			
			
			//mark them as having been imported to aMs so wms can archive
			$sql:="UPDATE ams_exports SET transaction_state_indicator = 'X' "+"WHERE transaction_state_indicator = 'T' AND transaction_type_code = '100'"
			//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
			//$cases:=MySQL Execute ($conn_id;"";$stmt)  //
			
		Else 
			BEEP:C151
			zwStatusMsg("IMPORTING"; "There are no transactions to import: code = 100")
		End if 
		
		//MySQL Delete Row Set ($row_set)
		//$conn_id:=DB_ConnectionManager ("Close")
		
	Else 
		BEEP:C151
		zwStatusMsg("IMPORTING"; "There are no cases received to update: state = T")
	End if 
	
End if 
$0:=$aggregates
