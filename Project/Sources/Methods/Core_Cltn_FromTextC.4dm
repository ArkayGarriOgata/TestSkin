//%attributes = {}
//Method:  Core_Cltn_FromTextC(oValue)=>cValue
//Description:  This method will take text and place it into a collection

If (True:C214)  //Iniitialize
	
	C_OBJECT:C1216($1; $oValue)
	C_COLLECTION:C1488($0; $cValue)
	
	$oValue:=New object:C1471()
	$oValue:=$1
	
	$cValue:=New collection:C1472()
	
End if   //Done initialize

$cRow:=Split string:C1554($tWords; $tTerminator; sk trim spaces:K86:2)

If ($tSeperator#CorektBlank)  //Seperator
	
	For each ($tRow; $cRow)  //Row
		
		$cColumn:=Split string:C1554($tRow; $tSeperator; sk trim spaces:K86:2)
		
		For each ($tColumn; $cColumn)  //Column
			
			$pcColumnNum:=Get pointer:C304("$cColumn"+String:C10($nColumn; "00"))
			
		End for each   //Done column
		
	End for each   //Done row
	
Else   //No seperator
	
	$cValue:=$cRow.copy()
	
End if   //Done seperator

$oValue.cValue[$nRow]:=$tRowValue