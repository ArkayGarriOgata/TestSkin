Repeat 
	$find:=Request:C163("Which PO?"; ""; "Find"; "Cancel")
Until (ok=0) | (Length:C16($find)>0)


If (ok=1)
	QUERY:C277([edi_po_list:182]; [edi_po_list:182]customers_po:3=$find)
	If (Records in selection:C76([edi_po_list:182])>0)
		RELATE ONE SELECTION:C349([edi_po_list:182]; [edi_Inbox:154])
		zwStatusMsg("PO Search"; $find+" found in "+String:C10(Records in selection:C76([edi_Inbox:154]))+" edi messages.")
	Else 
		REDUCE SELECTION:C351([edi_Inbox:154]; 0)
		BEEP:C151
		zwStatusMsg("PO Search"; $find+" was not found.")
	End if 
	
	ORDER BY:C49([edi_Inbox:154]; [edi_Inbox:154]ID:1; <)
End if 