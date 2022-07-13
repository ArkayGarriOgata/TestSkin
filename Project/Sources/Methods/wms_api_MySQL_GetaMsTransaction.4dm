//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_GetaMsTransaction - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

// moved from wms_api_Get_aMs_Transactions

// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/10/08, 14:42:25

// Modified by: Mel Bohince (11/15/12) test for duplicate id's
// ----------------------------------------------------
// Method: wms_api_Get_aMs_Transactions({transactionType})
// Description
// pull records from the wms.ams_exports table
//
//types:
//100 = receipt
//200 = move
//300 = release picked
//400 =
//500 = bol complete

// Parameters
// ----------------------------------------------------

C_TEXT:C284($1)  //optional transaction type
C_LONGINT:C283($i; $numElements; $numRecs; $0; $num_transactions)
$0:=0
C_BOOLEAN:C305($break)
$break:=False:C215
READ WRITE:C146([WMS_aMs_Exports:153])

//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	//set up the import from mysql
	
	
	If (Count parameters:C259=0)
		$sql:="SELECT * FROM ams_exports WHERE "
		$sql:=$sql+"transaction_state_indicator = 'S'"  //not yet imported as indicated by 'S' rather than 'X'
	Else 
		$sql:="SELECT * FROM ams_exports WHERE "
		$sql:=$sql+"transaction_state_indicator = 'S' AND "  //not yet imported as indicated by 'S' rather than 'X'
		$sql:=$sql+"transaction_type_code = '"+$1+"' "  //looking for specific types of transactions *** was <= $1  ****
	End if 
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$row_count:=MySQL Get Row Count ($row_set)
	$0:=$row_count
	If ($row_count>0)
		ARRAY LONGINT:C221($aID; 0)
		ARRAY LONGINT:C221($aCode; 0)
		ARRAY TEXT:C222($aState; 0)
		ARRAY DATE:C224($aDate; 0)
		ARRAY TEXT:C222($aTime; 0)
		ARRAY TEXT:C222($aInitials; 0)
		ARRAY LONGINT:C221($aBOL; 0)
		ARRAY LONGINT:C221($aRel; 0)
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
		
		//MySQL Column To Array ($row_set;"";1;$aID)
		//MySQL Column To Array ($row_set;"";2;$aCode)
		//MySQL Column To Array ($row_set;"";3;$aState)
		//MySQL Column To Array ($row_set;"";4;$aDate)
		//MySQL Column To Array ($row_set;"";5;$aTime)
		//MySQL Column To Array ($row_set;"";6;$aInitials)
		//MySQL Column To Array ($row_set;"";7;$aBOL)
		//MySQL Column To Array ($row_set;"";8;$aRel)
		//MySQL Column To Array ($row_set;"";9;$aJobit)
		//MySQL Column To Array ($row_set;"";10;$aBin)
		//MySQL Column To Array ($row_set;"";11;$aQty)
		//MySQL Column To Array ($row_set;"";12;$aTo)
		//MySQL Column To Array ($row_set;"";13;$aFrom)
		//MySQL Column To Array ($row_set;"";14;$aSkidId)
		//MySQL Column To Array ($row_set;"";15;$aCaseId)
		//MySQL Column To Array ($row_set;"";16;$aNumCases)
		//MySQL Column To Array ($row_set;"";17;$aFromBinID)
		
		$numElements:=Size of array:C274($aID)  // Modified by: mel (1/7/10)
		ARRAY DATE:C224($aPostDate; $numElements)
		ARRAY TEXT:C222($aPostTime; $numElements)
		$nowDate:=4D_Current_date
		$nowTime:=String:C10(4d_Current_time; HH MM SS:K7:1)
		For ($i; 1; $numElements)
			$aPostDate{$i}:=$nowDate
			$aPostTime{$i}:=$nowTime
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
		//
		//$numElements:=Size of array($aID)
		
		REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
		ARRAY TO SELECTION:C261($aID; [WMS_aMs_Exports:153]id:1; $aCode; [WMS_aMs_Exports:153]TypeCode:2; $aState; [WMS_aMs_Exports:153]StateIndicator:3; $aDate; [WMS_aMs_Exports:153]TransDate:4; $aTime; [WMS_aMs_Exports:153]TransTime:5; $aInitials; [WMS_aMs_Exports:153]ModWho:6; $aBOL; [WMS_aMs_Exports:153]BOL_Number:7; $aRel; [WMS_aMs_Exports:153]Release_Number:8; $aJobit; [WMS_aMs_Exports:153]Jobit:9; $aBin; [WMS_aMs_Exports:153]BinId:10; $aQty; [WMS_aMs_Exports:153]ActualQty:11; $aTo; [WMS_aMs_Exports:153]To_aMs_Location:12; $aFrom; [WMS_aMs_Exports:153]From_aMs_Location:13; $aSkidId; [WMS_aMs_Exports:153]Skid_number:14; $aCaseId; [WMS_aMs_Exports:153]case_id:15; $aNumCases; [WMS_aMs_Exports:153]number_of_cases:16; $aFromBinID; [WMS_aMs_Exports:153]from_Bin_id:17; $aPostDate; [WMS_aMs_Exports:153]PostDate:18; $aPostTime; [WMS_aMs_Exports:153]PostTime:19)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			UNLOAD RECORD:C212([WMS_aMs_Exports:153])
			REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
			
		Else 
			
			REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
			
		End if   // END 4D Professional Services : January 2019 
		
		//mark them as having been imported to aMs so wms can archive
		$sql:="UPDATE ams_exports SET transaction_state_indicator = 'X' "+"WHERE transaction_id = ?"
		//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
		//$result:=MySQL Execute ($conn_id;"";$stmt)
		
		uThermoInit($numElements; "Saving Status State change")
		For ($i; 1; $numElements)
			//MySQL Set Longint In SQL ($stmt;1;$aID{$i})
			//$result:=MySQL Execute ($conn_id;"";$stmt)
			uThermoUpdate($i)
		End for 
		uThermoClose
		//$result:=MySQL Execute ($conn_id;"";$stmt)
		
	Else 
		BEEP:C151
		zwStatusMsg("IMPORTING"; "There are no transactions to import: "+$1)
	End if 
	
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//now process them chronolgically
	//wms_api_process_transactions 
	
End if 

