//%attributes = {}
//Method: Core_Document_ExistsB(tPathname;tDocument)=>bExists
//Description:  This method checks if document exists on volume

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPathname)
	C_TEXT:C284($2; $tDocument)
	
	C_BOOLEAN:C305($0; $bExists)
	
	$tPathname:=$1
	$tDocument:=$2
	
	$bExists:=False:C215
	
	ARRAY TEXT:C222($atDocument; 0)
	
End if   //Done initialize

Case of   //Validate
		
	: ($tPathname=CorektBlank)  //No folder
		
	: (Not:C34(Test path name:C476($tPathname)=Is a folder:K24:2))  //Not a valid folder
		
	: ($tDocument=CorektBlank)  //Any document in folder
		
		DOCUMENT LIST:C474($tPathname; $atDocument)
		
		$bExists:=(Size of array:C274($atDocument)>0)
		
	Else   //Specific document in folder
		
		DOCUMENT LIST:C474($tPathname; $atDocument)
		
		$bExists:=(Find in array:C230($atDocument; $tDocument)>0)
		
End case   //Done validate

$0:=$bExists