//%attributes = {"publishedWeb":true}
//(p) uChkLockedSet
//$1 - pointer to file
//$2 - (optional) string - 1 char - 'M' message, 'A' alert -default is M
//$3 (optional) longint delay time in ticks
C_POINTER:C301($1)
C_TEXT:C284($2)
C_LONGINT:C283($3)
C_BOOLEAN:C305($0)

If (Records in set:C195("LockedSet")>0)
	LOCKED BY:C353($1->; $EditProcNo; $EditUser; $EditMachin; $EditProces)
	$Text:=String:C10(Records in set:C195("LockedSet"))+" records in File "+Table name:C256($1)+" are locked..."
	$Text:=$Text+" Locked By User: "+$EditUser+Char:C90(13)
	$Text:=$Text+" Workstation: "+$EditMachin+Char:C90(13)
	$Text:=$Text+" Process: "+$EditProces+Char:C90(13)
	
	Case of 
		: (Count parameters:C259=1)
			MESSAGE:C88($Text)
		: ($2="M")
			MESSAGE:C88($Text)
		: ($2="A")
			ALERT:C41($Text)
	End case 
	
	If (Count parameters:C259=3)
		$Delay:=$3
	Else 
		$Delay:=60*60
	End if 
	DELAY PROCESS:C323(Current process:C322; $Delay)
End if 
$0:=(Records in set:C195("LockedSet")=0)

If (Not:C34($0))
	USE SET:C118("LockedSet")
End if 
//