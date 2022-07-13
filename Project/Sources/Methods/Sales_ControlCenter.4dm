//%attributes = {}
// _______
// Method: Sales_ControlCenter   ( ) ->
// By: Mel Bohince @ 12/10/19, 13:09:37
// Description
// open the Sales Rep's control center to set commissions
// values used in fSalesCommisionFlatRate which replaces fSalesCommission for everyone but GreggGoldman
// ----------------------------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=0)
	<>pid_sales:=Process number:C372("Sales_ControlCenter")
	If (<>pid_sales=0)  //singleton
		<>pid_sales:=New process:C317("Sales_ControlCenter"; <>lMidMemPart; "Sales_ControlCenter"; "init")
		If (False:C215)
			Sales_ControlCenter
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_sales)
		BRING TO FRONT:C326(<>pid_sales)
	End if 
	
Else 
	Case of 
		: ($1="init")
			zSetUsageLog(->[Salesmen:32]; "1"; Current method name:C684; 0)
			SET MENU BAR:C67(<>defaultMenu)
			
			C_OBJECT:C1216($form_o)
			$form_o:=New object:C1471
			$form_o.reps:=New object:C1471
			$form_o.customers:=New object:C1471
			
			$winRef:=OpenFormWindow(->[Salesmen:32]; "ControlCenter")
			DIALOG:C40([Salesmen:32]; "ControlCenter"; $form_o)
			CLOSE WINDOW:C154($winRef)
			<>pid_sales:=0
	End case 
End if 


