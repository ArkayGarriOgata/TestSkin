//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/11/13, 08:23:33
// ----------------------------------------------------
// Method: FG_ChkQtyShipped
// ----------------------------------------------------
// Modified by: Mel Bohince (4/18/14) cleanup "ThisSet"
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	C_TEXT:C284($tJobIt; $1)
	C_LONGINT:C283($xlTotalShipped; $xlScrapped; $xlGlued; $xlInventory)
	
	$tJobIt:=$1
	$xlTotalShipped:=0
	$xlScrapped:=0
	$xlGlued:=0
	$xlInventory:=0
	
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$tJobIt)
	CREATE SET:C116([Finished_Goods_Transactions:33]; "ThisSet")
	
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Receipt")  //Glued
	$xlGlued:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	USE SET:C118("ThisSet")
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship")
	$xlTotalShipped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	USE SET:C118("ThisSet")
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Scrap")
	$xlScrapped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	$xlInventory:=$xlGlued-$xlScrapped-$xlTotalShipped
	
	utl_LogIt("init")
	utl_LogIt($tJobIt+" "+[Finished_Goods_Locations:35]ProductCode:1+<>CR)
	utl_LogIt("Glued: "+String:C10($xlGlued))
	utl_LogIt("Scrapped: "+String:C10($xlScrapped))
	utl_LogIt("Shipped: "+String:C10($xlTotalShipped))
	utl_LogIt("Net Inventory: "+String:C10($xlInventory))
	utl_LogIt("show")
	
	CLEAR SET:C117("ThisSet")  // Modified by: Mel Bohince (4/18/14) cleanup
	
Else 
	
	C_TEXT:C284($tJobIt; $1)
	C_LONGINT:C283($xlTotalShipped; $xlScrapped; $xlGlued; $xlInventory)
	
	$tJobIt:=$1
	$xlTotalShipped:=0
	$xlScrapped:=0
	$xlGlued:=0
	$xlInventory:=0
	
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$tJobIt; *)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Receipt")  //Glued
	$xlGlued:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$tJobIt; *)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship")
	$xlTotalShipped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$tJobIt; *)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Scrap")
	$xlScrapped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	$xlInventory:=$xlGlued-$xlScrapped-$xlTotalShipped
	
	utl_LogIt("init")
	utl_LogIt($tJobIt+" "+[Finished_Goods_Locations:35]ProductCode:1+<>CR)
	utl_LogIt("Glued: "+String:C10($xlGlued))
	utl_LogIt("Scrapped: "+String:C10($xlScrapped))
	utl_LogIt("Shipped: "+String:C10($xlTotalShipped))
	utl_LogIt("Net Inventory: "+String:C10($xlInventory))
	utl_LogIt("show")
	
	
End if   // END 4D Professional Services : January 2019 query selection
