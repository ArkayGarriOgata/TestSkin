//%attributes = {"publishedWeb":true}
//(p) NANFinder
//allows locating & fixing of NANs
//• 12/11/97 cs 

C_BOOLEAN:C305($CheckField; $Continue)
C_LONGINT:C283($FileNum)
C_POINTER:C301($File)

uWinListCleanup

uYesNoCancel("Check for NANs in all fields in a file?"+Char:C90(13)+"   or"+Char:C90(13)+"a specific field,"+Char:C90(13)+"   or"+Char:C90(13)+"Process in multiple fields in Batch?"; "File"; "Field"; "Batch")

If (bCancel=1)
	NanBatcher
Else 
	$CheckField:=(OK=0)
	$Continue:=False:C215
	
	If (uSelectFile)  //*Choose file
		$File:=<>filePtr
		$FileNum:=Table:C252($File)
		ARRAY TEXT:C222($FieldName; Get last field number:C255($File))  //*set up field pointerd for searching and fixing
		ARRAY POINTER:C280(aSlcFldPtr; Get last field number:C255($File))
		
		For ($i; 1; Get last field number:C255($File))  //*build array of field pointers & field names
			$FieldName{$i}:=Field name:C257($FileNum; $i)
			aSlcFldPtr{$i}:=Field:C253($FileNum; $i)
		End for 
		
		If ($CheckField)  //*user wants a specific field
			ARRAY TEXT:C222($Files; Size of array:C274(<>axFiles))
			COPY ARRAY:C226(<>axFiles; $Files)
			SORT ARRAY:C229($FieldName; aSlcFldPtr; >)
			COPY ARRAY:C226($FieldName; <>axFiles)  //reuse array
			<>axFiles:=0
			uDialog("SelectField"; 300; 400)  //*let user select field
			
			If (OK=1) & (<>axFiles#0)  //* selection occured
				aSlcFldPtr{1}:=aSlcFldPtr{<>axFiles}
				<>axFiles:=0
				COPY ARRAY:C226($Files; <>axFiles)
				ARRAY TEXT:C222($Files; 0)
				ARRAY TEXT:C222($FieldName; 0)
				ARRAY POINTER:C280(aSlcFldPtr; 1)  //reduce to the specif field
				$Continue:=True:C214
			Else 
				$Continue:=False:C215
			End if 
		Else 
			$Continue:=True:C214
		End if 
		
		If ($Continue)  //* continue
			NaNCheckWork(->aSlcFldPtr)
			CLOSE WINDOW:C154
			CLOSE WINDOW:C154
		End if   //continue
	End if   //
	ON EVENT CALL:C190("")
End if 

uWinListCleanup