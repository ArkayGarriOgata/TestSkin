//%attributes = {"publishedWeb":true}
//gRMGrpDel: Deletion for file [RM_GROUP]

QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2=[Raw_Materials_Groups:22]Commodity_Key:3)
If (Records in selection:C76([Raw_Materials:21])>0)
	CREATE SET:C116([Raw_Materials:21]; "◊LastSelection"+String:C10(Table:C252(->[Raw_Materials:21])))
	zwStatusMsg("RM GROUP"; "Modify RawMaterials using Last Selection to see effected records")
	CONFIRM:C162("RM Group is listed in Raw Material record.  Delete anyway?"; "Delete"; "Cancel")
	If (ok=1)
		gDeleteRecord(->[Raw_Materials_Groups:22])
	End if 
Else 
	gDeleteRecord(->[Raw_Materials_Groups:22])
End if 