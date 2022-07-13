//%attributes = {}
//Method:  UsSp_Entry_Category
//Description:  This method handles Category

If (Form event code:C388=On Load:K2:1)
	
	Compiler_UsSp_Array(Current method name:C684; 0)
	
	APPEND TO ARRAY:C911(UsSp_atEntry_Category; "Issue")
	APPEND TO ARRAY:C911(UsSp_atEntry_Category; "Question")
	APPEND TO ARRAY:C911(UsSp_atEntry_Category; "Request")
	
	UsSp_atEntry_Category:=1
	
	UsSp_atEntry_Category{0}:=UsSp_atEntry_Category{1}
	
End if 
