//%attributes = {"publishedWeb":true}
//PM: uInitCoreSelArr() -> 
//@author  090295  MLB
//
<>aSlctFF{1}{1}:=Field:C253(->[zz_control:1]ApplicationName:1)
<>aSlctFF{1}{2}:=Field:C253(->[zz_control:1]Registrant:7)
<>aSlctFF{1}{3}:=Field:C253(->[zz_control:1]SerialNo:8)
<>aSlctFF{1}{4}:=Field:C253(->[zz_control:1]MaxUsers:10)
<>aSlctFF{1}{5}:=Field:C253(->[zz_control:1]Log_User_Actions:9)


<>aSlctFF{2}{1}:=Field:C253(->[z_administrators:2]Administrator:1)
<>aSlctFF{2}{2}:=Field:C253(->[z_administrators:2]CompanyName:2)
<>aSlctFF{2}{3}:=Field:C253(->[z_administrators:2]AppVersion:3)
<>aSlctFF{2}{4}:=Field:C253(->[z_administrators:2]LastUpdate:4)
<>aSlctFF{2}{5}:=Field:C253(->[z_administrators:2]Administrator:1)

<>aSlctFF{3}{1}:=Field:C253(->[x_id_numbers:3]Table_Number:1)
<>aSlctFF{3}{2}:=Field:C253(->[x_id_numbers:3]ID_No:2)
<>aSlctFF{3}{3}:=Field:C253(->[x_id_numbers:3]Seq_Offset:3)
<>aSlctFF{3}{4}:=Field:C253(->[x_id_numbers:3]Table_Number:1)
<>aSlctFF{3}{5}:=Field:C253(->[x_id_numbers:3]Table_Number:1)

<>aSlctFF{4}{1}:=Field:C253(->[y_accounting_departments:4]DepartmentID:1)
<>aSlctFF{4}{2}:=Field:C253(->[y_accounting_departments:4]Description:4)

<>aSlctFF{5}{1}:=Field:C253(->[Users:5]Initials:1)
<>aSlctFF{5}{2}:=Field:C253(->[Users:5]LastName:2)
<>aSlctFF{5}{3}:=Field:C253(->[Users:5]UserName:11)
<>aSlctFF{5}{4}:=Field:C253(->[Users:5]FirstName:3)
<>aSlctFF{5}{5}:=Field:C253(->[Users:5]BusTitle:5)


$i:=Table:C252(->[Raw_Materials_Transactions:23])
<>aSlctFF{$i}{1}:=Field:C253(->[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Raw_Materials_Transactions:23]POItemKey:4)
<>aSlctFF{$i}{3}:=Field:C253(->[Raw_Materials_Transactions:23]XferDate:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Raw_Materials_Transactions:23]JobForm:12)
<>aSlctFF{$i}{5}:=Field:C253(->[Raw_Materials_Transactions:23]ReferenceNo:14)


$i:=Table:C252(->[Customers_Invoices:88])
<>aSlctFF{$i}{1}:=Field:C253(->[Customers_Invoices:88]Status:22)
<>aSlctFF{$i}{2}:=Field:C253(->[Customers_Invoices:88]Invoice_Date:7)
<>aSlctFF{$i}{3}:=Field:C253(->[Customers_Invoices:88]InvoiceNumber:1)
<>aSlctFF{$i}{4}:=Field:C253(->[Customers_Invoices:88]OrderLine:4)
<>aSlctFF{$i}{5}:=Field:C253(->[Customers_Invoices:88]CustomersPO:11)

$i:=Table:C252(->[Job_Forms_CloseoutSummaries:87])
<>aSlctFF{$i}{1}:=Field:C253(->[Job_Forms_CloseoutSummaries:87]JobForm:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Job_Forms_CloseoutSummaries:87]Customer:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Job_Forms_CloseoutSummaries:87]Line:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Job_Forms_CloseoutSummaries:87]BookContrib:12)
<>aSlctFF{$i}{5}:=Field:C253(->[Job_Forms_CloseoutSummaries:87]ActContrib:14)

