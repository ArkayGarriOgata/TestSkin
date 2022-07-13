// ----------------------------------------------------
// Form Method: [Customers_ReleaseSchedules].SimpleForecast
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		SetObjectProperties(""; ->t_period1; True:C214; fcst_period1)
		SetObjectProperties(""; ->t_period2; True:C214; fcst_period2)
		SetObjectProperties(""; ->t_period3; True:C214; fcst_period3)
		SetObjectProperties(""; ->t_period4; True:C214; fcst_period4)
		SetObjectProperties(""; ->t_period5; True:C214; fcst_period5)
		SetObjectProperties(""; ->t_period6; True:C214; fcst_period6)
		
	: (Form event code:C388=On Outside Call:K2:11)
		$hit:=Find in array:C230(aCPN; <>rama_cpn)
		If ($hit>-1) & ($hit<=LISTBOX Get number of rows:C915(PickListBox))
			LISTBOX SELECT ROW:C912(PickListBox; $hit; lk replace selection:K53:1)
			OBJECT SET SCROLL POSITION:C906(PickListBox; $hit)
			
		Else 
			LISTBOX SELECT ROW:C912(PickListBox; 0; lk replace selection:K53:1)
		End if 
End case 