//%attributes = {"publishedWeb":true}
//Procedure: BatchSetLastRel()  022197  MLB
//this proc is to update the releases that are marked as 
//Last Release' so that their qty reflects past shipments
//•032597  MLB  show cpn in log
//021198 dont do mod date

C_LONGINT:C283($i; $numLasts; $hit; $numOrds; $addOn)

READ WRITE:C146([Customers_ReleaseSchedules:46])
READ ONLY:C145([Customers_Order_Lines:41])

MESSAGES OFF:C175
NewWindow(170; 150; 3; -722; "Adj Last Releases")
MESSAGE:C88(" Setting Last Releases "+Char:C90(13)+"in progress...")
//*Find the last releases
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]LastRelease:20=True:C214)
	$numLasts:=Records in selection:C76([Customers_ReleaseSchedules:46])
	CREATE SET:C116([Customers_ReleaseSchedules:46]; "LastRelease")
	
Else 
	
	//"LastRelease" replaced every where
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]LastRelease:20=True:C214)
	$numLasts:=Records in selection:C76([Customers_ReleaseSchedules:46])
	
End if   // END 4D Professional Services : January 2019 

//*Get the related orderlines

MESSAGE:C88(Char:C90(13)+" Gathering orderlines...")
RELATE ONE SELECTION:C349([Customers_ReleaseSchedules:46]; [Customers_Order_Lines:41])
ARRAY TEXT:C222($aOrdLine; 0)
ARRAY LONGINT:C221($aOrdQty; 0)
ARRAY LONGINT:C221($aOrdShip; 0)
ARRAY LONGINT:C221($aOrdRtn; 0)
ARRAY LONGINT:C221($aOrdNet; 0)
ARRAY LONGINT:C221($aOrdRels; 0)
ARRAY REAL:C219($aOrdOrun; 0)
SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOrdLine; [Customers_Order_Lines:41]Quantity:6; $aOrdQty; [Customers_Order_Lines:41]OverRun:25; $aOrdOrun; [Customers_Order_Lines:41]Qty_Shipped:10; $aOrdShip; [Customers_Order_Lines:41]Qty_Returned:35; $aOrdRtn)

//*Get the other release for these orders

MESSAGE:C88(Char:C90(13)+" Gathering other unshipped releases...")
RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]LastRelease:20=False:C215; *)
QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
ARRAY TEXT:C222($aRelOL; 0)
ARRAY LONGINT:C221($aRelSch; 0)
SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OrderLine:4; $aRelOL; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aRelSch)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
SORT ARRAY:C229($aRelOL; $aRelSch; >)

//*Calculate the volume of open releases, sans the last, and the net shipped

MESSAGE:C88(Char:C90(13)+" Calculate open releases and the net shipped...")
$numOrds:=Size of array:C274($aOrdLine)
ARRAY LONGINT:C221($aOrdNet; $numOrds)
ARRAY LONGINT:C221($aOrdRels; $numOrds)
For ($i; 1; $numOrds)
	$aOrdNet{$i}:=$aOrdShip{$i}-$aOrdRtn{$i}  //*    Set the net shipped
	$hit:=Find in array:C230($aRelOL; $aOrdLine{$i})  //*    Set the open release qty
	
	While ($hit>0)
		$aOrdRels{$i}:=$aOrdRels{$i}+$aRelSch{$hit}  //sum pending releases
		$hit:=Find in array:C230($aRelOL; $aOrdLine{$i}; $hit+1)
	End while 
End for 
//*For each
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	USE SET:C118("LastRelease")  //*Get the Last releases back
	
	CLEAR SET:C117("LastRelease")
	FIRST RECORD:C50([Customers_ReleaseSchedules:46])
	
	
Else 
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]LastRelease:20=True:C214)
	
	
End if   // END 4D Professional Services : January 2019 
C_DATE:C307($today)
$today:=4D_Current_date
C_TEXT:C284(xTitle; xText)
C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
$dist:=Current user:C182+$t
xTitle:="Last Release Qty Adjustments on "+String:C10($today; <>MIDDATE)
xText:="CPN"+$t+"Rel Number"+$t+"Customer Refer"+$t+"Old Qty"+$t+"New Qty"+$t+"SchDate"+$cr
uThermoInit($numLasts; "Last Release Qty Adjustments")

For ($i; 1; $numLasts)
	$hit:=Find in array:C230($aOrdLine; [Customers_ReleaseSchedules:46]OrderLine:4)
	
	If ($hit>0)  //*   recalc
		$addOn:=Round:C94(($aOrdQty{$hit}*($aOrdOrun{$hit}/100)); 0)  //amount of overrun allowed
		$lastQty:=($aOrdQty{$hit}+$addOn)-$aOrdNet{$hit}-$aOrdRels{$hit}  //order qty + overrun - (net shipped so far) - pending releases
		
	Else 
		$addOn:=0
		$lastQty:=0
	End if 
	
	If ($lastQty#0)  //*   revise if required
		If ([Customers_ReleaseSchedules:46]Sched_Qty:6#$lastQty)
			xText:=xText+[Customers_ReleaseSchedules:46]ProductCode:11+$t+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+$t+[Customers_ReleaseSchedules:46]CustomerRefer:3+$t+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6)+$t+String:C10($lastQty)+$t+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; <>MIDDATE)+$cr  //•032597  MLB
			
			[Customers_ReleaseSchedules:46]OverRunAddOn:21:=$addOn
			[Customers_ReleaseSchedules:46]ChgQtyVersion:14:=[Customers_ReleaseSchedules:46]ChgQtyVersion:14+1
			[Customers_ReleaseSchedules:46]OpenQty:16:=$lastQty-[Customers_ReleaseSchedules:46]Actual_Qty:8
			//[ReleaseSchedule]ModDate:=$today
			
			[Customers_ReleaseSchedules:46]ModWho:19:="BATC"
			[Customers_ReleaseSchedules:46]ChangeLog:23:="Last Release Qty changed on "+String:C10($today; <>MIDDATE)+", was "+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6)+$cr+[Customers_ReleaseSchedules:46]ChangeLog:23
			[Customers_ReleaseSchedules:46]Sched_Qty:6:=$lastQty
			If ([Customers_ReleaseSchedules:46]OriginalRelQty:24=0)
				[Customers_ReleaseSchedules:46]OriginalRelQty:24:=$lastQty
			End if 
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
		End if 
	End if 
	NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	uThermoUpdate($i)
End for 
uThermoClose
uClearSelection(->[Customers_ReleaseSchedules:46])
MESSAGES ON:C181
CLOSE WINDOW:C154