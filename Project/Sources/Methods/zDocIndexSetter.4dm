//%attributes = {"publishedWeb":true}
//Procedure: DocMelsIndices()  122298  MLB
//drop or add indicies procedurally

C_LONGINT:C283($numFiles; $file; $field; $fldType; $fldLen; $delim)  //wDocStructure(void)      
C_BOOLEAN:C305($isIndexed)
C_TEXT:C284($output; $input; $path)
C_TIME:C306($docRef)
C_POINTER:C301($fieldptr)
C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
$path:=""
<>fContinue:=True:C214
ON EVENT CALL:C190("eCancelProc")

uYesNoCancel("What would you like to do to the indicies?"; "Create"; "Remove"; "Nothing")
Case of 
	: (bNo=1)  //remove
		docName:="aMs.idx"
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			util_deleteDocument($path)
			$docRef:=Create document:C266($path)
			If (ok=1)
				
				$output:=""
				$numFiles:=Get last table number:C254
				uThermoInit($numFiles; "Dropping indices")
				
				For ($file; 1; $numFiles)
					If (<>fContinue) & (Is table number valid:C999($file))
						$numFields:=Get last field number:C255($file)
						For ($field; 1; $numFields)
							If (<>fContinue)
								GET FIELD PROPERTIES:C258($file; $field; $fldType; $fldLen; $isIndexed)
								If ($isIndexed)
									GOTO XY:C161(1; 2)
									MESSAGE:C88(" Dropping "+"["+Table name:C256($file)+"]"+Field name:C257($file; $field))
									$fieldptr:=Field:C253($file; $field)
									$output:=$output+String:C10($file)+$t+String:C10($field)+$t+"["+Table name:C256($file)+"]"+Field name:C257($file; $field)+$cr  //file/field numbers
									SET INDEX:C344($fieldptr->; False:C215)
									DELAY PROCESS:C323(Current process:C322; 15)
									GOTO XY:C161(1; 2)
									MESSAGE:C88(" "*42)
								End if 
							End if 
						End for 
						uThermoUpdate($file; 1)
					End if 
				End for 
				uThermoClose
				
				SEND PACKET:C103($docRef; $output)
				CLOSE DOCUMENT:C267($docRef)
				
			End if   //created doc
		End if   //given a path
		BEEP:C151
		
	: (bAccept=1)  //create
		$input:=""
		
		$docRef:=Open document:C264($path)
		If (ok=1)
			RECEIVE PACKET:C104($docRef; $input; 32500)
			If (ok=1)
				$numFields:=EDI_countCR(Length:C16($input); $input)
				uThermoInit($numFields; "Creating indices")
				For ($i; 1; $numFields)
					If (<>fContinue)
						$delim:=Position:C15($cr; $input)  //get the first line
						$line:=Substring:C12($input; 1; $delim)
						$input:=Substring:C12($input; $delim+1)  //remove it for next pass
						$delim:=Position:C15($t; $line)
						$file:=Num:C11(Substring:C12($line; 1; $delim-1))  //get the file num
						$line:=Substring:C12($line; $delim+1)
						$delim:=Position:C15($t; $line)
						$field:=Num:C11(Substring:C12($line; 1; $delim-1))  //get the fieldnn
						$fieldptr:=Field:C253($file; $field)
						GOTO XY:C161(1; 2)
						MESSAGE:C88(" Indexing "+"["+Table name:C256($file)+"]"+Field name:C257($file; $field))
						SET INDEX:C344($fieldptr->; True:C214)
						DELAY PROCESS:C323(Current process:C322; 15)
						GOTO XY:C161(1; 2)
						MESSAGE:C88(" "*42)
						uThermoUpdate($i; 1)
					End if 
				End for 
				uThermoClose
			End if 
			CLOSE DOCUMENT:C267($docRef)
		End if   //opened doc        
		
		BEEP:C151
		
End case 
ON EVENT CALL:C190("")
BEEP:C151
//