//%attributes = {"publishedWeb":true}
//PM:  ORD_AddSpecialFG  
//formerly  `(p) addSpecialFG 4/26/95 chip
//create a finished good record for special billing item
//$1 order number
//5/3/95 upr 1489 chip
//•060295  MLB  UPR 184 ADD  line
//•061295  MLB  UPR 1641 add gl inclome code
//• 4/14/98 cs Nan checking
//•052599  mlb  use the variables so can work from cco and co
//•110899  mlb  UPR add param 2 from dOrderAddItem2

C_LONGINT:C283($1)  //order number
C_TEXT:C284($2)  //product code

If (Count parameters:C259>1)
	sDesc:=$2
End if 

CREATE RECORD:C68([Finished_Goods:26])
[Finished_Goods:26]Acctg_UOM:29:="E"
[Finished_Goods:26]SpecialBilling:23:=True:C214
[Finished_Goods:26]CustID:2:=""
[Finished_Goods:26]Status:14:="New"
[Finished_Goods:26]ProjectNumber:82:=[Customers_Orders:40]ProjectNumber:53
[Finished_Goods:26]ClassOrType:28:=String:C10(r2; "00")
[Finished_Goods:26]FG_KEY:47:=Substring:C12(sDesc; 1; 20)  //sDesc
[Finished_Goods:26]ProductCode:1:=Substring:C12(sDesc; 1; 20)
[Finished_Goods:26]CartonDesc:3:=sDesc
[Finished_Goods:26]Line_Brand:15:=""  //•060295  MLB  UPR 184
READ ONLY:C145([Finished_Goods_Classifications:45])  //•061295  MLB  UPR 1641
QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Finished_Goods:26]ClassOrType:28)  //•061295  MLB  UPR 1641
[Finished_Goods:26]GL_Income_Code:22:=[Finished_Goods_Classifications:45]GL_income_code:3  //•061295  MLB  UPR 1641

If (Count parameters:C259>0)
	If ($1#0)
		[Finished_Goods:26]LastOrderNo:18:=$1
	End if 
End if 
[Finished_Goods:26]LastPrice:27:=uNANCheck(r5)  //5/3/95
[Finished_Goods:26]LastCost:26:=uNANCheck(r4+r6+r7)  //5/3/95
[Finished_Goods:26]ModWho:25:=<>zResp
[Finished_Goods:26]ModDate:24:=4D_Current_date
SAVE RECORD:C53([Finished_Goods:26])