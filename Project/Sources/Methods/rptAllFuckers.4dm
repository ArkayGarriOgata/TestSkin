//%attributes = {"publishedWeb":true}
//Procedure: rptAllFuckers()  082798  MLB
//•090398  MLB  tidy up

CONFIRM:C162("Do you wish to report Customer liabilities older than a certain date?"; "Search"; "Cancel")
If (ok=1)
	$date:=4D_Current_date-364
	$dateString:=String:C10($date; <>MIDDATE)
	$dateString:=Request:C163("Look at orderlines before:"; $dateString)
	If (ok=1)
		$date:=Date:C102($dateString)
		READ ONLY:C145([Customers:16])
		QUERY:C277([Customers:16])
		
		If (ok=1)
			If (Records in selection:C76([Customers:16])>0)
				$Path:=uCreateFolder("Defaulted_Orders_"+$dateString)
				
				While (Not:C34(End selection:C36([Customers:16])))
					rptFuckMe([Customers:16]Name:2; $date; $path)
					NEXT RECORD:C51([Customers:16])
				End while 
				
			Else 
				BEEP:C151
				ALERT:C41("No customers found.")
			End if 
		End if 
	End if 
End if 