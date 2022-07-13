//%attributes = {"publishedWeb":true}
//Procedure: BatchSetQtyWrel()  022197  MLB
//update teh orderline quantity with release field
//Procedure: BatchSetLastRel()  022197  MLB
//this proc is to update the releases that are marked as 
//Last Release' so that their qty reflects past shipments
//• 9/2/97 cs - we stopped setting SchedQty to Actual

C_LONGINT:C283($i; $hit; $numOrds)
C_TEXT:C284(xTitle; xText)
C_TEXT:C284($t; $cr)
C_DATE:C307($today)
ARRAY TEXT:C222($aOrdLine; 0)
ARRAY LONGINT:C221($aOrdRels; 0)
ARRAY LONGINT:C221($aOrdQty; 0)
ARRAY DATE:C224($aModDate; 0)
ARRAY TEXT:C222($aModeWho; 0)
ARRAY TEXT:C222($aCPN; 0)

$today:=4D_Current_date
$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="Orderline Qty with Release Adjustments on "+String:C10($today; <>MIDDATE)
xText:="Orderline"+$t+"Old Qty"+$t+"New Qty"+$t+"Order Qty"+$t+"CPN"+$cr

READ WRITE:C146([Customers_Order_Lines:41])
READ ONLY:C145([Customers_ReleaseSchedules:46])

MESSAGES OFF:C175

//NewWindow (170;140;3;-722;"Adj Orderline Qty w/ release")
zwStatusMsg("Adj Qty w/ Rel"; " Adj Qty w/ release in progress...")
//*Find the open orders
qryOpenOrdLines
SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOrdLine; [Customers_Order_Lines:41]QtyWithRel:20; $aOrdRels; [Customers_Order_Lines:41]Quantity:6; $aOrdQty; [Customers_Order_Lines:41]ModDate:15; $aModDate; [Customers_Order_Lines:41]ModWho:16; $aModeWho; [Customers_Order_Lines:41]ProductCode:5; $aCpn)
$numOrds:=Size of array:C274($aOrdLine)
ARRAY LONGINT:C221($aOrdAdj; $numOrds)
If (False:C215)  //realtime way, for Insider searches
	uOLcalcRel_info([Customers_Order_Lines:41]OrderLine:3)  //searches releases
End if 

zwStatusMsg("Adj Qty w/ Rel"; " Gathering Releases...")
RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)
ARRAY TEXT:C222($aRelOL; 0)
ARRAY LONGINT:C221($aRelSch; 0)
ARRAY LONGINT:C221($aActQty; 0)
SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OrderLine:4; $aRelOL; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aRelSch; [Customers_ReleaseSchedules:46]Actual_Qty:8; $aActQty)  //• 9/2/97 cs added actual qty array
uClearSelection(->[Customers_ReleaseSchedules:46])
SORT ARRAY:C229($aRelOL; $aRelSch; $aActQty; >)  //• 9/11/97 added second array to sort
uThermoInit($numOrds; "Orderline Release Qty Adjustments")

For ($i; 1; $numOrds)
	$aOrdAdj{$i}:=0
	$hit:=Find in array:C230($aRelOL; $aOrdLine{$i})  //*    Set the open release qty
	
	While ($hit>0)
		If ($aRelSch{$hit}>$aActQty{$hit}) & ($aActQty{$hit}>0)  //• 9/11/97, added > 0• 9/2/97 cs shipped short -new release created for differen
			$aOrdAdj{$i}:=$aOrdAdj{$i}+$aActQty{$hit}  //• 9/2/97 cs 
		Else   //• 9/2/97 cs use release qty
			$aOrdAdj{$i}:=$aOrdAdj{$i}+$aRelSch{$hit}  //summing release quantities
		End if 
		$hit:=Find in array:C230($aRelOL; $aOrdLine{$i}; $hit+1)
	End while 
	
	If ($aOrdAdj{$i}#$aOrdRels{$i})  //release qtys not equal orderlines with rel qtys
		xText:=xText+$aOrdLine{$i}+$t+String:C10($aOrdRels{$i})+$t+String:C10($aOrdAdj{$i})+$t+String:C10($aOrdQty{$i})+$t+$aCPN{$i}+$cr
		$aModDate{$i}:=$today
		$aModeWho{$i}:="BATC"
		$aOrdRels{$i}:=$aOrdAdj{$i}
	End if 
	uThermoUpdate($i)
End for 
uThermoClose

ARRAY TO SELECTION:C261($aModDate; [Customers_Order_Lines:41]ModDate:15; $aModeWho; [Customers_Order_Lines:41]ModWho:16; $aOrdRels; [Customers_Order_Lines:41]QtyWithRel:20)
uClearSelection(->[Customers_Order_Lines:41])
//MESSAGES ON

//QM_Sender (xTitle;"";xText;distributionList)
//rPrintText ("AdjW/Rel.LOG")
ARRAY TEXT:C222($aRelOL; 0)
ARRAY LONGINT:C221($aRelSch; 0)
ARRAY LONGINT:C221($aActQty; 0)