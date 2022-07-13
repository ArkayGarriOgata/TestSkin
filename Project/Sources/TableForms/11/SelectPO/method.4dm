If (Form event code:C388=On Load:K2:1)  //(LP) [PURCHASE_ORDER]SelectPO
	sCriterion1:=""
	t1:=""
	//dDate:=`4D_Current_date
	rb1:=1
	CREATE EMPTY SET:C140([Purchase_Orders:11]; "printThese")
End if 