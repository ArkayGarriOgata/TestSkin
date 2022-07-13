If ([Customers_ReleaseSchedules:46]LastRelease:20)
	t5:="LAST RELEASE  "
Else 
	t5:=""
End if 

If ([Customers_ReleaseSchedules:46]PayU:31=1)  //91097 mlb
	t5:=t5+"  **PAY-USE**  "
End if 
//
If ([Finished_Goods:26]ProductCode:1#[Customers_ReleaseSchedules:46]ProductCode:11)
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11)
End if 
t5:=t5+[Finished_Goods:26]CartonDesc:3