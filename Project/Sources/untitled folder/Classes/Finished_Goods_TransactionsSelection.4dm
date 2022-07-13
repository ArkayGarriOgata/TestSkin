/*
EntitySelection Class for Finished_Goods_Transactions
By: MelvinBohince @ 06/10/22, 09:31:42
Description:
          functions to apply against an fgx entity selection
Example:
         $fgx_es:=ds.Finished_Goods_Transactions.query("Jobit = :1"; "18145.01.05")//make an EntSel
         $good:=$fgx_es.getGoodQuantity()  //call class func
         $shipped:=$fgx_es.getShippedNetQuantity()  //call class func
         
         $fgx_es:=ds.Finished_Goods_Transactions.query("ProductCode = :1"; "6FW2-01-0117")//make an EntSel
         $good:=$fgx_es.getGoodQuantity()  //call class func
         $shipped:=$fgx_es.getShippedNetQuantity()  //call class func
*/

Class extends EntitySelection

Function getGoodQuantity()->$goodQty : Integer
	//return the quantity of the Received less the Scrapped
	// this is likely different than what was reported on the MachineTickets of the ShiftCard
	
	var $receivedQty; $scrapQty; $goodQty : Integer
	
	$receivedQty:=This:C1470.query("XactionType = :1"; "Receipt").sum("Qty")
	$scrapQty:=This:C1470.query("XactionType = :1"; "Scrap").sum("Qty")
	
	$goodQty:=$receivedQty-$scrapQty
	
	
Function getShippedNetQuantity()->$netShipped : Integer
	//return the quantity of the Received less the Scrapped
	
	var $shippedQty; $returnedQty; $netShipped : Integer
	
	$shippedQty:=This:C1470.query("XactionType = :1"; "Ship").sum("Qty")
	$returnedQty:=This:C1470.query("XactionType = :1"; "Return").sum("Qty")
	
	$netShipped:=$shippedQty-$returnedQty
	
	