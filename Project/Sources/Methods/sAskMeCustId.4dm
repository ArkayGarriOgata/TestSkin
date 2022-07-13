//%attributes = {"publishedWeb":true}
//(p)saskmeCustId

If (sCustID#"")  //sAskMeCustId    mod 2.22.94
	If ([Customers:16]ID:1#sCustID)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=sCustID)
	End if 
	sCustName:=[Customers:16]Name:2
	UNLOAD RECORD:C212([Customers:16])
Else 
	sCustName:=""
End if 

//sCPN:=""
//sBrand:=""
//sDesc:=""
totalDemand:=0
totalSupply:=0
totalStatus:=0
iitotal1:=0
iitotal2:=0
iitotal3:=0
iitotal4:=0

REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)  //•020896  MLB  
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
sAskMeButtons(0)