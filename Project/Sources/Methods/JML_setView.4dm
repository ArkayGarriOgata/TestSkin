//%attributes = {"publishedWeb":true}
//Method: JML_setView()  042199  MLB
//called by tab control on output list
//tabs: Pending,Approved,Posted,Paid,Hold
// Modified by: Mel Bohince (3/5/18) added printflow filters
// Modified by: Mel Bohince (4/14/21) add 3WkClose, disable Preflight, Completed, Shipped, No Job, restrict doOver&Proof to past year

zwStatusMsg("Searching"; "Please Wait...")

C_LONGINT:C283($1; $tabNumber; $itemRef)
C_TEXT:C284($itemText)
C_POINTER:C301($2; $orderBy)



If (Count parameters:C259=2)
	$tabNumber:=$1
	$orderBy:=$2
Else 
	CUT NAMED SELECTION:C334([Job_Forms_Master_Schedule:67]; "hold")
	
	$tabNumber:=Selected list items:C379(iJMLTabs)
	Case of   //sort radio buttons
		: (b1=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]MAD:21
		: (b2=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]JobForm:4
		: (b3=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]Line:5
		: (b4=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]PressDate:25
		: (b5=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]GateWayDeadLine:42
		: (b6=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]ThroughPut:86
		: (b7=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]M1:82
		: (b8=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]M2:83
		: (b9=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]Investment:87
		: (b10=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]JohnsonRank:85
		: (b11=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]FirstReleaseDat:13
	End case 
End if 

