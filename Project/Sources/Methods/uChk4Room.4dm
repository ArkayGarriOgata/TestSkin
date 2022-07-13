//%attributes = {"publishedWeb":true}
//uChk4room(pixels needed;pixel increment;1st layout;{2ndlayout})
//            mod 2/25/94 to allow use by job as well as estimate and orders
// Modified by: Mel Bohince (10/29/19) see line 23, this was missing and was looking for form in wrong table
C_LONGINT:C283($1; $2)
C_TEXT:C284($3; $4)

If (maxPixels-pixels<$1)  //make sure there is room for totals
	pixels:=fFillPage(maxPixels; pixels; 1)  //returns 0
	iPage:=iPage+1
	If (Position:C15("JB"; $3)#0)
		Print form:C5([Jobs:15]; $3)
	Else 
		Print form:C5([Estimates:17]; $3)
	End if 
	
	If (Count parameters:C259=4)
		Case of 
			: ((Position:C15("Est"; $4)#0) | (Position:C15("Q"; $4)#0))
				Print form:C5([Estimates:17]; $4)
			: (Position:C15("JB"; $4)#0)
				Print form:C5([Jobs:15]; $4)
			: (Position:C15("RS"; $4)#0)
				Print form:C5([Customers_ReleaseSchedules:46]; $4)
			Else 
				Print form:C5([Customers_Order_Lines:41]; $4)
		End case 
		// pixels:=pixels+$2
	End if 
	pixels:=pixels+$2
End if 