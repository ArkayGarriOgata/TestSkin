//%attributes = {"publishedWeb":true}
//Procedure: FG_ChkInventoryBal({jobit})  092795  MLB
//test inventory balances of f/g with receipt of a given date
//• 5/1/97 cs replaced thermoset
// Modified by: Mel Bohince (2/7/18) simplify
// Modified by: Mel Bohince (2/8/18) don't include adjustments in inv equation, and exclude shipped cases from wms
// Modified by: MelvinBohince (4/5/22) change xls to csv

C_TEXT:C284($t; $r; $1)
C_LONGINT:C283($jobit; $qtyOH; $qtyWant; $qtyReceived; $qtyProduced; $qtyGood; $qtyScapped; $qtyReturned; $qtyNetShipped; $qtyShipped; $qtyAdjusted; $qtyRevShip; $qtyOHcalc; $wmsOnhand)
C_TEXT:C284(xText; xTitle)
C_BOOLEAN:C305($displayOnScreen; $WMS_Connection)
ARRAY TEXT:C222($aJobits; 0)
C_DATE:C307($2; $3)

WMS_API_LoginLookup  //make sure <>WMS variables are up to date.
If (WMS_API_4D_DoLogin)
	$WMS_Connection:=True:C214
	//$ttSQL:="SELECT SUM(qty_in_case) FROM cases WHERE jobit = ? "
	
Else 
	$WMS_Connection:=False:C215
End if 
$t:=","  // Modified by: MelvinBohince (4/5/22) change xls to csv, Char(9)
$r:=Char:C90(13)

CREATE EMPTY SET:C140([Finished_Goods_Transactions:33]; "theTrans")
MESSAGES OFF:C175

Case of 
	: (Count parameters:C259=1)
		$displayOnScreen:=True:C214
		APPEND TO ARRAY:C911($aJobits; $1)
		//xTitle:="Inventory Equation Check for "+$1
		
	: (Count parameters:C259=3)  //date range
		$displayOnScreen:=False:C215  //write to a file
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=$2; *)  //any activity
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=$3)
		//QUERY([Finished_Goods_Transactions]; & ;[Finished_Goods_Transactions]XactionType#"Ship")
		DISTINCT VALUES:C339([Finished_Goods_Transactions:33]Jobit:31; $aJobits)
		xTitle:="Inventory Balance Equation for "+"items with transcations between "+String:C10($2; Internal date short special:K1:4)+" and "+String:C10($3; Internal date short special:K1:4)
		If (False:C215)
			xText:="Jobit"+$t+"CPN"+$t+"0Good"+$t+"Produced"+$t+"Good"+$t+"CalcScrap"+$t+"Scrapped"+$t+"ErrorScrap"+$t+"Received"+$t+"ErrorReceip"+$t+"Shipped"+$t+"Returned"+$t+"NetShipped"+$t+"Adjusted"+$t
			xText:=xText+"CalcOnHand"+$t+"Onhand"+$t+"ErrorOnhand"+$t+"Abs_Error"+$t+"CaseCount"+$r
		Else 
			xText:="Jobit"+$t+"CPN"+$t+"Received"+$t+"Scrapped"+$t+"Shipped"+$t+"Returned"+$t+"CalcOnHand"+$t+"Onhand"+$t+"ErrorOnhand"+$t+"Error_Sort"+$t+"Adjusted"+$t+"CaseCount"+$t+"WMS"+$t+"SyncErr"+$r
		End if 
		docName:="InventoryTest"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"  // Modified by: MelvinBohince (4/5/22) change xls to csv
		$docRef:=util_putFileName(->docName)
		SEND PACKET:C103($docRef; xTitle+$r+$r)
		
	Else 
		$displayOnScreen:=False:C215  //write to a file
		ALL RECORDS:C47([Finished_Goods_Locations:35])
		DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $aJobits)
		xTitle:="Inventory Balance Equation for "+"all On-hand Inventory"
		If (False:C215)
			xText:="Jobit"+$t+"CPN"+$t+"0Good"+$t+"Produced"+$t+"Good"+$t+"CalcScrap"+$t+"Scrapped"+$t+"ErrorScrap"+$t+"Received"+$t+"ErrorReceip"+$t+"Shipped"+$t+"Returned"+$t+"NetShipped"+$t+"Adjusted"+$t
			xText:=xText+"CalcOnHand"+$t+"Onhand"+$t+"ErrorOnhand"+$t+"Abs_Error"+$t+"CaseCount"+$r
		Else 
			xText:="Jobit"+$t+"CPN"+$t+"Received"+$t+"Scrapped"+$t+"Shipped"+$t+"Returned"+$t+"CalcOnHand"+$t+"Onhand"+$t+"ErrorOnhand"+$t+"Error_Sort"+$t+"Adjusted"+$t+"CaseCount"+$t+"WMS"+$t+"SyncErr"+$r
		End if 
		docName:="InventoryTest"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"  // Modified by: MelvinBohince (4/5/22) change xls to csv,
		$docRef:=util_putFileName(->docName)
		SEND PACKET:C103($docRef; xTitle+$r+$r)
