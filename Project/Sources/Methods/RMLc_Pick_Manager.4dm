//%attributes = {}
//Method:  RMLc_Pick_Manager(tCheckBoxName)
//Description:  This method handles the check box choices

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tCheckBoxName)
	
	$tCheckBoxName:=$1
	
End if   //Done initialize

Form:C1466.nAll:=0

If ($tCheckBoxName="RMLc_Pick_nAll")  //All
	
	Form:C1466.nColdFoil:=0
	Form:C1466.nRollStock:=0
	Form:C1466.nSheeted:=0
	Form:C1466.nPlastic:=0
	
	Form:C1466.nAll:=1
	
End if   //Done all
