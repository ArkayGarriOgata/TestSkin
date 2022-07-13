//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/19/09, 13:04:37
// ----------------------------------------------------
// Method: EDI_Delfor_Reconcile
// Description
// compare our release schedule to their delfor(s)
// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($2)
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

READ WRITE:C146([Customers_ReleaseSchedules:46])

QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=$1; *)
QUERY:C277([Finished_Goods_DeliveryForcasts:145];  & ; [Finished_Goods_DeliveryForcasts:145]edi_buyer:15=$2)
ORDER BY:C49([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2; >; [Finished_Goods_DeliveryForcasts:145]DateDock:4; >)

$break:=False:C215
$numRecs:=Records in selection:C76([Finished_Goods_DeliveryForcasts:145])

uThermoInit($numRecs; "Reconciling DELFOR")
For ($i; 1; $numRecs)
	$exception:=""
	If ($break)
		$i:=$i+$numRecs
	End if 
	
	//If ([Finished_Goods_DeliveryForcasts]ProductCode="12M0-01-0113")
	//TRACE
	//End if 
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3=[Finished_Goods_DeliveryForcasts:145]refer:3)
	
	If (Records in selection:C76([Customers_ReleaseSchedules:46])=0)  //try a less direct way
		Case of 
			: (Substring:C12([Finished_Goods_DeliveryForcasts:145]refer:3; 1; 2)="BP")
				$refer:=Replace string:C233([Finished_Goods_DeliveryForcasts:145]refer:3; "BP"; "BR")  //legacy flipflop
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3=$refer)
				
			: (Substring:C12([Finished_Goods_DeliveryForcasts:145]refer:3; 1; 2)="<F")  //but only if a forecast
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods_DeliveryForcasts:145]ProductCode:2; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Promise_Date:32=[Finished_Goods_DeliveryForcasts:145]DateDock:4; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]EDI_Disposition:36="OMIT")  //hasn't already been touched
				If (Records in selection:C76([Customers_ReleaseSchedules:46])>1)  //maybe two dif qty's, like on the planned monthly type
					SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]; $aRecNum; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aTestQty)
					ARRAY LONGINT:C221($aDeltaQty; Size of array:C274($aRecNum))  //so need to find the one closest to this new qty
					For ($test_qty; 1; Size of array:C274($aRecNum))
						$aDeltaQty{$test_qty}:=Abs:C99($aTestQty{$test_qty}-[Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
					End for 
					SORT ARRAY:C229($aDeltaQty; $aRecNum; $aTestQty; >)
					GOTO RECORD:C242([Customers_ReleaseSchedules:46]; $aRecNum{1})
				End if 
				[Customers_ReleaseSchedules:46]CustomerRefer:3:=[Finished_Goods_DeliveryForcasts:145]refer:3  //update the refer, zone may have changed
		End case 
	End if 
	//record changes in the release if any
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		If (Substring:C12([Finished_Goods_DeliveryForcasts:145]refer:3; 1; 2)="<F")  //if forecast, go ahead and update it
			$changed:=False:C215
			If ([Customers_ReleaseSchedules:46]EDI_Disposition:36="OMIT")
				[Customers_ReleaseSchedules:46]EDI_Disposition:36:=""  //first tickle
				If ([Customers_ReleaseSchedules:46]Sched_Qty:6#[Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
					[Customers_ReleaseSchedules:46]Sched_Qty:6:=[Finished_Goods_DeliveryForcasts:145]QtyOpen:7
					[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]Sched_Qty:6
					$changed:=True:C214
				End if 
			Else   //probably a <FPP which always is 1st of the month, but multiple times possible
				[Customers_ReleaseSchedules:46]Sched_Qty:6:=[Customers_ReleaseSchedules:46]Sched_Qty:6+[Finished_Goods_DeliveryForcasts:145]QtyOpen:7
				[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]Sched_Qty:6
			End if 
			
			If ([Customers_ReleaseSchedules:46]Promise_Date:32#[Finished_Goods_DeliveryForcasts:145]DateDock:4)
				[Customers_ReleaseSchedules:46]Promise_Date:32:=[Finished_Goods_DeliveryForcasts:145]DateDock:4
				$lead_time_in_days:=ADDR_getLeadTime([Finished_Goods_DeliveryForcasts:145]ShipTo:8)
				[Customers_ReleaseSchedules:46]Sched_Date:5:=[Customers_ReleaseSchedules:46]Promise_Date:32-$lead_time_in_days
				$changed:=True:C214
			End if 
			
			If ([Customers_ReleaseSchedules:46]Shipto:10#[Finished_Goods_DeliveryForcasts:145]ShipTo:8)
				[Customers_ReleaseSchedules:46]Shipto:10:=[Finished_Goods_DeliveryForcasts:145]ShipTo:8
				$changed:=True:C214
			End if 
			If ([Customers_ReleaseSchedules:46]CustID:12="?edi?")
				If ([Finished_Goods_DeliveryForcasts:145]Custid:12#"")
					If ([Finished_Goods_DeliveryForcasts:145]Custid:12#"?edi?")
						[Customers_ReleaseSchedules:46]CustID:12:=[Finished_Goods_DeliveryForcasts:145]Custid:12
					End if 
				End if 
			End if 
			If ($changed)
				[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
				[Customers_ReleaseSchedules:46]ModWho:19:="DLFR"
				[Customers_ReleaseSchedules:46]edi_buyer:47:=[Finished_Goods_DeliveryForcasts:145]edi_buyer:15
				[Customers_ReleaseSchedules:46]ChangeLog:23:="Updated "+$2+" as of "+$1+Char:C90(13)+[Customers_ReleaseSchedules:46]ChangeLog:23
			Else 
				[Customers_ReleaseSchedules:46]ChangeLog:23:="Same "+$2+" as of "+$1+Char:C90(13)+[Customers_ReleaseSchedules:46]ChangeLog:23
			End if 
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
			
		Else 
			$exceptions:=""
			[Customers_ReleaseSchedules:46]EDI_Disposition:36:=""
			If ([Customers_ReleaseSchedules:46]Promise_Date:32#[Finished_Goods_DeliveryForcasts:145]DateDock:4)
				$exceptions:=$exceptions+" DATE  "
				If (Position:C15("CHG"; [Customers_ReleaseSchedules:46]EDI_Disposition:36)=0)
					[Customers_ReleaseSchedules:46]EDI_Disposition:36:="CHG "+[Customers_ReleaseSchedules:46]EDI_Disposition:36
				End if 
				[Customers_ReleaseSchedules:46]EDI_Disposition:36:=[Customers_ReleaseSchedules:46]EDI_Disposition:36+" DATE"
			End if 
			If ([Customers_ReleaseSchedules:46]Sched_Qty:6#[Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
				$exceptions:=$exceptions+" QTY  "
				If (Position:C15("CHG"; [Customers_ReleaseSchedules:46]EDI_Disposition:36)=0)
					[Customers_ReleaseSchedules:46]EDI_Disposition:36:="CHG "+[Customers_ReleaseSchedules:46]EDI_Disposition:36
				End if 
				[Customers_ReleaseSchedules:46]EDI_Disposition:36:=[Customers_ReleaseSchedules:46]EDI_Disposition:36+" QTY"
			End if 
			If ([Customers_ReleaseSchedules:46]Shipto:10#[Finished_Goods_DeliveryForcasts:145]ShipTo:8)
				$exceptions:=$exceptions+" DEST  "
				If (Position:C15("CHG"; [Customers_ReleaseSchedules:46]EDI_Disposition:36)=0)
					[Customers_ReleaseSchedules:46]EDI_Disposition:36:="CHG "+[Customers_ReleaseSchedules:46]EDI_Disposition:36
				End if 
				[Customers_ReleaseSchedules:46]EDI_Disposition:36:=[Customers_ReleaseSchedules:46]EDI_Disposition:36+" SHIPTO"
			End if 
			If (Length:C16($exceptions)>0)
				$exceptions:="DELFOR"+$exceptions+"CHANGE "
				[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
				[Customers_ReleaseSchedules:46]ModWho:19:="DLFR"
			End if 
			[Customers_ReleaseSchedules:46]edi_buyer:47:=[Finished_Goods_DeliveryForcasts:145]edi_buyer:15
			[Customers_ReleaseSchedules:46]ChangeLog:23:=$exceptions+$2+" as of "+$1+Char:C90(13)+[Customers_ReleaseSchedules:46]ChangeLog:23
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
		End if 
		
	Else   //couldn't find a match
		If (Substring:C12([Finished_Goods_DeliveryForcasts:145]refer:3; 1; 2)="<F")  //if forecast, go ahead and insert it
			CREATE RECORD:C68([Customers_ReleaseSchedules:46])
			[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
			[Customers_ReleaseSchedules:46]OrderNumber:2:=0
			[Customers_ReleaseSchedules:46]OrderLine:4:=""
			[Customers_ReleaseSchedules:46]Shipto:10:=[Finished_Goods_DeliveryForcasts:145]ShipTo:8
			[Customers_ReleaseSchedules:46]Billto:22:=[Finished_Goods_DeliveryForcasts:145]BillTo:16
			[Customers_ReleaseSchedules:46]ProductCode:11:=[Finished_Goods_DeliveryForcasts:145]ProductCode:2
			[Customers_ReleaseSchedules:46]CustomerRefer:3:=[Finished_Goods_DeliveryForcasts:145]refer:3
			[Customers_ReleaseSchedules:46]CustID:12:=[Finished_Goods_DeliveryForcasts:145]Custid:12
			If (Length:C16([Customers_ReleaseSchedules:46]CustID:12)=0)
				[Customers_ReleaseSchedules:46]CustID:12:="?edi?"
			End if 
			[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
			[Customers_ReleaseSchedules:46]ModWho:19:="DLFR"
			[Customers_ReleaseSchedules:46]CreatedBy:46:="DLFR"
			[Customers_ReleaseSchedules:46]PayU:31:=0  //•101095  MLB 
			[Customers_ReleaseSchedules:46]Entered_Date:34:=4D_Current_date
			[Customers_ReleaseSchedules:46]THC_State:39:=9  //•102297  MLB  was, -4, chg so it show up as not being processed yet
			[Customers_ReleaseSchedules:46]edi_buyer:47:=[Finished_Goods_DeliveryForcasts:145]edi_buyer:15
			$numFG:=qryFinishedGood("#CPN"; [Customers_ReleaseSchedules:46]ProductCode:11)
			If ($numFG>0)
				[Customers_ReleaseSchedules:46]CustomerLine:28:=[Finished_Goods:26]Line_Brand:15
				[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Finished_Goods:26]ProjectNumber:82
			End if 
			
			[Customers_ReleaseSchedules:46]Promise_Date:32:=[Finished_Goods_DeliveryForcasts:145]DateDock:4
			$lead_time_in_days:=ADDR_getLeadTime([Customers_ReleaseSchedules:46]Shipto:10)
			[Customers_ReleaseSchedules:46]Sched_Date:5:=[Customers_ReleaseSchedules:46]Promise_Date:32-$lead_time_in_days
			[Customers_ReleaseSchedules:46]Sched_Qty:6:=[Finished_Goods_DeliveryForcasts:145]QtyOpen:7
			[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]Sched_Qty:6
			[Customers_ReleaseSchedules:46]ChangeLog:23:=$2+" as of "+$1
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
		End if 
	End if 
	
	//SAVE RECORD([Finished_Goods_DeliveryForcasts])
	NEXT RECORD:C51([Finished_Goods_DeliveryForcasts:145])
	uThermoUpdate($i)
End for 
uThermoClose