If (Count parameters:C259=0)  //search
	GET LIST ITEM:C378(iJMLTabs; $tabNumber; $itemRef; $itemText)
	$criteria:=""
	Case of   //tab button clicked
		: ($itemText="Lifted")
			MESSAGES OFF:C175
			READ ONLY:C145([Job_Forms_Machine_Tickets:61])
			
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Master_Schedule:67])+" file. Please Wait...")
			QUERY BY FORMULA:C48([Job_Forms_Master_Schedule:67]; \
				([Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)\
				 & ([Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms_Machine_Tickets:61]JobForm:1)\
				 & ([Job_Forms_Machine_Tickets:61]DownHrsCat:12="15@")\
				)
			
			zwStatusMsg(""; "")
			
			$criteria:="Having a Downtime #15"
			
		: ($itemText="Sheeted")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateStockSheeted:47#!00-00-00!)
			$criteria:="Not Printed, but was Sheeted"
			
		: ($itemText="Schd?")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!)
			$criteria:="Planner Released, but not on Press Schedule or Printed"
			
		: ($itemText="Not Done")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
			$criteria:="[JobMasterLog]DateComplete=!00/00/00!"
			
		: ($itemText="ClosingSet?")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42=!00-00-00!)
			$criteria:="Closing date not set"
			
		: ($itemText="3Wk-Close")  // Modified by: Mel Bohince (4/14/21) 
			JML_HaveClosingNotReleased(3)
			b5:=1
			b4:=0
			$orderBy:=->[Job_Forms_Master_Schedule:67]GateWayDeadLine:42
			$criteria:="Planner hasn't Released, Closing in less than 3 weeks from now, might be met"
			
		: ($itemText="CloseNotMet")
			JML_HaveClosingNotReleased(2; 0)
			b5:=1
			b4:=0
			$orderBy:=->[Job_Forms_Master_Schedule:67]GateWayDeadLine:42
			$criteria:="Planner hasn't Released, Closing in less than 2 weeks from now, Closing not met"
			
			
		: ($itemText="Preflight")  //obsolete
			// Removed by: Mel Bohince (4/14/21) 
			//READ ONLY([Finished_Goods])
			//READ ONLY([Job_Forms_Items])
			
			//zwStatusMsg ("Relating";" Searching "+Table name(->[Finished_Goods])+" file. Please Wait...")
			//QUERY BY FORMULA([Job_Forms_Master_Schedule];\
				([Job_Forms_Master_Schedule]Printed=!00-00-00!)\
				 & ([Job_Forms_Master_Schedule]PlannerReleased#!00-00-00!)\
				 & ([Job_Forms_Master_Schedule]PressDate#!00-00-00!)\
				 & ([Job_Forms_Master_Schedule]DateFinalArtApproved#!00-00-00!)\
				 & ([Job_Forms_Items]JobForm=[Job_Forms_Master_Schedule]JobForm)\
				 & ([Job_Forms_Items]ProductCode=[Finished_Goods]ProductCode)\
				 & ([Finished_Goods]Preflight=true)\
				)
			
			//zwStatusMsg ("PREFLIGHT";"TRUE")
			
			//$criteria:="Release with Press Date, has Final Art, F/G not Preflighted"
			
		: ($itemText="No Job")  //obsolete
			// Removed by: Mel Bohince (4/14/21) 
			//QUERY([Job_Forms_Master_Schedule];[Job_Forms_Master_Schedule]DateComplete=!00-00-00!;*)
			//QUERY([Job_Forms_Master_Schedule]; & ;[Job_Forms_Master_Schedule]JobForm=("@.**"))
			//$criteria:="[JobMasterLog]JobForm=(@.**)"
			
		: ($itemText="Proofs")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  | ; [Job_Forms_Master_Schedule:67]DateComplete:15>Add to date:C393(4D_Current_date; -1; 0; 0); *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobType:31="2@")
			$criteria:="[JobMasterLog]JobType=2@ in the past year"
			
		: ($itemText="Do Overs")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  | ; [Job_Forms_Master_Schedule:67]DateComplete:15>Add to date:C393(4D_Current_date; -1; 0; 0); *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobType:31="4@")
			$criteria:="[JobMasterLog]JobType=4@ in the past year"
			
		: ($itemText="MAD?") | ($itemText="HRD?")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]MAD:21=!00-00-00!)
			$criteria:="Needs a HRD date"
			
		: ($itemText="Plnr?")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14=!00-00-00!)
			$criteria:="Needs to be Released by Planner"
			
		: ($itemText="Stock")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
			$criteria:="Released by planner, Scheduled, but Stock not Received"
			
		: ($itemText="Plates")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DatePlatesRecd:39=!00-00-00!)
			
		: ($itemText="Ink")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateInkRecd:40=!00-00-00!)
			
		: ($itemText="Print")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
			$criteria:="Released by planner, Scheduled, but not yet Printed"
			
		: ($itemText="475")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Operations:36="@475@")
			
		: ($itemText="414")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Operations:36="@414@")
			
		: ($itemText="415")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Operations:36="@415@")
			
		: ($itemText="416")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Operations:36="@416@")
			
		: ($itemText="417")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Operations:36="@417@")
			
			
		: ($itemText="Dies")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]GlueReady:28=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateDiesStampingRecd:41=!00-00-00!)
			
		: ($itemText="Printed")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]GlueReady:28=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32#!00-00-00!)
			$criteria:="Released by planner, Printed, but not marked as GlueReady"
			
		: ($itemText="Glue")
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!; *)
			QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]GlueReady:28#!00-00-00!)
			$criteria:="Released by planner and marked as GlueReady"
			
		: ($itemText="Completed")  //obsolete
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15>Add to date:C393(4D_Current_date; -1; 0; 0))
			
		: ($itemText="Shipped")  //obsolete
			// Removed by: Mel Bohince (4/14/21) 
			//QUERY([Job_Forms_Master_Schedule];[Job_Forms_Master_Schedule]ActualFirstShip#!00-00-00!)
			
		Else 
			QUERY:C277([Job_Forms_Master_Schedule:67])
	End case 
	zwStatusMsg($itemText; $criteria+" Sorted by: "+Field name:C257($orderBy))
	
	Case of   //time horizon
		: (cb1=1)  //5 day horizon
			QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25<=(4D_Current_date+5))
			
		: (cb3=1)  //2 week horzion
			QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25<=(4D_Current_date+14))
			
		: (cb2=1)  //all
			//pass
	End case 
	
	Case of 
		: (i1=1) & (i2=1)
			//don't restrict
		: (i1=1)
			QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]LocationOfMfg:30="@OS@")
			
		: (i2=1)
			QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]LocationOfMfg:30="VA")
			
		Else 
			//both off, dont restrict
	End case 
	
	If (i4=1)
		//QUERY SELECTION([JobMasterLog];[JobMasterLog]PressDate#!00/00/00!)
		QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]RepeatJob:27#"")
	End if 
	
	If (i3=1)
		zwStatusMsg("Searching"; " for your records")
		$numCust:=User_AllowedRecords(Table name:C256(->[Customers:16]))
		SELECTION TO ARRAY:C260([Customers:16]Name:2; $aCustName)
		QUERY SELECTION WITH ARRAY:C1050([Job_Forms_Master_Schedule:67]Customer:2; $aCustName)
		
	End if 
	
	If (i6=1)
		$endDate:=4D_Current_date
		
		QUERY SELECTION BY FORMULA:C207([Job_Forms_Master_Schedule:67]; \
			([Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms:42]JobFormID:5)\
			 & (([Job_Forms:42]Completed:18>$endDate) | ([Job_Forms:42]Completed:18=!00-00-00!))\
			 & ([Job_Forms:42]StartDate:10<=$endDate)\
			 & ([Job_Forms:42]StartDate:10#!00-00-00!)\
			 & ([Job_Forms:42]Status:6#"Closed")\
			)
		
	End if 
	
	If (iPF1=1)  //obsolete
		QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Exported_PrintFlow:89#!00-00-00!)
	End if 
	
	If (iPF2=1)  //obsolete
		QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Exported_PrintFlow:89=!00-00-00!)
	End if 
	
Else 
	USE NAMED SELECTION:C332("hold")
End if 

If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	RESOLVE POINTER:C394($orderBy; $variable; $table; $field)
	
	Case of 
		: ($field=Field:C253(->[Job_Forms_Master_Schedule:67]Priority:33))
			ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Priority:33; >)
			
		: ($field=Field:C253(->[Job_Forms_Master_Schedule:67]ThroughPut:86))
			ORDER BY:C49([Job_Forms_Master_Schedule:67]; $orderBy->; <)
			
		: ($field=Field:C253(->[Job_Forms_Master_Schedule:67]Investment:87))
			ORDER BY:C49([Job_Forms_Master_Schedule:67]; $orderBy->; <)
			
		Else 
			ORDER BY:C49([Job_Forms_Master_Schedule:67]; $orderBy->; >)
	End case 
	
	lastTab:=$tabNumber
Else 
	BEEP:C151
End if 

CREATE SET:C116([Job_Forms_Master_Schedule:67]; "◊LastSelection"+String:C10(fileNum))
CREATE SET:C116([Job_Forms_Master_Schedule:67]; "CurrentSet")
SET WINDOW TITLE:C213(fNameWindow(->[Job_Forms_Master_Schedule:67]))