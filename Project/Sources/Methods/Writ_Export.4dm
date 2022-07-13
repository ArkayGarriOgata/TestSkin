//%attributes = {}
//Method:  Writ_Export(oExport)
//Description:  This method will export (save) a write area
//
// oExport.oWriteArea
// oExport.tFullPathName
// oExport.nFormat
// oExport.nHTML

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oExport)
	
	C_OBJECT:C1216($oWriteArea)
	C_TEXT:C284($tFullPathName)
	C_LONGINT:C283($nFormat)
	C_LONGINT:C283($nHTML)
	
	$oExport:=New object:C1471()
	
	$oExport:=$1
	
	$oWriteArea:=New object:C1471()
	$tFullPathName:=CorektBlank
	$nFormat:=wk 4wp:K81:4
	$nHTML:=wk html wysiwyg:K81:175
	
	If (OB Is defined:C1231($oExport; "oWriteArea"))
		$oWriteArea:=$oExport.oWriteArea
	End if 
	
	If (OB Is defined:C1231($oExport; "tFullPathName"))
		$tFullPathName:=$oExport.tFullPathName
	End if 
	
	If (OB Is defined:C1231($oExport; "nFormat"))
		$nFormat:=$oExport.nFormat
	End if 
	
	If (OB Is defined:C1231($oExport; "nHTML"))
		$nHTML:=$oExport.HTML
	End if 
	
End if   //Done initialize

If ($tFullPathName=CorektBlank)
	
	$tFilename:=Select document:C905(CorektBlank; CorektAsterisk; CorektBlank; File name entry:K24:17)
	
	$tFullPathName:=Document
	
End if 

WP EXPORT DOCUMENT:C1337($oWriteArea; $tFullPathName; $nFormat; $nHTML)

