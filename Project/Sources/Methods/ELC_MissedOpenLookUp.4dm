//%attributes = {}
// Method: ELC_MissedOpenLookUp () -> 
// ----------------------------------------------------
// by: mel: 08/05/04, 16:43:48
// • mel (9/15/04, 11:06:29) deal with PC date system in excel
//pc uses 1/1/1900 as day 1, Mac uses 1/2/1904 as day one, EL sends the former
// ----------------------------------------------------
// Description:
// generate data for Excel vlookup to merge with Lauder report open/miss
//this is a death-march assignment
// • mel (9/7/04, 16:27:55 remove verbose comments, blank, inventory, shipped, or HRD w/Proj Dockdate
//Proj Dockdate = transportation lead added to HRD,  transleadtime = promise - sched
// ----------------------------------------------------
// Modified by: Mel Bohince (8/14/14) add column with po and no line item

C_LONGINT:C283($i; $numJMI; $numFG; $dateOffset; $dot)
C_TEXT:C284($t; $cr)
C_DATE:C307(dDateEnd; dDateBegin)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

MESSAGES OFF:C175
zwStatusMsg("Estée Lauder"; "Missed/Open Lookup Table")

$dateOffset:=1462
$t:=Char:C90(9)
$cr:=Char:C90(13)
//NewWindow (240;115;6;0;"Enter 'Scheduled' Date Range")
windowTitle:="Enter 'Scheduled' Date Range"
$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)
dDateBegin:=Add to date:C393(4D_Current_date; 0; -4; 0)
dDateEnd:=Add to date:C393(4D_Current_date; 0; 2; 0)

DIALOG:C40([zz_control:1]; "DateRange2")
CLOSE WINDOW:C154($winRef)

