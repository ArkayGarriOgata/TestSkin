//%attributes = {"publishedWeb":true}
//(p) Purge_RMs
//at Request of Angelo-
//if a raw amterial is NOT used by a PO item in AMS Remove it
//OVERRIDE - do not remove any produciton materials
//• 6/5/98 cs created
//100798 mlb close window
//•092999  mlb  UPR correct the prodcution commodity keys

C_TEXT:C284($Path)

READ WRITE:C146([Raw_Materials:21])
ALL RECORDS:C47([Raw_Materials:21])
CREATE SET:C116([Raw_Materials:21]; "AllRms")

ALL RECORDS:C47([Purchase_Orders_Items:12])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Raw_Materials:21]Raw_Matl_Code:1; ->[Purchase_Orders_Items:12]Raw_Matl_Code:15)
	
	
Else 
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Raw_Materials:21])+" file. Please Wait...")
	RELATE ONE SELECTION:C349([Purchase_Orders_Items:12]; [Raw_Materials:21])
	zwStatusMsg(""; "")
	
End if   // END 4D Professional Services : January 2019 query selection
CREATE SET:C116([Raw_Materials:21]; "InUse")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Raw_Materials_Locations:25]Raw_Matl_Code:1; ->[Raw_Materials:21]Raw_Matl_Code:1)  //get bins
	
	
Else 
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Raw_Materials_Locations:25])+" file. Please Wait...")
	RELATE MANY SELECTION:C340([Raw_Materials_Locations:25]Raw_Matl_Code:1)
	zwStatusMsg(""; "")
	
	
End if   // END 4D Professional Services : January 2019 query selection
ARRAY TEXT:C222($aBinsRm; 0)
SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]Raw_Matl_Code:1; $aBinsRM)
uClearSelection(->[Raw_Materials_Locations:25])
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	USE SET:C118("InUse")
	
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2="01@"; *)  //ignore production materials
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="02@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="03@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="04@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="05@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="06@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="07@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="08@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="13@")
	CREATE SET:C116([Raw_Materials:21]; "Production")
	UNION:C120("InUse"; "Production"; "InUse")
	CLEAR SET:C117("Production")
	DIFFERENCE:C122("AllRms"; "InUse"; "AllRms")
	USE SET:C118("AllRms")
	CLEAR SET:C117("AllRms")
	CLEAR SET:C117("InUse")
	
	
Else 
	//you don't need line 46
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "Production")
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2="01@"; *)  //ignore production materials
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="02@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="03@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="04@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="05@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="06@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="07@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="08@"; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="13@")
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	UNION:C120("InUse"; "Production"; "InUse")
	CLEAR SET:C117("Production")
	DIFFERENCE:C122("AllRms"; "InUse"; "AllRms")
	USE SET:C118("AllRms")
	CLEAR SET:C117("AllRms")
	CLEAR SET:C117("InUse")
	
	
End if   // END 4D Professional Services : January 2019 

If (Records in selection:C76([Raw_Materials:21])>0)
	$Path:=<>purgeFolderPath
	
	If ($Path#"")
		SET CHANNEL:C77(10; $Path+"Raw Materials"+String:C10(4D_Current_date; 1))
		
		If (OK=1)
			uThermoInit(Records in selection:C76([Raw_Materials:21]); "Purging "+String:C10(Records in selection:C76([Raw_Materials:21]); "###,##0")+" Raw MAterials, press Esc to stop.")
			
			For ($i; 1; Records in selection:C76([Raw_Materials:21]))
				
				If (Find in array:C230($aBinsRm; [Raw_Materials:21]Raw_Matl_Code:1)<0)  //insure that this material in not currently in inventory
					SEND RECORD:C78([Raw_Materials:21])
					NEXT RECORD:C51([Raw_Materials:21])
					uThermoUpdate($i)
				End if 
			End for 
			uThermoClose  //100798 mlb
			SET CHANNEL:C77(11)
			xTitle:=""
			xText:=String:C10(Records in selection:C76([Raw_Materials:21]))+"Raw Material records purged."
			MESSAGE:C88(Char:C90(13)+"Deleting Archived Raw Materials...")
			DELETE SELECTION:C66([Raw_Materials:21])
			FLUSH CACHE:C297
			rPrintText("RM_Purge"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".LOG")
		End if 
	End if 
End if 