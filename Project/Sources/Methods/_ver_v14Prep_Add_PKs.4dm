//%attributes = {}
// Method: _ver_v14Prep_Add_PKs ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 06/12/14, 13:53:44
// ----------------------------------------------------
// Description
// 
//fails if table already has pk defined
// ----------------------------------------------------

//based on Josh Flechers webinar; http://kb.4d.com/assetid=76991

//custom prep work

//manually set UUID fields to pk_id in WindowSet@ tables #185 & 186, then skip in loop
//clear records in [Raw_Material_Commodities] and drop the two _sync fields to sidestep duplicate key error on table 54

READ WRITE:C146([Raw_Material_Commodities:54])
ALL RECORDS:C47([Raw_Material_Commodities:54])
SELECTION TO ARRAY:C260([Raw_Material_Commodities:54]CommodityID:1; $comID; [Raw_Material_Commodities:54]CommodityName:2; $comName)
DELETE SELECTION:C66([Raw_Material_Commodities:54])
ARRAY TO SELECTION:C261($comID; [Raw_Material_Commodities:54]CommodityID:1; $comName; [Raw_Material_Commodities:54]CommodityName:2)


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
			$statement_t:=$statement_t+"ALTER TABLE ["+$tableName_t+"] "
			$statement_t:=$statement_t+"ADD pk_id UUID AUTO_GENERATE PRIMARY KEY;"
			
			Begin SQL
				EXECUTE IMMEDIATE :$statement_t;
			End SQL
			
		End if 
		
	End if 
	
	
End for 
uThermoClose
utl_Logfile("bench_mark.log"; "End")

