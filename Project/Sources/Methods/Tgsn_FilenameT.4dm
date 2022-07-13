//%attributes = {}
//Method:  Tgsn_FilenameT=>tTungstenFilename
//Description:  This method will return a filename for Tungsten invoices

If (True:C214)  //Initialize
	
	C_TEXT:C284($0; $tTungstenFilename)
	
	$tTungstenFilename:=CorektBlank
	
End if   //Done Initialize

$tTungstenFilename:=ArkyktName+Core_Date_ddhhmmssT

$0:=$tTungstenFilename