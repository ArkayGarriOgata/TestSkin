//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/25/08, 15:47:17
// ----------------------------------------------------
// Method: Arden_DeliverySchedule
// ----------------------------------------------------
// based on: PnG_DeliverySchedule () -> 
// ----------------------------------------------------

READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ WRITE:C146([Finished_Goods:26])
C_TEXT:C284($line)

COMPARE_CUSTID:="00074"
C_TIME:C306($docRef)
C_TEXT:C284($errorMsg)
$errorMsg:=""
C_BOOLEAN:C305($continue; $validateFG; $quit)
$quit:=True:C214
$continue:=True:C214
C_TEXT:C284($period)  //fYYYYMM
C_TEXT:C284($t; $r)
$t:=Char:C90(9)
$r:=Char:C90(13)
C_LONGINT:C283($validFG; $i; $countRows; $positionUnderscore; $positionOfSkipHeadings; $positionOfRowType; $positionOfWeeklyDates; $positionOfCPN; $countOfWeeks; $countOfColumns; $row; $col)
ARRAY TEXT:C222($aSkippedCPNs; 0)
ARRAY TEXT:C222($aSkippedLines; 0)

SET MENU BAR:C67(<>DefaultMenu)
uConfirm("Import E.Arden Forecast 'text' document with dates formated?"; "Yes"; "Cancel")
If (OK=1)
	uConfirm("Import only 'known' Finished Goods?"; "Known"; "All")
	If (OK=1)
		$validateFG:=True:C214
	Else 
		$validateFG:=False:C215
	End if 
	
	//expectations:
	$positionOfSkipHeadings:=5
	$positionOfRowType:=8
	$positionOfWeeklyDates:=9
	$positionOfCPN:=3
	$countOfWeeks:=35  //includes pastdue and the monthly brackets
	$countOfColumns:=$countOfWeeks+$positionOfWeeklyDates
	
	Repeat 
		zwStatusMsg("IMPORT"; "Find an E.Arden Forecast 'text' document with dates formated?")
		$docRef:=Open document:C264("")
		$continue:=($docRef#?00:00:00?)
		If ($continue)  //opened document
			zwStatusMsg("IMPORT"; "Reading "+document)
			$positionUnderscore:=Position:C15("_"; document)
			$docName:=Substring:C12(document; $positionUnderscore+1)  //strip off /path/to/doc/Arkay_
			$positionUnderscore:=Position:C15("_"; $docName)
			$plant:=Substring:C12($docName; 1; $positionUnderscore-1)  //US or EUR
			$version:=Substring:C12($docName; $positionUnderscore+1; 6)  //date string
			
			For ($i; 1; $positionOfSkipHeadings)  //role past the header stuff
				RECEIVE PACKET:C104($docRef; $line; $r)
			End for 
			
			RECEIVE PACKET:C104($docRef; $line; $r)
			util_TextParser($countOfColumns; $line)
			$continue:=(util_TextParser($positionOfWeeklyDates)="Weekly Dates")  //mapping correct
			If ($continue)  //load the week dates
				ARRAY TEXT:C222($aWeek; $countOfWeeks)
				For ($i; 1; $countOfWeeks)  //get date titles
					$aWeek{$i}:=util_TextParser($i+$positionOfWeeklyDates)
					If ($i=2)
						$validDate:=Date:C102($aWeek{$i})
						If ($validDate=!00-00-00!)  //not formated correctly, probably 23-Mar-08
							$continue:=False:C215
							$errorMsg:=$errorMsg+"Date Format Not Correct; "+Char:C90(13)+"Change to MM/YY/YY not DD-MMM-YY"+Char:C90(13)
						End if 
					End if 
				End for 
				If ($continue)
					ARRAY LONGINT:C221($aQty; 0; 0)
					ARRAY TEXT:C222($aCPN; 0)
					ARRAY TEXT:C222($aLine; 0)
					//dump the titles row
					RECEIVE PACKET:C104($docRef; $line; $r)
					
					//put the data into arrays 
					RECEIVE PACKET:C104($docRef; $line; $r)  //this row is the "Projected Inventory", hopefully
					$continue:=(OK=1)  //got an important row
					$currentBrand:=""
					$currentCPN:=""
					$rowCursor:=0
					While ($continue)  //going to come in groups of 4 lines per cpn
						
						util_TextParser($countOfColumns; $line)
						$continue:=(util_TextParser($positionOfRowType)="Projected Inventory")  //mapping correct
						If ($continue)  //real good chance we're on the right row
							$thisCPN:=util_TextParser($positionOfCPN)
							If ($thisCPN#$currentCPN) & (Length:C16($thisCPN)>0)  //this row is the "Projected Inventory"
								$thisBrand:=Substring:C12(util_TextParser($positionOfCPN-1); 1; 20)
								If (Length:C16($thisBrand)>0)  //they don't repeat the brand
									$currentBrand:=$thisBrand
								End if 
								$currentCPN:=Substring:C12($thisCPN; 1; 20)
								
								RECEIVE PACKET:C104($docRef; $line; $r)  //bingo!   this row is the "Demand Consumption"
								
								util_TextParser($countOfColumns; $line)
								$rowCursor:=$rowCursor+1
								APPEND TO ARRAY:C911($aCPN; $currentCPN)
								APPEND TO ARRAY:C911($aLine; $currentBrand)
								INSERT IN ARRAY:C227($aQty; $rowCursor; 1)
								INSERT IN ARRAY:C227($aQty{$rowCursor}; 1; $countOfWeeks)
								For ($i; 1; $countOfWeeks)  //fill the columns
									$qtyValue:=util_TextParser($positionOfWeeklyDates+$i)
									$aQty{$rowCursor}{$i}:=Num:C11($qtyValue)
								End for 
								
							End if 
							
							RECEIVE PACKET:C104($docRef; $line; $r)  //this row is the "Confirmed Purchase Orders"
							RECEIVE PACKET:C104($docRef; $line; $r)  // this row is the "Firm/Material/Suggested Req"
							
							
							RECEIVE PACKET:C104($docRef; $line; $r)  //this row should be the "Projected Inventory"
							$continue:=(OK=1)
							
						Else 
							$errorMsg:=$errorMsg+"Mapping Not Correct "+"'Projected Inventory' Missing in cell H8"+Char:C90(13)
						End if 
						
					End while 
					
				End if   //date format OK
				
			Else 
				$errorMsg:=$errorMsg+"Mapping Not Correct "+"Weekly Dates' Missing In cell I9"+Char:C90(13)
			End if   //mapping correct
			
			zwStatusMsg("IMPORT"; "Closing "+document)
			CLOSE DOCUMENT:C267($docRef)
			BEEP:C151
			
			
			If (Length:C16($errorMsg)=0)  //delete prior forecasts
				READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
				QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8=$plant)
				If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])>0)
					uConfirm("Delete the prior import of plant called "+$plant+" ?"; "Delete"; "Skip Import")
					If (OK=1)
						zwStatusMsg("DELETING"; String:C10(Records in selection:C76([Finished_Goods_DeliveryForcasts:145]))+" prior forecasts")
						util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145]; "*")
						QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8="")
						util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145]; "*")
						$continue:=True:C214
					Else 
						$continue:=False:C215
						$errorMsg:=$errorMsg+"Prior Forecasts Not Deleted "+Char:C90(13)
					End if 
				Else 
					$continue:=True:C214
				End if 
			End if 
			
			
			If ($continue) & (Length:C16($errorMsg)=0)
				$countRows:=Size of array:C274($aCPN)
				$week28:=Date:C102($aWeek{29})-2  //they schedule for Sunday, so back it up to Friday
				$pastDue:=Date:C102($aWeek{2})-2-7
				uThermoInit($countRows; "Importing Arden DelFor")
				For ($row; 1; $countRows)
					uThermoUpdate($row)
					For ($col; 1; $countOfWeeks)
						If ($aQty{$row}{$col}>0)
							Case of 
								: (Position:C15("/"; $aWeek{$col})>0)
									$dateScheduled:=Date:C102($aWeek{$col})-2
								: (Position:C15("Past"; $aWeek{$col})>0)
									$dateScheduled:=$pastDue
								: (Position:C15("29"; $aWeek{$col})>0)
									$dateScheduled:=$week28+7
								: (Position:C15("34"; $aWeek{$col})>0)
									$dateScheduled:=$week28+(7*6)
								: (Position:C15("39"; $aWeek{$col})>0)
									$dateScheduled:=$week28+(7*11)
								: (Position:C15("44"; $aWeek{$col})>0)
									$dateScheduled:=$week28+(7*16)
								: (Position:C15("49"; $aWeek{$col})>0)
									$dateScheduled:=$week28+(7*21)
								: (Position:C15("Beyond"; $aWeek{$col})>0)
									$dateScheduled:=$week28+(7*26)
								Else 
									$dateScheduled:=$week28+(7*31)
							End case 
							
							If ($validateFG)  //test if in fg table
								$hit:=Find in array:C230($aSkippedCPNs; $aCPN{$row})  //check the cache
								If ($hit>-1)
									$validFG:=0
								Else 
									$validFG:=qryFinishedGood("00074"; $aCPN{$row})
									If ($validFG=0)
										APPEND TO ARRAY:C911($aSkippedCPNs; $aCPN{$row})
										APPEND TO ARRAY:C911($aSkippedLines; $aLine{$row})
									End if 
								End if 
							Else   //don't validate
								$validFG:=1
							End if 
							
							If ($validFG>0)
								CREATE RECORD:C68([Finished_Goods_DeliveryForcasts:145])
								[Finished_Goods_DeliveryForcasts:145]id:1:=String:C10($row; "000")+String:C10($col; "00")
								[Finished_Goods_DeliveryForcasts:145]ProductCode:2:=$aCPN{$row}
								[Finished_Goods_DeliveryForcasts:145]DateDock:4:=$dateScheduled
								[Finished_Goods_DeliveryForcasts:145]QtyOpen:7:=$aQty{$row}{$col}
								[Finished_Goods_DeliveryForcasts:145]refer:3:="<FDS>"+$plant+" "+$aWeek{$col}
								[Finished_Goods_DeliveryForcasts:145]ShipTo:8:=$plant
								[Finished_Goods_DeliveryForcasts:145]asOf:9:=$version
								[Finished_Goods_DeliveryForcasts:145]QtyWanted:5:=$aQty{$row}{$col}
								[Finished_Goods_DeliveryForcasts:145]QtyReceived:6:=0
								[Finished_Goods_DeliveryForcasts:145]Custid:12:="00074"
								SAVE RECORD:C53([Finished_Goods_DeliveryForcasts:145])
							End if 
						End if 
					End for 
				End for 
				uThermoClose
				
				REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
				
			End if   //no document
			
			If ($continue)
				uConfirm("Import another file?"; "Done"; "Another")
				If (OK=1)
					$quit:=True:C214
				Else 
					$quit:=False:C215
				End if 
			End if 
			
		Else   //no document
			$errorMsg:=$errorMsg+"Document Not Opened"+Char:C90(13)
		End if   //*****
	Until ($quit) | (Not:C34($continue))
	
	If (Length:C16($errorMsg)>0)
		BEEP:C151
		uConfirm($errorMsg; "OK"; "Help")
	End if 
	
	If (Size of array:C274($aSkippedCPNs)>0)  //show what was skipped
		utl_LogIt("init")
		utl_LogIt("CPN's SKIPPED DURING IMPORT"; 1)
		For ($i; 1; Size of array:C274($aSkippedCPNs))
			utl_LogIt($aSkippedCPNs{$i}+" "+$aSkippedLines{$i}; 1)
		End for 
		utl_LogIt("show")
	End if 
	
	REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
End if   //do the import
