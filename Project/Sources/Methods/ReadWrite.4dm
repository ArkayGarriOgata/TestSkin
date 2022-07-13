//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 03/08/07, 15:54:54
// ----------------------------------------------------
// Method: ReadWrite(->table)  --> void
// Description
// so can access from user mode
//uses the the window title for the table name
// ----------------------------------------------------

$windowName:=Get window title:C450(Frontmost window:C447)
$tableName:=Substring:C12($windowName; 1; (Position:C15(":"; $windowName)-1))

If (Size of array:C274(<>axFiles)=0)  //Load 'em
	C_LONGINT:C283($i; $t)
	$t:=Get last table number:C254
	ARRAY TEXT:C222(<>axFiles; $t)
	ARRAY INTEGER:C220(<>axFileNums; $t)  //•051496  MLB 
	
	For ($i; 1; $t)
		If (Is table number valid:C999($i))
			<>axFiles{$i}:=Table name:C256($i)
			<>axFileNums{$i}:=$i  //Store the filenumber by position
		End if 
	End for 
	
	ARRAY TEXT:C222(<>axFiles; $Count)  //• 6/10/98 cs resize
	ARRAY INTEGER:C220(<>axFileNums; $Count)  //•051496  MLB 
End if 

$i:=Find in array:C230(<>axFiles; $tableName)
If ($i>-1)
	<>filePtr:=Table:C252(<>axFileNums{$i})
	zwStatusMsg("Set ReadWrite"; $tableName)
	READ WRITE:C146(<>filePtr->)
Else 
	BEEP:C151
	zwStatusMsg("Set ReadWrite"; "FAILED: "+$windowName)
End if 