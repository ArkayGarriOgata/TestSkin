//%attributes = {}
//CAR_Set_CARType_FieldValue
//By: DJC
//Date: 5/12/05
//Purpose: This method located under each radio button on the
//[CorrectiveAction]Input form sets the field [CorrectiveAction]CARType
//with the appropriate value.

Case of 
	: (rb1_CARType=1)
		[QA_Corrective_Actions:105]CAR_Type:32:="Customer Reply Required"
		
	: (rb2_CARType=1)
		[QA_Corrective_Actions:105]CAR_Type:32:="Internal"
		
	: (rb3_CARType=1)
		[QA_Corrective_Actions:105]CAR_Type:32:="Customer Informational ONLY"
		
End case 