//(S) NewEstimate: Enter new estimate and bring down items from Estimate
//upr 1303 11/8/94

// Modified by: Mel Bohince (6/18/13) make doChangeOrder return error code and clear rev-est if not zero error
If (Length:C16([Customers_Order_Change_Orders:34]NewEstimate:38)=9)
	$err:=ORD_ChangeOrder([Customers_Order_Change_Orders:34]NewEstimate:38)
	If ($err#0)
		[Customers_Order_Change_Orders:34]NewEstimate:38:=""
	End if 
Else 
	BEEP:C151
	ALERT:C41([Customers_Order_Change_Orders:34]NewEstimate:38+" is not a valid estimate number."+Char:C90(13)+"Please Try again.")
	[Customers_Order_Change_Orders:34]NewEstimate:38:=""
	GOTO OBJECT:C206([Customers_Order_Change_Orders:34]NewEstimate:38)
End if   //wrong length

RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)
//EOP