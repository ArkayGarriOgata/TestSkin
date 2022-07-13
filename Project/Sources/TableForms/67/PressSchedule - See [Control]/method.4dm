// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 12/4/01  14:45
// ----------------------------------------------------
// Form Method: [Job_Forms_Master_Schedule].PressSchedule - See [Control]
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Close Box:K2:21)
		HIDE PROCESS:C324(Current process:C322)
		
	: (Form event code:C388=On Outside Call:K2:11)
		If (Length:C16(sCriterion1)=3)  //refresh
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1)
			If (Records in selection:C76([ProductionSchedules:110])>0)
				pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
				ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >; [ProductionSchedules:110]StartDate:4; >)
			Else 
				pressBackLog:=0
			End if 
			zwStatusMsg("SCHED"; sCriterion1+" has been refreshed")
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		//$settings:=JML_PresScheduleSettings ("reset")
		$settings:=PS_Settings("get"; sCriterion1)
		OBJECT SET ENABLED:C1123(*; "canSee@"; False:C215)
		OBJECT SET ENABLED:C1123(*; "canSched@"; False:C215)
		SetObjectProperties("canSee@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties("canSched@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/13/13)
		
		If (User in group:C338(Current user:C182; "RoleOperations"))
			OBJECT SET ENABLED:C1123(*; "canSee@"; True:C214)
			OBJECT SET ENABLED:C1123(*; "canSched@"; True:C214)
			SetObjectProperties("canSee@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties("canSched@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		End if 
		GOTO OBJECT:C206(sCriterion1)
		//: (Form event=On Activate )
		//If (Length(sCriterion1)=3)  `refresh
		//QUERY([PressSchedule];[PressSchedule]Press=sCriterion1)
		//ORDER BY([PressSchedule];[PressSchedule]Priority;>;[PressSchedule]StartDate;>)
		//End if 
End case 