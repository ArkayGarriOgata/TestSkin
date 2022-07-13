
sCustName:=CUST_getName([Customers_ReleaseSchedules:46]CustID:12)
tRecert:=""
If (REL_getRecertificationRequired("lookup"; [Customers_ReleaseSchedules:46]ProductCode:11))
	tRecert:="RE-CERTIFICATION REQUIRED"+Char:C90(13)+"Done By: _____________"
End if 
//