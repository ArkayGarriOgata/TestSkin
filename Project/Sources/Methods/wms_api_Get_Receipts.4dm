//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_Get_Receipts - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
//re-written for MySQL vs 4D

C_LONGINT:C283($0; $xlAggregates)
$xlAggregates:=0

If (<>fWMS_Use4D)
	$xlAggregates:=WMS_API_4D_getReceipts
Else 
	$xlAggregates:=wms_api_MySQL_Get_Receipts
End if 

$0:=$xlAggregates




If (False:C215)  //v0.1.0-JJG (05/16/16) - moved to wms_api_MySQ_Get_Reeipts
	//  // ----------------------------------------------------
	//  // User name (OS): mel
	//  // Date and time: 05/10/08, 14:42:25
	//  // ----------------------------------------------------
	//  // Method: wms_api_Get_Receipts
	//  // Description
	//  // pull records from the wms.ams_exports table that are Receipts (type 100)
	//  //
	//  // Parameters - none
	//  // Modified by: Mel Bohince (11/15/12)
	
	
	//  // ----------------------------------------------------
	
	//C_LONGINT($row;$0;$transaction_code;$cases;$aggregates)
	//$aggregates:=0
	//$cases:=0
	//$transaction_code:=100
	//  //C_LONGINT($aggregate_id)
	//  //$aggregate_id:=TSTimeStamp   `TS2iso   `used to mark the batch
	//C_DATE($date)
	//C_TIME($time)
	//TS2DateTime (TSTimeStamp ;->$date;->$time)  //becomes time of import, not time of scan
	//C_BOOLEAN($break)
	//$break:=False
	//READ WRITE([WMS_aMs_Exports])
	
	//$conn_id:=DB_ConnectionManager ("Open")
	//If ($conn_id>0)
	//  //set up the import from mysql
	
	//  //mark them as being targeted incase new ones arrive while this is running
	//$sql:="UPDATE ams_exports SET transaction_state_indicator = 'T' "+"WHERE transaction_state_indicator = 'S' AND transaction_type_code = '100'"
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//$cases:=MySQL Execute ($conn_id;"";$stmt)
	//If ($cases>0)
	//  //mysql> select bin_id, jobit, to_ams_location, sum(actual_qty) 
	//  //     from ams_export_archives 
	//  //     where transaction_type_code = 100 and transaction_state_indicator = 'S'  
	//  //     group by bin_id, jobit, to_ams_location;
	
	//  //mysql> select max(transaction_id) as id, bin_id, jobit, to_ams_location, sum(actual_qty) from ams_exports where transaction_type_code = 100 and transaction_state_indicator = 'X' group by bin_id, jobit, to_ams_location order by jobit;
	
	//$sql:="SELECT  max(transaction_id) as id, jobit, bin_id, transaction_initials, "
	//$sql:=$sql+"sum(actual_qty), skid_number, sum(number_of_cases), from_bin_id "
	//$sql:=$sql+"FROM ams_exports "
	//$sql:=$sql+"WHERE transaction_state_indicator = 'T' "  //not yet imported but Targeted this run'
	//$sql:=$sql+"AND transaction_type_code = '100' "  //looking for specific types of transactions *** was <= $1  ****
	//$sql:=$sql+"GROUP BY skid_number, from_bin_id"
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$aggregates:=MySQL Get Row Count ($row_set)
	//If ($aggregates>0)
	//  //this is the arrays for the full ams_exports records
	//ARRAY LONGINT($aID;0)  //$aggregate_id
	//ARRAY LONGINT($aCode;0)  //$transaction_code
	//ARRAY TEXT($aState;0)  //S
	//ARRAY DATE($aDate;0)  //$date
	//ARRAY TEXT($aTime;0)  //$time
	//ARRAY TEXT($aInitials;0)
	//ARRAY LONGINT($aBOL;0)  //0
	//ARRAY LONGINT($aRel;0)  //0
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
	
	
	//  //pull the grouped values
	//MySQL Column To Array ($row_set;"";1;$aID)
	//MySQL Column To Array ($row_set;"";2;$aJobit)
	//MySQL Column To Array ($row_set;"";3;$aBin)
	//MySQL Column To Array ($row_set;"";4;$aInitials)
	//MySQL Column To Array ($row_set;"";5;$aQty)
	//MySQL Column To Array ($row_set;"";6;$aSkidId)
	//MySQL Column To Array ($row_set;"";7;$aNumCases)
	
	//  //default the missing data
	//  //ARRAY LONGINT($aID;$aggregates)  `$aggregate_id
	//ARRAY LONGINT($aCode;$aggregates)  //$transaction_code
	//ARRAY TEXT($aState;$aggregates)  //S
	//ARRAY DATE($aDate;$aggregates)  //$date
	//ARRAY TEXT($aTime;$aggregates)  //$time
	//ARRAY LONGINT($aBOL;$aggregates)  //0
	//ARRAY LONGINT($aRel;$aggregates)  //0
	//ARRAY TEXT($aTo;$aggregates)
	//ARRAY TEXT($aFrom;$aggregates)
	//ARRAY TEXT($aFromBinID;$aggregates)
	//ARRAY TEXT($aCaseId;$aggregates)
	//ARRAY DATE($aPostDate;$aggregates)
	//ARRAY TEXT($aPostTime;$aggregates)
	//$nowDate:=4D_Current_date
	//$nowTime:=String(4d_Current_time;HH MM SS)  // Modified by: mel (1/7/10)
	//For ($row;1;$aggregates)
	//  //$aID{$row}:=$aggregate_id
	//$aCode{$row}:=100
	//$aState{$row}:="S"
	//$aDate{$row}:=$date
	//$aTime{$row}:=String($time;HH MM SS)
	//$aTo{$row}:="CC"  //:"+Substring($aBin{$row};3;1)
	//$aFrom{$row}:="WiP"
	//$aCaseId{$row}:=""
	//$aPostDate{$row}:=$nowDate
	//$aPostTime{$row}:=$nowTime
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
	
	//REDUCE SELECTION([WMS_aMs_Exports];0)
	//ARRAY TO SELECTION($aID;[WMS_aMs_Exports]id;$aCode;[WMS_aMs_Exports]TypeCode;$aState;[WMS_aMs_Exports]StateIndicator;$aDate;[WMS_aMs_Exports]TransDate;$aTime;[WMS_aMs_Exports]TransTime;$aInitials;[WMS_aMs_Exports]ModWho;$aBOL;[WMS_aMs_Exports]BOL_Number;$aRel;[WMS_aMs_Exports]Release_Number;$aJobit;[WMS_aMs_Exports]Jobit;$aBin;[WMS_aMs_Exports]BinId;$aQty;[WMS_aMs_Exports]ActualQty;$aTo;[WMS_aMs_Exports]To_aMs_Location;$aFrom;[WMS_aMs_Exports]From_aMs_Location;$aSkidId;[WMS_aMs_Exports]Skid_number;$aCaseId;[WMS_aMs_Exports]case_id;$aNumCases;[WMS_aMs_Exports]number_of_cases;$aFromBinID;[WMS_aMs_Exports]from_Bin_id;$aPostDate;[WMS_aMs_Exports]PostDate;$aPostTime;[WMS_aMs_Exports]PostTime)
	//UNLOAD RECORD([WMS_aMs_Exports])
	//REDUCE SELECTION([WMS_aMs_Exports];0)
	
	
	//  //mark them as having been imported to aMs so wms can archive
	//$sql:="UPDATE ams_exports SET transaction_state_indicator = 'X' "+"WHERE transaction_state_indicator = 'T' AND transaction_type_code = '100'"
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//$cases:=MySQL Execute ($conn_id;"";$stmt)  //
	
	//Else 
	//BEEP
	//zwStatusMsg ("IMPORTING";"There are no transactions to import: code = 100")
	//End if 
	
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//Else 
	//BEEP
	//zwStatusMsg ("IMPORTING";"There are no cases received to update: state = T")
	//End if 
	
	//End if 
	//$0:=$aggregates
End if 
