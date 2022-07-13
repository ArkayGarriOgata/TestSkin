//%attributes = {"publishedWeb":true}
//(p) uGetIncomeCode
//used in an apply to selectio in the batch routines
//• 4/16/98 cs created

If ([Finished_Goods_Classifications:45]Class:1#[Finished_Goods:26]ClassOrType:28)
	QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Finished_Goods:26]ClassOrType:28)
End if 

[Finished_Goods:26]GL_Income_Code:22:=[Finished_Goods_Classifications:45]GL_income_code:3
[Finished_Goods:26]ModWho:25:="Batc"
//