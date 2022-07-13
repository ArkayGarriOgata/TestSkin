//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: AdvancedSchedulerGoToPage - Created `v1.0.0-PJK (12/18/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
//$1=Page

Case of 
	: ($1=1)
		Adv_JobSchedulerArrays("LoadNeedHRD")
		
	: ($1=2)
		Adv_JobSchedulerArrays("LoadAllScheduled")
		
End case 