//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/11/06, 14:10:36
// ----------------------------------------------------
// Method: PO_setExtendedTotals
// ----------------------------------------------------

Case of 
	: (Count parameters:C259=0)
		BEEP:C151
		
	: ($1="all")
		SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]ExtPrice:11; $aExtPrice; [Purchase_Orders_Items:12]Canceled:44; $aCancelledFlag; [Purchase_Orders_Items:12]CommodityCode:16; $aCommCode)
		$sum:=0
		allow_supply_chain:=False:C215
		For ($i; 1; Size of array:C274($aExtPrice))
			If (Not:C34($aCancelledFlag{$i}))
				$sum:=$sum+$aExtPrice{$i}
				
				If ($aCommCode{$i}=17) | ($aCommCode{$i}=1)
					allow_supply_chain:=True:C214
				Else 
					allow_supply_chain:=False:C215
				End if 
			End if 
		End for 
		$sum:=Round:C94($sum; 2)
		
		If (Num:C11([Purchase_Orders:11]LastChgOrdNo:18)=0)
			[Purchase_Orders:11]OrigOrderAmt:12:=$sum  //Round(Sum([Purchase_Orders_Items]ExtPrice);2)
		End if 
		[Purchase_Orders:11]ChgdOrderAmt:13:=$sum  //Round(Sum([Purchase_Orders_Items]ExtPrice);2)
		
	: ($1="current")
		If (Not:C34([Purchase_Orders_Items:12]Canceled:44))
			If (Num:C11([Purchase_Orders:11]LastChgOrdNo:18)=0)
				[Purchase_Orders:11]OrigOrderAmt:12:=Round:C94([Purchase_Orders:11]OrigOrderAmt:12-Old:C35([Purchase_Orders_Items:12]ExtPrice:11)+[Purchase_Orders_Items:12]ExtPrice:11; 2)
			End if 
			[Purchase_Orders:11]ChgdOrderAmt:13:=Round:C94([Purchase_Orders:11]ChgdOrderAmt:13-Old:C35([Purchase_Orders_Items:12]ExtPrice:11)+[Purchase_Orders_Items:12]ExtPrice:11; 2)
			
		Else   //cancelled, so remove old extprice
			If (Num:C11([Purchase_Orders:11]LastChgOrdNo:18)=0)
				[Purchase_Orders:11]OrigOrderAmt:12:=Round:C94([Purchase_Orders:11]OrigOrderAmt:12-Old:C35([Purchase_Orders_Items:12]ExtPrice:11); 2)
			End if 
			[Purchase_Orders:11]ChgdOrderAmt:13:=Round:C94([Purchase_Orders:11]ChgdOrderAmt:13-Old:C35([Purchase_Orders_Items:12]ExtPrice:11); 2)
			
		End if 
End case 