xNotes:=[Customers_Orders:40]Comments:15
wWindowTitle("push"; "Customer Order "+String:C10([Customers_Orders:40]OrderNumber:1)+"'s Comments")
OpenSheetWindow(->[Finished_Goods:26]; "Notesdialog")
DIALOG:C40([Finished_Goods:26]; "Notesdialog")
CLOSE WINDOW:C154
If (ok=1) & (Not:C34(Read only state:C362([Customers_Orders:40])))
	[Customers_Orders:40]Comments:15:=xNotes
End if 
wWindowTitle("pop")