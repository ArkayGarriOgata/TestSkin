//%attributes = {"publishedWeb":true}
//uChk4room(pixels needed;pixel increment;1st layout;{2ndlayout})

C_LONGINT:C283($1; $2)
C_TEXT:C284($3; $4)

If (maxPixels-pixels<$1)  //make sure there is room for totals
	pixels:=fFillPage(maxPixels; pixels; 1)  //returns 0
	iPage:=iPage+1
	Print form:C5([Estimates:17]; $3)
	If (Count parameters:C259=4)
		Print form:C5([Estimates:17]; $4)
		// pixels:=pixels+$2
	End if 
	pixels:=pixels+$2
Else 
	Print form:C5([Estimates:17]; $3)
	pixels:=pixels+$2
End if 