$i:=Table:C252(->[Job_Forms_Master_Schedule:67])
<>aSlctFF{$i}{1}:=Field:C253(->[Job_Forms_Master_Schedule:67]JobForm:4)
<>aSlctFF{$i}{2}:=Field:C253(->[Job_Forms_Master_Schedule:67]Salesman:1)
<>aSlctFF{$i}{3}:=Field:C253(->[Job_Forms_Master_Schedule:67]Line:5)
<>aSlctFF{$i}{4}:=Field:C253(->[Job_Forms_Master_Schedule:67]PressDate:25)
<>aSlctFF{$i}{5}:=Field:C253(->[Job_Forms_Master_Schedule:67]MAD:21)



$i:=Table:C252(->[Customers_Projects:9])
<>aSlctFF{$i}{1}:=Field:C253(->[Customers_Projects:9]Name:2)
<>aSlctFF{$i}{2}:=Field:C253(->[Customers_Projects:9]CustomerName:4)
<>aSlctFF{$i}{3}:=Field:C253(->[Customers_Projects:9]CustomerLine:5)
<>aSlctFF{$i}{4}:=Field:C253(->[Customers_Projects:9]Customerid:3)
<>aSlctFF{$i}{5}:=Field:C253(->[Customers_Projects:9]id:1)

$i:=Table:C252(->[Job_Forms_Items_Costs:92])
<>aSlctFF{$i}{1}:=Field:C253(->[Job_Forms_Items_Costs:92]FG_Key:13)
<>aSlctFF{$i}{2}:=Field:C253(->[Job_Forms_Items_Costs:92]Jobit:3)
<>aSlctFF{$i}{3}:=Field:C253(->[Job_Forms_Items_Costs:92]JobForm:1)
<>aSlctFF{$i}{4}:=Field:C253(->[Job_Forms_Items_Costs:92]RemainingQuantity:15)
<>aSlctFF{$i}{5}:=Field:C253(->[Job_Forms_Items_Costs:92]RemainingTotal:12)

$i:=Table:C252(->[WMS_AllowedLocations:73])
<>aSlctFF{$i}{1}:=Field:C253(->[WMS_AllowedLocations:73]ValidLocation:1)
<>aSlctFF{$i}{2}:=Field:C253(->[WMS_AllowedLocations:73]BarcodedID:2)

$i:=Table:C252(->[QA_Corrective_Actions:105])
<>aSlctFF{$i}{1}:=Field:C253(->[QA_Corrective_Actions:105]RequestNumber:1)
<>aSlctFF{$i}{2}:=Field:C253(->[QA_Corrective_Actions:105]DateCreated:2)
<>aSlctFF{$i}{3}:=Field:C253(->[QA_Corrective_Actions:105]ProductCode:7)
<>aSlctFF{$i}{4}:=Field:C253(->[QA_Corrective_Actions:105]RGA:4)
<>aSlctFF{$i}{5}:=Field:C253(->[QA_Corrective_Actions:105]Custid:5)

$i:=Table:C252(->[QA_Corrective_ActionsReason:106])
<>aSlctFF{$i}{1}:=Field:C253(->[QA_Corrective_ActionsReason:106]id:1)
<>aSlctFF{$i}{2}:=Field:C253(->[QA_Corrective_ActionsReason:106]Category:2)
<>aSlctFF{$i}{3}:=Field:C253(->[QA_Corrective_ActionsReason:106]Reason:3)
<>aSlctFF{$i}{4}:=Field:C253(->[QA_Corrective_ActionsReason:106]Category:2)
<>aSlctFF{$i}{5}:=Field:C253(->[QA_Corrective_ActionsReason:106]Category:2)

