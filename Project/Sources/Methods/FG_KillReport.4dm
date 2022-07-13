//%attributes = {}
// Method: FG_KillReport () -> 
// ----------------------------------------------------
// by: mel: 07/26/05, 11:50:53
// ----------------------------------------------------
// Description:
// see also rptAgeFGdetail
// ----------------------------------------------------

C_TEXT:C284($r; $t)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)
C_LONGINT:C283($i; $numElements)

$r:=Char:C90(13)
$t:=Char:C90(9)
xTitle:="KILL REPORT "+String:C10(4D_Current_date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
$heading:="PRODUCT CODE"+$t+"TOTAL ONHAND"+$t+"OPEN PO QTY"+$t+"OPEN REL QTY"+$t+"OPEN WIP QTY"+$t+"KILLSTATUS"+$t+"BIN LOCATION"+$t+"JOBIT"+$t+"QUANTITY"+$t+"CONFIRM-KILL"+$r

//get customer list of those needing kills
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]KillStatus:30>0)
zwStatusMsg(String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" KILLS FOUND"; "You may query for a particular customer.")
QUERY SELECTION:C341([Finished_Goods_Locations:35])
DISTINCT VALUES:C339([Finished_Goods_Locations:35]CustID:16; $aCustId)

$numElements:=Size of array:C274($aCustId)

uThermoInit($numElements; "Processing Kills")
For ($cust; 1; $numElements)
	docName:="KillReport_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+"."+$aCustId{$cust}+"."+"xls"
	$docRef:=util_putFileName(->docName)
	SEND PACKET:C103($docRef; xTitle+$r+$r)
	xText:=""
	xText:=xText+CUST_getName($aCustId{$cust})+$r+$heading
	//get item list of those needing kills
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16=$aCustId{$cust}; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]KillStatus:30>0)
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]ProductCode:1; $aCPN)
	
	For ($i; 1; Size of array:C274($aCPN))
		xText:=xText+$aCPN{$i}+$t
		//get all the bins for this item, even if not too old
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$aCPN{$i})
		ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2; >)
		$onHand:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
		xText:=xText+String:C10($onHand)+$t
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$aCPN{$i})
		$numOrd:=qryOpenOrdLines("x"; "*")
		If ($numOrd>0)
			xText:=xText+String:C10(Sum:C1([Customers_Order_Lines:41]Qty_Open:11))+$t
		Else 
			xText:=xText+"0"+$t
		End if 
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$aCPN{$i}; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			xText:=xText+String:C10(Sum:C1([Customers_ReleaseSchedules:46]OpenQty:16))+$t
		Else 
			xText:=xText+"0"+$t
		End if 
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$aCPN{$i}; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
		If (Records in selection:C76([Job_Forms_Items:44])>0)
			xText:=xText+String:C10(Sum:C1([Job_Forms_Items:44]Qty_Want:24))+$t
		Else 
			xText:=xText+"0"+$t
		End if 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($bin; 1; Records in selection:C76([Finished_Goods_Locations:35]))
				xText:=xText+String:C10([Finished_Goods_Locations:35]KillStatus:30)+$t+[Finished_Goods_Locations:35]Location:2+$t+[Finished_Goods_Locations:35]Jobit:33+$t+String:C10([Finished_Goods_Locations:35]QtyOH:9)+$r+(5*$t)
				NEXT RECORD:C51([Finished_Goods_Locations:35])
			End for 
			
			
		Else 
			
			ARRAY LONGINT:C221($_KillStatus; 0)
			ARRAY TEXT:C222($_Location; 0)
			ARRAY TEXT:C222($_Jobit; 0)
			ARRAY LONGINT:C221($_QtyOH; 0)
			
			SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]KillStatus:30; $_KillStatus; [Finished_Goods_Locations:35]Location:2; $_Location; [Finished_Goods_Locations:35]Jobit:33; $_Jobit; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
			
			For ($bin; 1; Size of array:C274($_KillStatus); 1)
				xText:=xText+String:C10($_KillStatus{$bin})+$t+$_Location{$bin}+$t+$_Jobit{$bin}+$t+String:C10($_QtyOH{$bin})+$r+(5*$t)
				
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 First record
		
		xText:=xText+$r
		
		If (Length:C16(xText)>20000)
			SEND PACKET:C103($docRef; xText)
			xText:=""
		End if 
	End for   //each product
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	If (Count parameters:C259=0)
		$err:=util_Launch_External_App(docName)
	End if 
	
	uThermoUpdate($cust)
End for   //each customer
uThermoClose

xTitle:=""
xText:=""