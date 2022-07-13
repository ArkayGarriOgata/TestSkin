//%attributes = {"publishedWeb":true}
//Procedure: doExportRecs()  051895  MLB
//see also doImportRecs
//•081595  MLB 
//• 5/15/97 cs unloaded last record exported
//• 5/30/97 cs made search editor & 'all records work, display selected records 
//  BEFORE exporting
//• 4/17/98 cs include exclude button function
//•052099  mlb  smooth out function in User Environmnet


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
	If (uSelectFile)  //Choose file
		filePtr:=<>filePtr
		$tablePointer:=filePtr
		uSetUp(1)
		
		If (rbSearchEd=1)  //• 5/30/97 cs make search or get all records
			QUERY:C277($tablePointer->)
		Else 
			ALL RECORDS:C47($tablePointer->)
			OK:=1
		End if 
		
		CREATE SET:C116($tablePointer->; "CurrentSet")  //• 4/17/98 cs include exclude button function
		//• 5/30/97 cs opened processes own window    
		$winRef:=NewWindow(500; 350; 0; 8; "Exporting "+String:C10(Records in selection:C76($tablePointer->))+" from "+Table name:C256($tablePointer))
		fAdHocLocal:=True:C214  //flag that this any other searching is a search dialog
		DISPLAY SELECTION:C59($tablePointer->; *)  //• 5/30/97 cs display selected records
		CLOSE WINDOW:C154($winRef)  //closes window records are displayed in    
		
	End if 
End if 

If (OK=1) & (Records in selection:C76($tablePointer->)>0)  //search OK or all records, stop if no records found
	
	CONFIRM:C162("Export selected records from "+Table name:C256($tablePointer)+"?")  //confirm export
	If (OK=1)
		
		SET CHANNEL:C77(12; "")
		If (OK=1)
			<>fContinue:=True:C214
			ON EVENT CALL:C190("eCancelProc")
			$NumRecs:=Records in selection:C76($tablePointer->)
			$winRef:=NewWindow(300; 80; 6; 0; "Exporting")  //•081595  MLB, made non modal `• 5/30/97 cs  
			GOTO XY:C161(1; 0)
			MESSAGE:C88("Exporting from "+Table name:C256($tablePointer)+".")
			GOTO XY:C161(1; 2)
			MESSAGE:C88("Press Command+. to stop.")
			FIRST RECORD:C50($tablePointer->)
			$i:=0
			
			Repeat 
				SEND RECORD:C78($tablePointer->)
				NEXT RECORD:C51($tablePointer->)
				$i:=$i+1
				
				If (($i%10)=0)
					GOTO XY:C161(2; 4)
					MESSAGE:C88("Records remaining to be exported: "+String:C10(($NumRecs-$i); "^^^,^^^,^^^"))
				End if 
			Until ((End selection:C36($tablePointer->)) | (Not:C34(<>fContinue)))
			
			CLOSE WINDOW:C154($winRef)
			ON EVENT CALL:C190("")
			BEEP:C151
			
			If (<>fContinue)
				ALERT:C41("Export completed. "+String:C10($i)+" records exported from "+Table name:C256($tablePointer)+".")
			Else 
				BEEP:C151
				ALERT:C41("Export stopped. Better check the results.")
			End if 
		End if 
		SET CHANNEL:C77(11)
	End if 
Else 
	If (Records in selection:C76($tablePointer->)=0)
		ALERT:C41("Nothing Found.")
	End if 
End if 
UNLOAD RECORD:C212($tablePointer->)
