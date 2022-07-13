//%attributes = {}
// Method: PnG_DeliverySchedule_v2
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 04/19/12, 16:19:08
// ----------------------------------------------------
// Description
// read in a downloaded DeliverySchedule Doc FROM PORTAL and compare to Releases
// new version doesn't have a header section and columns are a bit different
// ----------------------------------------------------
// Modified by: Mel Bohince (1/21/14) clean out embedded commas and fix last update date if from BRown
// Modified by: Mel Bohince (5/10/16) don't fix Browns date and offer to make releases for all plants
// Modified by: Mel Bohince (5/20/16) with cayey 1666 gone, do its spl things to brown summit 02439

READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ WRITE:C146([Finished_Goods:26])
C_TEXT:C284($line; $columnHeaders)
C_TEXT:C284(COMPARE_CUSTID)
C_TIME:C306($docRef)
C_DATE:C307($version)
C_TEXT:C284($period)  //fYYYYMM
C_BOOLEAN:C305($continue)
C_TEXT:C284($currentCPN)
C_TEXT:C284($t; $r)

$columnHeaders:="Deliv. Date,Deliv. Time,Z1,Product,Ch/ Nw,Order Doc. No.,Item No.,SL No.,Prod.Desc.,Unit of Measure,Document Qty.,Notified Qty.,Delivered Qty.,Due Qty.,Plant Desc.,P&G MRP Controller,Last Updated,Ship-From Loc.,Ship-To Loc."
COMPARE_CUSTID:="00199"
$version:=4D_Current_date
$t:=","
$r:=Char:C90(13)
$eol:=Char:C90(10)
$quit:=True:C214

SET MENU BAR:C67(<>DefaultMenu)

