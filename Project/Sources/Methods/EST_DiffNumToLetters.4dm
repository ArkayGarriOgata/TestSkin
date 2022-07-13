//%attributes = {"publishedWeb":true}
//PM:  EST_DiffNumToLetters  112499  mlb
//convert an interger to a double letter counter
//Makes a 2 character label used to uniquely Identify a differential 
//within an estimate   `Ascii("A")  `=65
//=A when val is 1-26, B when val is 27-52...

C_TEXT:C284($0)
C_LONGINT:C283($1)

$0:=Char:C90(($1\27)+65)+Char:C90((($1-1)%27)+65)