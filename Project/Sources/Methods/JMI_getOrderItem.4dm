//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/01/15, 10:54:00
// ----------------------------------------------------
// Method: JMI_getOrderItem
// Description
// return the orderitem of a jobit
//
// ----------------------------------------------------

$num:=qryJMI($1)
If ($num>0)
	$0:=[Job_Forms_Items:44]OrderItem:2
Else 
	$0:="N/F"
End if 