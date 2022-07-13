//%attributes = {}
//Method: Cust_GetEmailsT(oPeople)=>tDistributionList
//Description:  This method returns customer specific emails 
//. It allows you to specify who gets this email that is specified in the Customers record

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oPeople)
	C_TEXT:C284($0; $tDistributionList)
	
	C_BOOLEAN:C305($bCustomerFound)
	
	C_TEXT:C284($tDelimiter)
	C_TEXT:C284($tTableName; $tQuery)
	
	C_OBJECT:C1216($esCustomers; $eCustomer)
	
	$oPeople:=New object:C1471()
	
	$oPeople:=$1
	
	$tDistributionList:=CorektBlank
	
	$tTableName:=Table name:C256(->[Customers:16])
	
	$esCustomers:=New object:C1471()
	$eCustomer:=New object:C1471()
	
	$tDelimiter:=Char:C90(Tab:K15:37)
	
End if   //Done initialize

If (OB Is defined:C1231($oPeople; "tCustomerID"))  //Customer ID
	
	$tQuery:="ID = "+$oPeople.tCustomerID
	
	$esCustomers:=ds:C1482[$tTableName].query($tQuery)
	
	If ($esCustomers.length>0)  //Found
		
		$eCustomer:=$esCustomers.first()
		
		$bCustomerFound:=True:C214
		
	End if   //Done found
	
End if   //Done customer ID

If ($bCustomerFound)  //Customer
	
	If (OB Is defined:C1231($oPeople; "bCustomerService"))  //Customer Service
		
		$tEmail:=Email_WhoAmI(CorektBlank; $eCustomer.CustomerService)
		
		$tDistributionList:=$tDistributionList+Choose:C955(($tEmail=CorektBlank); \
			CorektBlank; \
			$tEmail+$tDelimiter)
		
		$tEmail:=Email_WhoAmI(CorektBlank; $eCustomer.CustomerService2)
		
		$tDistributionList:=$tDistributionList+Choose:C955(($tEmail=CorektBlank); \
			CorektBlank; \
			$tEmail+$tDelimiter)
		
	End if   //Done customer service
	
	If (OB Is defined:C1231($oPeople; "bSales"))  //SalesmanID
		
		$tEmail:=Email_WhoAmI(CorektBlank; $eCustomer.SalesmanID)
		
		$tDistributionList:=$tDistributionList+Choose:C955(($tEmail=CorektBlank); \
			CorektBlank; \
			$tEmail+$tDelimiter)
		
	End if   //Done salesmanID
	
	If (OB Is defined:C1231($oPeople; "bPlanner"))  //PlannerID
		
		$tEmail:=Email_WhoAmI(CorektBlank; $eCustomer.PlannerID)
		
		$tDistributionList:=$tDistributionList+Choose:C955(($tEmail=CorektBlank); \
			CorektBlank; \
			$tEmail+$tDelimiter)
		
	End if   //Done plannerID
	
	If (OB Is defined:C1231($oPeople; "bNotifyEmails"))  //NotifyEmails
		
		$tEmail:=Replace string:C233($eCustomer.NotifyEmails; CorektCR; $tDelimiter)
		
		$tDistributionList:=$tDistributionList+Choose:C955(($tEmail=CorektBlank); \
			CorektBlank; \
			$tEmail+$tDelimiter)
		
	End if   //Done NotifyEmails
	
End if   //Done customer

$0:=$tDistributionList