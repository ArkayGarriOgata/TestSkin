//%attributes = {}
//Method:  UsSp_Entry_Manager
//Description:  This method handles enabling and disabling of objects

OBJECT SET ENABLED:C1123(UsSp_nEntry_Send; False:C215)  //Assume send should be disabled

Case of   //Values filled in
		
	: (UsSp_tEntry_Issue=CorektBlank)
	: (UsSp_tEntry_Email=CorektBlank)
	: (Length:C16(UsSp_tEntry_Issue)<5)
	: (Not:C34(email_validate_address(UsSp_tEntry_Email)))
	Else   //Values filled in
		
		OBJECT SET ENABLED:C1123(UsSp_nEntry_Send; True:C214)
		
End case   //Done values filled in
