//%attributes = {}
//Method:  Help_OM_Variable(tVariableName)
//Description: This method handles Variables in the Help module

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tVariableName)
	
	$tVariableName:=$1
	
End if   //Done initialize

Case of   //Variable
		
	: ($tVariableName="Help_Entr_tFind")
		
		Help_Entr_Find
		
	: ($tVariableName="Help_Entr_tCategory")
		
		Help_Entr_Category
		
	: ($tVariableName="Help_Entr_tTitle")
		
		Help_Entr_Title
		
	: ($tVariableName="Help_Entr_tPathName")
		
		Help_Entr_Manager
		
	: ($tVariableName="Help_Entr_tKeyword")
		
		Help_Entr_Manager
		
	: ($tVariableName="Help_View_tFind")
		
		Help_View_Find
		
End case   //Done variable
