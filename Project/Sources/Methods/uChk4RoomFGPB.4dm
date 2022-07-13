//%attributes = {"publishedWeb":true}
C_LONGINT:C283($1; $2)  //uChk4roomFGPB(pixels needed;pixel increment;1st layout;{2ndlayout})
C_TEXT:C284($3; $4)
If (maxPixels-pixels<$1)  //make sure there is room for totals
	pixels:=fFillPage(maxPixels; pixels)
	iPage:=iPage+1
	Print form:C5([Finished_Goods:26]; $3)
	If (Count parameters:C259=4)
		Print form:C5([Finished_Goods:26]; $4)
	End if 
	pixels:=pixels+$2
End if 