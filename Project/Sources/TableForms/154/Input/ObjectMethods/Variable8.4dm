//Object Method: bmap()  101598  MLB
$continue:=False:C215
If ([edi_Inbox:154]Mapped:6<=0)
	$continue:=True:C214
Else 
	uConfirm("This message has already been mapped."; "Re Map"; "Cancel")
	If (ok=1)
		$continue:=True:C214
	End if 
End if 

If ($continue)
	EDI_MapInboxMsg
	
	If (Length:C16([edi_Inbox:154]ICN:4)>0)
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]edi_ICN:56=[edi_Inbox:154]ICN:4)
		ORDER BY:C49([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1; >)
	Else 
		REDUCE SELECTION:C351([Customers_Orders:40]; 0)
	End if 
End if 