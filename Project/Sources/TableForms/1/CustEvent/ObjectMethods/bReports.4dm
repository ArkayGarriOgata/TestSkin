// ----------------------------------------------------
// Method: [zz_control].CustEvent.bReports
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:="Customer Detail Report;Commission Settings;Bookings Report"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)
					ViewSetter(7; ->[Customers:16]; "Customer Detail Report")
				: ($user_choice=2)
					$pid:=New process:C317("Cust_CommissionScaleRpt"; <>lMinMemPart; "CommissionScaleRpt")
				: ($user_choice=3)
					$pid:=New process:C317("Cust_BookingsRpt"; <>lMinMemPart; "BookingsRpt")
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
End case 