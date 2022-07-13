//%attributes = {"publishedWeb":true}
//PM: eBag_UI() -> 
//@author mlb - 1/29/02  14:53
// Modified by: Mel Bohince (12/9/15) allow mulitple instances

C_TEXT:C284($1)

If (Count parameters:C259=0)
	If (<>pid_eBag=0)
		<>pid_eBag:=New process:C317("eBag_UI"; <>lMidMemPart; "eBag"; "init")
		If (False:C215)
			eBag_UI
		End if 
	Else 
		CONFIRM:C162("Bring open eBag to front or new eBag window?"; "Front"; "New")  // Modified by: Mel Bohince (12/9/15) allow mulitple instances
		If (ok=1)
			SHOW PROCESS:C325(<>pid_eBag)
			BRING TO FRONT:C326(<>pid_eBag)
			POST OUTSIDE CALL:C329(<>pid_eBag)
		Else   // Modified by: Mel Bohince (12/9/15) allow mulitple instances
			<>pid_eBag:=New process:C317("eBag_UI"; <>lMidMemPart; "eBag"; "init")
		End if 
	End if 
	
Else 
	Case of 
		: ($1="init")
			SET MENU BAR:C67(<>defaultmenu)
			CostCtrCurrent("init"; "00/00/00")
			
			C_LONGINT:C283(hlCategoryTypes; hlAssignable)
			hlCategoryTypes:=ToDo_StdTaskList("init")
			
			eBag_MakeTabs("init")
			$bool:=FG_LaunchItem("init")
			sCriterion1:=""
			tWindowTitle:="eBag"  // Added by: Mark Zinke (1/14/13)  //◊jobform:=sCriterion1
			$winRef:=OpenFormWindow(->[zz_control:1]; "eBag_dio"; ->tWindowTitle; tWindowTitle)  // Modified by: Mark Zinke (1/4/13) Was Open Form Window
			
			READ ONLY:C145([JTB_Job_Transfer_Bags:112])
			READ ONLY:C145([ProductionSchedules:110])
			READ ONLY:C145([Jobs:15])
			READ ONLY:C145([Job_Forms:42])
			READ ONLY:C145([Job_Forms_Items:44])
			READ ONLY:C145([Job_Forms_Machines:43])
			READ ONLY:C145([Job_Forms_Materials:55])
			READ ONLY:C145([Job_Forms_Master_Schedule:67])
			READ ONLY:C145([Customers_Projects:9])
			READ ONLY:C145([Process_Specs:18])
			READ ONLY:C145([Raw_Materials:21])
			READ ONLY:C145([Finished_Goods:26])
			READ ONLY:C145([Finished_Goods_Locations:35])
			READ ONLY:C145([Customers:16])
			// Modified by: Mel Bohince (1/17/20)
			READ ONLY:C145([Finished_Goods_Transactions:33])
			READ ONLY:C145([Raw_Materials_Allocations:58])
			READ ONLY:C145([Raw_Materials_Transactions:23])
			READ ONLY:C145([Purchase_Orders_Job_forms:59])
			READ ONLY:C145([Job_Forms_Machine_Tickets:61])  //Toggle this on the edit machine ticket button
			//end mod
			
			FORM SET INPUT:C55([zz_control:1]; "eBag_dio")
			ADD RECORD:C56([zz_control:1]; *)
			FORM SET INPUT:C55([zz_control:1]; "Input")
			CLOSE WINDOW:C154
			eBag_unloadRelated
			
			READ ONLY:C145([JTB_Job_Transfer_Bags:112])
			READ ONLY:C145([Jobs:15])
			READ ONLY:C145([Job_Forms:42])
			READ ONLY:C145([Job_Forms_Items:44])
			READ ONLY:C145([Job_Forms_Machines:43])
			READ ONLY:C145([Job_Forms_Materials:55])
			READ ONLY:C145([Job_Forms_Master_Schedule:67])
			READ ONLY:C145([Customers_Projects:9])
			READ ONLY:C145([Process_Specs:18])
			READ ONLY:C145([Raw_Materials:21])
			
			
			<>pid_eBag:=0
	End case 
	
End if 
//