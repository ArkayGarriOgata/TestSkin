//(s) hbInvoice [customerorder]input.pg1
uConfirm("Are You Sure that You Want to Bill Non-Product"+" Items, Such as Plates, Dies etc.?"; "Invoice"; "Cancel")

If (OK=1)
	Invoice_NonShippingItem
	Invoice_SetInvoiceBtnState
End if 