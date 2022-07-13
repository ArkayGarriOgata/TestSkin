//%attributes = {"publishedWeb":true}
//(p) rEfficiency 
//report to show machine efficiency of a selected time frame
//this report does something a LITTLE different -
//this procedure generates 3 seperate reports
//the FIRST report processes the Machine Ticket records AND
//fills arrays which are used in the 2nd and 3rd reports
//the arrays are accessed by SELECTED RECORD NUMBER
//because the 3 reports use the same base data set, machine tickets, they
//will need to be traversed 3 times (once for each report) to make
//the coding as straight forward as possible (althouh printing a little slower
// I am printing using print selection instead of designing and printing using 
//a print layout sequence
//• 2/18/98 cs created
//• 3/3/98 cs changed where production data comes from
//was initiallyfromJMI actual qty now [machineticket]goodunits

C_TEXT:C284(xText; t3; xReptTitle)
C_TEXT:C284($Div)
C_REAL:C285(rReal1; rReal2; rReal3; rReal4)
C_DATE:C307(dDateEnd; dDateBegin)
C_TIME:C306(vDoc)

uDialog("SetupEffeciency"; 240; 140)

If (OK=1)  //user accepted date range entered
	uSetupCCDivisio
	rReal1:=0
	rReal2:=0
	rReal3:=0
	rReal4:=0
	
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dDateBegin; *)  //locate machine tickets for date range user entered
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dDateEnd)
	CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "DateRange")
	
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)  //something was found
		
		If (cbPrnt2Disk=0)  //if NOT printing to disk, set up page & printer
			util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "EfficiencyMR")
			PRINT SETTINGS:C106
		Else   //set up folder to hold files  
			$Path:=GetDefaultPath
			$Error:=Test path name:C476($Path+"EfficiencyReports")
			
			If ($Error=0)  //folder was NOT found
				$Error:=NewFolder($Path+"EfficiencyReports")  //create it
				
				If ($Error=0)  //folder got created
					OK:=1
				Else 
					ALERT:C41("Could not create needed folder.  Error: "+String:C10($Error))
					OK:=0
				End if 
			End if 
			$Path:=$Path+"EfficiencyReports:"  //$path already contains a ':'      
		End if 
		
		If (OK=1)  //either print setting OKed or folder for reports exists now
			Case of   //determine and locate machine tickets for division
				: (rbBoth=1)  //both
					$Div:="Hauppauge & Roanoke"
					USE SET:C118("DateRange")
					CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "H")
					//no change in selection        
				: (rbHaup=1)  //Hauppauge
					$Div:="Hauppauge"
					USE SET:C118("◊CCHauppauge")
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						uRelateSelect(->[Job_Forms_Machine_Tickets:61]CostCenterID:2; ->[Cost_Centers:27]ID:1; 1)
						
						
					Else 
						
						zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Machine_Tickets:61])+" file. Please Wait...")
						RELATE MANY SELECTION:C340([Job_Forms_Machine_Tickets:61]CostCenterID:2)
						zwStatusMsg(""; "")
						
					End if   // END 4D Professional Services : January 2019 query selection
					CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "H")
					INTERSECTION:C121("DateRange"; "H"; "H")
				: (rbRoan=1)  //Roanoke        
					$Div:="Roanoke"
					USE SET:C118("◊CCRoanoke")
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						uRelateSelect(->[Job_Forms_Machine_Tickets:61]CostCenterID:2; ->[Cost_Centers:27]ID:1; 1)
						
						
					Else 
						
						zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Machine_Tickets:61])+" file. Please Wait...")
						RELATE MANY SELECTION:C340([Job_Forms_Machine_Tickets:61]CostCenterID:2)
						zwStatusMsg(""; "")
						
					End if   // END 4D Professional Services : January 2019 query selection
					CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "H")
					INTERSECTION:C121("DateRange"; "H"; "H")
			End case 
			USE SET:C118("H")
			CLEAR SET:C117("H")
			CLEAR SET:C117("DateRange")
			
			If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)  //something still found
				ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]JobForm:1; >)  //set up for printing
				$Count:=Records in selection:C76([Job_Forms_Machine_Tickets:61])
				ARRAY REAL:C219(ayDown_Bud; $Count)  //these arrays are populated during the first report's run (either printed or disk
				ARRAY REAL:C219(arNum1; $Count)
				ARRAY TEXT:C222(aDesc; $Count)  //cc description
				ARRAY TEXT:C222(aText; $Count)
				
				If (cbPrnt2Disk=1)  //printing to disk
					If (rEffecMr2Disk($Path; $Div))  //create disk file and pass back completion flag
						If (rEffecRun2Disk($Path; $Div))  //create disk file and pass back completion flag
							If (rEffecSum2Disk($Path; $Div))  //create disk file and pass back completion flag
							Else 
								ALERT:C41("Summary report did not complete")
							End if 
						Else 
							ALERT:C41("Machine Running report did not complete")
						End if 
					Else 
						ALERT:C41("Make Ready report did not complete")
					End if 
					
				Else   //* -- print MR report     
					SET WINDOW TITLE:C213("Printing Make Ready Efficiencys")
					BREAK LEVEL:C302(1)
					ACCUMULATE:C303(rReal1; rReal2)
					xReptTitle:="MR Efficiency for "+$Div
					t3:="for Date Range: "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)
					FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "EfficiencyMR")
					PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61]; *)
					//* -- print Run report     
					FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])
					BREAK LEVEL:C302(1)
					ACCUMULATE:C303(rReal1; rReal2)
					xReptTitle:="Running Efficiency for "+$Div
					t3:="for Date Range: "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)
					FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "EfficiencyRun")
					SET WINDOW TITLE:C213("Printing Running Efficiencys")
					PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61]; *)
					// clean up some arrays
					ARRAY REAL:C219(arNum1; 0)  //oop rate
					ARRAY TEXT:C222(aText; 0)  //cust/line
					//* -- print Summary report     
					FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])
					BREAK LEVEL:C302(1)
					SET WINDOW TITLE:C213("Printing Efficiencys Summary")
					ACCUMULATE:C303(rReal1; rReal3; rReal6; rReal13; [Job_Forms_Machine_Tickets:61]Run_Act:7; [Job_Forms_Machine_Tickets:61]MR_Act:6; [Job_Forms_Machine_Tickets:61]DownHrs:11)
					xReptTitle:="Efficiency Summary for "+$Div
					t3:="for Date Range: "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)
					util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "EfficiencySum")
					FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "EfficiencySum")
					PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61]; *)
				End if 
				//clean up all arrays created
				$Count:=0
				ARRAY REAL:C219(ayDown_Bud; $Count)
				ARRAY REAL:C219(arNum1; $Count)
				ARRAY TEXT:C222(aDesc; $Count)  //cc description
				ARRAY TEXT:C222(aText; $Count)
				FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "List")
			Else 
				ALERT:C41("No Machine Tickets foound for Date Range "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)+" and Division = "+$Div)
			End if 
		End if 
	Else 
		ALERT:C41("No Machine Tickets foound for Date Range "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd))
	End if 
End if 

uClearSelection(->[Job_Forms_Machine_Tickets:61])
uWinListCleanup
uWinListCleanup