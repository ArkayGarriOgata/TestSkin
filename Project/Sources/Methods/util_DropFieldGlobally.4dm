//%attributes = {}
// _______
// Method: util_DropFieldGlobally   ( ) ->
// By: Mel Bohince @ 03/11/21, 16:07:58
// Description
// based on _ver_v14Prep_Add_PKs
// ----------------------------------------------------
//remove fields named z_SYNC_DATA and z_SYNC_ID everywhere

C_TEXT:C284($statement_t; $tableName_t; $fieldName_t)
C_LONGINT:C283($curTable_l; $numTables_l; $vlField)
C_BOOLEAN:C305($has_z_SYNC_DATA; $has_z_SYNC_ID)

utl_Logfile("bench_mark.log"; "Start Field Removal")

$numTables_l:=Get last table number:C254

uThermoInit($numTables_l; "Processing Array")
For ($curTable_l; 1; $numTables_l)
	uThermoUpdate($curTable_l; 1)
	
	If (Is table number valid:C999($curTable_l))
		$tableName_t:=Table name:C256($curTable_l)
		
		//look to see if fields to drop exist
		$has_z_SYNC_ID:=False:C215
		$has_z_SYNC_DATA:=False:C215
		$has__SYNC_ID:=False:C215
		$has__SYNC_DATA:=False:C215
		
		For ($vlField; Get last field number:C255($curTable_l); 1; -1)
			
			$fieldName_t:=Field name:C257($curTable_l; $vlField)
			
			//test for field 1
			If (Is field number valid:C1000($curTable_l; $vlField))
				If ($fieldName_t="z_SYNC_DATA")
					$has_z_SYNC_DATA:=True:C214
				End if 
			End if 
			
			//test for field 2
			If (Is field number valid:C1000($curTable_l; $vlField))
				If ($fieldName_t="z_SYNC_ID")
					$has_z_SYNC_ID:=True:C214
				End if 
			End if 
			
			If (Is field number valid:C1000($curTable_l; $vlField))
				If ($fieldName_t="_SYNC_DATA")
					$has__SYNC_DATA:=True:C214
				End if 
			End if 
			
			//test for field 2
			If (Is field number valid:C1000($curTable_l; $vlField))
				If ($fieldName_t="_SYNC_ID")
					$has__SYNC_ID:=True:C214
				End if 
			End if 
			
			
		End for   //each field
		
		$statement_t:=""
		If ($has_z_SYNC_ID)
			$tableName_t:=Table name:C256($curTable_l)
			$statement_t:=$statement_t+"ALTER TABLE ["+$tableName_t+"] "
			$statement_t:=$statement_t+"DROP z_SYNC_ID;"
			
			Begin SQL
				EXECUTE IMMEDIATE :$statement_t;
			End SQL
			
			utl_Logfile("bench_mark.log"; "   z_SYNC_ID removed from "+$tableName_t)
		End if   //has field
		
		$statement_t:=""
		If ($has_z_SYNC_DATA)
			$tableName_t:=Table name:C256($curTable_l)
			$statement_t:=$statement_t+"ALTER TABLE ["+$tableName_t+"] "
			$statement_t:=$statement_t+"DROP z_SYNC_DATA;"
			
			Begin SQL
				EXECUTE IMMEDIATE :$statement_t;
			End SQL
			
			utl_Logfile("bench_mark.log"; "   z_SYNC_DATA removed from "+$tableName_t)
		End if   //has field
		
		$statement_t:=""
		If ($has__SYNC_ID)
			$tableName_t:=Table name:C256($curTable_l)
			$statement_t:=$statement_t+"ALTER TABLE ["+$tableName_t+"] "
			$statement_t:=$statement_t+"DROP _SYNC_ID;"
			
			Begin SQL
				EXECUTE IMMEDIATE :$statement_t;
			End SQL
			
			utl_Logfile("bench_mark.log"; "   _SYNC_ID removed from "+$tableName_t)
		End if   //has field
		
		$statement_t:=""
		If ($has__SYNC_DATA)
			$tableName_t:=Table name:C256($curTable_l)
			$statement_t:=$statement_t+"ALTER TABLE ["+$tableName_t+"] "
			$statement_t:=$statement_t+"DROP _SYNC_DATA;"
			
			Begin SQL
				EXECUTE IMMEDIATE :$statement_t;
			End SQL
			
			utl_Logfile("bench_mark.log"; "   _SYNC_DATA removed from "+$tableName_t)
		End if   //has field
		
	End if 
	
End for   //each table

uThermoClose
utl_Logfile("bench_mark.log"; "End")

