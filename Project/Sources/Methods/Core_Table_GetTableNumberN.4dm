//%attributes = {}
//Method:  Core_Table_GetTableNumberN(tTableName)=>nTableNumber
//Description:  This method will return the table number given a table name

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tTableName)
	C_LONGINT:C283($0; $nTableNumber)
	
	$tTableName:=$1
	$nTableNumber:=0
	
	$nNumberOfTables:=Get last table number:C254
	
End if   //Done initialize

For ($nTable; 1; $nNumberOfTables)  //Table
	
	Case of   //Valid table
			
		: (Not:C34(Is table number valid:C999($nTable)))  //Invalid Table number
		: ($tTableName#Table name:C256($nTable))  //Not the table
			
		Else   //Found table
			
			$nTableNumber:=$nTable
			
			$nTable:=$nNumberOfTables+1
			
	End case   //Done valid table
	
End for   //Done table

$0:=$nTableNumber