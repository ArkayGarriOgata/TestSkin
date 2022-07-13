//%attributes = {"publishedWeb":true}
//uProcessID(process name)->processs id
//returns -1 if the process name passed does not exist or was killed.
//•052495  IS,Inc.  UPR 1533

C_LONGINT:C283($i; $0; $state)
C_TEXT:C284($1; $procName)  //•052495  IS,Inc.  UPR  1533 changed from string 30 -> text.
C_LONGINT:C283($time)

$0:=Aborted:K13:1
$procName:=""
$state:=0
$time:=0

For ($i; 1; Count tasks:C335)
	PROCESS PROPERTIES:C336($i; $procName; $state; $time)
	If ($1=$procName)
		If ($state#Aborted:K13:1)
			$0:=$i
			$i:=Count tasks:C335+1
		Else   //it was killed
			$0:=Aborted:K13:1
		End if 
	End if 
End for 