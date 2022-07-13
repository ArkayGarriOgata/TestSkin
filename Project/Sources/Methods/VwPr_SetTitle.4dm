//%attributes = {}
//Method:  VwPr_SetTitle(tViewProArea;cAttribute)
//Description:  This method will set title to ViewProArea

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tViewProArea)
	C_COLLECTION:C1488($2; $cAttribute)
	
	C_LONGINT:C283($nColumn; $nPeriod)
	C_OBJECT:C1216($oStyle)
	C_TEXT:C284($tTitle)
	
	$cAttribute:=New collection:C1472()
	
	$tViewProArea:=$1
	$cAttribute:=$2
	
	$nColumn:=0
	$nPeriod:=0
	$tTitle:=CorektBlank
	
	$oStyle:=New object:C1471()
	$ostyle.font:="10pt Arial Rounded MT Bold"
	$ostyle.hAlign:=vk label alignment top center:K89:55
	
End if   //Done initialize

For each ($tTitle; $cAttribute)  //Title
	
	$nPeriod:=Position:C15(CorektPeriod; $tTitle)
	
	If ($nPeriod>0)  //Inherent
		
		$tTitle:=Substring:C12($tTitle; $nPeriod+1)
		
	End if   //Done inherent
	
	VP SET TEXT VALUE(VP Cell($tViewProArea; $nColumn; 0); $tTitle)
	VP SET CELL STYLE(VP Cell($tViewProArea; $nColumn; 0); $oStyle)
	
	$nColumn:=$nColumn+1  //increment column
	
End for each   //Done title
