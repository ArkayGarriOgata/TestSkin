//%attributes = {"publishedWeb":true}
//Procedure: uPurgeEstOrphs(»keyField)  062995  MLB
//•062995  MLB  UPR 1507
//• 5/1/97 cs replaced thermoset
//• 3/27/98 cs orphans were NOT written to disk - fixed
//• 3/27/98 cs added default path to file creation
//•063099  mlb  docname too long on some DifferntialForm table
//•092999  mlb  UPR clear set after reporting resuslts.

If (<>fContinue)  //esc pressed
	C_POINTER:C301($1; $fieldPtr; $filePtr)
	C_LONGINT:C283($i; $recs; $hit)
	C_TEXT:C284(xTitle; xText; $Path)
	$fieldPtr:=$1
	$filePtr:=Table:C252(Table:C252($1))
	C_TEXT:C284($docname)  //•063099  mlb  docname too long on some DifferntialForm table
	
	$Path:=<>purgeFolderPath
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) ADD TO SET
		
		CREATE EMPTY SET:C140($filePtr->; "DeleteThese")
		
		
	Else 
		
		ARRAY LONGINT:C221($_records_numbers; 0)
		
	End if   // END 4D Professional Services : January 2019 
	
	ALL RECORDS:C47($filePtr->)
	TRACE:C157
	$recs:=Records in selection:C76($filePtr->)  //Table name($FilePtr)+" "
	$docname:="Orf_"+Substring:C12(Table name:C256($FilePtr); 1; 16)+fYYMMDD(4D_Current_date; 2000)
	SET CHANNEL:C77(10; $Path+$docname)  //•063099  mlb  docname too long on some DifferntialForm table
	//SET CHANNEL(10;$Path+"Orphans-"+Table name($FilePtr)+" "+String(4D_Current_date)
	uThermoInit($recs; "Purging orphans from "+String:C10($recs; "###,##0 ")+Table name:C256($filePtr)+" records.")  //• 5/1/97 cs replaced thermoset
	
	For ($i; 1; $recs)
		$hit:=Find in array:C230(aEstimate; Substring:C12($fieldPtr->; 1; 9))
		
		If ($hit=-1)  //then it is an orphan
			
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) ADD TO SET
				
				ADD TO SET:C119($filePtr->; "DeleteThese")
				
				
			Else 
				
				APPEND TO ARRAY:C911($_records_numbers; Record number:C243($filePtr->))
				
				
			End if   // END 4D Professional Services : January 2019 
			SEND RECORD:C78($FilePtr->)
		End if 
		NEXT RECORD:C51($filePtr->)
		
		If (Not:C34(<>fContinue))
			$i:=$i+$recs
		End if 
		uThermoUpdate($i)  //• 5/1/97 cs replaced thermoset
	End for 
	
	SET CHANNEL:C77(11)
	uThermoClose  //• 5/1/97 cs replaced thermoset
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3)
		USE SET:C118("DeleteThese")
		
	Else 
		
		CREATE SET FROM ARRAY:C641($filePtr->; $_records_numbers; "DeleteThese")
		USE SET:C118("DeleteThese")
		
	End if   // END 4D Professional Services : January 2019 
	
	If (<>fContinue)
		xText:=xText+Char:C90(13)+String:C10(Records in set:C195("DeleteThese"); "^^^,^^^,^^0 ")+Table name:C256($filePtr)+" Orphans Deleted."
		DELETE SELECTION:C66($filePtr->)
		CLEAR SET:C117("DeleteThese")  //•092999  mlb  
		FLUSH CACHE:C297
	Else 
		xText:=xText+Char:C90(13)+"Purge Canceled, no "+Table name:C256($filePtr)+" were deleted."
	End if 
End if 
uClearSelection($FilePtr)
