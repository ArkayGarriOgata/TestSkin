//%attributes = {}
//Method: Util_UniqueRecord(pTable)
//Descprition:  This method will make sure that a unique record is ready
// to be modified or created for table

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pTable)
	C_LONGINT:C283($nNumberOfRecords)
	
	$pTable:=$1
	
	$nNumberOfRecords:=Records in selection:C76($pTable->)
	
End if   //Done Initialize

Case of   //Number of records
		
	: ($nNumberOfRecords=0)
		
		CREATE RECORD:C68($pTable->)
		
	: ($nNumberOfRecords=1)
		
		READ WRITE:C146($pTable->)
		LOAD RECORD:C52($pTable->)
		
	: ($nNumberOfRecords>1)
		
		DELETE SELECTION:C66($pTable->)
		CREATE RECORD:C68($pTable->)
		
End case   //Done number of records
