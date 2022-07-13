// ----------------------------------------------------
// User name (OS): MLB
// Date: 2/28/95
// ----------------------------------------------------
// Form Method: [Job_Forms].Input
// ----------------------------------------------------
// Modified by: Mel Bohince (12/7/16) losing materials after drilling down, tidy up use of named selections
// Modified by: Mel Bohince (4/28/21) clear jml's plnrelease date if on hold now

Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222(aTabVisited; 0)  // Modified by: Mel Bohince (12/7/16) track which named selections exist
		//Est_PandGCheckProbs  // Modified by: Mark Zinke (2/4/14) 
		Cust_getBrandLines([Job_Forms:42]cust_id:82; ->aBrand)  // Added by: Mark Zinke (5/30/13)
		If ([Job_Forms:42]CustomerLine:62="")
			[Job_Forms:42]CustomerLine:62:=[Jobs:15]Line:3
		End if 
		util_ComboBoxSetup(->aBrand; [Job_Forms:42]CustomerLine:62)  // Added by: Mark Zinke (5/30/13)
		MESSAGES OFF:C175
		wWindowTitle("Push"; "Jobform {budget} "+[Job_Forms:42]JobFormID:5)
		C_LONGINT:C283(vAskMePID)
		READ ONLY:C145([Job_Forms_Machine_Tickets:61])
		READ ONLY:C145([Raw_Materials_Transactions:23])
		READ ONLY:C145([Raw_Materials_Allocations:58])
		READ ONLY:C145([Process_Specs:18])
		READ ONLY:C145([Customers_Projects:9])
		READ ONLY:C145([ProductionSchedules:110])
		If ([Job_Forms:42]FixedSalesValue:92>0)  // Modified by: MelvinBohince (3/22/22) 
			OBJECT SET VISIBLE:C603(*; "FixedPriceField"; True:C214)
		Else 
			OBJECT SET VISIBLE:C603(*; "FixedPriceField"; False:C215)
		End if 
		
		If (Read only state:C362([Job_Forms:42]))
			READ ONLY:C145([Job_Forms_Items:44])
			READ ONLY:C145([Job_Forms_Machines:43])
			READ ONLY:C145([Job_Forms_Materials:55])
			READ ONLY:C145([Job_Forms_Master_Schedule:67])
			// Modified by: Mel Bohince (1/16/20) the 5 lines below
			READ ONLY:C145([Customers:16])
			READ ONLY:C145([Finished_Goods_Transactions:33])
			READ ONLY:C145([Job_Forms_Loads:162])
			READ ONLY:C145([Purchase_Orders_Job_forms:59])
			READ ONLY:C145([Finished_Goods:26])
			
		Else 
			READ WRITE:C146([Job_Forms_Items:44])
			READ WRITE:C146([Job_Forms_Machines:43])
			READ WRITE:C146([Job_Forms_Materials:55])
			READ WRITE:C146([Job_Forms_Master_Schedule:67])
			ARRAY TEXT:C222(<>atSeq; 0)
			ARRAY TEXT:C222(<>atCC; 0)
			ARRAY TEXT:C222(<>atCommKey; 0)
			ARRAY TEXT:C222(<>atRMCode; 0)
			ARRAY REAL:C219(<>arQty; 0)
			ARRAY TEXT:C222(<>atUM; 0)
			ARRAY REAL:C219(<>arCost; 0)
			ARRAY LONGINT:C221(<>axlRecNum; 0)
			ARRAY LONGINT:C221($atSeq; 0)
			
			//zwStatusMsg ("UPDATING";" [JobMasterLog]FirstReleaseDat")
			//QUERY([Job_Forms_Master_Schedule];[Job_Forms_Master_Schedule]JobForm=[Job_Forms]JobFormID)
			//If ([Job_Forms_Master_Schedule]ActualFirstShip=!00/00/00!)  //hasn't ship yet
			//zwStatusMsg ("JobMaster Update";" Getting the Release Info...")
			//[Job_Forms_Master_Schedule]FirstReleaseDat:=JML_get1stRelease ([Job_Forms]JobFormID)  //*      Get the earliest release
			//If ([Job_Forms_Master_Schedule]FirstReleaseDat<[Job_Forms]NeedDate) & ([Job_Forms_Master_Schedule]FirstReleaseDat#!00/00/00!)
			//uConfirm ("Verify the NeedDate, looks like there is a release on "+String([Job_Forms_Master_Schedule]FirstReleaseDat;System date short);"OK";"Help")
			//End if 
			//[Job_Forms_Master_Schedule]ActualFirstShip:=JMI_get1stShipment ([Job_Forms]JobFormID)  //*      Get the first shipment
			//[Job_Forms_Master_Schedule]Date1stItemMAD:=JML_get1stItemMAD ([Job_Forms]JobFormID)
			//End if 
			//REDUCE SELECTION([Job_Forms_Master_Schedule];0)
		End if 
		
		Jobform_load_related
		
		zwStatusMsg("SECURITY"; " Getting Clearance")
		If (Not:C34(User_AllowedCustomer([Customers_Projects:9]Customerid:3; ""; "via JF "+[Job_Forms:42]JobFormID:5)))
			bDone:=1
			CANCEL:C270
		End if 
		
		//If ([Job_Forms]Status#"Closed")
		//zwStatusMsg ("UPDATING";"Machine Tickets")
		//uGetActMachData (1)
		//USE NAMED SELECTION("machTicks")
		//USE NAMED SELECTION("machines")
		//
		//zwStatusMsg ("UPDATING";" R/M Issues   ")
		//uGetActMatlData (1)
		//USE NAMED SELECTION("Related")
		//USE NAMED SELECTION("rmXfers")
		//End if 
		
		ARRAY TEXT:C222(aMfgPlant; 0)
		LIST TO ARRAY:C288("Locations"; aMfgPlant)
		
		ARRAY TEXT:C222(aJobTypes; 0)
		LIST TO ARRAY:C288("JobType"; aJobTypes)
		
		Case of 
			: (iMode=1)
				
			: (iMode>2)  //review
				uSetEntStatus(->[Job_Forms:42]; False:C215)
				OBJECT SET ENABLED:C1123(bSetUp; False:C215)
				//OBJECT SET ENABLED(bSetUp2;False)  // Modified by: Mark Zinke (4/23/13) Commented.
				OBJECT SET ENABLED:C1123(bValidate; False:C215)
				OBJECT SET ENABLED:C1123(bGetRM; False:C215)
				OBJECT SET ENABLED:C1123(bRefresh; False:C215)
				OBJECT SET ENABLED:C1123(*; "FixedPrice"; False:C215)  // Modified by: MelvinBohince (3/22/22) 
				OBJECT SET ENABLED:C1123(*; "SetOrderlines"; False:C215)
				ARRAY TEXT:C222(aMfgPlant; 0)
				ARRAY TEXT:C222(aJobTypes; 0)
		End case 
		
		If (Position:C15("Hold"; [Job_Forms:42]Status:6)#0)  //2/28/95 upr 1242
			Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(3+(256*0)))
		Else 
			Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(15+(256*0)))
		End if 
		
		If ([Job_Forms:42]ShortGrain:48)
			Core_ObjectSetColor(->sbin; -(Red:K11:4+(256*Yellow:K11:2)))
			sBin:=" Short Grain! "
		Else 
			Core_ObjectSetColor(->sBin; -(Light grey:K11:13+(256*Light grey:K11:13)))
			sBin:=""
		End if 
		
		If ([Job_Forms:42]ColorStdSheets:60#0)  //• mlb - 5/15/02  11:36 add for Color Standard"
			xComment:=String:C10([Job_Forms:42]ColorStdSheets:60; "|Int_no_zero")+" for Color Standards"
		Else 
			xComment:=""
		End if 
		
		zwStatusMsg("PSPECT"; " Getting Stock spec")
		READ ONLY:C145([Process_Specs:18])  // Modified by: Mel Bohince (4/10/17)  read only
		If ([Process_Specs:18]ID:1#[Job_Forms:42]ProcessSpec:46)
			QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Job_Forms:42]ProcessSpec:46)
		End if 
		t4:=String:C10([Job_Forms:42]Caliper:49; "0.000#")+" "+[Process_Specs:18]Stock:7
		REDUCE SELECTION:C351([Process_Specs:18]; 0)
		
		<>jobform:=[Job_Forms:42]JobFormID:5
		zwStatusMsg("JobForm"; <>jobform)
		
		///////
		//////
		/////////
		
	: (Form event code:C388=On Validate:K2:3)
		C_BOOLEAN:C305($Failed)
		//If (Est_PandGQtyTest (->$Failed;"Save"))  // Commneted by: Mark Zinke (1/30/14)
		uUpdateTrail(->[Job_Forms:42]ModDate:7; ->[Job_Forms:42]ModWho:8; ->[Job_Forms:42]zCount:12)
		
		C_BOOLEAN:C305($updateSchedule)
		Case of 
			: ([Job_Forms:42]Status:6="Closed") & (Old:C35([Job_Forms:42]Status:6)#"Closed")
				$numAlloc:=RM_AllocationRemove([Job_Forms:42]JobFormID:5)
				$updateSchedule:=True:C214
				
			: ([Job_Forms:42]Status:6="Hold") & (Old:C35([Job_Forms:42]Status:6)#"Hold")  //going on hold
				$updateSchedule:=True:C214
				
				If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)  // Modified by: Mel Bohince (4/28/21) 
					[Job_Forms_Master_Schedule:67]PlannerReleased:14:=[Job_Forms:42]PlnnerReleased:59
					SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
				End if 
				
			: ([Job_Forms:42]Status:6#"Hold") & (Old:C35([Job_Forms:42]Status:6)="Hold")  //going off hold
				$updateSchedule:=True:C214
				
			: ([Job_Forms:42]Status:6="Kill") & (Old:C35([Job_Forms:42]Status:6)#"Kill")  //killing time, not reverseable
				$updateSchedule:=True:C214
				$numAlloc:=RM_AllocationRemove([Job_Forms:42]JobFormID:5)
				//fix the jobit so the offer no supply
				If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
					
					COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "holdJMI")  //•2/24/00  mlb 
					
				Else 
					
					ARRAY LONGINT:C221($_holdJMI; 0)
					LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Items:44]; $_holdJMI)
					
				End if   // END 4D Professional Services : January 2019 
				
				QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11=0)
				If (Records in selection:C76([Job_Forms_Items:44])>0)
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Want:24:=0)
						FIRST RECORD:C50([Job_Forms_Items:44])
						APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Yield:9:=0)
						FIRST RECORD:C50([Job_Forms_Items:44])
						APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2:="Killed")
						
					Else 
						
						APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Want:24:=0)
						APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Yield:9:=0)
						APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2:="Killed")
						
					End if   // END 4D Professional Services : January 2019 query selection
					
				End if 
				If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
					
					USE NAMED SELECTION:C332("holdJMI")
					CLEAR NAMED SELECTION:C333("holdJMI")
					
				Else 
					
					CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_holdJMI)
					
				End if   // END 4D Professional Services : January 2019 
				
				FIRST RECORD:C50([Job_Forms_Items:44])
				APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39:=4D_Current_date)
				
				If ([Job_Forms_Master_Schedule:67]JobForm:4#[Job_Forms:42]JobFormID:5)
					READ WRITE:C146([Job_Forms_Master_Schedule:67])
					QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms:42]JobFormID:5=[Job_Forms:42]JobFormID:5)
				End if 
				
				If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
					//SAVE RECORD([Job_Forms])  // if we don't, the jf will get unloaded by the jml trigger
					//$pushJF:=Record number([Job_Forms])
					//If ([JobMasterLog]PlannerReleased=!00/00/00!)
					[Job_Forms_Master_Schedule:67]Comment:22:="KILLED BY "+<>zResp+"  "+[Job_Forms_Master_Schedule:67]Comment:22  // Modified by: Mel Bohince (6/11/19) remove extra space between Killed and by
					[Job_Forms_Master_Schedule:67]DateComplete:15:=4D_Current_date
					[Job_Forms_Master_Schedule:67]PlannerReleased:14:=!00-00-00!  //[JobForm]PlnnerReleased
					SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
					
					//GOTO RECORD([Job_Forms];$pushJF)
					//End if 
				End if 
				
			Else 
				$updateSchedule:=False:C215
		End case 
		
		If ($updateSchedule)
			READ WRITE:C146([ProductionSchedules:110])
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=([Job_Forms:42]JobFormID:5+"@"))
			APPLY TO SELECTION:C70([ProductionSchedules:110]; PS_setJobInfo([ProductionSchedules:110]JobSequence:8))
			REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
			User_NotifyAll
		End if 
		
		
		
		//If ([Job_Forms]Status#"Hold") & (Old([Job_Forms]Status)="Hold")  //going off hold
		
		
		//Else 
		//READ WRITE([ProductionSchedules])
		//QUERY([ProductionSchedules];[ProductionSchedules]JobSequence=([Job_Forms]JobFormID+"@");*)
		//QUERY([ProductionSchedules]; & ;[ProductionSchedules]Info=("ON HOLD@"))
		//If (Records in selection([ProductionSchedules])>0)
		//APPLY TO SELECTION([ProductionSchedules];PS_setJobInfo ([ProductionSchedules]JobSequence))
		//REDUCE SELECTION([ProductionSchedules];0)
		//User_NotifyAll 
		//End if 
		//End if 
		
		//If ([Job_Forms]Status="Kill") & (Old([Job_Forms]Status)#"Kill")  //going on hold
		
		//End if 
		
		//If ([Job_Forms]Status#"Kill") & (Old([Job_Forms]Status)="Kill")  //going off hold
		//READ WRITE([ProductionSchedules])
		//QUERY([ProductionSchedules];[ProductionSchedules]JobSequence=([Job_Forms]JobFormID+"@"))
		//APPLY TO SELECTION([ProductionSchedules];PS_setJobInfo ([ProductionSchedules]JobSequence))
		//REDUCE SELECTION([ProductionSchedules];0)
		//User_NotifyAll 
		//End if 
		
		If (Size of array:C274(<>atSeq)>0)
			MakeArrayJFMaterials("Compare")  // Added by: Mark Zinke (10/2/13) 
		End if 
		
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
		
		
	: (Form event code:C388=On Unload:K2:2)
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
		
		CLEAR NAMED SELECTION:C333("Jobits")
		
		If (Find in array:C230(aTabVisited; "Machines & Material")>-1)
			CLEAR NAMED SELECTION:C333("Related")
			CLEAR NAMED SELECTION:C333("machines")
		End if 
		
		If (Find in array:C230(aTabVisited; "Actuals Entered")>-1)
			CLEAR NAMED SELECTION:C333("machTicks")
			CLEAR NAMED SELECTION:C333("rmXfers")
		End if 
		
		
		wWindowTitle("pop")
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
End case 