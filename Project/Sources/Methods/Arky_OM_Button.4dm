//%attributes = {}
//Method:  Arky_OM_Button(tButtonName)
//Description: This method handles the buttons for the Arky module

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tButtonName)
	
	C_TEXT:C284($tProcess)
	
	$tButtonName:=$1
	
End if   //Done Initialize

Case of   //Button
		
	: ($tButtonName="Arky_nPrcs_OnLoad")
		
		Arky_Prcs_OnLoad
		
	: (Position:C15(Form:C1466.ktProcess; $tButtonName)>0)
		
		$tProcess:=Form:C1466.cPage[FORM Get current page:C276]+CorektPipe+\
			Substring:C12($tButtonName; Position:C15(CorektPipe; $tButtonName)+1)
		
		Arky_Prcs_Process($tProcess)
		
	: (Position:C15(Form:C1466.ktHome; $tButtonName)>0)
		
		Arky_Prcs_Home
		
	: (Position:C15(Form:C1466.ktSales; $tButtonName)>0)
		
		//Arky_Prcs_Sales
		
	: (Position:C15(Form:C1466.ktCustomerService; $tButtonName)>0)
		
		Arky_Prcs_CustomerService
		
	: (Position:C15(Form:C1466.ktProduction; $tButtonName)>0)
		
		//Arky_Prcs_Production
		
	: (Position:C15(Form:C1466.ktWarehouse; $tButtonName)>0)
		
		//Arky_Prcs_Warehouse
		
	: ($tButtonName="Arky_gPrcs_BusinessUnit")
		
		Arky_Prcs_BusinessUnit
		
End case 