Repeat 
	$docRef:=Open document:C264("")
	If ($docRef#?00:00:00?)
		//check if the column headers look rite
		RECEIVE PACKET:C104($docRef; $line; $eol)  //this should be the column headings
		$line:=util_text_CSV_cleaner($line)  // Modified by: Mel Bohince (1/21/14) clean out embedded commas and fix last update date if from BRown
		util_TextParser(20; $line; Character code:C91($t); Character code:C91($r))
		$delivery_date_header:=util_TextParser(1)
		If (Position:C15("Deliv"; $delivery_date_header)>0)  //looks like a header
			$continue:=True:C214
			$ib_delv_qty_col:=util_TextParser(13)
			If (Position:C15("IB"; $ib_delv_qty_col)>0)  //hunt valley has no IB qty col, others seem to have it.
				$delivery_qty_col:=14
			Else 
				$delivery_qty_col:=13
			End if 
			
		Else 
			uConfirm("Are these headings? "+$line; "Yes"; "No")
			If (OK=1)
				$continue:=True:C214
				uConfirm("Which column is titled 'Delivered Qty'"; "14"; "13")
				If (OK=1)
					$delivery_qty_col:=14
				Else 
					$delivery_qty_col:=13
				End if 
				
			Else 
				$continue:=False:C215
			End if 
		End if 
		
		If ($continue)  //header are good
			//determine which plant this import is from based on first data row
			$PnG_Plant:=""
			RECEIVE PACKET:C104($docRef; $line; $eol)
			$line:=util_text_CSV_cleaner($line)  // Modified by: Mel Bohince (1/21/14) clean out embedded commas and fix last update date if from BRown
			util_TextParser(20; $line; Character code:C91($t); Character code:C91($r))
			$PnG_Plant:=util_TextParser($delivery_qty_col+2)
			
			Case of   //convert to ams address id
				: (Position:C15("cayey"; $PnG_Plant)>0)
					$PnG_Plant:="01666"
				: (Position:C15("belle"; $PnG_Plant)>0)
					$PnG_Plant:="02284"
				: (Position:C15("swing"; $PnG_Plant)>0)
					$PnG_Plant:="02033"
				: (Position:C15("brown"; $PnG_Plant)>0)
					$PnG_Plant:="02439"
				: (Position:C15("iowa"; $PnG_Plant)>0)
					$PnG_Plant:="02620"
				: (Position:C15("hunt"; $PnG_Plant)>0)
					$PnG_Plant:="04475"
				Else 
					$PnG_Plant:=Request:C163("Which plant? belle swing brown iowa hunt Greensboro"; "brown"; "Ok"; "Cancel")  // • mel (2/3/11) allow plant name to be entered if not on csv file
					Case of 
						: (Position:C15("cayey"; $PnG_Plant)>0)
							$PnG_Plant:="01666"
						: (Position:C15("belle"; $PnG_Plant)>0)
							$PnG_Plant:="02284"
						: (Position:C15("swing"; $PnG_Plant)>0)
							$PnG_Plant:="02033"
						: (Position:C15("brown"; $PnG_Plant)>0)
							$PnG_Plant:="02439"
						: (Position:C15("iowa"; $PnG_Plant)>0)
							$PnG_Plant:="02620"
						: (Position:C15("hunt"; $PnG_Plant)>0)
							$PnG_Plant:="04475"
						Else 
							$PnG_Plant:="ABORT"
							$continue:=False:C215
					End case 
			End case 
			
			//clear prior imports
			$make_release:=False:C215
			
			READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
			QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8=$PnG_Plant)
			If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])>0)
				uConfirm("Delete the prior import of plant# "+$PnG_Plant+" ?"; "Delete"; "Skip Import")
				If (OK=1)
					util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145]; "*")
					QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8="")
					util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145]; "*")
					$continue:=True:C214
				End if 
			Else   //no priors
				OK:=1
				$continue:=True:C214
			End if 
			
			If ($PnG_Plant="02439")
				uConfirm("Make release record?"; "Add Release"; "No")
				If (OK=1)
					$make_release:=True:C214
					//delete the prior releases forecasts
					READ WRITE:C146([Customers_ReleaseSchedules:46])
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="02439"; *)
					//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]Expedite="Imported";*)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3="<F@"; *)  //don't want to hit any <BUFFER>'s
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						util_DeleteSelection(->[Customers_ReleaseSchedules:46]; "*")
					End if 
				End if 
				
			End if 
			
			If (OK=1) & ($continue)
				$currentSize:=300  //create buffers
				ARRAY TEXT:C222($cpn; $currentSize)
				ARRAY DATE:C224($schd; $currentSize)
				ARRAY LONGINT:C221($qty; $currentSize)
				ARRAY LONGINT:C221($qtyOrd; $currentSize)
				ARRAY LONGINT:C221($qtyRec; $currentSize)
				ARRAY TEXT:C222($refer; $currentSize)
				ARRAY TEXT:C222($asOf; $currentSize)
				ARRAY TEXT:C222($PnG_planner; $currentSize)  //:=util_TextParser (16)
				C_LONGINT:C283($cursor)
				$cursor:=0  //got the first line up above
				uThermoInit(200; "Importing from "+document)
				$thermo:=0
				
				utl_LogIt("init")
				utl_LogIt("CPN's SKIPPED DURING IMPORT"; 1)
				ARRAY TEXT:C222($aSkippedCPNs; 0)
				SET QUERY LIMIT:C395(1)
				
				While (Length:C16($line)>0)
					$currentCPN:=util_TextParser(4)
					QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=(COMPARE_CUSTID+":"+$currentCPN))
					If (Records in selection:C76([Finished_Goods:26])=1)
						$cursor:=$cursor+1
						$schd{$cursor}:=Date:C102(Substring:C12(util_TextParser(1); 1; 10))
						$cpn{$cursor}:=$currentCPN
						$refer{$cursor}:=util_TextParser(6)+"."+util_TextParser(7)+"."+util_TextParser(8)
						If (util_TextParser(3)="P")  //planned vs firm
							$refer{$cursor}:="<FDS>"+$refer{$cursor}
						End if 
						
						$qtyOrd{$cursor}:=Num:C11(util_TextParser(11))
						$qtyRec{$cursor}:=Num:C11(util_TextParser($delivery_qty_col))
						$qty{$cursor}:=Num:C11(util_TextParser($delivery_qty_col+1))
						$PnG_planner{$cursor}:=util_TextParser($delivery_qty_col+3)
						If (False:C215)  //$PnG_Plant="02439")  // Modified by: Mel Bohince (1/21/14) clean out embedded commas and fix last update date if from BRown
							$fuckedUpDate:=util_TextParser($delivery_qty_col+4)
							$asOf{$cursor}:=Substring:C12($fuckedUpDate; 4; 2)+"/"+Substring:C12($fuckedUpDate; 1; 2)+"/"+Substring:C12($fuckedUpDate; 9; 2)
						Else 
							$asOf{$cursor}:=Substring:C12(util_TextParser($delivery_qty_col+4); 1; 8)
						End if 
						
					Else   //skipped
						$hit:=Find in array:C230($aSkippedCPNs; $currentCPN)
						If ($hit=-1)
							APPEND TO ARRAY:C911($aSkippedCPNs; $currentCPN)
							utl_LogIt($currentCPN+"   "+util_TextParser(3))
						End if 
					End if   //in f/g item master
					
					//get next line
					RECEIVE PACKET:C104($docRef; $line; $eol)
					$line:=util_text_CSV_cleaner($line)  // Modified by: Mel Bohince (1/21/14) clean out embedded commas and fix last update date if from BRown
					util_TextParser(20; $line; Character code:C91($t); Character code:C91($r))
					$thermo:=$thermo+1
					$currentSize:=Size of array:C274($qty)
					If ($cursor>=$currentSize)  //expand the buffers
						$currentSize:=$currentSize+20
						ARRAY TEXT:C222($cpn; $currentSize)
						ARRAY DATE:C224($schd; $currentSize)
						ARRAY LONGINT:C221($qty; $currentSize)
						ARRAY LONGINT:C221($qtyOrd; $currentSize)
						ARRAY LONGINT:C221($qtyRec; $currentSize)
						ARRAY TEXT:C222($refer; $currentSize)
						ARRAY TEXT:C222($asOf; $currentSize)
						ARRAY TEXT:C222($PnG_planner; $currentSize)
					End if 
					uThermoUpdate($thermo)
				End while 
				
				SET QUERY LIMIT:C395(0)
				utl_LogIt("show")
				
				ARRAY TEXT:C222($cpn; $cursor)
				ARRAY DATE:C224($schd; $cursor)
				ARRAY LONGINT:C221($qty; $cursor)
				ARRAY LONGINT:C221($qtyOrd; $cursor)
				ARRAY LONGINT:C221($qtyRec; $cursor)
				ARRAY TEXT:C222($refer; $cursor)
				ARRAY TEXT:C222($asOf; $cursor)
				ARRAY TEXT:C222($PnG_planner; $cursor)
				MULTI SORT ARRAY:C718($cpn; >; $schd; >; $qty; $qtyOrd; $qtyRec; $refer; $asOf; $PnG_planner)
				
				ARRAY TEXT:C222($id; $cursor)
				ARRAY TEXT:C222($plant; $cursor)
				ARRAY TEXT:C222($aCustid; $cursor)
				
				C_LONGINT:C283($i; $numElements)
				$numElements:=Size of array:C274($cpn)
				For ($i; 1; $numElements)  //set the plant and cust id's
					$id{$i}:=String:C10($i; "00000")
					$plant{$i}:=$PnG_Plant
					$aCustid{$i}:=COMPARE_CUSTID
				End for 
				$thermo:=$thermo+((200-$thermo)/2)
				uThermoUpdate($thermo)
				
				REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
				ARRAY TO SELECTION:C261($id; [Finished_Goods_DeliveryForcasts:145]id:1; $cpn; [Finished_Goods_DeliveryForcasts:145]ProductCode:2; $schd; [Finished_Goods_DeliveryForcasts:145]DateDock:4; $qty; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; $refer; [Finished_Goods_DeliveryForcasts:145]refer:3; $plant; [Finished_Goods_DeliveryForcasts:145]ShipTo:8; $asOf; [Finished_Goods_DeliveryForcasts:145]asOf:9; $qtyOrd; [Finished_Goods_DeliveryForcasts:145]QtyWanted:5; $qtyRec; [Finished_Goods_DeliveryForcasts:145]QtyReceived:6; $aCustid; [Finished_Goods_DeliveryForcasts:145]Custid:12)
				$thermo:=$thermo+1
				//PnG_DeliveryScheduleCompare 
				$thermo:=200
				uThermoUpdate($thermo)
				uThermoClose
				
				PnP_setFGowner
				
				If ($make_release)
					For ($i; 1; $numElements)  //set the plant and cust id's
						CREATE RECORD:C68([Customers_ReleaseSchedules:46])
						[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
						[Customers_ReleaseSchedules:46]Shipto:10:=$plant{$i}
						[Customers_ReleaseSchedules:46]ProductCode:11:=$cpn{$i}
						QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=(COMPARE_CUSTID+":"+$cpn{$i}))
						[Customers_ReleaseSchedules:46]CustomerLine:28:=[Finished_Goods:26]Line_Brand:15
						[Customers_ReleaseSchedules:46]Sched_Date:5:=$schd{$i}
						//[Customers_ReleaseSchedules]Sched_Date:=$aWeek{$i}-ADDR_getLeadTime ([Customers_ReleaseSchedules]Shipto)
						//[Customers_ReleaseSchedules]Sched_Date:=REL_NoWeekEnds ([Customers_ReleaseSchedules]Sched_Date)  // • mel (6/22/05, 17:08:14)
						[Customers_ReleaseSchedules:46]Sched_Qty:6:=$qty{$i}
						[Customers_ReleaseSchedules:46]CustomerRefer:3:=$refer{$i}
						// Modified by: Mel Bohince (5/20/16) was cayey, now brownsummit
						If ($plant{$i}="02439")  //redundant, but things changes
							If (Position:C15("<"; $refer{$i})=0)  //they are to always be forecasts
								[Customers_ReleaseSchedules:46]CustomerRefer:3:="<FDS>"+$refer{$i}
							End if 
						End if 
						[Customers_ReleaseSchedules:46]Expedite:35:="Imported"
						[Customers_ReleaseSchedules:46]EDI_Disposition:36:=$asOf{$i}+"-"+$PnG_planner{$i}
						[Customers_ReleaseSchedules:46]OpenQty:16:=$qty{$i}
						[Customers_ReleaseSchedules:46]CustID:12:=$aCustid{$i}
						[Customers_ReleaseSchedules:46]Entered_Date:34:=$version
						[Customers_ReleaseSchedules:46]ModDate:18:=$version
						[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
						[Customers_ReleaseSchedules:46]CreatedBy:46:="PORT"
						[Customers_ReleaseSchedules:46]THC_State:39:=9
						
						[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Finished_Goods:26]ProjectNumber:82
						SAVE RECORD:C53([Customers_ReleaseSchedules:46])
					End for 
					UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
					UNLOAD RECORD:C212([Finished_Goods:26])
					
				End if 
			End if   //headers looked OK
			CLOSE DOCUMENT:C267($docRef)
			BEEP:C151
		End if   //OK and continue
		
		uConfirm("Import another file?"; "Done"; "Another")
		If (OK=1)
			$quit:=True:C214
		Else 
			$quit:=False:C215
		End if 
		
	Else 
		uConfirm("File not opened?"; "Done"; "Try again")
		If (OK=1)
			$quit:=True:C214
		Else 
			$quit:=False:C215
		End if 
	End if   //doc opened
Until ($quit)

REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)