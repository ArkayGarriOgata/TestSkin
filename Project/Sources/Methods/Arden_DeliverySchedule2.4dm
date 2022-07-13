//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/02/12, 12:25:03
// ----------------------------------------------------
// Method: Arden_DeliverySchedule2
// Description
// Change to file that was being sent, only interested in projected inventory
// row, and then only as it goes negative.
// Log any FG that are not in item master and ignore.
// Ignore if Status is not "A"ctive
// mlb 6/1/12 $make_aleast_one for every active item, optional
// ----------------------------------------------------

C_TEXT:C284($line; $errorMsg)
C_DATE:C307($today)
C_TEXT:C284(COMPARE_CUSTID)
C_TIME:C306($docRef)
C_BOOLEAN:C305($continue; $quit; $make_aleast_one; $none_found)
C_LONGINT:C283($t; $r; $i; $positionOfSkipHeadings; $positionOfRowType; $positionOfPASTDUE; $positionOfCPN; $countOfWeeks; $countOfColumns; $positionOfRunDate; $row; $col)

READ ONLY:C145([Finished_Goods:26])

$today:=4D_Current_date
COMPARE_CUSTID:="00074"
$errorMsg:=""
$quit:=True:C214
$continue:=True:C214
$r:=13  //Char(13)return

SET MENU BAR:C67(<>DefaultMenu)
READ WRITE:C146([Customers_ReleaseSchedules:46])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "just_created")
	
Else 
	
	ARRAY LONGINT:C221($_just_created; 0)
	
End if   // END 4D Professional Services : January 2019 

uConfirm("What delimiter is used in the import file?"; "Comma"; "Tab")
If (OK=1)
	$t:=44  //","
	$file_type:="'CSV'"
Else 
	$t:=9  //Char(9) tab
	$file_type:="'TXT'"
End if 

