// ----------------------------------------------------
// Form Method: [Raw_Materials_Transactions].Rama_Transactions
// Modified by: Mel Bohince (11/5/12) allow btns to toggle to undo setting date
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4) | (Form event code:C388=On Selection Change:K2:29)
		
		If (InvListBox<=Size of array:C274(InvListBox))
			OBJECT SET ENABLED:C1123(bInvoice; True:C214)
			If (User in group:C338(Current user:C182; "RoleAccounting"))
				OBJECT SET ENABLED:C1123(bPay; True:C214)
			End if 
			
			//LISTBOX SELECT ROW(InvListBox;InvListBox;Replace listbox selection)
			zwStatusMsg("Selected"; String:C10(InvListBox))
			
			If (aDateInvoiced{InvListBox}=!00-00-00!)
				SetObjectProperties(""; ->bInvoice; True:C214; "Invoice")
			Else 
				SetObjectProperties(""; ->bInvoice; True:C214; "Un-Invoice")
			End if 
			
			If (aDatePaid{InvListBox}=!00-00-00!)
				SetObjectProperties(""; ->bPay; True:C214; "Pay")
			Else 
				SetObjectProperties(""; ->bPay; True:C214; "Un-Pay")
			End if 
			
		Else 
			OBJECT SET ENABLED:C1123(bInvoice; False:C215)
			OBJECT SET ENABLED:C1123(bPay; False:C215)
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET ENABLED:C1123(bInvoice; False:C215)
		OBJECT SET ENABLED:C1123(bPay; False:C215)
		C_DATE:C307(dDateEnd; dDateBegin)
		dDateBegin:=!00-00-00!
		If (dDateEnd=!00-00-00!)
			dDateEnd:=4D_Current_date
		End if 
		
	: (Form event code:C388=On Outside Call:K2:11)
		//$hit:=Find in array(aCPN;<>rama_cpn)
		//If ($hit>-1) & ($hit<=LISTBOX Get number of rows(InvListBox))
		//LISTBOX SELECT ROW(InvListBox;$hit;Replace listbox selection)
		//OBJECT SET SCROLL POSITION(InvListBox;$hit)
		//
		//Else 
		//LISTBOX SELECT ROW(InvListBox;0;Replace listbox selection)
		//End if 
		
End case 