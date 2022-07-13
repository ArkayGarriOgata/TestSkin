//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 12/07/15, 11:04:42
// ----------------------------------------------------
// Method: MULOADREC
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_POINTER:C301($1)  //$1=»File to laod
C_BOOLEAN:C305($2; $0)  //$2=Bailout True-User False-auto None-Load forever $0=True if loaded
C_LONGINT:C283($xiBailOut)  //v0.1.0-JJG (03/28/17) - converted from integer
READ WRITE:C146($1->)
If (Locked:C147($1->) | (Record number:C243($1->)=-1))
	LOAD RECORD:C52($1->)
	If (Locked:C147($1->))
		Case of 
			: (Count parameters:C259=1)  //never bail out
				$xiBailOut:=0
			: ($2)  //user attended bailout option
				$xiBailOut:=1
			Else   //automatic bailout option
				$xiBailOut:=-1
		End case 
		MULOADREC_LOOP($1; $xiBailOut)
	End if 
End if 
$0:=Not:C34(Locked:C147($1->))