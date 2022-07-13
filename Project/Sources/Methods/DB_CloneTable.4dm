//%attributes = {}
// (PM) DB_CloneTable
// Clones all records from a single table to a MySQL database
// $1 = MySQL connection
// $2 = Table pointer

C_LONGINT:C283($1; $vl_Connection; $vl_TableNr; $vl_FieldNr; $vl_Statement; $vl_Record; $vl_RecordCount; $vl_FieldType; $vl_Result)
C_POINTER:C301($2; $vp_Table; $vp_Field)
C_TEXT:C284($vt_TableName; $vt_FieldName; $vt_SQL)

$vl_Connection:=$1
$vp_Table:=$2
$vl_TableNr:=Table:C252($vp_Table)
$vt_TableName:=Table name:C256($vp_Table)

// Build the insert statement for this table
$vt_SQL:="INSERT INTO `"+$vt_TableName+"` ( "
For ($vl_FieldNr; 1; Get last field number:C255($vp_Table))
	$vt_FieldName:=Field name:C257($vl_TableNr; $vl_FieldNr)
	$vt_SQL:=$vt_SQL+"`"+$vt_FieldName+"`, "
End for 

// Add the values clause
$vt_SQL:=Substring:C12($vt_SQL; 1; Length:C16($vt_SQL)-2)
$vt_SQL:=$vt_SQL+" ) VALUES ( "
$vt_SQL:=$vt_SQL+("?, "*Get last field number:C255($vp_Table))
$vt_SQL:=Substring:C12($vt_SQL; 1; Length:C16($vt_SQL)-2)
$vt_SQL:=$vt_SQL+" )"

//$vl_Statement:=MySQL New SQL Statement ($vl_Connection;$vt_SQL)

ALL RECORDS:C47($vp_Table->)
$vl_RecordCount:=Records in selection:C76($vp_Table->)

// Start a transaction to get a better performance
//$vl_Result:=MySQL Execute ($vl_Connection;"BEGIN")

// Loop through all records
For ($vl_Record; 1; $vl_RecordCount)
	
	// Insert the field values in the SQL statement
	For ($vl_FieldNr; 1; Get last field number:C255($vp_Table))
		
		$vp_Field:=Field:C253($vl_TableNr; $vl_FieldNr)
		GET FIELD PROPERTIES:C258($vp_Field; $vl_FieldType)
		
		//Case of 
		//: ($vl_FieldType=Is alpha field)
		//MySQL Set String In SQL ($vl_Statement;$vl_FieldNr;$vp_Field->)
		//: ($vl_FieldType=Is text)
		//MySQL Set Text In SQL ($vl_Statement;$vl_FieldNr;$vp_Field->)
		//: ($vl_FieldType=Is boolean)
		//MySQL Set Boolean In SQL ($vl_Statement;$vl_FieldNr;Num($vp_Field->))
		//: ($vl_FieldType=Is integer)
		//MySQL Set Integer In SQL ($vl_Statement;$vl_FieldNr;$vp_Field->)
		//: ($vl_FieldType=Is longInt)
		//MySQL Set Longint In SQL ($vl_Statement;$vl_FieldNr;$vp_Field->)
		//: ($vl_FieldType=Is real)
		//MySQL Set Real In SQL ($vl_Statement;$vl_FieldNr;$vp_Field->)
		//: ($vl_FieldType=Is date)
		//MySQL Set Date In SQL ($vl_Statement;$vl_FieldNr;$vp_Field->)
		//: ($vl_FieldType=Is time)
		//MySQL Set Time In SQL ($vl_Statement;$vl_FieldNr;$vp_Field->)
		//: ($vl_FieldType=Is picture)
		//MySQL Set Picture In SQL ($vl_Statement;$vl_FieldNr;$vp_Field->)
		//: ($vl_FieldType=Is BLOB)
		//MySQL Set Blob In SQL ($vl_Statement;$vl_FieldNr;$vp_Field->)
		//: ($vl_FieldType=Is subtable)
		//MySQL Set Text In SQL ($vl_Statement;$vl_FieldNr;"NULL")  // Not supported
		//End case 
		
	End for 
	
	// Insert the recod and move on to the next
	//$vl_Result:=MySQL Execute ($vl_Connection;"";$vl_Statement)
	NEXT RECORD:C51($vp_Table->)
	
	// Commit every 1000 records
	If (($vl_Record%1000)=0)
		//$vl_Result:=MySQL Execute ($vl_Connection;"COMMIT")
		//$vl_Result:=MySQL Execute ($vl_Connection;"BEGIN")
	End if 
	
End for 

// Commit the last transaction
//$vl_Result:=MySQL Execute ($vl_Connection;"COMMIT")

//MySQL Delete SQL Statement ($vl_Statement)