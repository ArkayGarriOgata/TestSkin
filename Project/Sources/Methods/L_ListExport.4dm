//%attributes = {"publishedWeb":true}
//(P) L_ListExport: Exports Choice Lists see also L_LIstImport
//upr 1445 3/6/95

C_TEXT:C284($Temp)
C_LONGINT:C283($i; $j; $Size)

$winRef:=NewWindow(500; 380; 6; 1; "Choice Lists Export")
MESSAGE:C88(" Setting up list names...")
L_ListNames  //setup array of list names

MESSAGE:C88(Char:C90(13)+" Creating output file named 'LISTDATA'...")
util_deleteDocument("LISTDATA")
SET CHANNEL:C77(10; "LISTDATA")
If (OK=1)
	ARRAY TEXT:C222($asList; 0)  //holds list items
	ARRAY TEXT:C222($asLink; 0)  //holds linked lists
	
	For ($i; 1; Size of array:C274(<>aListNames))
		$Temp:=<>aListNames{$i}
		MESSAGE:C88(Char:C90(13)+"  "+$Temp+" ")
		SEND VARIABLE:C80($Temp)
		LIST TO ARRAY:C288(<>aListNames{$i}; $asList)  //;$asLink)
		
		$Size:=Size of array:C274($asList)
		SEND VARIABLE:C80($Size)
		For ($j; 1; $Size)
			MESSAGE:C88(String:C10($j)+" ")
			SEND VARIABLE:C80($asList{$j})
			SEND VARIABLE:C80($asLink{$j})
		End for 
	End for 
	SET CHANNEL:C77(11; "")
End if 
CLOSE WINDOW:C154($winRef)
BEEP:C151