//(s) Raw_Matl_Code [material_psepc]OperSeqIncl

//• 5/22/97 cs created

//see also [material_psepc]incl, [material_est]caseformincl,


If (Not:C34(Read only state:C362([Raw_Materials:21])))
	READ ONLY:C145([Raw_Materials:21])  //avoid locking RM recorrd.
	
End if 
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Process_Specs_Materials:56]Raw_Matl_Code:13)  //locate raw material entered

Case of 
	: (False:C215)  //(Records in selection([RAW_MATERIALS])=0) & ([Material_PSpec]Commodity_Key="02@")  `allow (for INKs ONLY) ability to insert ink formula w/o Raw mat
		
		CONFIRM:C162("The Raw Material Code you have entered does not exist in AMS."+Char:C90(13)+"Is the Ink Formula you entered ("+[Process_Specs_Materials:56]Raw_Matl_Code:13+") correct?")
		If (OK=0)  //user confirmed entry of incorrect ink formula
			
			[Process_Specs_Materials:56]Raw_Matl_Code:13:=""
		End if 
	: (Records in selection:C76([Raw_Materials:21])=0)  //if not found, stop entry
		
		ALERT:C41("The Raw Material Code Entered in NOT valid."+Char:C90(13)+"Please Enter a valid RM Code."+Char:C90(13)+"Click the 'Pick' button for a list of valid Rm Codes.")
		Self:C308->:=""
End case 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Raw_Materials:21])
	
	
Else 
	
	// Read only mode see line 9
	
End if   // END 4D Professional Services : January 2019 
//