//%attributes = {"publishedWeb":true}
//(P) beforeCID: before phase processing for [PO_CLAUSE_TABLE]
//4/26/95 upr 1469 chip

If ([Purchase_Orders_Clauses:14]ID:1="")
	[Purchase_Orders_Clauses:14]ModDate:8:=4D_Current_date
	[Purchase_Orders_Clauses:14]ModWho:9:=<>zResp
End if 
If (iMode#2)
	OBJECT SET ENABLED:C1123(bDelete; False:C215)
End if 
If (iMode=3)
	OBJECT SET ENABLED:C1123(bAcceptRec; False:C215)
End if 
RELATE MANY:C262([Purchase_Orders_Clauses:14]ID:1)  //4/26/95 upr 1469 chip