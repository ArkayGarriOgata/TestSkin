//%attributes = {}
// _______
// Method: MRO_ImportSpreadSheet   ( ) ->
// By: Mel Bohince @ 07/01/19, 16:33:33
// Description
// prime the pump with the legacy spreadsheet
// ----------------------------------------------------
// ----------------------------------------------------
// based on: pattern_ReadTextDocument
// ----------------------------------------------------
// new fields in RM table created to support this -- [Raw_Materials]UsedBy , [Raw_Materials]PartType


C_LONGINT:C283($1; $id)
C_DATE:C307($today)
C_TEXT:C284($recordDelimitor)
C_TIME:C306($docRef)
C_REAL:C285($cost)
C_TEXT:C284($rmCode; $desc)
C_BOOLEAN:C305($continue)

If (Count parameters:C259=0)
	CONFIRM:C162("Import text as: RMCode<tab>PartType<tab>Location<tab>Desc<tab>UsedBy<tab>Vendor<cr>?")
	If (OK=1)
		$id:=New process:C317("MRO_ImportSpreadSheet"; <>lMinMemPart; "Data_Import"; 2)
		If (False:C215)
			MRO_ImportSpreadSheet
		End if 
	End if 
	
Else 
	READ WRITE:C146([MaintRepairSupply_Bins:161])
	READ WRITE:C146([Raw_Materials:21])
	READ WRITE:C146([Raw_Materials_Suggest_Vendors:173])
	
	CONFIRM:C162("Delete all records in [MaintRepairSupply_Bins] before importing?"; "No"; "Delete")
	If (ok=0)
		TRUNCATE TABLE:C1051([MaintRepairSupply_Bins:161])
		If (ok=1)
			$continue:=True:C214
			
			//undo some stuff
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Matl_Manager:18="MRO")  //created on a prior pass
			DELETE SELECTION:C66([Raw_Materials:21])
			
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]UsedBy:52#""; *)
			QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]PartType:51#""; *)
			QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]PreferedBin:37#""; *)
			QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Stocked:5=True:C214)
			APPLY TO SELECTION:C70([Raw_Materials:21]; [Raw_Materials:21]UsedBy:52:="")
			APPLY TO SELECTION:C70([Raw_Materials:21]; [Raw_Materials:21]PartType:51:="")
			APPLY TO SELECTION:C70([Raw_Materials:21]; [Raw_Materials:21]PreferedBin:37:="")
			APPLY TO SELECTION:C70([Raw_Materials:21]; [Raw_Materials:21]Stocked:5:=False:C215)
			
			QUERY:C277([Raw_Materials_Suggest_Vendors:173]; [Raw_Materials_Suggest_Vendors:173]VendorID:1="MRO++")
			DELETE SELECTION:C66([Raw_Materials_Suggest_Vendors:173])
		End if 
		
	Else 
		$continue:=True:C214
	End if 
	
	If ($continue)
		//CREATE EMPTY SET([Raw_Materials];"modified")
		//tag [Raw_Materials]Matl_Manager:="MRO" if modified
		//tag [Raw_Materials_Suggest_Vendors]VendorID:="MRO++" if modified
		$recordDelimitor:=Char:C90(13)
		
		$docRef:=Open document:C264("")  //open the document
		If (OK=1)
			RECEIVE PACKET:C104($docRef; $row; $recordDelimitor)  //read the document
			$i:=0
			$row:=Replace string:C233($row; Char:C90(34); "")
			While (Length:C16($row)>10)  //(OK=1) &
				$i:=$i+1
				zwStatusMsg("$row"+String:C10($i); $row)
				
				util_TextParser(6; $row)
				
				$rmCode:=fStripSpace("B"; util_TextParser(1))
				$type:=fStripSpace("B"; util_TextParser(2))
				$bin:=fStripSpace("B"; util_TextParser(3))
				$desc:=fStripSpace("B"; util_TextParser(4))
				$usedBy:=fStripSpace("B"; util_TextParser(5))
				$vendor:=fStripSpace("B"; util_TextParser(6))
				
				util_TextParser
				
				QUERY:C277([MaintRepairSupply_Bins:161]; [MaintRepairSupply_Bins:161]PartNumber:3=$rmCode; *)
				QUERY:C277([MaintRepairSupply_Bins:161];  & ; [MaintRepairSupply_Bins:161]Bin:2=$bin)
				
				If (Records in selection:C76([MaintRepairSupply_Bins:161])=0)
					CREATE RECORD:C68([MaintRepairSupply_Bins:161])
					[MaintRepairSupply_Bins:161]Bin:2:=$bin
					[MaintRepairSupply_Bins:161]PartNumber:3:=$rmCode
					[MaintRepairSupply_Bins:161]Quantity:4:=0
				End if 
				[MaintRepairSupply_Bins:161]Quantity:4:=[MaintRepairSupply_Bins:161]Quantity:4+1  //not sure about spreadsheet
				
				QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$rmCode)
				If (Records in selection:C76([Raw_Materials:21])=0)
					utl_Logfile("Import.log"; "Created "+$rmCode+" in [RM]")
					CREATE RECORD:C68([Raw_Materials:21])
					[Raw_Materials:21]Raw_Matl_Code:1:=$rmCode
					[Raw_Materials:21]Description:4:=$desc
					[Raw_Materials:21]Matl_Manager:18:="MRO"
				End if 
				
				[MaintRepairSupply_Bins:161]Raw_Matl_fk:5:=[Raw_Materials:21]pk_id:55
				
				[Raw_Materials:21]Stocked:5:=True:C214
				
				If (Length:C16([Raw_Materials:21]PreferedBin:37)=0)
					[Raw_Materials:21]PreferedBin:37:=$bin
				End if 
				
				If (Position:C15($usedBy; [Raw_Materials:21]UsedBy:52)=0)
					[Raw_Materials:21]UsedBy:52:=[Raw_Materials:21]UsedBy:52+" "+$usedBy
				End if 
				
				If (Position:C15($type; [Raw_Materials:21]PartType:51)=0)
					[Raw_Materials:21]PartType:51:=[Raw_Materials:21]PartType:51+" "+$type
				End if 
				
				RELATE MANY:C262([Raw_Materials:21]Suggest_Vendors:49)
				QUERY SELECTION:C341([Raw_Materials_Suggest_Vendors:173]; [Raw_Materials_Suggest_Vendors:173]Name:4=$vendor)
				If (Records in selection:C76([Raw_Materials_Suggest_Vendors:173])=0)
					utl_Logfile("Import.log"; "Created "+$vendor+" for [RM] "+$rmCode)
					CREATE RECORD:C68([Raw_Materials_Suggest_Vendors:173])
					[Raw_Materials_Suggest_Vendors:173]Name:4:=$vendor
					[Raw_Materials_Suggest_Vendors:173]Raw_Matl_Code:2:=$rmCode
					[Raw_Materials_Suggest_Vendors:173]VendorID:1:="MRO++"
					SAVE RECORD:C53([Raw_Materials_Suggest_Vendors:173])
				End if 
				
				SAVE RECORD:C53([MaintRepairSupply_Bins:161])
				SAVE RECORD:C53([Raw_Materials:21])
				
				
				RECEIVE PACKET:C104($docRef; $row; $recordDelimitor)
				$row:=Replace string:C233($row; Char:C90(34); "")
			End while 
			
			CLOSE DOCUMENT:C267($docRef)
			
			UNLOAD RECORD:C212([MaintRepairSupply_Bins:161])
			UNLOAD RECORD:C212([Raw_Materials:21])
			UNLOAD RECORD:C212([Raw_Materials_Suggest_Vendors:173])
			
			BEEP:C151
		End if   //open doc
	End if   //continue
End if   //count params