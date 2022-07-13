//%attributes = {"publishedWeb":true}
//(p) JCOInitVars
//initialize, and type vars for JCO
//• 12/16/97 cs created

C_REAL:C285(rH2; rH3; rH4; rH5; rH6; rH7; rH8; rH9; rH10; rH11; rH12; rH13; rH14; rH15)
C_TEXT:C284(aJobNo)
C_LONGINT:C283(iPage)
C_BOOLEAN:C305(fHdgChg; fBold)
ARRAY TEXT:C222(aRpt; 0)
ARRAY TEXT:C222(aJFID; 0)
ARRAY TEXT:C222(aCustName; 0)
ARRAY TEXT:C222(aLine; 0)

For ($i; 2; 15)
	$Ptr:=Get pointer:C304("rh"+String:C10($i))
	$Ptr->:=0
End for 
iPage:=1
iPixel:=0
zzi:=0
fHdgChg:=False:C215
fBold:=False:C215
zDefFilePtr:=->[Job_Forms:42]
sCol3Hdr:="Budget"+Char:C90(13)+"Adj by Prod"