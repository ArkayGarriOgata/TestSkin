//%attributes = {"publishedWeb":true}
//PM:  uProcessNameid) ->name 110399  mlb
//return the name of a process
C_TEXT:C284($procName; $0)
C_LONGINT:C283($1; $state; $time)
$0:="process "+String:C10($1)+" not found"
$procName:=""
$state:=0
$time:=0
PROCESS PROPERTIES:C336($1; $procName; $state; $time)
If (Length:C16($procName)>0)
	$0:=$procName
End if 
//