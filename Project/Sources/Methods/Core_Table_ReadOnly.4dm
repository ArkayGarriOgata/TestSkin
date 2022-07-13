//%attributes = {}
//Method:  Core_Table_ReadOnly (peTable{;bClearSelection})
// By: Garri Ogata @ 10/28/20, 13:57:42
//Description:  This method sets table or tables to read only
//  peTable can be either: 
//.       ->[Table]
//.       ->nTableNumber
//.       ->[Table]KeyField adds related table to put in read only also
//.       ->apTable
//.       ->anTableNumber

//.  The method will load $apTable by coercing which ever was passed in
//.  into the array pointer to a table.
//.  It then loops thru the tables and clears the selection and sets to read only
// ----------------------------------------------------
// Modified by: Garri Ogata (11/10/20) Changed table and field comparisons to >0 and <1

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $peTable)
	C_BOOLEAN:C305($2; $bClearSelection)
	
	C_TEXT:C284($tName)
	
	C_LONGINT:C283($nTable; $nField)
	C_LONGINT:C283($nTableType)
	C_LONGINT:C283($nTable; $nNumberOfTables)
	
	C_LONGINT:C283($nOneTable; $nOneField; $nChoiceField)
	C_BOOLEAN:C305($bAutoOne; $bAutoMany)
	
	C_POINTER:C301($pTable)
	
	ARRAY POINTER:C280($apTable; 0)
	
	$peTable:=$1
	$bClearSelection:=False:C215
	
	If (Count parameters:C259>=2)  //Parameters
		$bClearSelection:=$2
	End if   //Done parameters
	
	$nTableType:=0
	
	RESOLVE POINTER:C394($peTable; $tName; $nTable; $nField)
	
	If ($nTable<1)  //Not a table
		
		$nTableType:=Type:C295($peTable->)
		
	End if   //Done not a table
	
End if   //Done Initialize

Case of   //Load $apTable
		
	: ($nField>0)
		
		GET RELATION PROPERTIES:C686($peTable; $nOneTable; $nOneField; $nChoiceField; $bAutoOne; $bAutoMany)
		
		APPEND TO ARRAY:C911($apTable; Table:C252($nTable))
		APPEND TO ARRAY:C911($apTable; Table:C252($nOneTable))
		
	: ($nTable>0)
		
		APPEND TO ARRAY:C911($apTable; $peTable)
		
	: ($nTableType=Is longint:K8:6)
		
		APPEND TO ARRAY:C911($apTable; Table:C252($nTable))
		
	: ($nTableType=LongInt array:K8:19)
		
		$nNumberOfTables:=Size of array:C274($peTable->)
		
		For ($nTable; 1; $nNumberOfTables)  //Tables
			
			APPEND TO ARRAY:C911($apTable; Table:C252($peTable->{$nTable}))
			
		End for   //Done tables
		
	: ($nTableType=Pointer array:K8:23)
		
		COPY ARRAY:C226($peTable; $apTable)
		
End case   //Done loading $apTable

$nNumberOfTables:=Size of array:C274($apTable)

For ($nTable; 1; $nNumberOfTables)  //Tables
	
	$pTable:=$apTable{$nTable}
	
	If ($bClearSelection)  //Clear selection
		
		REDUCE SELECTION:C351($pTable->; 0)
		
	End if   //Done clear selection
	
	UNLOAD RECORD:C212($pTable->)
	
	READ ONLY:C145($pTable->)
	
	LOAD RECORD:C52($pTable->)
	
End for   //Done tables
