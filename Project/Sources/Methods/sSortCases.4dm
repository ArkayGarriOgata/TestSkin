//%attributes = {"publishedWeb":true}
C_LONGINT:C283($1)  //sSortCases
RELATE MANY:C262([Estimates:17]EstimateNo:1)
Case of 
	: ($1=1)
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]Item:1; >)
		SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]diffNum:11; $aCase)
		SORT ARRAY:C229($aCase; <)
		// [ESTIMATE]Last_Scenario:=$aCase{1}
	: ($1=2)
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]ProductCode:5; >; [Estimates_Carton_Specs:19]diffNum:11; >)
		SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]diffNum:11; $aCase)
		SORT ARRAY:C229($aCase; <)
		//[ESTIMATE]Last_Scenario:=$aCase{1}
	Else 
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]Item:1; >)
End case 
//