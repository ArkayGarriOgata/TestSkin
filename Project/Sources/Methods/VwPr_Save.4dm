//%attributes = {}
//Method:  VwPr_Save(oParameter)
//Description:  This method will save a viewpro area to disk in xlsx format

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oParameter)
	
	C_OBJECT:C1216($oExport)
	C_TEXT:C284($tPathName)
	
	If (Count parameters:C259>=1)
		$oParameter:=$1
	End if 
	
	$tViewProArea:="ViewProArea"
	$tExtension:=vk MS Excel format:K89:2
	
	If (OB Is defined:C1231($oParameter; "tViewProArea"))
		$tViewProArea:=$oParameter.tViewProArea
	End if 
	
	If (OB Is defined:C1231($oParameter; "tExtension"))
		$tExtension:=$oParameter.tExtension
	End if 
	
	$oExport:=New object:C1471()
	$tPathName:=CorektBlank
	
	$oExport.format:=$tExtension
	
End if   //Done initialize

$tPathName:=Select document:C905(CorektBlank; CorektBlank; "Save the document as..."; File name entry:K24:17)

If (OK=1)
	
	VP EXPORT DOCUMENT($tViewProArea; Document; $oExport)
	
End if 