$i:=Table:C252(->[QA_Corrective_ActionsLocations:107])
<>aSlctFF{$i}{1}:=Field:C253(->[QA_Corrective_ActionsLocations:107]Location:1)
<>aSlctFF{$i}{2}:=Field:C253(->[QA_Corrective_ActionsLocations:107]Contact1:2)
<>aSlctFF{$i}{3}:=Field:C253(->[QA_Corrective_ActionsLocations:107]Contact1Email:3)
<>aSlctFF{$i}{4}:=Field:C253(->[QA_Corrective_ActionsLocations:107]Contact2:4)
<>aSlctFF{$i}{5}:=Field:C253(->[QA_Corrective_ActionsLocations:107]Contact2Email:5)

$i:=Table:C252(->[Finished_Goods_PackingSpecs:91])
<>aSlctFF{$i}{1}:=Field:C253(->[Finished_Goods_PackingSpecs:91]FileOutlineNum:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Finished_Goods_PackingSpecs:91]CaseCount:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Finished_Goods_PackingSpecs:91]CaseSizeLWH:7)
<>aSlctFF{$i}{4}:=Field:C253(->[Finished_Goods_PackingSpecs:91]SkidSize:23)
<>aSlctFF{$i}{5}:=Field:C253(->[Finished_Goods_PackingSpecs:91]SkidType:24)

$i:=Table:C252(->[WMS_WarehouseOrders:146])
<>aSlctFF{$i}{1}:=Field:C253(->[WMS_WarehouseOrders:146]RawMatlCode:2)
<>aSlctFF{$i}{2}:=Field:C253(->[WMS_WarehouseOrders:146]JobReference:4)
<>aSlctFF{$i}{3}:=Field:C253(->[WMS_WarehouseOrders:146]Needed:5)
<>aSlctFF{$i}{4}:=Field:C253(->[WMS_WarehouseOrders:146]Delivered:6)
<>aSlctFF{$i}{5}:=Field:C253(->[WMS_WarehouseOrders:146]id:1)



$i:=Table:C252(->[edi_Inbox:154])
<>aSlctFF{$i}{1}:=Field:C253(->[edi_Inbox:154]ID:1)
<>aSlctFF{$i}{2}:=Field:C253(->[edi_Inbox:154]Path:2)  //[edi_Inbox]PO_Numbers// Modified by: Mel Bohince (5/7/15) po's no longer save in text
<>aSlctFF{$i}{3}:=Field:C253(->[edi_Inbox:154]Date_Received:9)
<>aSlctFF{$i}{4}:=Field:C253(->[edi_Inbox:154]ICN:4)
<>aSlctFF{$i}{5}:=Field:C253(->[edi_Inbox:154]Mapped:6)

$i:=Table:C252(->[edi_Outbox:155])
<>aSlctFF{$i}{1}:=Field:C253(->[edi_Outbox:155]ID:1)
<>aSlctFF{$i}{2}:=Field:C253(->[edi_Outbox:155]PO_Number:8)
<>aSlctFF{$i}{3}:=Field:C253(->[edi_Outbox:155]Com_AccountName:7)
<>aSlctFF{$i}{4}:=Field:C253(->[edi_Outbox:155]Subject:5)
<>aSlctFF{$i}{5}:=Field:C253(->[edi_Outbox:155]CrossReference:6)

$i:=Table:C252(->[edi_COM_Account:156])
<>aSlctFF{$i}{1}:=Field:C253(->[edi_COM_Account:156]Name:1)
<>aSlctFF{$i}{2}:=Field:C253(->[edi_COM_Account:156]Server:2)
<>aSlctFF{$i}{3}:=Field:C253(->[edi_COM_Account:156]User:3)
<>aSlctFF{$i}{4}:=Field:C253(->[edi_COM_Account:156]Path:5)
<>aSlctFF{$i}{5}:=Field:C253(->[edi_COM_Account:156]Disabled:9)

$i:=Table:C252(->[edi_Preferences:157])
<>aSlctFF{$i}{1}:=Field:C253(->[edi_Preferences:157]PrefName:2)
<>aSlctFF{$i}{2}:=Field:C253(->[edi_Preferences:157]UserName:1)
<>aSlctFF{$i}{3}:=Field:C253(->[edi_Preferences:157]Prefs:3)

