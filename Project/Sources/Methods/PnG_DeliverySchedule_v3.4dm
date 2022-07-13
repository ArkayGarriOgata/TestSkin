//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date: 07/16/13
// ----------------------------------------------------
// Method: PnG_DeliverySchedule_v3
// Description
// Read in a downloaded DeliverySchedule Doc FROM PORTAL and compare to Releases.
// Open html file with Excel and save it as Tab Delimited Text. This is the file needed for 4D.
// Copy the nbsp and use that for the replace command. Replace the nbsp with a normal space.
// This is important!
// ----------------------------------------------------
/////*******
/////*******
/////*******
/////*******  ` Modified by: Mel Bohince (1/30/14) proofread
///// Quantities are twisted and shipto is hardcoded incorrectly /////
/////*******
/////*******
/////*******
/////*******

C_TEXT:C284($tLine; $tName; COMPARE_CUSTID; $tCurrentCPN; $tDelivHeader; $tPnGPlant)
C_LONGINT:C283($i)
C_BOOLEAN:C305($bContinue; $bQuit; $bMakeRelease)
C_DATE:C307($dVersion; $dDate)
C_TIME:C306($hDocRef)
ARRAY TEXT:C222(atNames; 0)

READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ WRITE:C146([Finished_Goods:26])

COMPARE_CUSTID:="00199"

SET MENU BAR:C67(<>DefaultMenu)
$dVersion:=4D_Current_date
$bQuit:=True:C214

CenterWindow(475; 770; 4+2048; "Instructions")
DIALOG:C40([zz_control:1]; "TextFileInstructions")
CLOSE WINDOW:C154

