//%attributes = {}
//Method:  Arky_Prcs_LoadTable(tProcess)
//Description:  This will load the table information specified by Process
//   ARRAY TEXT(Arky_atPrcs_TableField;$nRows)
//   ARRAY TEXT(Arky_atPrcs_TableName;$nRows)
//   ARRAY TEXT(Arky_atPrcs_FieldName;$nRows)

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tProcess)
	
	C_LONGINT:C283($nField; $nNumberOfFields)
	C_LONGINT:C283($nTable; $nNumberOfTables)
	C_LONGINT:C283($nTableNumber)
	
	ARRAY LONGINT:C221($anTable; 0)
	
	$tProcess:=$1
	
	Compiler_Arky_Array(Current method name:C684; 0)
	
	Case of 
			
		: ($tProcess=Form:C1466.ktHome)
			
			APPEND TO ARRAY:C911($anTable; Table:C252(->[Addresses:30]))
			APPEND TO ARRAY:C911($anTable; Table:C252(->[Customers:16]))
			
		: ($tProcess=Form:C1466.ktSales)
			
			APPEND TO ARRAY:C911($anTable; Table:C252(->[Customers:16]))
			APPEND TO ARRAY:C911($anTable; Table:C252(->[Customers_Orders:40]))
			APPEND TO ARRAY:C911($anTable; Table:C252(->[Customers_Order_Lines:41]))
			
		: ($tProcess=Form:C1466.ktCustomerService)
			
			APPEND TO ARRAY:C911($anTable; Table:C252(->[Customers:16]))
			APPEND TO ARRAY:C911($anTable; Table:C252(->[Customers_Orders:40]))
			APPEND TO ARRAY:C911($anTable; Table:C252(->[Customers_Order_Lines:41]))
			
	End case 
	
	$nNumberOfTables:=Size of array:C274($anTable)
	
End if   //Done initialize

For ($nTable; 1; $nNumberOfTables)  //Tables
	
	$nTableNumber:=$anTable{$nTable}
	
	If (Is table number valid:C999($nTableNumber))  //Valid table
		
		$nNumberOfFields:=Get last field number:C255($nTableNumber)
		
		For ($nField; 1; $nNumberOfFields)  //Fields
			
			If (Is field number valid:C1000($nTable; $nField))  //Valid field
				
				APPEND TO ARRAY:C911(Arky_atPrcs_TableField; String:C10($nTable)+CorektPipe+String:C10($nField))
				APPEND TO ARRAY:C911(Arky_atPrcs_TableName; Table name:C256($nTableNumber))
				APPEND TO ARRAY:C911(Arky_atPrcs_FieldName; Field name:C257($nTableNumber; $nField))
				
			End if   //Done valid field
			
		End for   //Done fields
		
	End if   //Done valid table
	
End for   //Done tables

MULTI SORT ARRAY:C718(Arky_atPrcs_TableName; >; Arky_atPrcs_FieldName; >; Arky_atPrcs_TableField)
