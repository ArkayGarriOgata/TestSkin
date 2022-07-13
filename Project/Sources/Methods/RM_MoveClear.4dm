//%attributes = {"publishedWeb":true}
// -------
// Method: MoveRMClear   ( ) ->
//was:
//(p) MoveRMClear

tSubgroup:=""
aBullet:=0
aRmRecNo:=0
asText:=0
aRmCode:=0
ARRAY TEXT:C222(aBullet; 0)
ARRAY TEXT:C222(asText; 0)
ARRAY TEXT:C222(aRmCode; 0)
ARRAY LONGINT:C221(aRmRecNo; 0)
OBJECT SET ENABLED:C1123(bSort; False:C215)
GOTO OBJECT:C206(tSubgroup)