xTitle:="Missed/Open Lookup Table"
//get date range
xText:="PO"+$t+"Comment"+$t+"ProjectedDock"+$cr  //"Shipped"+$t+"TransLead"+$t+"itemHRD"+$t+"jobHRD"+$cr
//$docRef:=Create document("ELC_MADwarning"+fYYMMDD (4D_Current_date))
docName:="ELC_MissedOpenLookUp"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	//report excess qtys (no order release or forecasts)
	READ ONLY:C145([Customers:16])
	READ ONLY:C145([Job_Forms_Items:44])
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	If (Current user:C182#"Designer") | (True:C214)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
			
			$numRels:=ELC_query(->[Customers_ReleaseSchedules:46]CustID:12)  //get elc's jobits
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>=dDateBegin; *)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")
			
			
		Else 
			
			$critiria:=ELC_getName
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$critiria; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>=dDateBegin; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")
			
		End if   // END 4D Professional Services : January 2019 ELC_query
	Else 
		QUERY:C277([Customers_ReleaseSchedules:46])
	End if 
	//If ($onlyShipped)
	//QUERY SELECTION([ReleaseSchedule]; & ;[ReleaseSchedule]Actual_Date#!00/00/00!)
	//Else 
	//QUERY SELECTION([ReleaseSchedule]; & ;[ReleaseSchedule]Actual_Date=!00/00/00!)
	//End if 
	$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3; >; [Customers_ReleaseSchedules:46]ReleaseNumber:1; >)
		FIRST RECORD:C50([Customers_ReleaseSchedules:46])
		
	Else 
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3; >; [Customers_ReleaseSchedules:46]ReleaseNumber:1; >)
		// see previous line
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	uThermoInit($numRels; "Missed/Open Lookup Table")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $numRels)
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			//look for open pegged releases  
			//make the release refers look like on their spreadsheet
			//follow po prefixes obsolete
			//$po:=Replace string([Customers_ReleaseSchedules]CustomerRefer;"WR";"WP")
			//$po:=Replace string($po;"BR";"BP")
			//If (Position("BP";$po)>0) | (Position("WP";$po)>0)
			//  //$po:=Replace string($po;".";"")
			//$po:=Replace string($po;".001";"")
			//Else 
			//$po:=Replace string($po;".01.001";"")
			//End if 
			
			// Modified by: Mel Bohince (8/14/14) 
			//$po:=Replace string($po;".01";"")
			//$po:=Replace string($po;".001";"")
			
			$po:=[Customers_ReleaseSchedules:46]CustomerRefer:3
			$dot:=Position:C15("."; $po)
			If ($dot>0)
				$po:=Substring:C12($po; 1; ($dot-1))
			End if 
			
			$dot:=Position:C15("-"; $po)
			If ($dot>0)
				$po:=Substring:C12($po; 1; ($dot-1))
			End if 
			//init vars for this record
			$itemMAD:=!00-00-00!
			$jobform:="n/r"  //record set in line above
			$mad:=!00-00-00!
			$comment:=""
			$projectedOntime:=""  //add transportation lead to HRD
			
			If ([Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
				$comment:="Shipped: "+String:C10([Customers_ReleaseSchedules:46]Actual_Date:7; System date short:K1:1)
				If (Position:C15("Partial"; [Customers_ReleaseSchedules:46]Expedite:35)>0)
					$comment:=$comment+" "+[Customers_ReleaseSchedules:46]Expedite:35
				End if 
				
				//If ([ReleaseSchedule]Actual_Qty<[ReleaseSchedule]Sched_Qty)
				//$comment:=$comment+", "+[ReleaseSchedule]Expedite
				//End if 
				
			Else 
				Case of 
					: ([Customers_ReleaseSchedules:46]THC_State:39=0)
						$comment:="Inventory Available"
						
					Else 
						$itemMAD:=JMI_getMAD
						$jobform:=[Job_Forms_Items:44]JobForm:1  //record set in line above
						If ($itemMAD#!00-00-00!)
							$comment:="HRD: "+String:C10($itemMAD; System date short:K1:1)
							$projectedOntime:=String:C10(Rel_getLeadTime([Customers_ReleaseSchedules:46]Shipto:10)+$itemMAD-$dateOffset)
							
						Else 
							$mad:=JML_getMAD($jobform)
							If ($mad#!00-00-00!)
								$comment:="HRD: "+String:C10($mad; System date short:K1:1)
								$projectedOntime:=String:C10(Rel_getLeadTime([Customers_ReleaseSchedules:46]Shipto:10)+$mad-$dateOffset)
							Else   // • mel (9/7/04, 16:30:49) don't show em what job needs a mad date
								//If ($jobform#"")
								//$comment:="see: "+$jobform
								//End if 
							End if 
						End if 
				End case 
				// • mel (9/7/04, 16:30:49) don't mention DR's
				//If ([ReleaseSchedule]VarianceComment="DR") | ([ReleaseSchedule]VarianceComment="AD")
				//$comment:=$comment+" Balance of a Partial"
				//End if 
			End if 
			// • mel (9/7/04, 16:31:29) don't mention is its a launch item that's not approved
			//If (FG_LaunchItem ("is";[ReleaseSchedule]ProductCode))
			//$comment:=$comment+" Launch "
			//If (FG_LaunchItem ("hold";[ReleaseSchedule]ProductCode))
			//$comment:=$comment+" not approved "
			//End if 
			//End if 
			// • mel (9/7/04, 16:31:29) don't mention what status the order is in
			//RELATE ONE([ReleaseSchedule]OrderLine)
			//$comment:=$comment+" Order status is "+[OrderLines]Status
			
			xText:=xText+$po+$t+$comment+$t+$projectedOntime+$cr
			//String([ReleaseSchedule]Actual_Date;Short )+$t+String([ReleaseSchedule]Promise_Date-[ReleaseSchedule]Sched_Date)+$t+String($itemMAD;Short )+$t+String($mad;Short )+$cr
			
			NEXT RECORD:C51([Customers_ReleaseSchedules:46])
			uThermoUpdate($i)
		End for 
		
		
	Else 
		//laghzaoui a invoke with parametre JMI_getMAD  on ligne 227
		//$cpn:=[Customers_ReleaseSchedules]ProductCode
		//$orderline:=[Customers_ReleaseSchedules]OrderLine
		
		ARRAY DATE:C224($_Actual_Date; 0)
		ARRAY TEXT:C222($_Expedite; 0)
		ARRAY LONGINT:C221($_THC_State; 0)
		ARRAY TEXT:C222($_Shipto; 0)
		ARRAY TEXT:C222($_CustomerRefer; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY TEXT:C222($_OrderLine; 0)
		
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Actual_Date:7; $_Actual_Date; \
			[Customers_ReleaseSchedules:46]Expedite:35; $_Expedite; \
			[Customers_ReleaseSchedules:46]THC_State:39; $_THC_State; \
			[Customers_ReleaseSchedules:46]Shipto:10; $_Shipto; \
			[Customers_ReleaseSchedules:46]CustomerRefer:3; $_CustomerRefer; \
			[Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; \
			[Customers_ReleaseSchedules:46]OrderLine:4; $_OrderLine)
		
		
		For ($i; 1; $numRels; 1)
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			$po:=$_CustomerRefer{$i}
			$dot:=Position:C15("."; $po)
			If ($dot>0)
				$po:=Substring:C12($po; 1; ($dot-1))
			End if 
			
			$dot:=Position:C15("-"; $po)
			If ($dot>0)
				$po:=Substring:C12($po; 1; ($dot-1))
			End if 
			//init vars for this record
			$itemMAD:=!00-00-00!
			$jobform:="n/r"  //record set in line above
			$mad:=!00-00-00!
			$comment:=""
			$projectedOntime:=""  //add transportation lead to HRD
			
			If ($_Actual_Date{$i}#!00-00-00!)
				$comment:="Shipped: "+String:C10($_Actual_Date{$i}; System date short:K1:1)
				If (Position:C15("Partial"; $_Expedite{$i})>0)
					$comment:=$comment+" "+$_Expedite{$i}
				End if 
				
			Else 
				Case of 
					: ($_THC_State{$i}=0)
						$comment:="Inventory Available"
						
					Else 
						$itemMAD:=JMI_getMAD($_ProductCode{$i}; $_OrderLine{$i})
						$jobform:=[Job_Forms_Items:44]JobForm:1  //record set in line above
						If ($itemMAD#!00-00-00!)
							$comment:="HRD: "+String:C10($itemMAD; System date short:K1:1)
							$projectedOntime:=String:C10(Rel_getLeadTime($_Shipto{$i})+$itemMAD-$dateOffset)
							
						Else 
							$mad:=JML_getMAD($jobform)
							If ($mad#!00-00-00!)
								$comment:="HRD: "+String:C10($mad; System date short:K1:1)
								$projectedOntime:=String:C10(Rel_getLeadTime($_Shipto{$i})+$mad-$dateOffset)
							Else   // • mel (9/7/04, 16:30:49) don't show em what job needs a mad date
							End if 
						End if 
				End case 
			End if 
			xText:=xText+$po+$t+$comment+$t+$projectedOntime+$cr
			
			uThermoUpdate($i)
		End for 
		
	End if   // END 4D Professional Services : January 2019 
	
	SEND PACKET:C103($docRef; xText)
	uThermoClose
	
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$err:=util_Launch_External_App(docName)
End if   //open doc