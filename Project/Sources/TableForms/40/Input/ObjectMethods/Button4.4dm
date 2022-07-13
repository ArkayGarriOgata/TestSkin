$new_sender:=Request:C163("6315311578, BEESL.ESL001 or 5164547103"; [Customers_Orders:40]edi_sender_id:57; "Set"; "Cancel")
If (ok=1)
	[Customers_Orders:40]edi_sender_id:57:=$new_sender
End if 