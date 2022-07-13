//%attributes = {"publishedWeb":true}
//PM: util_outerJoin(->findField;->likeField;{0=dontMsg}) -> 
//@author mlb - 4/20/01  10:49
//formerly uRelateSelect(»searchField;»baseField;{0=dontMsg}) v5, 3/92
//gets the related records in SearchFile for current selection in BaseFile
//relations not required between files but search field should be indexed
//$1 = »Search field
//$2 = »Base field
//$3 = 0-Don't print message, 1 or No parameter-Print message
//Example call: RelateSelection(»[SearchFile]SearchField;»[BaseFile]BaseField)
//Based on original code by Tony Ringsmuth 6/90
//Modified  3/92 by Tom Kucharik and Bob Keleher
//  faster when searching on a large selection
//  more efficient when searching from a many file to a one
//• 3/11/98 cs clear up memory!!!!!

C_POINTER:C301($SearchFile; $BaseFile; $Array; $1; $2)
C_LONGINT:C283($Max; $i; $Type; $Cnt; $3)
C_BOOLEAN:C305($Msg)

$Msg:=True:C214

If (Count parameters:C259>2)
	$Msg:=($3#0)
End if 
$SearchFile:=Table:C252(Table:C252($1))  //get pointer to file from field pointer
$BaseFile:=Table:C252(Table:C252($2))
CREATE EMPTY SET:C140($SearchFile->; "Related")

If (Records in selection:C76($BaseFile->)>0)
	If ($Msg)
		//CenterWindow (35;400;"";1)
		//NewWindow (370;30;3;-722;"Projecting Selection")
		zwStatusMsg("Relating"; " Searching "+Table name:C256($SearchFile)+" file. Please Wait...")
	End if 
	GET FIELD PROPERTIES:C258($2; $Type)
	
	Case of   //create appropriate array to hold base fields
		: ($Type=9) | ($Type=11)  //  long integer or time
			ARRAY LONGINT:C221(alRelTemp; 0)
			$Array:=->alRelTemp
		: ($Type=8)  //                         integer
			ARRAY INTEGER:C220(aiRelTemp; 0)
			$Array:=->aiRelTemp
		: ($Type=0) | ($Type=2)  //      string or text
			ARRAY TEXT:C222(axRelTemp; 0)
			$Array:=->axRelTemp
		: ($Type=4)  //                           Date
			ARRAY DATE:C224(adRelTemp; 0)
			$Array:=->adRelTemp
		Else 
			ALERT:C41("Type "+String:C10($type)+" fields not supported by procedure RelateSelection")
			ABORT:C156
	End case 
	SELECTION TO ARRAY:C260($2->; $Array->)  //get all base fields
	$Max:=255  //maximum built search commands in one grouping
	SORT ARRAY:C229($Array->)
	QUERY:C277($SearchFile->; $1->=$Array->{1}; *)  //setup first search
	$Cnt:=1  //count of built search commands
	
	For ($i; 2; Size of array:C274($Array->))
		If ($Array->{$i}#$Array->{$i-1})  //not found as previous search criteria
			Case of 
				: ($Cnt=0)  //first search in group
					QUERY:C277($SearchFile->; $1->=$Array->{$i}; *)
					$Cnt:=1
				: ($Cnt<$Max)  //still within built search limit
					QUERY:C277($SearchFile->;  | ; $1->=$Array->{$i}; *)  //add to built search
					$Cnt:=$Cnt+1
				Else   //last search in group
					QUERY:C277($SearchFile->;  | ; $1->=$Array->{$i})
					$Cnt:=0  //reset for next built search group
					CREATE SET:C116($SearchFile->; "Relating")
					UNION:C120("Related"; "Relating"; "Related")
			End case 
		End if 
	End for 
	
	If ($Cnt#0)  //built search group has been created but not executed
		QUERY:C277($SearchFile->)  //finish search
		CREATE SET:C116($SearchFile->; "Relating")
		UNION:C120("Related"; "Relating"; "Related")
	End if 
	CLEAR SET:C117("Relating")
	CLEAR VARIABLE:C89($Array->)
	
	If ($Msg)
		//CLOSE WINDOW
		//zwStatusMsg ("Relating";String(Records in selection($SearchFile->))+" records fo
		zwStatusMsg(""; "")
	End if 
End if 
USE SET:C118("Related")
CLEAR SET:C117("Related")
ARRAY DATE:C224(adRelTemp; 0)  //• 3/11/98 cs clear up memory!!!!!
ARRAY LONGINT:C221(alRelTemp; 0)
ARRAY INTEGER:C220(aiRelTemp; 0)
ARRAY TEXT:C222(axRelTemp; 0)