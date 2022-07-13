//%attributes = {}
//Method:  Batch_0000_Run(tBatchName)
//Description:  This method will run tBatchName just like
//.  it was the only one to run. It will only run this method
// if run from production it is up to the user to change back 
// the date and time.

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tBatchName)
	
	$tBatchName:=$1
	
	READ WRITE:C146([y_batches:10])
	
	QUERY:C277([y_batches:10]; [y_batches:10]Daily:5=True:C214; *)
	QUERY:C277([y_batches:10];  | ; [y_batches:10]Weekly:6=True:C214; *)
	QUERY:C277([y_batches:10];  | ; [y_batches:10]Monthly:7=True:C214)
	
	$nNumberOfBatches:=Records in selection:C76([y_batches:10])
	
	CREATE EMPTY SET:C140([y_batches:10]; "Daily")
	CREATE EMPTY SET:C140([y_batches:10]; "Weekly")
	CREATE EMPTY SET:C140([y_batches:10]; "Monthly")
	
End if   //Done Initialize

For ($nBatch; 1; $nNumberOfBatches)  //Checked sets
	
	GOTO SELECTED RECORD:C245([y_batches:10]; $nBatch)
	
	Case of   //Set
			
		: ([y_batches:10]Daily:5=True:C214)
			
			ADD TO SET:C119([y_batches:10]; "Daily")
			
		: ([y_batches:10]Weekly:6=True:C214)
			
			ADD TO SET:C119([y_batches:10]; "Daily")
			
		: ([y_batches:10]Monthly:7=True:C214)
			
			ADD TO SET:C119([y_batches:10]; "Daily")
			
	End case   //Done set
	
End for   //Done checked sets

APPLY TO SELECTION:C70([y_batches:10]; [y_batches:10]Daily:5:=False:C215)  //UnCheck All
APPLY TO SELECTION:C70([y_batches:10]; [y_batches:10]Weekly:6:=False:C215)
APPLY TO SELECTION:C70([y_batches:10]; [y_batches:10]Monthly:7:=False:C215)

If (Core_Query_UniqueRecordB(->[y_batches:10]BatchName:1; ->$tBatchName))  //Check tBatchName
	
	[y_batches:10]Daily:5:=True:C214
	
	SAVE RECORD:C53([y_batches:10])
	
End if   //Done check tBatchName

CHANGE CURRENT USER:C289(2; "ams4dba")  //Change to administrator

bBatch_Runner  //Run method

CHANGE CURRENT USER:C289(1; "1147")  //Change back to designer

USE SET:C118("Daily")
APPLY TO SELECTION:C70([y_batches:10]; [y_batches:10]Daily:5:=True:C214)

USE SET:C118("Weekly")
APPLY TO SELECTION:C70([y_batches:10]; [y_batches:10]Weekly:6:=True:C214)

USE SET:C118("Monthly")
APPLY TO SELECTION:C70([y_batches:10]; [y_batches:10]Monthly:7:=True:C214)

CLEAR SET:C117("Daily")
CLEAR SET:C117("Weekly")
CLEAR SET:C117("Monthly")

Core_Table_ReadOnly(->[y_batches:10])
