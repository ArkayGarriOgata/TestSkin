// -
// Form Method: [Finished_Goods].PickOptions
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------
// Modified by: Mel Bohince (10/26/21) add clipboard option

If (Form event code:C388=On Load:K2:1)
	If ([Estimates:17]Brand:3="")
		OBJECT SET ENABLED:C1123(bBrand; False:C215)
	Else 
		SetObjectProperties(""; ->bBrand; True:C214; "Pick from "+[Estimates:17]Brand:3+" only")
	End if 
	
	If ([Estimates:17]Cust_ID:2="")
		OBJECT SET ENABLED:C1123(bCust; False:C215)
		OBJECT SET ENABLED:C1123(bNew; False:C215)
		BEEP:C151
		ALERT:C41("Enter a customer first.")
		CANCEL:C270
		
	Else 
		SetObjectProperties(""; ->bCust; True:C214; "Pick from customer "+CUST_getName([Estimates:17]Cust_ID:2; "elc"))
	End if 
	
	C_TEXT:C284($clipboardText)
	$clipboardText:=Get text from pasteboard:C524  //copied from excel, columns delimited by <tabs>, rows by <return+newline>
	If (ok=1)
		OBJECT SET ENABLED:C1123(bFromClipboard; True:C214)
	Else 
		OBJECT SET ENABLED:C1123(bFromClipboard; False:C215)
	End if 
	
End if 