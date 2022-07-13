
// Method: [Job_Forms_Machine_Tickets].Input ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 05/02/14, 16:11:41
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Timer:K2:25)
		$now:=TSTimeStamp
		$elapseSeconds:=$now-tSecondsStarted
		tsElapse:=Substring:C12(Time string:C180($elapseSeconds); 1; 5)
		rElapse:=Round:C94(((Time:C179(tsElapse)+0)/60)/60; 2)
		
	: (Form event code:C388=On Data Change:K2:15) | (Form event code:C388=On Clicked:K2:4)
		If ([Job_Forms_Machine_Tickets:61]DownHrs:11>0) | (Length:C16([Job_Forms_Machine_Tickets:61]DownHrsCat:12)>0)
			OBJECT SET ENTERABLE:C238([Job_Forms_Machine_Tickets:61]DownHrsCat:12; True:C214)
		Else 
			OBJECT SET ENTERABLE:C238([Job_Forms_Machine_Tickets:61]DownHrsCat:12; False:C215)
			[Job_Forms_Machine_Tickets:61]DownHrsCat:12:=""
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		cb1:=0
		OBJECT SET ENTERABLE:C238(*; "e@"; True:C214)
		OBJECT SET ENABLED:C1123(*; "e@"; True:C214)
		C_TIME:C306(tElapse)
		C_TEXT:C284(tsElapse)
		tsElapse:="00:00"
		rElapse:=0
		tSecondsStarted:=TSTimeStamp
		tsStarted:=TS2String(tSecondsStarted)
		tsStarted:=Substring:C12(tsStarted; 1; Length:C16(tsStarted)-3)
		
		SET TIMER:C645(60*60)
		
		If (Is new record:C668([Job_Forms_Machine_Tickets:61]))
			If (iSeq>0)
				[Job_Forms_Machine_Tickets:61]JobForm:1:=sCriterion1
				[Job_Forms_Machine_Tickets:61]Sequence:3:=iSeq
				[Job_Forms_Machine_Tickets:61]DateEntered:5:=dDate
				[Job_Forms_Machine_Tickets:61]Shift:18:=iShift
				[Job_Forms_Machine_Tickets:61]GlueMachItemNo:4:=iItem
				[Job_Forms_Machine_Tickets:61]Operator:27:=iOperator
				
				If (Position:C15(sCC; <>GLUERS)>0)  //use what is on glue schedule
					[Job_Forms_Machine_Tickets:61]CostCenterID:2:=sCC
				Else   //use what is inthe production schedule
					$schdCC:=PS_getCostCenter(sCriterion1+"."+String:C10(iSeq; "000"))
					If (Length:C16($schdCC)=3)
						[Job_Forms_Machine_Tickets:61]CostCenterID:2:=$schdCC
					Else 
						[Job_Forms_Machine_Tickets:61]CostCenterID:2:=sCC
					End if 
				End if 
				
				If (Position:C15([Job_Forms_Machine_Tickets:61]CostCenterID:2; <>GLUERS)>0)
					OBJECT SET ENTERABLE:C238([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; True:C214)
				Else 
					OBJECT SET ENTERABLE:C238([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; False:C215)
				End if 
				
				
			End if 
			
		Else   //existing record
			If (Position:C15("C"; [Job_Forms_Machine_Tickets:61]P_C:10)>0)
				cb1:=1
			End if 
			
			If ((Position:C15("√"; [Job_Forms_Machine_Tickets:61]Comment:25)>0))
				OBJECT SET ENTERABLE:C238(*; "e@"; False:C215)
				OBJECT SET ENABLED:C1123(*; "e@"; False:C215)
				uConfirm("Machine Ticket has been approved, changes not permitted."; "Shucks"; "Ok")
			End if 
		End if 
		
		If ([Job_Forms_Machine_Tickets:61]DownHrs:11>0)
			OBJECT SET ENTERABLE:C238([Job_Forms_Machine_Tickets:61]DownHrsCat:12; True:C214)
		Else 
			OBJECT SET ENTERABLE:C238([Job_Forms_Machine_Tickets:61]DownHrsCat:12; False:C215)
		End if 
		
		If ([Job_Forms_Machine_Tickets:61]TimeStampEntered:17>0)
			t1:=TS2String([Job_Forms_Machine_Tickets:61]TimeStampEntered:17)
		Else 
			t1:=""
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		If (cb1=1)
			[Job_Forms_Machine_Tickets:61]P_C:10:="C"
		Else 
			[Job_Forms_Machine_Tickets:61]P_C:10:="P"
		End if 
		
		// ----------------------------------------------------
		// User name (OS): Mel Bohince
		// Date and time: 09/03/15, 12:47:24
		// ----------------------------------------------------
		// Method: [Job_Forms_Machine_Tickets].Input.Invisible Button
		// Description
		// add some constraints
		//
		// ----------------------------------------------------
		
		//$dtCode:=Substring([Job_Forms_Machine_Tickets]DownHrsCat;1;2)
		//$dtCodesNeedingComment:=" 13 20 21 26 30 44 99 "
		//$dtCodesAgainstPlant:=" 07 10 15 30 33 35 40 42 44 50 55 60 70 76 80 93 "
		//$jobRepresentingPlant:="0"+String(Year of(Current date))+".02"
		
		//  //look for special causes for rejection, else accept
		//Case of 
		//  //gotta have something
		//: (([Job_Forms_Machine_Tickets]MR_Act+[Job_Forms_Machine_Tickets]Run_Act+[Job_Forms_Machine_Tickets]DownHrs+[Job_Forms_Machine_Tickets]Good_Units+[Job_Forms_Machine_Tickets]Waste_Units)=0)
		//uConfirm ("Please enter some time and/or counts.";"Ok";"Help")
		//REJECT
		//GOTO OBJECT([Job_Forms_Machine_Tickets]MR_Act)
		
		//  //dt needs reason
		//: ([Job_Forms_Machine_Tickets]DownHrs>0) & (Length([Job_Forms_Machine_Tickets]DownHrsCat)=0)
		//uConfirm ("Please select catagory for the Downtime.";"Ok";"Help")
		//REJECT
		//GOTO OBJECT([Job_Forms_Machine_Tickets]DownHrsCat)
		
		//  //dt reason needs hours
		//: ([Job_Forms_Machine_Tickets]DownHrs=0) & (Length([Job_Forms_Machine_Tickets]DownHrsCat)>0)
		//uConfirm ("Please enter time for "+[Job_Forms_Machine_Tickets]DownHrsCat+" or clear the reason.";"Ok";"Help")
		//REJECT
		//GOTO OBJECT([Job_Forms_Machine_Tickets]DownHrsCat)
		
		//  //some dt on presses need comment
		//: (Position(sCC;<>PRESSES)>0) & ([Job_Forms_Machine_Tickets]DownHrs>0) & (Length([Job_Forms_Machine_Tickets]Comment)<3) & (Position($dtCode;$dtCodesNeedingComment)>0)
		//uConfirm ("Comment required for this Downtime category "+[Job_Forms_Machine_Tickets]DownHrsCat+".";"Ok";"Try again")
		//REJECT
		//GOTO OBJECT([Job_Forms_Machine_Tickets]Comment)
		
		//  //some dt goes against plant, not job
		//: (Position($dtCode;$dtCodesAgainstPlant)>0) & (([Job_Forms_Machine_Tickets]MR_Act+[Job_Forms_Machine_Tickets]Run_Act+[Job_Forms_Machine_Tickets]Good_Units+[Job_Forms_Machine_Tickets]Waste_Units)=0)
		//  //uConfirm ("Charge "+[Job_Forms_Machine_Tickets]DownHrsCat+" against the Plant or Job?";"Plant";"Job")
		//  //If (ok=1)
		//[Job_Forms_Machine_Tickets]Comment:=[Job_Forms_Machine_Tickets]Comment+" occurred during job "+[Job_Forms_Machine_Tickets]JobForm
		//[Job_Forms_Machine_Tickets]JobForm:=$jobRepresentingPlant
		//  //End if 
		//ACCEPT
		
		//Else 
		//ACCEPT
		//End case 
		
		
		
		zwStatusMsg("SAVED"; [Job_Forms_Machine_Tickets:61]JobForm:1+"."+String:C10([Job_Forms_Machine_Tickets:61]Sequence:3; "000")+" MR="+String:C10([Job_Forms_Machine_Tickets:61]MR_Act:6)+" "+" RUN="+String:C10([Job_Forms_Machine_Tickets:61]Run_Act:7)+" "+" DT="+String:C10([Job_Forms_Machine_Tickets:61]DownHrs:11)+" "+[Job_Forms_Machine_Tickets:61]DownHrsCat:12)
End case 