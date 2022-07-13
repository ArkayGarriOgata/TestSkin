//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_Get_aMs_Transactions - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumImported)
C_TEXT:C284($1; $ttType)
If (Count parameters:C259>0)
	$ttType:=$1
End if 
$xlNumImported:=0

Case of 
	: ((Count parameters:C259>0) & <>fWMS_Use4D)
		$xlNumImported:=WMS_API_4D_getAMSTransactions($ttType)
		
	: (<>fWMS_Use4D)
		$xlNumImported:=WMS_API_4D_getAMSTransactions
		
	: (Count parameters:C259>0)
		$xlNumImported:=wms_api_MySQL_GetaMsTransaction($ttType)
		
	Else 
		$xlNumImported:=wms_api_MySQL_GetaMsTransaction
		
End case 

$0:=$xlNumImported

If (False:C215)  //v0.1.0-JJG (05/16/16) - moved to wms_api_MySQL_getaMsTransaction
	//  // ----------------------------------------------------
	//  // User name (OS): mel
	//  // Date and time: 05/10/08, 14:42:25
	
	//  // Modified by: Mel Bohince (11/15/12) test for duplicate id's
	//  // ----------------------------------------------------
	//  // Method: wms_api_Get_aMs_Transactions({transactionType})
	//  // Description
	//  // pull records from the wms.ams_exports table
	//  //
	//  //types:
	//  //100 = receipt
	//  //200 = move
	//  //300 = release picked
	//  //400 =
	//  //500 = bol complete
	
	//  // Parameters
	//  // ----------------------------------------------------
	
	//C_TEXT($1)  //optional transaction type
	//C_LONGINT($i;$numElements;$numRecs;$0;$num_transactions)
	//$0:=0
	//C_BOOLEAN($break)
	//$break:=False
	//READ WRITE([WMS_aMs_Exports])
	
	//$conn_id:=DB_ConnectionManager ("Open")
	//If ($conn_id>0)
	//  //set up the import from mysql
	
	
	//If (Count parameters=0)
	//$sql:="SELECT * FROM ams_exports WHERE "
	//$sql:=$sql+"transaction_state_indicator = 'S'"  //not yet imported as indicated by 'S' rather than 'X'
	//Else 
	//$sql:="SELECT * FROM ams_exports WHERE "
	//$sql:=$sql+"transaction_state_indicator = 'S' AND "  //not yet imported as indicated by 'S' rather than 'X'
	//$sql:=$sql+"transaction_type_code = '"+$1+"' "  //looking for specific types of transactions *** was <= $1  ****
	//End if 
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$row_count:=MySQL Get Row Count ($row_set)
	//$0:=$row_count
	//If ($row_count>0)
	//ARRAY LONGINT($aID;0)
	//ARRAY LONGINT($aCode;0)
	//ARRAY TEXT($aState;0)
	//ARRAY DATE($aDate;0)
	//ARRAY TEXT($aTime;0)
	//ARRAY TEXT($aInitials;0)
	//ARRAY LONGINT($aBOL;0)
	//ARRAY LONGINT($aRel;0)
	//ARRAY TEXT($aJobit;0)
	//ARRAY TEXT($aBin;0)
	//ARRAY LONGINT($aQty;0)
	//ARRAY TEXT($aTo;0)
	//ARRAY TEXT($aFrom;0)
	//ARRAY TEXT($aSkidId;0)
	//ARRAY TEXT($aCaseId;0)
	//ARRAY INTEGER($aNumCases;0)
	//ARRAY TEXT($aFromBinID;0)
	
	//ARRAY DATE($aPostDate;0)
	//ARRAY TEXT($aPostTime;0)
	
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
	
	//$numElements:=Size of array($aID)  // Modified by: mel (1/7/10)
	//ARRAY DATE($aPostDate;$numElements)
	//ARRAY TEXT($aPostTime;$numElements)
	//$nowDate:=4D_Current_date
	//$nowTime:=String(4d_Current_time;HH MM SS)
	//For ($i;1;$numElements)
	//$aPostDate{$i}:=$nowDate
	//$aPostTime{$i}:=$nowTime
	//End for 
	
	//  //$row:=1
	//  //While ($row<=Size of array($aID))
	//  //$hit:=Find in array(aExsistingTransactions;$aID{$row})
	//  //If ($hit>-1)
	//  //DELETE FROM ARRAY($aID;$row;1)
	//  //DELETE FROM ARRAY($aCode;$row;1)
	//  //DELETE FROM ARRAY($aState;$row;1)
	//  //DELETE FROM ARRAY($aDate;$row;1)
	//  //DELETE FROM ARRAY($aTime;$row;1)
	//  //DELETE FROM ARRAY($aInitials;$row;1)
	//  //DELETE FROM ARRAY($aBOL;$row;1)
	//  //DELETE FROM ARRAY($aRel;$row;1)
	//  //DELETE FROM ARRAY($aJobit;$row;1)
	//  //DELETE FROM ARRAY($aBin;$row;1)
	//  //DELETE FROM ARRAY($aQty;$row;1)
	//  //DELETE FROM ARRAY($aTo;$row;1)
	//  //DELETE FROM ARRAY($aFrom;$row;1)
	//  //DELETE FROM ARRAY($aSkidId;$row;1)
	//  //DELETE FROM ARRAY($aCaseId;$row;1)
	//  //DELETE FROM ARRAY($aNumCases;$row;1)
	//  //DELETE FROM ARRAY($aFromBinID;$row;1)
	//  //DELETE FROM ARRAY($aPostDate;$row;1)
	//  //DELETE FROM ARRAY($aPostTime;$row;1)
	//  //Else 
	//  //$row:=$row+1
	//  //End if 
	//  //End while 
	//  //
	//  //$numElements:=Size of array($aID)
	
	//REDUCE SELECTION([WMS_aMs_Exports];0)
	//ARRAY TO SELECTION($aID;[WMS_aMs_Exports]id;$aCode;[WMS_aMs_Exports]TypeCode;$aState;[WMS_aMs_Exports]StateIndicator;$aDate;[WMS_aMs_Exports]TransDate;$aTime;[WMS_aMs_Exports]TransTime;$aInitials;[WMS_aMs_Exports]ModWho;$aBOL;[WMS_aMs_Exports]BOL_Number;$aRel;[WMS_aMs_Exports]Release_Number;$aJobit;[WMS_aMs_Exports]Jobit;$aBin;[WMS_aMs_Exports]BinId;$aQty;[WMS_aMs_Exports]ActualQty;$aTo;[WMS_aMs_Exports]To_aMs_Location;$aFrom;[WMS_aMs_Exports]From_aMs_Location;$aSkidId;[WMS_aMs_Exports]Skid_number;$aCaseId;[WMS_aMs_Exports]case_id;$aNumCases;[WMS_aMs_Exports]number_of_cases;$aFromBinID;[WMS_aMs_Exports]from_Bin_id;$aPostDate;[WMS_aMs_Exports]PostDate;$aPostTime;[WMS_aMs_Exports]PostTime)
	//UNLOAD RECORD([WMS_aMs_Exports])
	//REDUCE SELECTION([WMS_aMs_Exports];0)
	
	//  //mark them as having been imported to aMs so wms can archive
	//$sql:="UPDATE ams_exports SET transaction_state_indicator = 'X' "+"WHERE transaction_id = ?"
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//$result:=MySQL Execute ($conn_id;"";$stmt)
	
	//uThermoInit ($numElements;"Saving Status State change")
	//For ($i;1;$numElements)
	//MySQL Set Longint In SQL ($stmt;1;$aID{$i})
	//$result:=MySQL Execute ($conn_id;"";$stmt)
	//uThermoUpdate ($i)
	//End for 
	//uThermoClose 
	//  //$result:=MySQL Execute ($conn_id;"";$stmt)
	
	//Else 
	//BEEP
	//zwStatusMsg ("IMPORTING";"There are no transactions to import: "+$1)
	//End if 
	
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//  //now process them chronolgically
	//  //wms_api_process_transactions 
	
	//End if 
End if 
