//%attributes = {}
//Method:  VwPr_Title({oParameter})
//Description:  This method will set the title row style

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oParameter)
	
	C_OBJECT:C1216($oFont)
	C_OBJECT:C1216($oStyle)
	C_TEXT:C284($tFontInfo)
	
	If (Count parameters:C259>=1)
		$oParameter:=$1
	End if 
	
	$tViewProArea:="ViewProArea"
	
	If (OB Is defined:C1231($oParameter; "nLastColumn"))
		$nLastColumn:=$oParameter.nLastColumn
	End if 
	
	$nLastColumn:=10  //V19 use VP Get column count($tViewProArea)
	
	If (OB Is defined:C1231($oParameter; "nLastColumn"))
		$nLastColumn:=$oParameter.nLastColumn
	End if 
	
	$oFont:=New object:C1471()
	$oFont.family:="Courier New"
	$oFont.size:="12px"
	$oFont.weight:=vk font weight lighter:K89:66
	
	$tFontInfo:=VP Object to font($oFont)
	
	$oStyle:=New object:C1471("oFont"; $tFontInfo)
	$oStyle.backColor:="lightblue"
	$oStyle.foreColor:="black"
	
	VP ADD STYLESHEET($tViewProArea; "Title"; $oStyle)
	
End if 

VP SET CELL STYLE(VP Cells($tViewProArea; 0; 0; $nLastColumn; 1); $oStyle)


