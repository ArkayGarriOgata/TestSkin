//%attributes = {"publishedWeb":true}
//PM:  ORD_GetOpenDemand({cpn};{no overrun})  081099  mlb

C_TEXT:C284($1; $2)
C_LONGINT:C283($0; $openDemand; $numRecs; $i)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	If (Count parameters:C259>0)  //otherwise primary orderlines already current
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$1)
	End if 
	//SEARCH([OrderLines]; & [OrderLines]CustID=[Finished_Goods]CustID)
	$numRecs:=qryOpenOrdLines(""; "*")
	
Else 
	
	If (Count parameters:C259>0)  //otherwise primary orderlines already current
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$1; *)
	End if 
	
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
	
	$numRecs:=Records in selection:C76([Customers_Order_Lines:41])
	
End if   // END 4D Professional Services : January 2019 First record


$openDemand:=0
If ($numRecs>0)
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Qty_Open:11; $aOpen; [Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]OverRun:25; $aOR)
	
	//FIRST RECORD([OrderLines])
	For ($i; 1; $numRecs)
		If (Count parameters:C259<2)  //use overun
			$openDemand:=$openDemand+($aOpen{$i}+($aQty{$i}*($aOR{$i}/100)))
		Else 
			$openDemand:=$openDemand+$aOpen{$i}
		End if 
	End for 
End if 

$0:=$openDemand