//%attributes = {"publishedWeb":true}
//(P) gNewCustOrdCO:  creates new Customer Order Change Order
//11/10/94 Planned by was incorrect
//3/1/95 upr 1242 put the job on hold also
//•062695  MLB  UPR 206
//•020296  MLB  adapt for use with EDI
//•050396  MLB  UPR 184

C_TEXT:C284($1)  //*EDI use carries a parameter, see
C_BOOLEAN:C305($EDI)

If (Count parameters:C259<1)
	$EDI:=False:C215
Else 
	$EDI:=True:C214
End if 

CREATE RECORD:C68([Customers_Order_Change_Orders:34])
//•fNewCustOrdCO• :=True
[Customers_Order_Change_Orders:34]ChangeOrderNumb:1:=app_GetPrimaryKey  //app_AutoIncrement (->[Customers_Order_Change_Orders])
[Customers_Order_Change_Orders:34]DateOpened:3:=4D_Current_date
[Customers_Order_Change_Orders:34]OrderNo:5:=[Customers_Orders:40]OrderNumber:1
[Customers_Order_Change_Orders:34]Brand:23:=[Customers_Orders:40]CustomerLine:22
[Customers_Order_Change_Orders:34]ChgOrderStatus:20:="New"
If ($EDI)
	[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=[Customers_Order_Change_Orders:34]ChgOrderStatus:20+" EDI"
End if 
[Customers_Order_Change_Orders:34]CustID:2:=[Customers_Orders:40]CustID:2
If (Not:C34($EDI))
	[Customers_Order_Change_Orders:34]Author:15:=<>zResp
	[Customers_Order_Change_Orders:34]ModDate:18:=4D_Current_date
	[Customers_Order_Change_Orders:34]ModWho:19:=<>zResp
Else 
	[Customers_Order_Change_Orders:34]Author:15:="EDI"
	[Customers_Order_Change_Orders:34]ModDate:18:=4D_Current_date
	[Customers_Order_Change_Orders:34]ModWho:19:="EDI"
	[Customers_Order_Change_Orders:34]CustInstr:24:="EDI MESSAGE: "+$1
End if 

[Customers_Order_Change_Orders:34]zCount:17:=1
[Customers_Order_Change_Orders:34]Planner:37:=[Customers_Orders:40]PlannedBy:30  //11/10/94
[Customers_Order_Change_Orders:34]OrigEstimate:39:=[Customers_Orders:40]EstimateNo:3
[Customers_Order_Change_Orders:34]OldCaseScenario:41:=[Customers_Orders:40]CaseScenario:4
[Customers_Order_Change_Orders:34]NewBrand:42:=[Customers_Orders:40]CustomerLine:22
[Customers_Order_Change_Orders:34]OldBrand:43:=[Customers_Orders:40]CustomerLine:22
[Customers_Order_Change_Orders:34]JobNo:30:=[Customers_Orders:40]JobNo:44  //•062695  MLB  UPR 206
If ([Customers_Orders:40]IsContract:52) & (Not:C34($EDI))  //•050396  MLB  UPR 184
	uConfirm("You may not add costed items to a CONTRACT Order."; "OK"; "Help")
End if 
SAVE RECORD:C53([Customers_Order_Change_Orders:34])

If (Position:C15("Hold"; [Customers_Orders:40]Status:10)=0)
	[Customers_Orders:40]LastStatus:48:=[Customers_Orders:40]Status:10  //so gChgOApproval can rtn to that state
End if 
If (Not:C34($EDI))
	[Customers_Orders:40]Status:10:="Hold Change Pending"
	util_ComboBoxSetup(->asOrdStat; [Customers_Orders:40]Status:10)
Else 
	[Customers_Orders:40]Status:10:="Hold EDI Change Pending"
End if 

SAVE RECORD:C53([Customers_Orders:40])

If (Not:C34($EDI))
	MODIFY RECORD:C57([Customers_Order_Change_Orders:34]; *)
End if 