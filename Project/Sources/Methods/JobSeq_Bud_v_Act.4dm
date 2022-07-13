//%attributes = {}
// -------
// Method: JobSeq_Bud_v_Act   ( ) ->
// By: Mel Bohince @ 10/12/17, 12:46:23
// Description
// 
// ----------------------------------------------------
// Modified by: MelvinBohince (4/5/22) change xls to csv, replaced "\t" with ","

//find the machine budgets for jobs completed in range with their actuals
C_TEXT:C284($1; $2; $distributionList)
C_DATE:C307(dDateBegin; dDateEnd; $To)
C_LONGINT:C283($hit)

Case of 
	: (Count parameters:C259=0)
		<>pid_:=New process:C317("JobSeq_Bud_v_Act"; <>lMidMemPart; "JobSeq_Bud_v_Act"; "ui")
		If (False:C215)
			JobSeq_Bud_v_Act
		End if 
		
	: (Count parameters:C259=4) & ($1="init")
		$distributionList:=$2
		$from:=$3
		$to:=$4
		<>pid_:=New process:C317("JobSeq_Bud_v_Act"; <>lMidMemPart; "JobSeq_Bud_v_Act"; "batch"; $distributionList; $from; $to)
		
	Else 
		
		Case of 
			: ($1="ui")
				//Get YTD date range
				windowTitle:="Jobs Completed in date range"
				$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)
				dDateBegin:=Date:C102(FiscalYear("start"; Current date:C33))
				$To:=UtilGetDate(Current date:C33; "ThisMonth"; ->dDateEnd)  //last day of month
				DIALOG:C40([zz_control:1]; "DateRange2")
				CLOSE WINDOW:C154($winRef)
				
			: ($1="batch")
				//batch mode, to be emailed
				$distributionList:=$2
				dDateBegin:=$3  //UtilGetDate (current date;"ThisMonth";->dDateEnd)// this month
				dDateEnd:=$4
				ok:=1
		End case 
		
		If (ok=1)
			ARRAY TEXT:C222($aJob; 0)
			ARRAY TEXT:C222($aStatus; 0)
			ARRAY DATE:C224($aCompleted; 0)
			ARRAY REAL:C219($aCal; 0)
			ARRAY REAL:C219($aLen; 0)
			ARRAY REAL:C219($aWid; 0)
			ARRAY LONGINT:C221($aUP; 0)
			ARRAY LONGINT:C221($aGross; 0)
			ARRAY LONGINT:C221($aNet; 0)
			ARRAY LONGINT:C221($aWaste; 0)
			
			Begin SQL
				select JobFormID, Status, Completed, Caliper, Lenth, Width, NumberUp, EstGrossSheets, EstNetSheets, EstWasteSheets
				from Job_Forms 
				where Status <> 'Kill' and JobFormID not like '02%' and ClosedDate between :dDateBegin and :dDateEnd
				order by JobFormID
				into :$aJob, :$aStatus, :$aCompleted, :$aCal, :$aLen, :$aWid, :$aUP, :$aGross, :$aNet, :$aWaste
			End SQL
			
			$numElements:=Size of array:C274($aJob)
			
			C_TEXT:C284($text; $docName)
			C_TIME:C306($docRef)
			$text:="JOBS CLOSED FROM: "+String:C10(dDateBegin; Internal date short special:K1:4)+" TO: "+String:C10(dDateEnd; Internal date short special:K1:4)+"\r\r"
			$text:=$text+"JobFormID,Status,Closed,Caliper,Length,Width,NumberUp,EstGrossSheets,EstNetSheets,EstWasteSheets\r"
			$docName:="JOB_BUD_V_ACT_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"  // Modified by: MelvinBohince (4/5/22) change xls to csv
			$docRef:=util_putFileName(->$docName)
			
			If ($docRef#?00:00:00?)
				
				uThermoInit($numElements; "Exporting Jobs...")
				For ($i; 1; $numElements)
					
					$text:=$text+$aJob{$i}+","+$aStatus{$i}+","+String:C10($aCompleted{$i}; Internal date short special:K1:4)+","+String:C10($aCal{$i})+","+String:C10($aLen{$i})+","+String:C10($aWid{$i})+","+String:C10($aUP{$i})+","+String:C10($aGross{$i})+","+String:C10($aNet{$i})+","+String:C10($aWaste{$i})+"\r"
					uThermoUpdate($i)
				End for 
				uThermoClose
				
				SEND PACKET:C103($docRef; $text)
				SEND PACKET:C103($docRef; "\r\r------ END OF JOBS ------\r\r")
				
				$text:="JobSequence,CostCenterID,Flex_field1,Flex_field2,Flex_field3,Flex_field4,Flex_Field5,Flex_field6,Flex_field7,"
				$text:=$text+"FormChangeHere,Planned_MR_Hrs,Planned_RunHrs,Planned_Qty,Planned_Waste,Act_MR_Hrs,Act_RunHrs,Act_Qty,Act_Waste\r"
				SEND PACKET:C103($docRef; $text)
				$text:=""
				//CostCtr_FlexFieldLabels
				uThermoInit($numElements; "Exporting Sequencs...")
				For ($i; 1; $numElements)
					
					ARRAY TEXT:C222($aJobSeq; 0)
					ARRAY TEXT:C222($aCC; 0)
					ARRAY LONGINT:C221($aF1; 0)
					ARRAY LONGINT:C221($aF2; 0)
					ARRAY LONGINT:C221($aF3; 0)
					ARRAY LONGINT:C221($aF4; 0)
					ARRAY BOOLEAN:C223($aF5; 0)
					ARRAY BOOLEAN:C223($aF6; 0)
					ARRAY LONGINT:C221($aF7; 0)
					ARRAY BOOLEAN:C223($aChg; 0)
					ARRAY REAL:C219($aMR; 0)
					ARRAY REAL:C219($aRun; 0)
					ARRAY REAL:C219($aQty; 0)
					ARRAY LONGINT:C221($aWaste; 0)
					
					$jobform:=$aJob{$i}
					Begin SQL
						select JobSequence, CostCenterID, Flex_field1, Flex_field2, Flex_field3, Flex_field4, Flex_Field5, Flex_field6, Flex_field7, 
						FormChangeHere, Planned_MR_Hrs, Planned_RunHrs, Planned_Qty, Planned_Waste
						from Job_Forms_Machines 
						where JobForm = :$jobform and CostCenterID not like '!%'
						order by JobSequence
						into :$aJobSeq, :$aCC, :$aF1, :$aF2, :$aF3, :$aF4, :$aF5, :$aF6, :$aF7, :$aChg, :$aMR, :$aRun, :$aQty, :$aWaste
					End SQL
					
					$numSeq:=Size of array:C274($aJobSeq)
					For ($seq; 1; $numSeq)
						$text:=$text+$aJobSeq{$seq}+","+$aCC{$seq}+","+String:C10($aF1{$seq})+","+String:C10($aF2{$seq})+","+String:C10($aF3{$seq})+","+String:C10($aF4{$seq})+","+String:C10($aF5{$seq})+","+String:C10($aF6{$seq})+","+String:C10($aF7{$seq})+","+String:C10($aChg{$seq})+","+String:C10($aMR{$seq})+","+String:C10($aRun{$seq})+","+String:C10($aQty{$seq})+","+String:C10($aWaste{$seq})+","
						
						$jobseq:=$aJobSeq{$seq}
						$mr:=0
						$run:=0
						$good:=0
						$waste:=0
						Begin SQL
							select sum(MR_Act), sum(Run_Act), sum(Good_Units), sum(Waste_Units)
							from Job_Forms_Machine_Tickets
							where JobFormSeq = :$jobseq
							group by JobFormSeq
							into :$mr, :$run, :$good, :$waste
						End SQL
						
						$text:=$text+String:C10($mr)+","+String:C10($run)+","+String:C10($good)+","+String:C10($waste)+"\r"
						
					End for 
					
					uThermoUpdate($i)
				End for 
				uThermoClose
				
				SEND PACKET:C103($docRef; $text)
				SEND PACKET:C103($docRef; "\r\r------ END OF SEQS ------\r\r")
				
				CLOSE DOCUMENT:C267($docRef)
				
				If (Count parameters:C259=4) & ($1="batch")
					EMAIL_Sender("JobSeq_Bud_v_Act_"+fYYMMDD(Current date:C33); ""; "Open attached with Excel"; $distributionList; $docName)
					util_deleteDocument($docName)
				Else 
					$err:=util_Launch_External_App($docName)
				End if 
			End if 
			
		End if   //ok
		
End case 
