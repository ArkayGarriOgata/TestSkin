//(s) sMachLabel1
// reusing an existing variable
//created 3/2/98 cs

If (Printing page:C275=1)
	Self:C308->:="P.O. Total: "+String:C10([Purchase_Orders:11]ChgdOrderAmt:13; "$###,###,##0.00")
Else 
	Self:C308->:=""
End if 
//