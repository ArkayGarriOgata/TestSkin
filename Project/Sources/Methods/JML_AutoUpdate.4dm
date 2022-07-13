//%attributes = {"publishedWeb":true}
//PM: JML_AutoUpdate() -> 
//see also server version JML_Update()
//see also JMI_get1stRelease
//formerly(p) sJobTrackUpdate
//called by Batch_ArtandOKs and jml_print
//2/2/94 upr 155 add routines for final oks and final art.
//2/8/95
//•080996  MLB  optimize by using arrays
//• 2/25/97 cs discussion with Michelle Dinafrio-
//  art OK = all Fgs have art received => dylox(s) returned
//  final ok = S&S + Dyloxes (art received) + Disk + B&W + SpecSheet (on each Fg)
//  + color & embossing
//•012298  MLB  Comment and change the OKs section
//•020398  MLB  require an entry for Color & Leaf to set FinalOK date
//•022098  MLB  fix final ok algo
//•030598  MLB  turn off messaging if param is passed
//•2/28/01  mlb  no long set MAD 
//utl_Trace 
//*Init files and vars 

MESSAGES OFF:C175

READ WRITE:C146([Job_Forms_Master_Schedule:67])
READ ONLY:C145([Job_Forms_Items:44])

//*   Load Jobform 
zwStatusMsg("JobMaster Update"; " Getting the Jobform...")
JML_getJobInfo([Job_Forms_Master_Schedule:67]JobForm:4)

If (Pjt_isLaunch([Job_Forms_Master_Schedule:67]JobForm:4))
	[Job_Forms_Master_Schedule:67]Launch:64:="Launch"
Else 
	[Job_Forms_Master_Schedule:67]Launch:64:=""
End if 
$numJMI:=qryJMI([Job_Forms_Master_Schedule:67]JobForm:4; 0; "@")
If ($numJMI>0)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]Completed:39; $aDate)
	For ($item; 1; $numJMI)
		If (FG_LaunchItem("is"; $aCPN{$item}))
			[Job_Forms_Master_Schedule:67]Launch:64:="Launch"
			$item:=$item+$numJMI
		End if 
	End for 
	// • mel (8/25/04, 14:36:09)
	QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
	If (Records in selection:C76([Job_Forms_Items:44])=0)
		//If (JML_CanThisJobBeMarkedComplete )
		//all marked as complete
		JML_setJobComplete([Job_Forms_Master_Schedule:67]JobForm:4)
		//End if 
		//EMAIL_Sender ("Pls 'Complete' job "+[JobMasterLog]JobForm)
	End if 
End if 

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)

JML_getCustInfo([Job_Forms_Master_Schedule:67]JobForm:4)

//*   Get Stock 
zwStatusMsg("JobMaster Update"; " Getting the Stock number...")
[Job_Forms_Master_Schedule:67]S_Number:7:=JML_getStockRMcode([Job_Forms_Master_Schedule:67]JobForm:4)
[Job_Forms_Master_Schedule:67]caliper:63:=Job_getBoardCaliper([Job_Forms_Master_Schedule:67]JobForm:4)  // • mel (8/17/04, 12:16:16)

If ([Job_Forms_Master_Schedule:67]DateStockDue:16=!00-00-00!)
	[Job_Forms_Master_Schedule:67]DateStockDue:16:=JML_getStockAvailablity([Job_Forms_Master_Schedule:67]JobForm:4; "Due")
End if 

If ([Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
	[Job_Forms_Master_Schedule:67]DateStockRecd:17:=JML_getStockAvailablity([Job_Forms_Master_Schedule:67]JobForm:4; "Received")
End if 

//*Get the Jobs status via MachineTickets
JML_StatusFromMachineTickets

//*   Determine plant  
If ([Job_Forms_Master_Schedule:67]LocationOfMfg:30="")
	zwStatusMsg("JobMaster Update"; " Getting the Plant location...")
	[Job_Forms_Master_Schedule:67]LocationOfMfg:30:=JML_getPlant([Job_Forms_Master_Schedule:67]JobForm:4)
End if 

//*   Load Releases
zwStatusMsg("JobMaster Update"; " Getting the Release Info...")
If ([Job_Forms_Master_Schedule:67]ActualFirstShip:19=!00-00-00!)  //hasn't ship yet
	[Job_Forms_Master_Schedule:67]FirstReleaseDat:13:=JML_get1stRelease([Job_Forms_Master_Schedule:67]JobForm:4)  //*      Get the earliest release
	[Job_Forms_Master_Schedule:67]ActualFirstShip:19:=JMI_get1stShipment([Job_Forms_Master_Schedule:67]JobForm:4)  //*      Get the first shipment
	[Job_Forms_Master_Schedule:67]Date1stItemMAD:50:=JML_get1stItemMAD([Job_Forms_Master_Schedule:67]JobForm:4)
End if 

//*   Load Job Items  
zwStatusMsg("JobMaster Update"; " Getting the Job items...")
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
zwStatusMsg("JobMaster Update"; " Getting the Art OKs...")
//If ([JobMasterLog]FinalArtWorkRec=!00/00/00!)
[Job_Forms_Master_Schedule:67]DateFinalArtApproved:12:=JML_getFinalArt([Job_Forms_Master_Schedule:67]JobForm:4)
//End if 

//*   Establish Final OKs date
//If ([JobMasterLog]DateFinalOKs=!00/00/00!)  `otherwise don't bother
zwStatusMsg("JobMaster Update"; " Getting the Final OKs...")
[Job_Forms_Master_Schedule:67]DateFinalToolApproved:18:=JML_getFinalOKs([Job_Forms_Master_Schedule:67]JobForm:4)  //see also JML_FinalOKsOLD 
//End if 

//If ([JobMasterLog]GateWayDeadLine#!00/00/00!)
[Job_Forms_Master_Schedule:67]DateClosingMet:23:=JML_getGateWayMet([Job_Forms_Master_Schedule:67]JobForm:4)
//End if 
If (Length:C16([Job_Forms_Master_Schedule:67]RepeatJob:27)=0)
	[Job_Forms_Master_Schedule:67]RepeatJob:27:=Job_getDieRepeat
End if 

SAVE RECORD:C53([Job_Forms_Master_Schedule:67])

JML_setColors(12)
//MESSAGES ON

USE SET:C118("ToProduce")
CLEAR SET:C117("ToProduce")