//%attributes = {"publishedWeb":true}
//(p) MoveIssueClear
//$1 - string (optional) - anything, clear vars too
//clear arrays used in dialog
//• 8/5/98 cs created

ARRAY TEXT:C222(aBullet; 0)
ARRAY REAL:C219(aFlex2; 0)
ARRAY TEXT:C222(aLine; 0)
ARRAY DATE:C224(aDate; 0)
ARRAY LONGINT:C221(aRmRecNo; 0)
ARRAY TEXT:C222(aRmCode; 0)

If (Count parameters:C259=1)
	sJobform:=""
	tSubgroup:=""
End if 