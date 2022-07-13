//%attributes = {}

// Method: JML_Update ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/10/14, 11:06:50
// ----------------------------------------------------
// Description
// like JML_AutoUpdate but run on server
//
// ----------------------------------------------------
// Modified by: Mel Bohince (6/30/15) the end if on line 63 was at line 74 missing the completing section
C_BOOLEAN:C305(serverMethodDone)
serverMethodDone:=False:C215
C_LONGINT:C283(expireAt)
expireAt:=TSTimeStamp+(60*3)  //time stamp is in seconds so this is 3 minutes

READ WRITE:C146([Job_Forms_Master_Schedule:67])
READ ONLY:C145([Job_Forms_Items:44])

//TRACE

//JML_ReservationCancel   //get rid of any forms numbered ".**"

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15#!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)
APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Printed:32:=[Job_Forms_Master_Schedule:67]DateComplete:15)

FG_LaunchItem("Init")

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

$break:=False:C215
$numRecs:=Records in selection:C76([Job_Forms_Master_Schedule:67])

uThermoInit($numRecs; "Updating Records")
For ($i; 1; $numRecs)
	If ($break)
		$i:=$i+$numRecs
	End if 
	
	//*   Load Jobform 
	//zwStatusMsg ("JobMaster Update";" Getting the Jobform...")
	JML_getJobInfo([Job_Forms_Master_Schedule:67]JobForm:4)
	
	//determine if launch
	If (Pjt_isLaunch([Job_Forms_Master_Schedule:67]JobForm:4))
		[Job_Forms_Master_Schedule:67]Launch:64:="Launch"
		
	Else   //look at each item
		[Job_Forms_Master_Schedule:67]Launch:64:=""
		$numJMI:=qryJMI([Job_Forms_Master_Schedule:67]JobForm:4; 0; "@")
		If ($numJMI>0)
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]Completed:39; $aDate)
			For ($item; 1; $numJMI)
				If (FG_LaunchItem("is"; $aCPN{$item}))
					[Job_Forms_Master_Schedule:67]Launch:64:="Launch"
					$item:=$item+$numJMI
				End if 
			End for 
		End if   //is this a launch item// Modified by: Mel Bohince (6/30/15) missing if
	End if   // Modified by: Mel Bohince (6/30/15) this end if was in hte wrong place
	// • mel (8/25/04, 14:36:09)
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4; *)  //$numJMI:=qryJMI ([Job_Forms_Master_Schedule]JobForm;0;"@")
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
	If (Records in selection:C76([Job_Forms_Items:44])=0)  //all appear to be completed
		//If (JML_CanThisJobBeMarkedComplete )//obsolete rama gluing test
		//all marked as complete
		JML_setJobComplete([Job_Forms_Master_Schedule:67]JobForm:4)
		//End if 
		//EMAIL_Sender ("Pls 'Complete' job "+[JobMasterLog]JobForm)
	End if 
	
	
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	
	JML_getCustInfo([Job_Forms_Master_Schedule:67]JobForm:4)
	
	//*   Get Stock 
	//zwStatusMsg ("JobMaster Update";" Getting the Stock number...")
	[Job_Forms_Master_Schedule:67]S_Number:7:=JML_getStockRMcode([Job_Forms_Master_Schedule:67]JobForm:4)
	[Job_Forms_Master_Schedule:67]caliper:63:=Job_getBoardCaliper([Job_Forms_Master_Schedule:67]JobForm:4)  // • mel (8/17/04, 12:16:16)
	
	If ([Job_Forms_Master_Schedule:67]DateStockDue:16=!00-00-00!)
		[Job_Forms_Master_Schedule:67]DateStockDue:16:=JML_getStockAvailablity([Job_Forms_Master_Schedule:67]JobForm:4; "Due")
	End if 
	
	If ([Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
		[Job_Forms_Master_Schedule:67]DateStockRecd:17:=JML_getStockAvailablity([Job_Forms_Master_Schedule:67]JobForm:4; "Received")
	End if 
	
	If ([Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
		If (RM_AllocationTest([Job_Forms_Master_Schedule:67]S_Number:7; [Job_Forms_Master_Schedule:67]JobForm:4))
			[Job_Forms_Master_Schedule:67]DateStockRecd:17:=4D_Current_date
		End if 
	End if 
	//*Get the Jobs status via MachineTickets
	JML_StatusFromMachineTickets
	
	//*   Determine plant  
	If ([Job_Forms_Master_Schedule:67]LocationOfMfg:30="")
		//zwStatusMsg ("JobMaster Update";" Getting the Plant location...")
		[Job_Forms_Master_Schedule:67]LocationOfMfg:30:=JML_getPlant([Job_Forms_Master_Schedule:67]JobForm:4)
	End if 
	
	//*   Load Releases
	//zwStatusMsg ("JobMaster Update";" Getting the Release Info...")
	If ([Job_Forms_Master_Schedule:67]ActualFirstShip:19=!00-00-00!)  //hasn't ship yet
		[Job_Forms_Master_Schedule:67]FirstReleaseDat:13:=JML_get1stRelease([Job_Forms_Master_Schedule:67]JobForm:4; "includeFCST")  //*      Get the earliest release
		[Job_Forms_Master_Schedule:67]ActualFirstShip:19:=JMI_get1stShipment([Job_Forms_Master_Schedule:67]JobForm:4)  //*      Get the first shipment
	End if 
	[Job_Forms_Master_Schedule:67]Date1stItemMAD:50:=JML_get1stItemMAD([Job_Forms_Master_Schedule:67]JobForm:4)
	
	[Job_Forms_Master_Schedule:67]TotalProcessHours:84:=JML_getMachineHours([Job_Forms_Master_Schedule:67]JobForm:4; ->[Job_Forms_Master_Schedule:67]M1:82; ->[Job_Forms_Master_Schedule:67]M2:83; ->[Job_Forms_Master_Schedule:67]DurationPrinting:37)
	
	
	
	
	//*   Load Job Items  
	//zwStatusMsg ("JobMaster Update";" Getting the Job items...")
	$numJMI:=qryJMI([Job_Forms:42]JobFormID:5; 0; "@")
	If ($numJMI=0)  //this job has no items (still from estimate)
		CREATE EMPTY SET:C140([Finished_Goods:26]; "ToProduce")  //hold records from display
	Else 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Job_Forms_Items:44]ProductCode:3; 0)  //• upr 1848  
			
		Else 
			
			RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Finished_Goods:26])
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		CREATE SET:C116([Finished_Goods:26]; "ToProduce")  //• upr 1848
	End if 
	
	//*Get Art and Final ok date
	
	//*   Establish Art Recieved Date
	//zwStatusMsg ("JobMaster Update";" Getting the Art OKs...")
	//If ([JobMasterLog]FinalArtWorkRec=!00/00/00!)
	[Job_Forms_Master_Schedule:67]DateFinalArtApproved:12:=JML_getFinalArt([Job_Forms_Master_Schedule:67]JobForm:4)
	//End if 
	
	//*   Establish Final OKs date
	//If ([JobMasterLog]DateFinalOKs=!00/00/00!)  `otherwise don't bother
	//zwStatusMsg ("JobMaster Update";" Getting the Final OKs...")
	[Job_Forms_Master_Schedule:67]DateFinalToolApproved:18:=JML_getFinalOKs([Job_Forms_Master_Schedule:67]JobForm:4)  //see also JML_FinalOKsOLD 
	//End if 
	
	//If ([JobMasterLog]GateWayDeadLine#!00/00/00!)
	[Job_Forms_Master_Schedule:67]DateClosingMet:23:=JML_getGateWayMet([Job_Forms_Master_Schedule:67]JobForm:4)
	//End if 
	If (Length:C16([Job_Forms_Master_Schedule:67]RepeatJob:27)=0)
		[Job_Forms_Master_Schedule:67]RepeatJob:27:=Job_getDieRepeat
	End if 
	
	If (Not:C34([Job_Forms_Master_Schedule:67]Preflighed:43))
		If ([Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)
			qryJMI([Job_Forms_Master_Schedule:67]JobForm:4; 0; "@")
			If (Records in selection:C76([Job_Forms_Items:44])=0)  //this job has no items (still from estimate)
				REDUCE SELECTION:C351([Finished_Goods:26]; 0)
			Else 
				$custid:=[Job_Forms_Items:44]CustId:15
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Job_Forms_Items:44]ProductCode:3; 0)
					QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]CustID:2=$custid)
					
				Else 
					//see line 153
					
					$Criteria1:=[Job_Forms_Master_Schedule:67]JobForm:4
					
					QUERY BY FORMULA:C48([Finished_Goods:26]; \
						([Finished_Goods:26]ProductCode:1=[Job_Forms_Items:44]ProductCode:3)\
						 & ([Job_Forms_Items:44]JobForm:1=$Criteria1)\
						 & ([Job_Forms_Items:44]ProductCode:3="@")\
						 & ([Finished_Goods:26]CustID:2=$custid)\
						)
					
				End if   // END 4D Professional Services : January 2019 query selection
				
			End if 
			
			//*   Check if all have been preflighted
			If (Records in selection:C76([Finished_Goods:26])>0)  //if there are records found
				//zwStatusMsg ("JobMaster Update";" Checking for Preflight..."+[Job_Forms_Master_Schedule]JobForm)
				QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]Preflight:66=False:C215)
				[Job_Forms_Master_Schedule:67]Preflighed:43:=(Records in selection:C76([Finished_Goods:26])=0)  //if there are records then data is incomplete  
			End if 
		End if 
	End if 
	
	
	SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
	NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
	uThermoUpdate($i)
End for 

uThermoClose
zwStatusMsg("JobMaster Update"; " DONE")
REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)

serverMethodDone:=True:C214

While (TSTimeStamp<expireAt)  //wait for the client to get the arrays
	IDLE:C311
	DELAY PROCESS:C323(Current process:C322; (60*10))
End while 
