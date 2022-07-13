//%attributes = {}
// _______
// Method: FGX_recovery   ( ) ->
// By: Mel Bohince @ 04/26/21, 14:16:01
// Description
// Recover FG_Transaction records from an older datafile
// that are missing in a current datafile by importing only
// the records that are missing.
// ----------------------------------------------------
// Modified by: Mel Bohince (5/4/21) prompt for phase of running

C_BOOLEAN:C305($exportPrimaryKeys; $exportMissingRecords; $importMissingRecords)  //
C_TEXT:C284($havePk_t; $query)  //will be the exported primary key data from the current data file
C_COLLECTION:C1488($pKey_c; $pKeyStripped_c)  //collection to convert array to text, & without property name
ARRAY TEXT:C222($_pk_id; 0)  //array of primary keys
C_OBJECT:C1216($fgx_es; $fgx_e)
C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
$csvToExport:=""
$fieldDelimitor:=","
$recordDelimitor:="\r"

//$query:=" XactionDate >= '2021-01-01' & XactionDate <= '2021-04-30' & Jobit # '00000@' & XactionType = 'Ship' "
$begin_t:="2021-01-01"
$end_t:=Substring:C12(String:C10(Current date:C33; ISO date:K1:8); 1; 10)
$query:=" XactionDate >= '"+$begin_t+"' & XactionDate <= '"+$end_t+"' & Jobit # '00000@' "

//decide what step we are doing.
$exportPrimaryKeys:=False:C215
$exportMissingRecords:=False:C215
$importMissingRecords:=False:C215
CONFIRM:C162("0: Exporting current pk_id's from "+Data file:C490+"?"; "Yes"; "Other")  // Modified by: Mel Bohince (5/4/21) 
If (ok=1)  //step 1
	$exportPrimaryKeys:=True:C214
	
Else 
	CONFIRM:C162("1:  Exporting missing records from "+Data file:C490+"?"; "Yes"; "Other")
	If (ok=1)  //step 2
		$exportMissingRecords:=True:C214
		
	Else 
		CONFIRM:C162("2: Import missing records into "+Data file:C490+"?"; "Yes"; "Abort")
		If (ok=1)  //step 3
			
			CONFIRM:C162("3:  Have you set the 'skipTrigger' column to TRUE."; "Yes"; "Abort")
			If (ok=1)
				$importMissingRecords:=True:C214
			Else 
				$importMissingRecords:=False:C215  //abort
			End if 
		End if 
	End if 
End if 

Case of 
		
	: ($exportPrimaryKeys)  //1) Starting with the current data file, determine what fgx records are present in the current datafile so they are not duplicated
		//save the primary keys to a document
		//prep the document
		
		C_TEXT:C284($path; $suggestFileName; $docName)  //see also pattern_SaveAs ( )
		$suggestFileName:="pk_ids_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(Current time:C178; HH MM:K7:2); ":"; "")+".csv"
		$path:=util_DocumentPath+$suggestFileName  //suggest putting in the ams_doc's folder
		$docName:=Select document:C905($path; "CSV"; "Save the Primary Keys as:"; File name entry:K24:17)
		If (ok=1)
			$docRef:=Create document:C266(Document)  //name the export file
			If (ok=1)
				CLOSE DOCUMENT:C267($docRef)  //document is ready for use
				
				$fgx_es:=ds:C1482.Finished_Goods_Transactions.query($query)
				
				//prep a collection to use .join
				$pKey_c:=$fgx_es.toCollection("pk_id")
				COLLECTION TO ARRAY:C1562($pKey_c; $_pk_id; "pk_id")  // strip of the property name  //$tpk_id:=Core_Array_ToTextT (->$atpk_id;CorektCR)
				$pKeyStripped_c:=New collection:C1472
				ARRAY TO COLLECTION:C1563($pKeyStripped_c; $_pk_id)  //clean collection ready for a join
				$havePk_t:=$pKeyStripped_c.join("\r")
				
				zwStatusMsg("EXPORT PKID"; String:C10($fgx_es.length)+" will be saved to "+Document)
				TEXT TO DOCUMENT:C1237(Document; $havePk_t)  //save the primary keys
				BEEP:C151
				
			End if   //doc was created
		End if   //selected doc location
		
	: ($exportMissingRecords)  //2) Switch to the older datafile, find the set difference between the present records and all available tranactions (of the same criteria)
		ARRAY TEXT:C222($paths; 0)
		$document:=Select document:C905(util_DocumentPath; "CSV"; "Select the Primary Key comparison file:"; 0; $paths)
		If ((ok=1) & (Size of array:C274($paths)=1))
			$havePk_t:=Document to text:C1236($paths{1})
			
			$pKey_c:=New collection:C1472
			$pKey_c:=Split string:C1554($havePk_t; "\r")
			
			ARRAY TEXT:C222($_pk_id; 0)
			COLLECTION TO ARRAY:C1562($pKey_c; $_pk_id)
			
			QUERY WITH ARRAY:C644([Finished_Goods_Transactions:33]pk_id:37; $_pk_id)
			CREATE SET:C116([Finished_Goods_Transactions:33]; "Have")
			
			$fgx_es:=ds:C1482.Finished_Goods_Transactions.query($query)
			USE ENTITY SELECTION:C1513($fgx_es)
			
			CREATE SET:C116([Finished_Goods_Transactions:33]; "All")
			
			DIFFERENCE:C122("All"; "Have"; "HaveNot")
			USE SET:C118("HaveNot")
			
			//3) Export the needed records from the older datafile
			ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3; >; [Finished_Goods_Transactions:33]ProductCode:1; >)
			
			
			$fgx_es:=Create entity selection:C1512([Finished_Goods_Transactions:33])
			util_EntitySelection_To_CSV($fgx_es; "21,23,25,35")
			
		End if   //selected pk id file for doing the difference set
		
	: ($importMissingRecords)  //3) Import the needed records into the current datafile
		
		$numImported:=util_Import_From_CSV(->[Finished_Goods_Transactions:33]; "21,23,25,35,36")
		ALERT:C41(String:C10($numImported)+" records were imported"; "Awesome")
		
End case 