End case 

uThermoInit(Size of array:C274($aJobits); xTitle)
For ($jobit; 1; Size of array:C274($aJobits))
	If ($displayOnScreen)
		utl_LogIt("init")
	Else 
		If (Length:C16(xText)>20000)
			SEND PACKET:C103($docRef; xText)
			xText:=""
		End if 
	End if 
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$aJobits{$jobit})
	$qtyOH:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$aJobits{$jobit})
	$cpn:=[Job_Forms_Items:44]ProductCode:3
	$qtyProduced:=Sum:C1([Job_Forms_Items:44]Qty_Actual:11)
	$qtyGood:=Sum:C1([Job_Forms_Items:44]Qty_Good:10)
	$qtyWant:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
	If ($qtyGood=0)
		$goodFlag:=Char:C90(9)+"0"
		$qtyGood:=$qtyProduced
	Else 
		$goodFlag:=Char:C90(9)+""
	End if 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$aJobits{$jobit})
		CREATE SET:C116([Finished_Goods_Transactions:33]; "theTrans")
		
		//*    Get the pluses  
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
		$qtyReceived:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		
		USE SET:C118("theTrans")
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Scrap")
		$qtyScapped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		
		USE SET:C118("theTrans")
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship")
		$qtyShipped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		
		USE SET:C118("theTrans")
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Return")
		$qtyReturned:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		$qtyNetShipped:=$qtyShipped-$qtyReturned
		
		USE SET:C118("theTrans")
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Adjust")
		$qtyAdjusted:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		
		USE SET:C118("theTrans")
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="RevShip")
		$qtyRevShip:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		
	Else 
		
		$qtyReceived:=0
		$qtyScapped:=0
		$qtyShipped:=0
		$qtyReturned:=0
		$qtyAdjusted:=0
		$qtyRevShip:=0
		$qtyNetShipped:=0
		
		ARRAY LONGINT:C221($_qty; 0)
		ARRAY TEXT:C222($_actionType; 0)
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$aJobits{$jobit})
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Qty:6; $_qty; [Finished_Goods_Transactions:33]XactionType:2; $_actionType)
		For ($Iter; 1; Size of array:C274($_qty); 1)
			
			Case of 
				: ($_actionType{$Iter}="Receipt")
					$qtyReceived:=$qtyReceived+$_qty{$Iter}
				: ($_actionType{$Iter}="Scrap")
					$qtyScapped:=$qtyScapped+$_qty{$Iter}
				: ($_actionType{$Iter}="Ship")
					$qtyShipped:=$qtyShipped+$_qty{$Iter}
				: ($_actionType{$Iter}="Return")
					$qtyReturned:=$qtyReturned+$_qty{$Iter}
				: ($_actionType{$Iter}="Adjust")
					$qtyAdjusted:=$qtyAdjusted+$_qty{$Iter}
				: ($_actionType{$Iter}="RevShip")
					$qtyRevShip:=$qtyRevShip+$_qty{$Iter}
					
			End case 
			
		End for 
		$qtyNetShipped:=$qtyShipped-$qtyReturned
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	//*    Compare the trans to the bins
	$qtyOHcalc:=$qtyReceived-$qtyNetShipped-$qtyScapped  //+$qtyAdjusted the adjustment throws it off as it is already baked in
	
	$caseCnt:=PK_getCaseCount(FG_getOutline($cpn))
	
	If ($displayOnScreen)
		utl_LogIt("#")
		utl_LogIt($aJobits{$jobit}+" "+$cpn+" packed at "+String:C10($caseCnt)+"/case")
		
		utl_LogIt("     Act= "+String:C10($qtyProduced)+" Good"+$goodFlag+"= "+String:C10($qtyGood)+" Onhand= "+String:C10($qtyOH))
		
		If ($qtyGood>$qtyWant)
			utl_LogIt("          Excess= "+String:C10($qtyGood-$qtyWant))
		End if 
		
		If ($qtyGood<$qtyWant)
			utl_LogIt("          Short= "+String:C10($qtyWant-$qtyGood))
		End if 
		
		If ($qtyReceived#$qtyProduced)
			utl_LogIt("     ••••• Received= "+String:C10($qtyReceived)+" not equal to production ••••• Error= "+String:C10($qtyProduced-$qtyReceived)+"•••••")
		End if 
		
		If ($qtyScapped#($qtyProduced-$qtyGood))
			utl_LogIt("    •Scraps= "+String:C10($qtyScapped)+" not yielding Good count")
		End if 
		
		If ($qtyRevShip>0)
			utl_LogIt("     RevShip= "+String:C10($qtyRevShip)+" Just Weird that this exists")
		End if 
		
		utl_LogIt("     QtyOH= "+String:C10($qtyOH))
		utl_LogIt("          + Received= "+String:C10($qtyReceived))
		utl_LogIt("          - Net Shipped= "+String:C10($qtyNetShipped))
		utl_LogIt("          - Scrap= "+String:C10($qtyScapped))
		utl_LogIt("          + Adjust= "+String:C10($qtyAdjusted))
		
		If ($qtyOH#$qtyOHcalc)
			utl_LogIt("    ••••• Onhand Doesn't match INs and OUTs •••••")
			utl_LogIt("    ••••• Should Be= "+String:C10($qtyOHcalc)+" ••••• "+"Error= "+String:C10($qtyOH-$qtyOHcalc)+" •••••")
		End if 
		utl_LogIt("show")
	Else 
		
		If (False:C215)
			xText:=xText+$aJobits{$jobit}+$t+$cpn+$goodFlag+$t
			xText:=xText+String:C10($qtyProduced)+$t+String:C10($qtyGood)+$t+String:C10($qtyProduced-$qtyGood)+$t+String:C10($qtyScapped)+$t+String:C10(($qtyProduced-$qtyGood)-$qtyScapped)+$t
			xText:=xText+String:C10($qtyReceived)+$t+String:C10($qtyProduced-$qtyReceived)+$t+String:C10($qtyShipped)+$t+String:C10($qtyReturned)+$t+String:C10($qtyNetShipped)+$t
			xText:=xText+String:C10($qtyAdjusted)+$t+String:C10($qtyOHcalc)+$t+String:C10($qtyOH)+$t+String:C10($qtyOH-$qtyOHcalc)+$t+String:C10(Abs:C99($qtyOH-$qtyOHcalc))+$t+String:C10($caseCnt)+$r
		Else   //simplify
			
			If ($WMS_Connection)
				$ttJobitWMS:=Replace string:C233($aJobits{$jobit}; "."; "")
				$wmsOnhand:=0
				Begin SQL
					SELECT sum(qty_in_case) from cases where jobit = :$ttJobitWMS and case_status_code <> 300 
					into :$wmsOnhand
				End SQL
				$syncErr:=$qtyOH-$wmsOnhand
			Else 
				$wmsOnhand:=-1
				$syncErr:=-1
			End if 
			
			xText:=xText+$aJobits{$jobit}+$t+$cpn+$t
			xText:=xText+String:C10($qtyReceived)+$t+String:C10($qtyScapped)+$t+String:C10($qtyShipped)+$t+String:C10($qtyReturned)+$t+String:C10($qtyOHcalc)+$t+String:C10($qtyOH)+$t+String:C10($qtyOH-$qtyOHcalc)+$t+String:C10(Abs:C99($qtyOH-$qtyOHcalc))+$t+String:C10($qtyAdjusted)+$t+String:C10($caseCnt)+$t+String:C10($wmsOnhand)+$t+String:C10($syncErr)+$r
		End if 
	End if 
	
	uThermoUpdate($jobit)  //• 5/1/97 cs replaced thermoset
End for 
uThermoClose

If ($displayOnScreen)
	utl_LogIt("init")
Else 
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	//// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	If (Current user:C182="Designer")
		$err:=util_Launch_External_App(docName)
	Else 
		$body:="open attached with excel"
		EMAIL_Sender("FG_ChkInventoryBal-"+fYYMMDD(Current date:C33; 4); ""; $body; ""; docName)
		util_deleteDocument(docName)
	End if 
End if 
xText:=""

If ($WMS_Connection)
	WMS_API_4D_DoLogout
End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	CLEAR SET:C117("theTrans")
	
	
Else 
	
	
End if   // END 4D Professional Services : January 2019 query selection
MESSAGES ON:C181