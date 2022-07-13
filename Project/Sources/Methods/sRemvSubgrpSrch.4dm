//%attributes = {"publishedWeb":true}
//(s) sRemvSubGrpSrch
//moved code from 2 buttons
//• 6/10/98 cs created

QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=sCriterion1)

If (Records in selection:C76([Raw_Materials_Groups:22])#1)
	ALERT:C41("There were "+String:C10(Records in selection:C76([Raw_Materials_Groups:22]))+" Commodity keys found matching your search request."+Char:C90(13)+"Please enter a unique Commodity Key.")
	REJECT:C38
Else 
	CREATE SET:C116([Raw_Materials_Groups:22]; "Hold")
	
	If (CU_LocateSubgrp(sCriterion1)#1)  //locate any attached rm_group records - this will locate one-(RM_group record)
		ALERT:C41("There are Materials or other items attached to this Commodity Key."+Char:C90(13)+"You may not delete this Subgroup.")
	Else 
		USE SET:C118("Hold")
		CLEAR SET:C117("Hold")
		DELETE SELECTION:C66([Raw_Materials_Groups:22])
	End if 
End if 