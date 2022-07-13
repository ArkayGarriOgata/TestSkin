//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/21/09, 10:58:48
// ----------------------------------------------------
// Method: EDI_ShowNewOrders
// ----------------------------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=0)
	$pid:=New process:C317("EDI_ShowNewOrders"; <>lMidMemPart; "New EDI Orders"; "init")
	If (False:C215)
		EDI_ShowNewOrders
	End if 
	
Else 
	SET MENU BAR:C67(<>DefaultMenu)
	READ WRITE:C146([Customers_Orders:40])
	READ WRITE:C146([Customers_Order_Lines:41])
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_line_status:55="New@"; *)
	QUERY:C277([Customers_Order_Lines:41];  | ; [Customers_Order_Lines:41]edi_line_status:55="Change@")
	If (Records in selection:C76([Customers_Order_Lines:41])=0)
		uConfirm("No New or Changed EDI orders found, look for Sent or Reviewed?"; "Yes"; "No")
		If (OK=1)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_line_status:55="Sent@"; *)
			QUERY:C277([Customers_Order_Lines:41];  | ; [Customers_Order_Lines:41]edi_line_status:55="Review@")
		End if 
	End if 
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		$planner:=Request:C163("Which Arkay Planner?"; "ALL"; "OK"; "Help")
		If (OK=1)
			If ($planner#"ALL")
				QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_arkay_planner:68=$planner; *)
				QUERY SELECTION:C341([Customers_Order_Lines:41];  | ; [Customers_Order_Lines:41]edi_arkay_planner:68="")
			End if 
		End if 
		
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_arkay_planner:68; >; [Customers_Order_Lines:41]OrderLine:3; >)
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			FORM SET INPUT:C55([zz_control:1]; "edi_EnterInList")
			FORM SET INPUT:C55([Customers_Order_Lines:41]; "edi_Input")
			//using as enter in list -->  OUTPUT FORM([Customers_Order_Lines];"edi_compare")
			windowTitle:=""
			$winRef:=OpenFormWindow(->[Customers_Order_Lines:41]; "edi_Input"; ->windowTitle; "Compare EDI to AMS")
			ADD RECORD:C56([zz_control:1]; *)  //never save
			FORM SET INPUT:C55([zz_control:1]; "Input")
			FORM SET INPUT:C55([Customers_Order_Lines:41]; "Input")
			
		Else 
			ALERT:C41("No New or Changed EDI orders found for planner "+$planner)
		End if 
		
	Else 
		ALERT:C41("No New or Changed EDI orders found.")
	End if 
	
	REDUCE SELECTION:C351([Customers_Orders:40]; 0)
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	
End if 