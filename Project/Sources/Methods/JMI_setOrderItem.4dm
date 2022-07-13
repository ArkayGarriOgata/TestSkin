//%attributes = {"publishedWeb":true}
//PM: JMI_setOrderItem(jobit;orderline) -> 
//@author mlb - 9/3/02  12:22

C_TEXT:C284($1; $2)

READ WRITE:C146([Job_Forms_Items:44])  //•100898  mlb  UPR 1982 stomp out fill-ins

If (qryJMI($1)>0)
	If ([Job_Forms_Items:44]OrderItem:2="fill-in") | ([Job_Forms_Items:44]OrderItem:2="forecast")
		[Job_Forms_Items:44]OrderItem:2:=$2
		SAVE RECORD:C53([Job_Forms_Items:44])
	End if 
End if 