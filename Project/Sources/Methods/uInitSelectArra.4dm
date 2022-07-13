//%attributes = {"publishedWeb":true}
//Procedure: uInitSelectArra()  090295  MLB
//upr 1206
//remove the pointer to the nil pointer 9/20/94
//mod 10/3/94 phy inv chip
//mod 10/20/94 chip
//mod 11/14/94 chip upr 1283/4
//mod 12/13/94 UPR 1234 chip
//2/9/95 upr 1398
//upr 1242 2/28/95 change fields in [OrderChgHistory]
//•060195  MLB  UPR 1528 chg vendor default
//•061595  MLB  UPR ? add vendor name to po search
//•061695  MLB  UPR 1636
//•072895  MLB  UPR 201
//`•090195  MLB   switch from pointer array to integer
//• 6/5/97 cs added new array (one larger than file count) for Requistions upr1872
//• 8/13/98 cs new pallete for issue tickets

ARRAY INTEGER:C220(<>aSlctFF; Get last table number:C254+1; 5)  // File and Field select defaults
ARRAY POINTER:C280(aSlctField; 5)  //array used by fselectby

C_LONGINT:C283($i)

uInitCoreSelArr
uInitRMSelarrs
uInitFGSelarrs
uInitJobSelArrs
uInitEstSelarrs
//miscellaneous:
$i:=Table:C252(->[Contacts:51])
<>aSlctFF{$i}{1}:=Field:C253(->[Contacts:51]Company:3)
<>aSlctFF{$i}{2}:=Field:C253(->[Contacts:51]LastName:26)
<>aSlctFF{$i}{3}:=Field:C253(->[Contacts:51]FirstName:27)
<>aSlctFF{$i}{4}:=Field:C253(->[Contacts:51]ContactID:1)
<>aSlctFF{$i}{5}:=Field:C253(->[Contacts:51]Active:12)

<>aSlctFF{32}{1}:=Field:C253(->[Salesmen:32]ID:1)
<>aSlctFF{32}{2}:=Field:C253(->[Salesmen:32]LastName:2)
<>aSlctFF{32}{3}:=Field:C253(->[Salesmen:32]FirstName:3)
<>aSlctFF{32}{4}:=Field:C253(->[Salesmen:32]Active:12)
<>aSlctFF{32}{5}:=Field:C253(->[Salesmen:32]Coordinator:14)

$i:=Table:C252(->[Customers:16])
<>aSlctFF{$i}{1}:=Field:C253(->[Customers:16]Name:2)
<>aSlctFF{$i}{2}:=Field:C253(->[Customers:16]ID:1)
<>aSlctFF{$i}{3}:=Field:C253(->[Customers:16]SalesmanID:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Customers:16]Active:15)
<>aSlctFF{$i}{5}:=Field:C253(->[Customers:16]ParentCorp:19)

$i:=Table:C252(->[Addresses:30])
<>aSlctFF{$i}{1}:=Field:C253(->[Addresses:30]ID:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Addresses:30]Name:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Addresses:30]City:6)
<>aSlctFF{$i}{4}:=Field:C253(->[Addresses:30]State:7)
<>aSlctFF{$i}{5}:=Field:C253(->[Addresses:30]Zip:8)

$i:=Table:C252(->[Customers_Orders:40])
<>aSlctFF{$i}{1}:=Field:C253(->[Customers_Orders:40]OrderNumber:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Customers_Orders:40]CustomerName:39)
<>aSlctFF{$i}{3}:=Field:C253(->[Customers_Orders:40]PONumber:11)
<>aSlctFF{$i}{4}:=Field:C253(->[Customers_Orders:40]EstimateNo:3)
<>aSlctFF{$i}{5}:=Field:C253(->[Customers_Orders:40]Status:10)

$i:=Table:C252(->[Customers_Order_Lines:41])
<>aSlctFF{$i}{1}:=Field:C253(->[Customers_Order_Lines:41]ProductCode:5)
<>aSlctFF{$i}{2}:=Field:C253(->[Customers_Order_Lines:41]PONumber:21)
<>aSlctFF{$i}{3}:=Field:C253(->[Customers_Order_Lines:41]OrderNumber:1)
<>aSlctFF{$i}{4}:=Field:C253(->[Customers_Order_Lines:41]CustomerName:24)
<>aSlctFF{$i}{5}:=Field:C253(->[Customers_Order_Lines:41]Qty_Open:11)

$i:=Table:C252(->[Customers_ReleaseSchedules:46])
<>aSlctFF{$i}{1}:=Field:C253(->[Customers_ReleaseSchedules:46]ProductCode:11)
<>aSlctFF{$i}{2}:=Field:C253(->[Customers_ReleaseSchedules:46]CustomerRefer:3)
<>aSlctFF{$i}{3}:=Field:C253(->[Customers_ReleaseSchedules:46]ReleaseNumber:1)
<>aSlctFF{$i}{4}:=Field:C253(->[Customers_ReleaseSchedules:46]Sched_Date:5)
<>aSlctFF{$i}{5}:=Field:C253(->[Customers_ReleaseSchedules:46]CustomerLine:28)

