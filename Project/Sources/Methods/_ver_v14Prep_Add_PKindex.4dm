//%attributes = {}

// Method: _ver_v14Prep_Add_PKindex ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 07/17/14, 12:54:42
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

C_TEXT:C284($statement_t; $tableName_t)
C_LONGINT:C283($curTable_l; $numTables_l)

$numTables_l:=Get last table number:C254
utl_Logfile("bench_mark.log"; "Start")
uThermoInit($numTables_l; "Processing Array")
For ($curTable_l; 1; $numTables_l)
	uThermoUpdate($curTable_l; 1)
	$statement_t:=""
	utl_Trace
	
	If (Is table number valid:C999($curTable_l))
		If ($curTable_l#185) & ($curTable_l#186)  //& ($curTable_l#54)
			$tableName_t:=Table name:C256($curTable_l)
			$statement_t:=$statement_t+"CREATE INDEX pk_index_"+String:C10($curTable_l; "000")+" ON "+$tableName_t+" (pk_id);"
			
			Begin SQL
				EXECUTE IMMEDIATE :$statement_t;
			End SQL
			
		End if 
		
	End if 
	
	
End for 
uThermoClose
utl_Logfile("bench_mark.log"; "End")
