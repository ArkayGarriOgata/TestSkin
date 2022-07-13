//%attributes = {"publishedWeb":true}
//PM: x_CommissionOnPlanned() -> 
//@author mlb - 6/20/01  09:56

Case of 
	: (True:C214)  //2020 change, fixed percent in cust record for everyone except GG Gregg Goldman
		C_OBJECT:C1216($entSel; $invoiceObj; $result)
		//commission scale of -1 is prep, dont want to change those or Gregg and Walts
		$fromDate:=Request:C163("Enter the starting date:"; "1/1/20")
		
		Case of 
			: (ok=0)
				//abort
			: (Length:C16($fromDate)<6)
				ALERT:C41("Date entered '"+$fromDate+"' is suspicious, aborting.")
				
			Else 
				$beginning:=Date:C102($fromDate)
				$entSel:=ds:C1482.Customers_Invoices.query("SalesPerson # :1 and SalesPerson # :2 and CommissionScale > :3 and Invoice_Date >= :4"; "GG"; "WJS"; 0; $beginning)
				If ($entSel.length>0)
					utl_LogfileServer("aMs"; "Changing Percent on "+String:C10($entSel.length)+" invoices from "+$fromDate)
				End if 
				
				uThermoInit($numRecs; "Updating Commissions from "+$fromDate)
				For each ($invoiceObj; $entSel)
					$invoiceObj.CommissionPercent:=fSalesCommisionFlatRate($invoiceObj.CustomerID)
					//If ($invoiceObj.CommissionPercent>0)
					$invoiceObj.CommissionPayable:=$invoiceObj.CommissionPercent*$invoiceObj.ExtendedPrice
					$invoiceObj.CommissionPlan:="2020"
					$invoiceObj.CommissionScale:=-2
					$result:=$invoiceObj.save()
					If (Not:C34($result.success))
						utl_LogfileServer("aMs"; "...Setting Commission Percent failed on invoice "+String:C10($invoiceObj.InvoiceNumber)+" "+$result.statusText)
					End if 
					//End if 
					uThermoUpdate($i)
				End for each 
				uThermoClose
				
				utl_LogfileServer("aMs"; "Finished Setting Percent")
		End case 
		
		
		
	: (False:C215)  //2001 change
		//MESSAGES OFF
		//FIRST RECORD([Customers_Invoices])  //
		//APPLY TO SELECTION([Customers_Invoices];[Customers_Invoices]CommissionPayable:=fSalesCommission ("Normal";[Customers_Invoices]OrderLine;[Customers_Invoices]Quantity/1000))
		
End case 

