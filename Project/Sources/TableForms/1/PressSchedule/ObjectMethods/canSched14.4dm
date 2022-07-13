If (False:C215)  // Modified by: Mel Bohince (1/14/16) Frank didn't like double clicking each day
	
	C_TEXT:C284($ttProcName)
	C_LONGINT:C283($xlPID)
	$ttProcName:="Shop Calendar"+sCriterion1
	$xlPID:=New process:C317("ShopCalendar_Proc"; <>lMinMemPart; $ttProcName; sCriterion1; *)
	
	//v1.0.0-PJK (12/22/15) new screen
	
Else   // Modified by: Mel Bohince (1/14/16) original code with ugly, yet effiencient input form
	QUERY:C277([ProductionSchedules_Shop_Cal:116]; [ProductionSchedules_Shop_Cal:116]Dept:3=sCriterion1)
	If (Records in selection:C76([ProductionSchedules_Shop_Cal:116])=0)
		SF_ShopCalendar("init"; sCriterion1)
		QUERY:C277([ProductionSchedules_Shop_Cal:116]; [ProductionSchedules_Shop_Cal:116]Dept:3=sCriterion1)
	End if 
	
	CREATE SET:C116([ProductionSchedules_Shop_Cal:116]; "◊PassThroughSet")
	<>PassThrough:=True:C214
	ViewSetter(2; ->[ProductionSchedules_Shop_Cal:116])
End if 