$i:=Table:C252(->[Customers_Order_Change_Orders:34])
<>aSlctFF{$i}{1}:=Field:C253(->[Customers_Order_Change_Orders:34]ChangeOrderNumb:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Customers_Order_Change_Orders:34]OrderNo:5)
<>aSlctFF{$i}{3}:=Field:C253(->[Customers_Order_Change_Orders:34]ChgOrderStatus:20)
<>aSlctFF{$i}{4}:=Field:C253(->[Customers_Order_Change_Orders:34]Author:15)
<>aSlctFF{$i}{5}:=Field:C253(->[Customers_Order_Change_Orders:34]ApprovedBy:16)

$i:=Table:C252(->[x_fiscal_calendars:63])
<>aSlctFF{$i}{1}:=Field:C253(->[x_fiscal_calendars:63]Year_Month:4)
<>aSlctFF{$i}{2}:=Field:C253(->[x_fiscal_calendars:63]Period:1)
<>aSlctFF{$i}{3}:=Field:C253(->[x_fiscal_calendars:63]StartDate:2)
<>aSlctFF{$i}{4}:=Field:C253(->[x_fiscal_calendars:63]EndDate:3)
<>aSlctFF{$i}{5}:=Field:C253(->[x_fiscal_calendars:63]ModWho:6)

$i:=Table:C252(->[y_Customers_Name_Exclusions:76])
<>aSlctFF{$i}{1}:=Field:C253(->[y_Customers_Name_Exclusions:76]Name:1)

$i:=Get last table number:C254+1  //• 6/5/97 cs Special array for Requistion access to Purchase orders
<>aSlctFF{$i}{1}:=Field:C253(->[Purchase_Orders:11]ReqNo:5)
<>aSlctFF{$i}{2}:=Field:C253(->[Purchase_Orders:11]VendorName:42)
<>aSlctFF{$i}{3}:=Field:C253(->[Purchase_Orders:11]VendorID:2)
<>aSlctFF{$i}{4}:=Field:C253(->[Purchase_Orders:11]PODate:4)
<>aSlctFF{$i}{5}:=Field:C253(->[Purchase_Orders:11]Status:15)

$i:=Table:C252(->[Job_Forms_Issue_Tickets:90])  //• 8/13/98 cs new pallete - issuetickets
<>aSlctFF{$i}{1}:=Field:C253(->[Job_Forms_Issue_Tickets:90]JobForm:5)
<>aSlctFF{$i}{2}:=Field:C253(->[Job_Forms_Issue_Tickets:90]Posted:4)
<>aSlctFF{$i}{3}:=Field:C253(->[Job_Forms_Issue_Tickets:90]Raw_Matl_Code:2)
<>aSlctFF{$i}{4}:=Field:C253(->[Job_Forms_Issue_Tickets:90]PoItemKey:1)
<>aSlctFF{$i}{5}:=Field:C253(->[Job_Forms_Issue_Tickets:90]CostCenter:3)

$i:=Table:C252(->[Job_MakeVsBuy:97])
<>aSlctFF{$i}{1}:=Field:C253(->[Job_MakeVsBuy:97]JobFormId:2)
<>aSlctFF{$i}{2}:=Field:C253(->[Job_MakeVsBuy:97]Line:9)
<>aSlctFF{$i}{3}:=Field:C253(->[Job_MakeVsBuy:97]RequestedBy:5)
<>aSlctFF{$i}{4}:=Field:C253(->[Job_MakeVsBuy:97]Department:7)
<>aSlctFF{$i}{5}:=Field:C253(->[Job_MakeVsBuy:97]ApprovedOn:20)

$i:=Table:C252(->[Raw_Material_Labels:171])
<>aSlctFF{$i}{1}:=Field:C253(->[Raw_Material_Labels:171]Label_id:2)
<>aSlctFF{$i}{2}:=Field:C253(->[Raw_Material_Labels:171]Raw_Matl_Code:4)
<>aSlctFF{$i}{3}:=Field:C253(->[Raw_Material_Labels:171]POItemKey:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Raw_Material_Labels:171]Location:10)
<>aSlctFF{$i}{5}:=Field:C253(->[Raw_Material_Labels:171]ModWho:7)

$i:=Table:C252(->[PrintFlow_Msg_Queue:169])
<>aSlctFF{$i}{1}:=Field:C253(->[PrintFlow_Msg_Queue:169]Created:2)
<>aSlctFF{$i}{2}:=Field:C253(->[PrintFlow_Msg_Queue:169]JobRef:7)
<>aSlctFF{$i}{3}:=Field:C253(->[PrintFlow_Msg_Queue:169]EventSource:3)
<>aSlctFF{$i}{4}:=Field:C253(->[PrintFlow_Msg_Queue:169]Sent:5)
<>aSlctFF{$i}{5}:=Field:C253(->[PrintFlow_Msg_Queue:169]ModWho:4)