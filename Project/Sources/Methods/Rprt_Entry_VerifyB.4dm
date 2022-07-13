//%attributes = {}
//Method:  Rprt_Entry_VerifyB=>bVerified
//Description:  This method will verify if Report information can be saved

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bVerified)
	C_TEXT:C284($tMethod; $tName)
	
	ARRAY LONGINT:C221($anAsciiException; 0)
	
	APPEND TO ARRAY:C911($anAsciiException; 95)  //_ Underscore
	
	$bVerified:=False:C215
	
	$tName:=Form:C1466.tName
	Core_Text_Clean(->$tName; ->$anAsciiException)
	Form:C1466.tName:=$tName
	
	$tMethod:=Form:C1466.tMethod
	Core_Text_Clean(->$tMethod; ->$anAsciiException)
	Form:C1466.tMethod:=$tMethod
	
End if   //Done initialize

Case of   //Verifed
		
	: (Rprt_atEntry_Group{Rprt_atEntry_Group}=CorektBlank)
	: (Rprt_atEntry_Category{Rprt_atEntry_Category}=CorektBlank)
	: (Form:C1466.tName=CorektBlank)
	: (Form:C1466.tMethod=CorektBlank)
		
	Else   //All good
		
		$bVerified:=True:C214
		
End case   //Done verified

$0:=$bVerified