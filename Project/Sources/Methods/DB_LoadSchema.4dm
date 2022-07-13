//%attributes = {}
// (PM) DB_LoadSchema
// $1 = Table name

C_TEXT:C284($1; $vt_TableName)
C_LONGINT:C283($vl_Rowset)

$vt_TableName:=$1

ARRAY TEXT:C222(at_FieldNames; 0)
ARRAY TEXT:C222(at_FieldTypes; 0)
ARRAY TEXT:C222(at_NullsAllowed; 0)
ARRAY TEXT:C222(at_Keys; 0)
ARRAY TEXT:C222(at_DefaultValues; 0)
ARRAY TEXT:C222(at_Extras; 0)

If ((conn_id#0) & ($vt_TableName#""))
	// Get the table schema
	//$vl_Rowset:=MySQL Select (conn_id;"DESCRIBE "+$vt_TableName)
	
	//MySQL Column To Array ($vl_Rowset;"Field";0;at_FieldNames)
	//MySQL Column To Array ($vl_Rowset;"Type";0;at_FieldTypes)
	//MySQL Column To Array ($vl_Rowset;"Null";0;at_NullsAllowed)
	//MySQL Column To Array ($vl_Rowset;"Key";0;at_Keys)
	//MySQL Column To Array ($vl_Rowset;"Default";0;at_DefaultValues)
	//MySQL Column To Array ($vl_Rowset;"Extra";0;at_Extras)
	
	//MySQL Delete Row Set ($vl_Rowset)
	
End if 