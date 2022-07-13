//%attributes = {"publishedWeb":true}
//PM: ELC_OrderPattern() -> 
//@author mlb - 10/12/01  12:39

MESSAGES OFF:C175

C_LONGINT:C283($i; $numOL; $numFG)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="Order Pattern Report"
xText:=""

$month:=Month of:C24(Current date:C33)-1
zwStatusMsg("Estée Lauder"; "Order Pattern Report")
$targetMonth:=Request:C163("Enter the month/year:"; String:C10($month; "00")+"/2001"; "Analyze"; "Cancel")
If (OK=1)
	If (Length:C16($targetMonth)=7)
		zwStatusMsg("Estée Lauder"; "Order Pattern Report for month "+$targetMonth)
		$month:=Num:C11(Substring:C12($targetMonth; 1; 2))
		$year:=Num:C11(Substring:C12($targetMonth; 4; 4))
		dDateBegin:=Date:C102(String:C10($month)+"/1/"+String:C10($year))
		$nextMonth:=$month+1
		$nextYear:=$year
		If ($nextMonth>12)
			$nextMonth:=1
			$nextYear:=$nextYear+1
		End if 
		dDateEnd:=Date:C102(String:C10($nextMonth)+"/1/"+String:C10($nextYear))
		
		//$docRef:=Create document("ELC_OrderPattern"+$targetMonth)
		
		docName:="ELC_OrderPattern"+$targetMonth+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
				
				$numOL:=ELC_query(->[Customers_Order_Lines:41]CustID:4)  //get elc's jobits
				CREATE SET:C116([Customers_Order_Lines:41]; "allELCorders")
				QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13<dDateEnd; *)
				QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Quantity:6>10; *)
				QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0)
				$numOL:=Records in selection:C76([Customers_Order_Lines:41])
				$openOrderlines:=$numOL
				
				USE SET:C118("allELCorders")
				CLEAR SET:C117("allELCorders")
				QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13>=dDateBegin; *)
				QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<dDateEnd)
				
				
			Else 
				
				READ ONLY:C145([Customers_Order_Lines:41])
				C_LONGINT:C283($openOrderlines)
				$Critiria:=ELC_getName
				$openOrderlines:=0  // Modified by: Mel Bohince (6/9/21) 
				SET QUERY DESTINATION:C396(Into variable:K19:4; $openOrderlines)
				QUERY:C277([Customers_Order_Lines:41]; [Customers:16]ParentCorp:19=$Critiria; *)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13<dDateEnd; *)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Quantity:6>10; *)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0)
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				
				QUERY:C277([Customers_Order_Lines:41]; [Customers:16]ParentCorp:19=$Critiria; *)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13>=dDateBegin; *)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13<dDateEnd)
				
			End if   // END 4D Professional Services : January 2019 ELC_query
			
			$numOL:=Records in selection:C76([Customers_Order_Lines:41])
			$newOrderlines:=$numOL
			$newQty:=Sum:C1([Customers_Order_Lines:41]Quantity:6)
			$relsNeeded:=0
			$relsLeadProblem:=0
			$noArt:=0
			uThermoInit($numOL; "Analyzing new orders")
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
				
				For ($i; 1; $numOL)
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						$qtyReleased:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
						If ($qtyReleased<[Customers_Order_Lines:41]Quantity:6)
							$relsNeeded:=$relsNeeded+1
						End if 
						If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
							
							For ($j; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
								If ([Customers_ReleaseSchedules:46]Sched_Date:5<([Customers_Order_Lines:41]DateOpened:13+(4*7)))
									$relsLeadProblem:=$relsLeadProblem+1
								End if 
								NEXT RECORD:C51([Customers_ReleaseSchedules:46])
							End for 
							
						Else 
							
							
							ARRAY DATE:C224($_Sched_Date; 0)
							C_DATE:C307($DateOpened)
							
							$DateOpened:=[Customers_Order_Lines:41]DateOpened:13+(4*7)
							
							SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date)
							
							For ($j; 1; Size of array:C274($_Sched_Date); 1)
								If ($_Sched_Date{$j}<$DateOpened)
									$relsLeadProblem:=$relsLeadProblem+1
								End if 
								
							End for 
							
							
						End if   // END 4D Professional Services : January 2019 First record
						
					Else 
						$relsNeeded:=$relsNeeded+1
					End if 
					
					$numFG:=qryFinishedGood([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5)
					If ($numFG>0)
						If ([Finished_Goods:26]ArtReceivedDate:56=!00-00-00!)
							$noArt:=$noArt+1
						End if 
					End if 
					
					NEXT RECORD:C51([Customers_Order_Lines:41])
					uThermoUpdate($i)
				End for 
				
				
			Else 
				
				ARRAY TEXT:C222($_OrderLine; 0)
				ARRAY LONGINT:C221($_Quantity; 0)
				ARRAY DATE:C224($_DateOpened; 0)
				ARRAY TEXT:C222($_CustID; 0)
				ARRAY TEXT:C222($_ProductCode; 0)
				
				
				SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $_OrderLine; \
					[Customers_Order_Lines:41]Quantity:6; $_Quantity; \
					[Customers_Order_Lines:41]DateOpened:13; $_DateOpened; \
					[Customers_Order_Lines:41]CustID:4; $_CustID; \
					[Customers_Order_Lines:41]ProductCode:5; $_ProductCode)
				
				
				For ($i; 1; $numOL; 1)
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$_OrderLine{$i})
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						$qtyReleased:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
						If ($qtyReleased<$_Quantity{$i})
							$relsNeeded:=$relsNeeded+1
						End if 
						
						ARRAY DATE:C224($_Sched_Date; 0)
						C_DATE:C307($DateOpened)
						$DateOpened:=$_DateOpened{$i}+(4*7)
						
						SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date)
						
						For ($j; 1; Size of array:C274($_Sched_Date); 1)
							If ($_Sched_Date{$j}<$DateOpened)
								$relsLeadProblem:=$relsLeadProblem+1
							End if 
							
						End for 
						
					Else 
						$relsNeeded:=$relsNeeded+1
					End if 
					
					$numFG:=qryFinishedGood($_CustID{$i}; $_ProductCode{$i})
					If ($numFG>0)
						If ([Finished_Goods:26]ArtReceivedDate:56=!00-00-00!)
							$noArt:=$noArt+1
						End if 
					End if 
					
					uThermoUpdate($i)
				End for 
				
				
			End if   // END 4D Professional Services : January 2019 
			uThermoClose
			
			SEND PACKET:C103($docRef; xTitle+$cr+$cr)
			xText:="In the month "+$targetMonth+", there were "+String:C10($openOrderlines)+" open Lauder orders. "
			xText:=xText+String:C10($newOrderlines)+" were new."+$cr
			xText:=xText+"Of the "+String:C10($newOrderlines)+" new orders placed:"+$cr
			xText:=xText+String:C10($relsNeeded)+", "+String:C10(Round:C94($relsNeeded/$newOrderlines*100; 0))+"%, were not sufficiently forecasted for quantity "+"(either partially or not at all)."+$cr
			xText:=xText+String:C10($relsLeadProblem)+", "+String:C10(Round:C94($relsLeadProblem/$newOrderlines*100; 0))+"%, were not sufficiently forecasted for date (placed within 4 wks of the order)"+$cr
			xText:=xText+String:C10($noArt)+", "+String:C10(Round:C94($noArt/$newOrderlines*100; 0))+"%, did not have art available."+$cr
			SEND PACKET:C103($docRef; xText)
			
			CLOSE DOCUMENT:C267($docRef)
			BEEP:C151
			// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
			$err:=util_Launch_External_App(docName)
		End if   //doc open
		
	Else 
		BEEP:C151
		ALERT:C41("Entry must be in the form of MM/YYYY.")
	End if   //length rite
End if   //OK to go