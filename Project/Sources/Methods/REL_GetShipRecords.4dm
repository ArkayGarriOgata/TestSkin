//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 07/19/07, 10:47:09
// ----------------------------------------------------
// Method: REL_GetShipRecords
// Description
// load related records so invoice can be populated
// see also Invoice_GetShipRecords
// ----------------------------------------------------

C_LONGINT:C283($1; $BOL; $numFG)
C_TEXT:C284($exception; $0)

$BOL:=$1
$exception:=""

SET QUERY LIMIT:C395(1)
//*Load related records
If ([Customers_Bills_of_Lading:49]ShippersNo:1#$BOL)
	QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=$BOL)
	If (Records in selection:C76([Customers_Bills_of_Lading:49])=0)
		$exception:=$exception+" [Bills_of_Lading] record not found: "+String:C10($BOL)+Char:C90(13)
	End if 
End if 
RELATE MANY:C262([Customers_Bills_of_Lading:49]Manifest:16)

If ([Customers_Order_Lines:41]OrderLine:3#[Customers_ReleaseSchedules:46]OrderLine:4)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Customers_ReleaseSchedules:46]OrderLine:4)
	If (Records in selection:C76([Customers_Order_Lines:41])=0)
		$exception:=$exception+" [OrderLines] record not found: "+[Customers_ReleaseSchedules:46]OrderLine:4+Char:C90(13)
	End if 
End if 

If ([Customers_Orders:40]OrderNumber:1#[Customers_ReleaseSchedules:46]OrderNumber:2)
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_ReleaseSchedules:46]OrderNumber:2)
	If (Records in selection:C76([Customers_Orders:40])=0)
		$exception:=$exception+" [CustomerOrder] record not found: "+String:C10([Customers_ReleaseSchedules:46]OrderNumber:2)+Char:C90(13)
	End if 
End if 

If ([Customers:16]ID:1#[Customers_ReleaseSchedules:46]CustID:12)
	READ ONLY:C145([Customers:16])
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_ReleaseSchedules:46]CustID:12)
	If (Records in selection:C76([Customers:16])=0)
		$exception:=$exception+" [CUSTOMER] record not found: "+[Customers_ReleaseSchedules:46]CustID:12+Char:C90(13)
	End if 
End if 

If ([Finished_Goods_Classifications:45]Class:1#[Customers_Order_Lines:41]Classification:29)
	QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Customers_Order_Lines:41]Classification:29)
	If (Records in selection:C76([Finished_Goods_Classifications:45])=0)
		$exception:=$exception+" [FG_Class_n_Acct] record not found: "+[Customers_Order_Lines:41]Classification:29+Char:C90(13)
	End if 
End if 

If ([Finished_Goods:26]ProductCode:1#[Customers_ReleaseSchedules:46]ProductCode:11)
	$numFG:=qryFinishedGood([Customers:16]ID:1; [Customers_ReleaseSchedules:46]ProductCode:11)  //•4/15/99  MLB 
	If ($numFG=0)
		$exception:=$exception+" [Finished_Goods] record not found: "+[Customers:16]ID:1+":"+[Customers_ReleaseSchedules:46]ProductCode:11+Char:C90(13)
	End if 
End if 

If ([Addresses:30]ID:1#[Customers_ReleaseSchedules:46]Billto:22)
	READ ONLY:C145([Addresses:30])
	QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_ReleaseSchedules:46]Billto:22)
	If (Records in selection:C76([Addresses:30])=0)
		$exception:=$exception+" [Addresses]billto record not found: "+[Customers_ReleaseSchedules:46]Billto:22+Char:C90(13)
	End if 
End if 

SET QUERY LIMIT:C395(0)
If (Length:C16($exception)>0)
	$exception:=String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+" "+$exception
	utl_Logfile("shipping.log"; $exception)
End if 

$0:=$exception