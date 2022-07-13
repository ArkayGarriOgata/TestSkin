//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: RM_LastUseage
// ----------------------------------------------------

MESSAGES OFF:C175

ALL RECORDS:C47([Raw_Materials:21])
uThermoInit(Records in selection:C76([Raw_Materials:21]); "Setting [RAW_MATERIALS]LastPurDate")

For ($i; 1; Records in selection:C76([Raw_Materials:21]))
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
	If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
		SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]XferDate:3; $aDate)
		SORT ARRAY:C229($aDate; <)
		[Raw_Materials:21]LastPurDate:44:=$aDate{1}
		SAVE RECORD:C53([Raw_Materials:21])
	End if 
	NEXT RECORD:C51([Raw_Materials:21])
	uThermoUpdate($i)
End for 

uThermoClose

ALL RECORDS:C47([Raw_Materials_Groups:22])
uThermoInit(Records in selection:C76([Raw_Materials_Groups:22]); "Setting [RM_GROUP]LastUsage")
For ($i; 1; Records in selection:C76([Raw_Materials_Groups:22]))
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2=[Raw_Materials_Groups:22]Commodity_Key:3)
	If (Records in selection:C76([Raw_Materials:21])>0)
		SELECTION TO ARRAY:C260([Raw_Materials:21]LastPurDate:44; $aDate)
		SORT ARRAY:C229($aDate; <)
		[Raw_Materials_Groups:22]LastUsage:24:=$aDate{1}
		SAVE RECORD:C53([Raw_Materials_Groups:22])
	End if 
	NEXT RECORD:C51([Raw_Materials_Groups:22])
	uThermoUpdate($i)
End for 

uThermoClose