If (bYes=1)
	Repeat 
		$tName:=Select document:C905(""; ".txt"; "Please open one tab delimited text file."; 16; atNames)
		If (OK=1)
			$hDocRef:=Open document:C264(atNames{1}; Read mode:K24:5)
		End if 
		
		If ($hDocRef#?00:00:00?)
			$i:=1
			Repeat 
				RECEIVE PACKET:C104($hDocRef; $tLine; <>CR)  //this should be the column headings
				util_TextParser(20; $tLine; Character code:C91(<>TB); 13)
				$tDelivHeader:=util_TextParser(1)
				$i:=$i+1
			Until ((Position:C15("Deliv.date"; $tDelivHeader)>0) | (Position:C15("Deliv. date"; $tDelivHeader)>0) | ($tLine=""))  // Added by: Mark Zinke (1/16/14) 
			//RECEIVE PACKET($hDocRef;$tLine;<>CR)  //Blank line // Modified by: Mark Zinke (1/16/14) Removed
			
			If ($tLine#"")  //Header is good
				$tPnGPlant:="02033"  //Swing, always. No need to test for it.
				
				//Clear prior imports
				$bMakeRelease:=False:C215
				
				READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
				QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8=$tPnGPlant)
				If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])>0)
					uConfirm("Delete the prior import of plant# "+$tPnGPlant+" ?"; "Delete"; "Skip Import")
					If (OK=1)
						util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145]; "*")
						QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8="")
						util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145]; "*")
						$bContinue:=True:C214
					End if 
				Else   //no priors
					OK:=1
					$bContinue:=True:C214
				End if 
				
				uConfirm("Make release record?"; "Release"; "No")
				If (OK=1)
					$bMakeRelease:=True:C214
					//delete the prior releases
					READ WRITE:C146([Customers_ReleaseSchedules:46])
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="02033"; *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3="<F@"; *)  //don't want to hit any <BUFFER>'s
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						util_DeleteSelection(->[Customers_ReleaseSchedules:46]; "*")
					End if 
				End if 
				
				If (OK=1) & ($bContinue)
					ARRAY TEXT:C222($atCPN; 0)  //Column 4
					ARRAY DATE:C224($adSchd; 0)  //Column 1
					ARRAY LONGINT:C221($axlQty; 0)  //Column 12
					ARRAY LONGINT:C221($axlQtyOrd; 0)  //Column 10
					ARRAY LONGINT:C221($axlQtyRec; 0)  //Column 11
					ARRAY TEXT:C222($atRefer; 0)  //Column 5
					ARRAY DATE:C224($adAsOf; 0)  //Current date
					ARRAY TEXT:C222($atPnGPlanner; 0)  //Not supplied, use blanks.
					ARRAY TEXT:C222($atSkippedCPNs; 0)
					ARRAY DATE:C224($adLastUpdate; 0)  // Added by: Mark Zinke (1/16/14) 
					uThermoInit(200; "Importing from "+Document)
					$xlThermo:=0
					
					utl_LogIt("init")
					utl_LogIt("CPN's SKIPPED DURING IMPORT"; 1)
					SET QUERY LIMIT:C395(1)
					
					RECEIVE PACKET:C104($hDocRef; $tLine; <>CR)  //Get the first row.
					util_TextParser(20; $tLine; Character code:C91(<>TB); 13)
					While (Length:C16($tLine)>0)
						$tCurrentCPN:=util_TextParser(4)
						If ((Position:C15(" "; $tCurrentCPN)=0) & ($tCurrentCPN#"") & ($tCurrentCPN#"Material"))  //Ignore CPNs with spaces in them.
							QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=(COMPARE_CUSTID+":"+$tCurrentCPN))
							If (Records in selection:C76([Finished_Goods:26])=1)
								$dDate:=Date:C102(Substring:C12(util_TextParser(1); 1; 10))
								If ($dDate#!00-00-00!)
									APPEND TO ARRAY:C911($adSchd; $dDate)
								Else 
									APPEND TO ARRAY:C911($adSchd; $dSchDate)
								End if 
								If ($dDate#!00-00-00!)
									$dSchDate:=$dDate  //Store it for use in the blank lines.
								End if 
								APPEND TO ARRAY:C911($atCPN; $tCurrentCPN)
								APPEND TO ARRAY:C911($atRefer; util_TextParser(5)+"."+util_TextParser(6))
								If (util_TextParser(3)="P")  //Planned vs Firm
									$atRefer{Size of array:C274($atRefer)}:="<FDS>"+$atRefer{Size of array:C274($atRefer)}
								End if 
								
								APPEND TO ARRAY:C911($axlQtyOrd; Num:C11(util_TextParser(10)))
								APPEND TO ARRAY:C911($axlQtyRec; Num:C11(util_TextParser(11)))
								APPEND TO ARRAY:C911($axlQty; Num:C11(util_TextParser(12)))
								$tTemp:=Substring:C12(util_TextParser(18); 1; 10)  //This is in DD.MM.YYYY format needs to be in MM.DD.YYYY. // Added by: Mark Zinke (1/16/14) 
								$tTemp1:=Substring:C12($tTemp; 4; 2)+"/"+Substring:C12($tTemp; 1; 2)+"/"+Substring:C12($tTemp; 7)  // Added by: Mark Zinke (1/16/14) 
								APPEND TO ARRAY:C911($adLastUpdate; Date:C102($tTemp1))  // Added by: Mark Zinke (1/16/14) 
								APPEND TO ARRAY:C911($atPnGPlanner; "")
								APPEND TO ARRAY:C911($adAsOf; 4D_Current_date)
								
							Else   //Skipped
								If (Find in array:C230($atSkippedCPNs; $tCurrentCPN)=-1)
									APPEND TO ARRAY:C911($atSkippedCPNs; $tCurrentCPN)
									utl_LogIt($tCurrentCPN+"   "+util_TextParser(3))
								End if 
							End if 
							
							RECEIVE PACKET:C104($hDocRef; $tLine; <>CR)  //Get next line
							util_TextParser(20; $tLine; Character code:C91(<>TB); 13)
							$xlThermo:=$xlThermo+1
							
						Else 
							RECEIVE PACKET:C104($hDocRef; $tLine; <>CR)  //Get next line
							util_TextParser(20; $tLine; Character code:C91(<>TB); 13)
						End if 
						uThermoUpdate($xlThermo)
					End while 
					
					SET QUERY LIMIT:C395(0)
					If (Size of array:C274($atSkippedCPNs)>0)
						utl_LogIt("show")
					End if 
					
					MULTI SORT ARRAY:C718($atCPN; >; $adSchd; >; $axlQty; $axlQtyOrd; $axlQtyRec; $atRefer; $adAsOf; $atPnGPlanner; $adLastUpdate)  // Added by: Mark Zinke (1/16/14) Added $adLastUpdate
					
					ARRAY TEXT:C222($atID; 0)
					ARRAY TEXT:C222($atPlant; 0)
					ARRAY TEXT:C222($atCustID; 0)
					ARRAY TEXT:C222($atAsOf; 0)
					
					C_LONGINT:C283($i; $xlNumElements)
					$xlNumElements:=Size of array:C274($atCPN)
					For ($i; 1; $xlNumElements)  //Set the plant and cust id's
						APPEND TO ARRAY:C911($atID; String:C10($i; "00000"))
						APPEND TO ARRAY:C911($atPlant; $tPnGPlant)
						APPEND TO ARRAY:C911($atCustID; COMPARE_CUSTID)
						APPEND TO ARRAY:C911($atAsOf; String:C10($adAsOf{$i}))
					End for 
					$xlThermo:=$xlThermo+((200-$xlThermo)/2)
					uThermoUpdate($xlThermo)
					
					REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
					ARRAY TO SELECTION:C261($atID; [Finished_Goods_DeliveryForcasts:145]id:1; $atCPN; [Finished_Goods_DeliveryForcasts:145]ProductCode:2; $adSchd; [Finished_Goods_DeliveryForcasts:145]DateDock:4; $axlQty; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; $atRefer; [Finished_Goods_DeliveryForcasts:145]refer:3; $atPlant; [Finished_Goods_DeliveryForcasts:145]ShipTo:8; $atAsOf; [Finished_Goods_DeliveryForcasts:145]asOf:9; $axlQtyOrd; [Finished_Goods_DeliveryForcasts:145]QtyWanted:5; $axlQtyRec; [Finished_Goods_DeliveryForcasts:145]QtyReceived:6; $atCustID; [Finished_Goods_DeliveryForcasts:145]Custid:12)
					$xlThermo:=$xlThermo+1
					//PnG_DeliveryScheduleCompare 
					$xlThermo:=200
					uThermoUpdate($xlThermo)
					uThermoClose
					
					PnP_setFGowner
					
					If ($bMakeRelease)
						For ($i; 1; $xlNumElements)  //set the plant and cust id's
							CREATE RECORD:C68([Customers_ReleaseSchedules:46])
							[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
							[Customers_ReleaseSchedules:46]Shipto:10:=$atPlant{$i}
							[Customers_ReleaseSchedules:46]ProductCode:11:=$atCPN{$i}
							QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=(COMPARE_CUSTID+":"+$atCPN{$i}))
							[Customers_ReleaseSchedules:46]CustomerLine:28:=[Finished_Goods:26]Line_Brand:15
							[Customers_ReleaseSchedules:46]Sched_Date:5:=$adSchd{$i}
							[Customers_ReleaseSchedules:46]Sched_Qty:6:=$axlQty{$i}
							[Customers_ReleaseSchedules:46]CustomerRefer:3:=$atRefer{$i}
							If (Position:C15("<"; $atRefer{$i})=0)  //They are to always be forecasts
								[Customers_ReleaseSchedules:46]CustomerRefer:3:="<FDS>"+$atRefer{$i}
							End if 
							[Customers_ReleaseSchedules:46]Expedite:35:="Imported"
							[Customers_ReleaseSchedules:46]EDI_Disposition:36:=$atPnGPlanner{$i}+"-"+String:C10($adAsOf{$i})
							[Customers_ReleaseSchedules:46]OpenQty:16:=$axlQty{$i}
							[Customers_ReleaseSchedules:46]CustID:12:=$atCustID{$i}
							[Customers_ReleaseSchedules:46]Entered_Date:34:=$dVersion
							[Customers_ReleaseSchedules:46]ModDate:18:=$dVersion
							[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
							[Customers_ReleaseSchedules:46]CreatedBy:46:="PORT"
							[Customers_ReleaseSchedules:46]THC_State:39:=9
							[Customers_ReleaseSchedules:46]Entered_Date:34:=$adLastUpdate{$i}  // Added by: Mark Zinke (1/16/14) 
							[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Finished_Goods:26]ProjectNumber:82
							SAVE RECORD:C53([Customers_ReleaseSchedules:46])
						End for 
						UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
						UNLOAD RECORD:C212([Finished_Goods:26])
						
					End if 
					
				End if 
				CLOSE DOCUMENT:C267($hDocRef)
				BEEP:C151
			End if 
			
			uConfirm("Import another file?"; "Done"; "Another")
			If (OK=1)
				$bQuit:=True:C214
			Else 
				$bQuit:=False:C215
			End if 
			
		Else 
			uConfirm("File not opened?"; "Done"; "Try again")
			If (OK=1)
				$bQuit:=True:C214
			Else 
				$bQuit:=False:C215
			End if 
		End if   //doc opened
	Until ($bQuit)
	
	REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
End if 