//%attributes = {}
// _______
// Method: _version210903   ( ) ->
// By: Mel Bohince @ 09/02/21, 18:02:37
// Description
// Recover [edi_Outbox]SentTimeStamp lost during fucqueup'd
//   up applyToSelection to zero out timestamps for resending
//   use the Export below from the BACKUP datafile
//   and the Import below to the PRODUCTION datafile
// ----------------------------------------------------

C_TEXT:C284($jsonSentTimes_t)  //var used to and from document


CONFIRM:C162("Which?"; "Export"; "Import")
If (ok=1)  //export the id and sent
	//EXPORT by getting the edi_Outbox records with their ID's within a range
	// convert that entity selection to a collection containing the pk_ID and SentTimeStamp
	// then pack that collection in to an object calling the attribute "sentTimes"
	// so json stringify can send that object to a disk file
	
	
	C_OBJECT:C1216($outbox_es)
	C_LONGINT:C283($lowID; $highID)
	
	//set up for the query
	$lowID:=0
	$lowID:=Num:C11(Request:C163("Low ID = ?"; "260219"; "Continue"; "Abort"))
	If ($lowID>0) & (ok=1)
		$highID:=0
		$highID:=Num:C11(Request:C163("Hich ID = ?"; "269224"; "Continue"; "Abort"))
		If ($highID>0) & (ok=1)
			//let's do it!!
			$outbox_es:=ds:C1482.edi_Outbox.query("ID >= :1 and ID <= :2"; $lowID; $highID)
			If ($outbox_es.length>0)
				
				//prep a collection to save as json
				C_COLLECTION:C1488($_pkSentTime_c)
				$_pkSentTime_c:=$outbox_es.toCollection("SentTimeStamp"; dk with primary key:K85:6)
				
				C_OBJECT:C1216($jsonCollectionInObject)
				$jsonCollectionInObject:=New object:C1471("sentTimes"; $_pkSentTime_c)
				
				$jsonSentTimes_t:=JSON Stringify:C1217($jsonCollectionInObject; *)
				
				//get a file to save to
				C_TEXT:C284($path; $suggestFileName; $docName)  //see also pattern_SaveAs ( )
				$suggestFileName:="0timeStamps_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(Current time:C178; HH MM:K7:2); ":"; "")+".json"
				$path:=util_DocumentPath+$suggestFileName  //suggest putting in the ams_doc's folder
				$docName:=Select document:C905($path; "json"; "Save the TimeStamps as:"; File name entry:K24:17)
				If (ok=1)
					$docRef:=Create document:C266(Document)  //name the export file
					If (ok=1)
						
						CLOSE DOCUMENT:C267($docRef)  //document is ready for use
						TEXT TO DOCUMENT:C1237(Document; $jsonSentTimes_t)  //save the primary keys and sent timestamp
						BEEP:C151
						
					End if   //create
				End if   //path
				
			Else   //lenght=0
				ALERT:C41("No edi_Outbox records with ID between "+String:C10($lowID)+" and "+String:C10($highID))
			End if   //length
			
			
		End if   //high#given
	End if   //low#given
	
	
Else   //import
	//IMPORT by reading a disk file containing a JSON object
	// and updating the SentTimeStamp for every entity 
	// in the "sentTimes" collection of that object
	
	//find the exported file with the timestamp found in the backup data
	ARRAY TEXT:C222($paths; 0)
	$document:=Select document:C905(""; "json"; "Select the JSON file to import:"; 0; $paths)
	If ((ok=1) & (Size of array:C274($paths)=1))
		
		$jsonSentTimes_t:=Document to text:C1236($paths{1})
		
		//convert the imported text into a useable object
		C_OBJECT:C1216($importedJson_o)
		$importedJson_o:=JSON Parse:C1218($jsonSentTimes_t)  //this is an object with a property called SentTimes that is a collection of pk_ids (as __KEY) and timestamps
		
		C_OBJECT:C1216($edi_Outbox_e; $importedOutBoxKeyPair_o; $status_o)
		
		//process each key/value pair in the collection
		For each ($importedOutBoxKeyPair_o; $importedJson_o.sentTimes)
			$edi_Outbox_e:=ds:C1482.edi_Outbox.get($importedOutBoxKeyPair_o.__KEY)
			$edi_Outbox_e.SentTimeStamp:=$importedOutBoxKeyPair_o.SentTimeStamp
			$status_o:=$edi_Outbox_e.save()
			If (Not:C34($status_o.success))
				BEEP:C151
				TRACE:C157
			End if 
			
		End for each 
		BEEP:C151
		
	End if   //doc selected
	
End if   //export/import