//%attributes = {}
//Method:  Core_HList_Load(nHListNumber;papParameter;nFormat{;bLetter})
//Description:  This method will load a HList.

//Parameter should be used like this in the parameter array
//   CoreknHListTable:=1
//   CoreknHListPrimaryKey:=2
//   CoreknHListFolder:=3
//   CoreknHListTitle:=4
//   CoreknHListRelate:=5
//   CoreknHListTitleConcat1:=6
//   CoreknHListTitleConcat2:=7
//   CoreknHListTitleConcat3:=8  If this is used the folder information is from the one table
//       and the title information is from the many table

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $3; $nHListNumber; $nFormat)
	C_POINTER:C301($2; $papParameter)
	C_BOOLEAN:C305($4; $bLetter)
	
	C_TEXT:C284($tHListNumber)
	C_POINTER:C301($pHListLocation; $pHListListTitle)
	C_POINTER:C301($pTable; $pOrderField)
	C_LONGINT:C283($nNumberOfParameters)
	
	$nHListNumber:=$1
	$papParameter:=$2
	
	$nFormat:=CoreknFormatNoSpace
	$bLetter:=False:C215
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>2)
		$nFormat:=$3
	End if 
	
	If ($nNumberOfParameters>3)
		$bLetter:=$4
	End if 
	
	$pTable:=$papParameter->{CoreknHListInitTable}
	$pOrderField:=$papParameter->{CoreknHListInitFolder}
	
End if   //Done Initialize

ORDER BY:C49($pTable->; $pOrderField->; >)

Core_HList_Initialize($nHListNumber; $papParameter; $nFormat; $bLetter)

Core_HList_Create($nHListNumber)