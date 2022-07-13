//%attributes = {"publishedWeb":true}
//Procedure: doImportRecs()  051895  MLB
//•081595  MLB  
//• 5/30/97 cs re-odered actions - confirm import AFTER file select, others
// Modified by: Mel Bohince (6/14/16) update to v14
//see also doExportRecs 

C_LONGINT:C283($table; $numTables; $tableNumber)
PROCESS PROPERTIES:C336(Current process:C322; $procName; $procState; $procTime)
If ($procName="User/Custom@") | ($procName="Application process")  //•052099  mlb  smooth out function in User Environmnet
	
	//overwrite results of method ams_get_tables if it had been called
	
	//make a hash of tablename/tablenumber so we can get a pointer to the table in next step
	$numTables:=Get last table number:C254
	ARRAY TEXT:C222(<>axFiles; $numTables)
	ARRAY INTEGER:C220(<>axFileNums; $numTables)  //•051496  MLB 
	
	For ($table; 1; $numTables)
		If (Is table number valid:C999($table))
			<>axFiles{$table}:=Table name:C256($table)
			<>axFileNums{$table}:=$table  //Store the filenumber by position
		Else 
			<>axFiles{$table}:="invalid table"
			<>axFileNums{$table}:=$table
		End if 
	End for 
	
	
	//use the window name fo the application process window to determing the name of the table we're sitting on
	// it's in the form of [structure name +" - "+tablename+": "+records of total records]
	$windowName:=Get window title:C450(Frontmost window:C447)
	$colon:=Position:C15(":"; $windowName)  // use to use util_docGetShortName to parse out un-need window title crap
	$windowName:=Substring:C12($windowName; 1; ($colon-1))
	$hyphen:=Position:C15("-"; $windowName)
	$tableName:=Substring:C12($windowName; ($hyphen+2))
	
	$table:=Find in array:C230(<>axFiles; $tableName)
	If ($table>-1)
		$tablePointer:=Table:C252(<>axFileNums{$table})  //get the pointer and do some setup
		$tableNumber:=Table:C252($tablePointer)
		OK:=1
	Else 
		ok:=0
	End if 
	
Else   //select the file from the list, untested but should work
	zDefFilePtr:=->[Usage_Problem_Reports:84]
	uSelectFile  //Choose file
	$tablePointer:=<>filePtr
	$tableName:=Table name:C256($tablePointer)
	$tableNumber:=Table:C252($tablePointer)
End if 

If (OK=1)
	SET CHANNEL:C77(10; "")
	$Doc:=Document
	CONFIRM:C162("Import records into "+$tableName+"?")
	
	If (OK=1)
		<>fContinue:=True:C214
		ON EVENT CALL:C190("eCancelProc")
		i:=0
		$winRef:=NewWindow(300; 80; 6; 0; "Importing")  //•081595  MLB  , 5/30/97 cs made this non modal
		GOTO XY:C161(1; 0)
		MESSAGE:C88("Importing into "+$tableName+".")
		GOTO XY:C161(1; 2)
		MESSAGE:C88("Press Command+. to stop.")
		
		//location the primary key field
		$numFields:=Get last field number:C255($tablePointer)
		$primaryKey:=0
		For ($field; 1; $numFields)
			$fieldName:=Field name:C257($tableNumber; $field)
			If ($fieldName="pk_id")
				$primaryKey:=$field
				$field:=$field+$numFields  //break
			End if 
		End for 
		
		RECEIVE RECORD:C79($tablePointer->)
		
		While ((OK=1) & (<>fContinue))
			If (Is field number valid:C1000($tablePointer; $primaryKey))
				pkPtr:=Field:C253($tableNumber; $primaryKey)
				pkPtr->:=Generate UUID:C1066
			End if 
			SAVE RECORD:C53($tablePointer->)
			i:=i+1
			RECEIVE RECORD:C79($tablePointer->)
			
			If ((i%10)=0)
				GOTO XY:C161(2; 4)
				MESSAGE:C88(String:C10(i; "^^,^^^")+" records read.")
			End if 
		End while 
		
		CLOSE WINDOW:C154($winRef)
		ON EVENT CALL:C190("")
		BEEP:C151
		
		If (<>fContinue)
			If (i<1)
				ALERT:C41("Import failed. Make sure the incoming records are correct for "+Table name:C256($tablePointer)+".")
			End if 
		Else 
			BEEP:C151
			ALERT:C41("Import stopped. Better check the results.")
		End if 
	End if 
	SET CHANNEL:C77(11)
End if 
//uWinListCleanup 