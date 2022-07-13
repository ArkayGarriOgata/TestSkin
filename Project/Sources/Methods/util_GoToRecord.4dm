//%attributes = {}
// Method: util_GoToRecord ({recordNumber}{;ptrfield;}) -> 
// ----------------------------------------------------
// by: mel: 11/08/04, 11:15:20
// ----------------------------------------------------
// Description:
// something to help out DataCheck fixes

C_LONGINT:C283($1; $recNo; $parameters)
C_POINTER:C301($2; $filePtr)
$filePtr:=Current form table:C627
C_TEXT:C284($tableName; $3)

$parameters:=Count parameters:C259  //don't want to load table names if not needed
If ($parameters>=2)  //appearently called via the Run>Method "Execute", than params added
	Case of 
		: ($parameters=2)
			$filePtr:=Table:C252(Table:C252($2))
			READ WRITE:C146($filePtr->)
			GOTO RECORD:C242($filePtr->; $1)
			
		: ($parameters=3)
			$filePtr:=Table:C252(Table:C252($2))
			READ WRITE:C146($filePtr->)
			GOTO RECORD:C242($filePtr->; $1)
			Case of 
				: (Type:C295($2->)=Is longint:K8:6) | (Type:C295($2->)=Is integer:K8:5) | (Type:C295($2->)=Is real:K8:4)
					$2->:=Num:C11($3)
				: (Type:C295($2->)=Is date:K8:7)
					$2->:=Date:C102($3)
				: (Type:C295($2->)=Is boolean:K8:9)
					$2->:=("True"=$3)
				Else   //Is Alpha Field 
					$2->:=$3
			End case 
			SAVE RECORD:C53($filePtr->)
	End case 
	UNLOAD RECORD:C212($filePtr->)
	
Else   //interactive
	
	If (Size of array:C274(<>axFiles)=0)  //Load 'em
		C_LONGINT:C283($table; $activeTable)
		ARRAY TEXT:C222(<>axFiles; Get last table number:C254)
		ARRAY INTEGER:C220(<>axFileNums; Get last table number:C254)
		$activeTable:=0
		For ($table; 1; Get last table number:C254)
			If (Is table number valid:C999($table))
				$tableName:=Table name:C256($table)
				If (Substring:C12($tableName; 1; 2)#"zz")  //don't show app tables
					$activeTable:=$activeTable+1
					<>axFiles{$activeTable}:=$tableName
					<>axFileNums{$activeTable}:=$table  //Store the filenumber by position
				End if 
			End if 
		End for 
		ARRAY TEXT:C222(<>axFiles; $activeTable)  //• 6/10/98 cs resize
		ARRAY INTEGER:C220(<>axFileNums; $activeTable)  //•051496  MLB 
	End if 
	
	
	Case of 
		: ($parameters=0)  //interactive
			$windowName:=Get window title:C450(Frontmost window:C447)
			$tableName:=Substring:C12($windowName; 1; (Position:C15(":"; $windowName)-1))
			If (Position:C15("-"; $tableName)>0)
				$tableName:=Substring:C12($tableName; (Position:C15("-"; $tableName))+1)
			End if 
			$i:=Find in array:C230(<>axFiles; $tableName)
			If ($i>-1)
				$filePtr:=Table:C252(<>axFileNums{$i})
				
				$recNo:=Num:C11(Request:C163($tableName+" record#?"; "0"; "GoTo"; "Cancel"))
				If (ok=1)
					READ WRITE:C146($filePtr->)
					GOTO RECORD:C242($filePtr->; $recNo)
					If (Locked:C147($filePtr->))
						LOCKED BY:C353($filePtr->; $lockProcNo; $userName; $machName; $lockProcess)
						ALERT:C41("Locked by "+$userName+" doing ("+String:C10($lockProcNo)+") "+$lockProcess+" as "+$machName)
					End if 
				End if 
				UNLOAD RECORD:C212($filePtr->)
				
			Else 
				ALERT:C41("Table '"+$tableName+"' was not found.")
			End if 
			
		: ($parameters=1)  //
			$windowName:=Get window title:C450(Frontmost window:C447)
			$tableName:=Substring:C12($windowName; 1; (Position:C15(":"; $windowName)-1))
			If (Position:C15("-"; $tableName)>0)
				$tableName:=Substring:C12($tableName; (Position:C15("-"; $tableName))+1)
			End if 
			$i:=Find in array:C230(<>axFiles; $tableName)
			$filePtr:=Table:C252(<>axFileNums{$i})
			READ WRITE:C146($filePtr->)
			GOTO RECORD:C242($filePtr->; $1)
			UNLOAD RECORD:C212($filePtr->)
	End case 
	
End if 