uConfirm("Import E.Arden Forecast "+$file_type+" document?"; "Yes"; "Cancel")
If (OK=1)
	//expectations:
	$positionOfSkipHeadings:=1
	$positionOfStatus:=6  // ignore if not A
	$positionOfRowType:=8  //projected inventory|Demand Consump|Confiremed PO
	$positionOfPASTDUE:=10
	$positionOfCPN:=4
	$countOfWeeks:=18  //includes weeks and the monthly brackets
	$countOfColumns:=$countOfWeeks+$positionOfPASTDUE
	$positionOfRunDate:=29
	
	Repeat 
		zwStatusMsg("IMPORT"; "Find an E.Arden Forecast "+$file_type+" document.")
		$docRef:=Open document:C264("")
		$continue:=($docRef#?00:00:00?)
		If ($continue)  //opened document
			zwStatusMsg("IMPORT"; "Reading "+document)
			
			$plant:=Request:C163("Enter the aMs ShipTo number:"; "00000"; "OK"; "Abort")
			If (OK=1) & (Length:C16($plant)=5)
				uConfirm("Delete prior forecasts to '"+$plant+"'"; "OK"; "Abort")
				If (OK=1)
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="<FDS>@"; *)  //only the forecasts
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=COMPARE_CUSTID; *)  //for liz arden
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10=$plant)  //at this shipto
					util_DeleteSelection(->[Customers_ReleaseSchedules:46])
					
					uConfirm("Make at least one release 'A'ctive items?"; "Make"; "Ignore")
					$make_aleast_one:=(OK=1)
					
				Else 
					$continue:=False:C215
				End if 
				
			Else 
				$continue:=False:C215
			End if 
			
			If ($continue)
				For ($row; 1; $positionOfSkipHeadings)  //role past the header row
					RECEIVE PACKET:C104($docRef; $line; Char:C90($r))
				End for 
				
				RECEIVE PACKET:C104($docRef; $line; Char:C90($r))  //get the begin date and period dates
				util_TextParser($countOfColumns; $line; $t; $r)
				$vendor:=txt_Trim(util_TextParser(1))
				$continue:=($vendor="303451")
			End if 
			
			If ($continue)  //our vendor id looks present -- load the week dates
				$version:=String:C10(Num:C11(util_TextParser($positionOfRunDate)); "000000")  //this is the date of the export given on the portal
				ARRAY DATE:C224($aWeek; $countOfWeeks)
				For ($col; 1; $countOfWeeks)  //get date titles
					$aWeek{$col}:=util_dateFrom_mmddyy(txt_Trim(util_TextParser($col+$positionOfPASTDUE)))
				End for 
				
				utl_LogIt("init")
				utl_LogIt("CPN's SKIPPED DURING IMPORT"; 1)
				SET QUERY LIMIT:C395(1)
				RECEIVE PACKET:C104($docRef; $line; Char:C90($r))
				While (OK=1)
					util_TextParser($countOfColumns; $line; $t; $r)
					If (Position:C15("PROJECTED INVENTORY"; util_TextParser($positionOfRowType))>0)  //interested in this row
						If (Position:C15("A"; util_TextParser($positionOfStatus))>0)  // still interested in this row
							$currentCPN:=util_TextParser($positionOfCPN)
							If (Substring:C12($currentCPN; 1; 1)=Char:C90(34))
								$currentCPN:=txt_Trim(Substring:C12($currentCPN; 2; 13))
							Else 
								$currentCPN:=txt_Trim(Substring:C12($currentCPN; 1; 13))
							End if 
							QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=(COMPARE_CUSTID+":"+$currentCPN))
							If (Records in selection:C76([Finished_Goods:26])=1)  // in the item master so deal with it
								$currentQty:=0
								$lastQty:=0
								$consumption:=0
								$none_found:=True:C214  //where gonna make at least one forecast for one carton
								
								For ($col; 1; $countOfWeeks)  //look for negative projected inventory and make release if found.
									$currentQty:=Num:C11(util_TextParser($col+$positionOfPASTDUE))
									If ($currentQty#$lastQty)
										If ($currentQty<0)
											If ($lastQty<0)
												$consumption:=$lastQty-$currentQty
											Else 
												$consumption:=(-$currentQty)
											End if 
											
											$none_found:=False:C215
											CREATE RECORD:C68([Customers_ReleaseSchedules:46])
											[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
											[Customers_ReleaseSchedules:46]Shipto:10:=$plant
											[Customers_ReleaseSchedules:46]ProductCode:11:=$currentCPN
											[Customers_ReleaseSchedules:46]CustomerLine:28:=[Finished_Goods:26]Line_Brand:15
											[Customers_ReleaseSchedules:46]Sched_Date:5:=$aWeek{$col}
											//[Customers_ReleaseSchedules]Sched_Date:=$aWeek{$i}-ADDR_getLeadTime ([Customers_ReleaseSchedules]Shipto)
											//[Customers_ReleaseSchedules]Sched_Date:=REL_NoWeekEnds ([Customers_ReleaseSchedules]Sched_Date)  // • mel (6/22/05, 17:08:14)
											[Customers_ReleaseSchedules:46]Sched_Qty:6:=$consumption
											[Customers_ReleaseSchedules:46]CustomerRefer:3:="<FDS>"+$version
											[Customers_ReleaseSchedules:46]EDI_Disposition:36:=$version
											[Customers_ReleaseSchedules:46]OpenQty:16:=$consumption
											[Customers_ReleaseSchedules:46]CustID:12:=COMPARE_CUSTID
											[Customers_ReleaseSchedules:46]Entered_Date:34:=$today
											[Customers_ReleaseSchedules:46]ModDate:18:=$today
											[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
											[Customers_ReleaseSchedules:46]CreatedBy:46:="EADF"
											[Customers_ReleaseSchedules:46]THC_State:39:=9
											[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Finished_Goods:26]ProjectNumber:82
											SAVE RECORD:C53([Customers_ReleaseSchedules:46])
											If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
												
												ADD TO SET:C119([Customers_ReleaseSchedules:46]; "just_created")
												
											Else 
												
												APPEND TO ARRAY:C911($_just_created; Record number:C243([Customers_ReleaseSchedules:46]))
												
											End if   // END 4D Professional Services : January 2019 
											
										End if 
									End if 
									$lastQty:=$currentQty
								End for 
								
								If ($none_found) & ($make_aleast_one)
									CREATE RECORD:C68([Customers_ReleaseSchedules:46])
									[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
									[Customers_ReleaseSchedules:46]Shipto:10:=$plant
									[Customers_ReleaseSchedules:46]ProductCode:11:=$currentCPN
									[Customers_ReleaseSchedules:46]CustomerLine:28:=[Finished_Goods:26]Line_Brand:15
									[Customers_ReleaseSchedules:46]Sched_Date:5:=$aWeek{$countOfWeeks}
									//[Customers_ReleaseSchedules]Sched_Date:=$aWeek{$i}-ADDR_getLeadTime ([Customers_ReleaseSchedules]Shipto)
									//[Customers_ReleaseSchedules]Sched_Date:=REL_NoWeekEnds ([Customers_ReleaseSchedules]Sched_Date)  // • mel (6/22/05, 17:08:14)
									[Customers_ReleaseSchedules:46]Sched_Qty:6:=1
									[Customers_ReleaseSchedules:46]CustomerRefer:3:="<FDS>"+$version+" place_holder"
									[Customers_ReleaseSchedules:46]EDI_Disposition:36:=$version
									[Customers_ReleaseSchedules:46]OpenQty:16:=1
									[Customers_ReleaseSchedules:46]CustID:12:=COMPARE_CUSTID
									[Customers_ReleaseSchedules:46]Entered_Date:34:=$today
									[Customers_ReleaseSchedules:46]ModDate:18:=$today
									[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
									[Customers_ReleaseSchedules:46]CreatedBy:46:="EADF"
									[Customers_ReleaseSchedules:46]THC_State:39:=-1
									[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Finished_Goods:26]ProjectNumber:82
									SAVE RECORD:C53([Customers_ReleaseSchedules:46])
									If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
										
										ADD TO SET:C119([Customers_ReleaseSchedules:46]; "just_created")
										
									Else 
										
										APPEND TO ARRAY:C911($_just_created; Record number:C243([Customers_ReleaseSchedules:46]))
										
									End if   // END 4D Professional Services : January 2019 
								End if 
								
							Else   //log it
								utl_LogIt($currentCPN+"   "+util_TextParser(3))
							End if 
						End if 
					End if 
					
					RECEIVE PACKET:C104($docRef; $line; Char:C90($r))
				End while 
				
				SET QUERY LIMIT:C395(0)
				utl_LogIt("show")
				
			Else 
				$errorMsg:=$errorMsg+"Mapping Not Correct "+"Vendor number in column 1 should be 303451"+Char:C90(13)
			End if   //mapping correct
			
			zwStatusMsg("IMPORT"; "Closing "+document)
			CLOSE DOCUMENT:C267($docRef)
			BEEP:C151
			
		Else   //no document
			$errorMsg:=$errorMsg+"Document Not Opened"+Char:C90(13)
		End if   //*****
	Until ($quit) | (Not:C34($continue))
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		USE SET:C118("just_created")
		CLEAR SET:C117("just_created")
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_just_created)
		
	End if   // END 4D Professional Services : January 2019 
	
	pattern_PassThru(->[Customers_ReleaseSchedules:46])
	ViewSetter(2; ->[Customers_ReleaseSchedules:46])
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
End if   //do the import