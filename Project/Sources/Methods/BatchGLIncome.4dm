//%attributes = {"publishedWeb":true}
//(p) BatchGlIncome
//EDI (and other electronic FG creation methods do not have GL Income Code
//thebatch system must add this
//• 4/16/98 cs created
//• 4/21/98 cs insure that table is available for modifications
//• mlb - 3/6/02  16:53 don't worry about locked recods

READ WRITE:C146([Finished_Goods:26])

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ClassOrType:28#""; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]GL_Income_Code:22="")
If (Records in selection:C76([Finished_Goods:26])>0)
	//Repeat 
	APPLY TO SELECTION:C70([Finished_Goods:26]; uGetIncomeCode)
	//Until (uChkLockedSet (->[Finished_Goods]))
End if 