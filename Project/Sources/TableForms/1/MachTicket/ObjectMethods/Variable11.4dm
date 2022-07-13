//(S) bClear: (L)[CONTROL]'MachTicket

uConfirm("Clear the current Machine Ticket entry?"; "Clear"; "Cancel")

If (OK=1)
	gClearMT
End if 