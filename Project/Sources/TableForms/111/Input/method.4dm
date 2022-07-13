// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 2/1/02  12:09
// ----------------------------------------------------
// Form Method: [JPSI_Job_Physical_Support_Items].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([JPSI_Job_Physical_Support_Items:111]))
			[JPSI_Job_Physical_Support_Items:111]DateDesignated:6:=4D_Current_date
			[JPSI_Job_Physical_Support_Items:111]PjtNumber:3:=Pjt_getReferId
			If (Length:C16([JPSI_Job_Physical_Support_Items:111]PjtNumber:3)=5)
				READ ONLY:C145([Customers_Projects:9])
				QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[JPSI_Job_Physical_Support_Items:111]PjtNumber:3)
				If (Records in selection:C76([Customers_Projects:9])>0)
					[JPSI_Job_Physical_Support_Items:111]Custid:7:=[Customers_Projects:9]Customerid:3
				End if 
			End if 
			[JPSI_Job_Physical_Support_Items:111]Location:5:=JTB_setLocation
			
		Else 
			READ ONLY:C145([Customers_Projects:9])
			QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[JPSI_Job_Physical_Support_Items:111]PjtNumber:3)
		End if 
		
		If (Length:C16([JPSI_Job_Physical_Support_Items:111]ID:1)>0)
			SetObjectProperties(""; ->[JPSI_Job_Physical_Support_Items:111]ID:1; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		Else 
			SetObjectProperties(""; ->[JPSI_Job_Physical_Support_Items:111]ID:1; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		End if 
		
		LIST TO ARRAY:C288("JobPhySuptItemType"; aItemTypes)
		
	: (Form event code:C388=On Validate:K2:3)
		If (Is new record:C668([JPSI_Job_Physical_Support_Items:111]))
			JTB_LogJPSI([JPSI_Job_Physical_Support_Items:111]ID:1; "Designated by "+<>zResp+" at "+[JPSI_Job_Physical_Support_Items:111]Location:5+" to pjt:"+[JPSI_Job_Physical_Support_Items:111]PjtNumber:3)
		End if 
End case 