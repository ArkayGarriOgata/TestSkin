//%attributes = {}
//CAR_Set_CARType_RadioButton
//By: DJC
//Date: 5/12/05
//Purpose: This method located in the [CorrectiveAction]Input form
//method will set the radio buttons for CARType during the On Load event.

Case of 
	: ([QA_Corrective_Actions:105]CAR_Type:32="Customer Reply Required")
		rb1_CARType:=1
		
	: ([QA_Corrective_Actions:105]CAR_Type:32="Internal")
		rb2_CARType:=1
		
	: ([QA_Corrective_Actions:105]CAR_Type:32="Customer Informational ONLY")
		rb3_CARType:=1
		
End case 