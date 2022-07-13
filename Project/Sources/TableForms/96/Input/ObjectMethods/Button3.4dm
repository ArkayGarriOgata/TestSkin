utl_LogIt("init")
utl_LogIt("Transaction History for Skid "+[WMS_SerializedShippingLabels:96]HumanReadable:5+Char:C90(13))
READ ONLY:C145([Finished_Goods_Transactions:33])
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Skid_number:29=[WMS_SerializedShippingLabels:96]HumanReadable:5)
If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionNum:24; >)
		While (Not:C34(End selection:C36([Finished_Goods_Transactions:33])))
			utl_LogIt(TS_ISO_String_TimeStamp([Finished_Goods_Transactions:33]XactionDate:3; [Finished_Goods_Transactions:33]XactionTime:13)+Char:C90(9)+[Finished_Goods_Transactions:33]XactionType:2+Char:C90(9)+String:C10([Finished_Goods_Transactions:33]Qty:6)+Char:C90(9)+" to "+[Finished_Goods_Transactions:33]Location:9)
			NEXT RECORD:C51([Finished_Goods_Transactions:33])
		End while 
		
	Else 
		
		ARRAY TEXT:C222($_XactionNum; 0)
		ARRAY DATE:C224($_XactionDate; 0)
		ARRAY TIME:C1223($_XactionTime; 0)
		ARRAY TEXT:C222($_XactionType; 0)
		ARRAY LONGINT:C221($_Qty; 0)
		ARRAY TEXT:C222($_Location; 0)
		
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionNum:24; $_XactionNum; [Finished_Goods_Transactions:33]XactionDate:3; $_XactionDate; [Finished_Goods_Transactions:33]XactionTime:13; $_XactionTime; [Finished_Goods_Transactions:33]XactionType:2; $_XactionType; [Finished_Goods_Transactions:33]Qty:6; $_Qty; [Finished_Goods_Transactions:33]Location:9; $_Location)
		
		SORT ARRAY:C229($_XactionNum; $_XactionDate; $_XactionTime; $_XactionType; $_Qty; $_Location; >)
		
		
		For ($Iter; 1; Size of array:C274($_Location); 1)
			utl_LogIt(TS_ISO_String_TimeStamp($_XactionDate{$Iter}; $_XactionTime{$Iter})+Char:C90(9)+$_XactionType{$Iter}+Char:C90(9)+String:C10($_Qty{$Iter})+Char:C90(9)+" to "+$_Location{$Iter})
			
		End for 
	End if   // END 4D Professional Services : January 2019 First record
	
Else 
	utl_LogIt("no transactions for "+[WMS_SerializedShippingLabels:96]HumanReadable:5)
End if 
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
utl_LogIt("show")
utl_LogIt("init")