//%attributes = {"publishedWeb":true}
//(P) L_ListImport: Imports Choice Lists 
//upr 1445 3/6/95
//•020599  MLB   `v6change
//dont use local arrays or arrays in the Receive variable command
//C_TEXT($Temp)`sBuyerName used to overcome 4D bug on receive var (local prob

C_LONGINT:C283($j; $ListName)
ARRAY TEXT:C222(asList; 0)
ARRAY TEXT:C222(asLink; 0)

sBuyerName:=""  //cast as string 30
zSelectNum:=0  //zSelectNumused to overcome 4D bug on receive var (local $size
$winRef:=NewWindow(500; 380; 6; 1; "Choice Lists Import")
MESSAGE:C88(" Setting up list names...")
L_ListNames
MESSAGE:C88(Char:C90(13)+" Opening file named 'LISTDATA'...")
SET CHANNEL:C77(10; "LISTDATA")

If (OK=1)
	$ListName:=0
	RECEIVE VARIABLE:C81(sBuyerName)
	While (OK#0)
		$ListName:=$ListName+1
		If (<>aListNames{$ListName}=sBuyerName)  //allows us to rename lists
			MESSAGE:C88(Char:C90(13)+"  "+sBuyerName)
		Else 
			BEEP:C151
			MESSAGE:C88(Char:C90(13)+"  "+sBuyerName+" changed to "+<>aListNames{$ListName})
			sBuyerName:=<>aListNames{$ListName}
		End if 
		RECEIVE VARIABLE:C81(zSelectNum)
		ARRAY TEXT:C222(asList; zSelectNum)
		ARRAY TEXT:C222(asLink; zSelectNum)
		For ($j; 1; zSelectNum)
			t1:=""
			t2:=""
			MESSAGE:C88(String:C10($j)+" ")
			RECEIVE VARIABLE:C81(t1)
			RECEIVE VARIABLE:C81(t2)
			asList{$j}:=t1
			asLink{$j}:=t2
		End for 
		ARRAY TO LIST:C287(asList; sBuyerName)  //;asLink) `v6change
		RECEIVE VARIABLE:C81(sBuyerName)
	End while 
	SET CHANNEL:C77(11; "")
End if 

CLOSE WINDOW:C154
BEEP:C151