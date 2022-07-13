//%attributes = {"publishedWeb":true}
//PM:  JOB_MakeReserved  121799  mlb
//formerly  `Procedure: uCreateJobHdr()  061695  MLB
//see also doOpenOrder2
//•061695  MLB  UPR 1636
//*Create a Job header if necessary
//•072595  MLB 
//•080295  MLB rtn job number
//•090895  MLB  UPR 1719 remove alert so can run unattended

C_LONGINT:C283($job; $0)
C_TEXT:C284($1)  //`•072595  MLB  optional argument for jobform suffix on masterlog

NewWindow(250; 75; 4; -720)  //•090895  MLB  UPR 1719

If ([Estimates:17]JobNo:50=0)
	If ([Estimates:17]Status:30#"CONTRACT")  //•060195  MLB  UPR 184     
		$job:=Job_setJobNumber  //Se444quence number([Jobs])+◊aOffSet{Table(->[Jobs])}
		MESSAGE:C88(Char:C90(13)+" Planning Job "+String:C10($job)+"...")
		READ WRITE:C146([Jobs:15])
		CREATE RECORD:C68([Jobs:15])
		[Jobs:15]JobNo:1:=$job
		[Jobs:15]CustID:2:=[Estimates:17]Cust_ID:2
		[Jobs:15]CustomerName:5:=[Estimates:17]CustomerName:47
		[Jobs:15]Line:3:=[Estimates:17]Brand:3
		[Jobs:15]Status:4:="Reserved"
		[Jobs:15]EstimateNo:6:=[Estimates:17]EstimateNo:1
		[Jobs:15]CaseScenario:7:=""
		[Jobs:15]ModDate:8:=4D_Current_date
		[Jobs:15]ModWho:9:=<>zResp
		[Jobs:15]zCount:10:=1
		[Jobs:15]OrderNo:15:=[Estimates:17]OrderNo:51
		SAVE RECORD:C53([Jobs:15])
		BEEP:C151
		MESSAGE:C88(Char:C90(13)+" Job number "+String:C10($job)+" has been reserved for use for this Estimate.")
		
		[Estimates:17]JobNo:50:=$job
		SAVE RECORD:C53([Estimates:17])
		C_LONGINT:C283(<>JobNo; $id)
		<>EstNo:=[Estimates:17]EstimateNo:1
		<>JobNo:=$job
		$id:=New process:C317("EST_ChgJobRefer"; <>lMinMemPart; "Estimate Job Change")
		If (False:C215)
			EST_ChgJobRefer
		End if 
	End if   //contract
	
Else   //there is a job
	BEEP:C151
	MESSAGE:C88(Char:C90(13)+" Job number "+String:C10([Estimates:17]JobNo:50)+" had been opened for use for this estimate.")
End if   //no job
CLOSE WINDOW:C154
DELAY PROCESS:C323(Current process:C322; 180)
$0:=[Estimates:17]JobNo:50  //•080295  MLB

//*   Create a Job Tracker if necessary    
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=(String:C10([Estimates:17]JobNo:50)+"@"))  //1/26/95
If (Records in selection:C76([Job_Forms_Master_Schedule:67])=0)
	If ([Estimates:17]Status:30#"CONTRACT")  //•060195  MLB  UPR 184            
		If (Count parameters:C259=1)
			$JobForm:=String:C10([Estimates:17]JobNo:50)+$1
		Else 
			$JobForm:=String:C10([Estimates:17]JobNo:50)+".**"
		End if 
		JML_newViaJob($JobForm; [Estimates:17]DateCustomerWant:23; [Estimates:17]z_DateMutualAgree:24; ""; [Estimates:17]Sales_Rep:13; [Estimates:17]Brand:3; Substring:C12([Estimates:17]EstimateNo:1; 1; 6))
	End if 
End if 
REDUCE SELECTION:C351([Jobs:15]; 0)