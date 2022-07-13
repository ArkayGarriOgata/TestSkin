//%attributes = {}
// _______
// Method: patternCollectionToObject   ( ) ->
// By: Mel Bohince @ 09/03/21, 17:03:24
// Description
// see _version210903 for actual usage
// ----------------------------------------------------

//some scaffoldling for the compilers sake
C_OBJECT:C1216($outbox_es)
C_LONGINT:C283($lowID; $highID)
$outbox_es:=ds:C1482.edi_Outbox.query("ID >= :1 and ID <= :2"; $lowID; $highID)
If ($outbox_es.length>0)
	
	//prep a collection to save as json
	C_COLLECTION:C1488($_pkSentTime_c)
	
	//PATTERN STARTS HERE, get yourself a collection
	$_pkSentTime_c:=$outbox_es.toCollection("SentTimeStamp"; dk with primary key:K85:6)
	
	//then assign it to a attribute inside and object
	C_OBJECT:C1216($jsonCollectionInObject)
	$jsonCollectionInObject:=New object:C1471("sentTimes"; $_pkSentTime_c)
	
	$jsonSentTimes_t:=JSON Stringify:C1217($jsonCollectionInObject; *)
	
	//later you can loop thru them:
	//process each key/value pair in the collection
	//For each ($importedOutBoxKeyPair_o;$importedJson_o.sentTimes)
	//  //do something here
	//  //...
	//End for each 
	
End if 