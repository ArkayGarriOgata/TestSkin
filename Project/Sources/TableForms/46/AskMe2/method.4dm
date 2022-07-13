$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground(226; 255; 223; 255; 255; 255)
		If ([Customers_ReleaseSchedules:46]LastRelease:20)
			Core_ObjectSetColor(->[Customers_ReleaseSchedules:46]Sched_Date:5; -(3+(256*0)); True:C214)
			Core_ObjectSetColor(->[Customers_ReleaseSchedules:46]Sched_Qty:6; -(3+(256*0)); True:C214)
		Else 
			Core_ObjectSetColor(->[Customers_ReleaseSchedules:46]Sched_Date:5; -(15+(256*0)); True:C214)
			Core_ObjectSetColor(->[Customers_ReleaseSchedules:46]Sched_Qty:6; -(15+(256*0)); True:C214)
		End if 
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Customers_ReleaseSchedules:46]; "Customers_ReleaseSchedules")
		
End case 
