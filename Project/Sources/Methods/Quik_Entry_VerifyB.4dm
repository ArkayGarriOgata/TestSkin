//%attributes = {}
//Method:  Quik_Entry_VerifyB=>bVerified
//Description:  This method will verify if Quick Report information can be saved

If (True:C214)  //Initialize
	
	$bVerified:=False:C215
	
End if   //Done initialize

Case of   //Verifed
		
	: (Quik_atEntry_Group{Quik_atEntry_Group}=CorektBlank)
	: (Quik_atEntry_Category{Quik_atEntry_Category}=CorektBlank)
	: (Quik_tEntry_Name=CorektBlank)
	: (Quik_nEntry_ParentTable=0)
	: (BLOB size:C605(Quik_lEntry_Query)=0)
	: (BLOB size:C605(Quik_lEntry_QuickReport)=0)
	Else   //All good
		
		$bVerified:=True:C214
		
End case   //Done verified

$0:=$bVerified