iRelNumber:=0
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3=sBreakText)
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]OpenQty>0)

Case of 
	: (Records in selection:C76([Customers_ReleaseSchedules:46])=1)
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
		If (fLockNLoad(->[Customers_ReleaseSchedules:46]))
			iRelNumber:=[Customers_ReleaseSchedules:46]ReleaseNumber:1
		Else 
			BEEP:C151
			ALERT:C41("WARNING: Release record will not be updated if you continue.")
		End if 
		
	: (Records in selection:C76([Customers_ReleaseSchedules:46])>1)
		BEEP:C151
		ALERT:C41(sBreakText+" finds multiple Releases, make the cust refer unique and try again.")
		
	Else 
		BEEP:C151
		ALERT:C41(sBreakText+" was not found on any releases.")
End case 
