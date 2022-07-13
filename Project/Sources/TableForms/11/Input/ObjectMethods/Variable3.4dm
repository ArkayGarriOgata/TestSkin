USE SET:C118("ListboxSet0")
t1:=[Purchase_Orders_PO_Clauses:165]ClauseText:4
$winRef:=Open form window:C675([zz_control:1]; "text_dio")
DIALOG:C40([zz_control:1]; "text_dio")
[Purchase_Orders_PO_Clauses:165]ClauseText:4:=t1
SAVE RECORD:C53([Purchase_Orders_PO_Clauses:165])
CLOSE WINDOW:C154($winRef)
RELATE MANY:C262([Purchase_Orders:11]PO_Clauses:33)