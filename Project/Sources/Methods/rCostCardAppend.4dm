//%attributes = {"publishedWeb":true}
//Procedure: rCostCardAppend(text)  091098  MLB
//contruct cost card piece at a time
// Modified by: MelvinBohince (4/6/22) chg to CSV

C_TEXT:C284(tText)

If (Length:C16($1)>0)
	tText:=tText+$1
Else 
	tText:=tText+"\r"  //tText:=""
End if 