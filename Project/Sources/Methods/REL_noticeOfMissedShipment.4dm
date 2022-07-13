//%attributes = {"publishedWeb":true}
//PM: REL_noticeOfMissedShipment() -> 
//@author Mel - 5/03  11:19
//
// Modified by: Garri Ogata (8/27/21) changed to support multiple Customer emails

ARRAY DATE:C224($aSchDate; 0)
ARRAY DATE:C224($aActDate; 0)

READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Users:5])
READ ONLY:C145([Finished_Goods_Locations:35])

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5=4D_Current_date; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39=0; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<F@")

For ($i; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG@")
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		$onhand:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	Else 
		$onhand:=0
	End if 
	$subject:="Missed shipment for "+[Customers_ReleaseSchedules:46]ProductCode:11+", but had Inventory"
	$body:="Scheduled Qty: "+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6; "##,###,##0")+" Inventory was: "+String:C10($onhand; "##,###,##0")+Char:C90(13)
	$body:=$body+"  rel#: "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+", sched: "+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)
	$body:=$body+", promised: "+String:C10([Customers_ReleaseSchedules:46]Promise_Date:32; System date short:K1:1)
	
	If ([Customers_ReleaseSchedules:46]CustID:12#[Customers:16]ID:1)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_ReleaseSchedules:46]CustID:12)
	End if 
	$body:=$body+", Customer: "+[Customers:16]Name:2
	distributionList:=""
	
	C_OBJECT:C1216($oPeople)  // Modified by: Garri Ogata (8/26/21) People object
	$oPeople:=New object:C1471()
	$oPeople.tCustomerID:=[Customers_ReleaseSchedules:46]CustID:12
	$oPeople.bCustomerService:=True:C214
	distributionList:=Cust_GetEmailsT($oPeople)
	
	//QUERY([Users];[Users]Initials=[Customers]CustomerService)  //• mlb - 2/21/02  11:34
	//If (Records in selection([Users])>0)
	//distributionList:=distributionList+Email_WhoAmI ([Users]UserName)+Char(9)
	//End if 
	
	distributionList:=distributionList+Batch_GetDistributionList("REL_noticeOfMissedShipment")
	
	EMAIL_Sender($subject; ""; $body; distributionList)
	NEXT RECORD:C51([Customers_ReleaseSchedules:46])
End for 

REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Customers:16]; 0)
REDUCE SELECTION:C351([Users:5]; 0)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)