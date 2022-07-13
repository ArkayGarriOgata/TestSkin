//%attributes = {"publishedWeb":true}
//Procedure: rptAgeFGdetail()  111398  MLB
//one more report to be forgotten
//• mlb - 12/21/01  add glued date to output
// • mel (4/12/05, 17:05:19) use xfer date if glue date is null, use jobit instead of jf and Item
// • mel (6/1/05, 13:27:03) remove BH bins

C_TEXT:C284($1)
C_TEXT:C284($CR; $t)
C_DATE:C307($today; $three; $six; $nine; $twelve)

$CR:=Char:C90(13)
$t:=Char:C90(9)

READ ONLY:C145([Customers:16])
READ WRITE:C146([Job_Forms_Items:44])  // incase glue date needs reset
READ ONLY:C145([Finished_Goods_Locations:35])

//ELC_isEsteeLauderCompany see app_CommonArrays
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	If (Count parameters:C259=0)
		SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
		QUERY:C277([Finished_Goods_Locations:35])
		SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
	Else 
		ALL RECORDS:C47([Finished_Goods_Locations:35])
	End if 
	
	QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH@")
	
Else 
	
	If (Count parameters:C259=0)
		SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
		QUERY:C277([Finished_Goods_Locations:35])
		SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
		QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH@")
		
	Else 
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH@")
		
	End if 
	
	
End if   // END 4D Professional Services : January 2019 query selection

If (Records in selection:C76([Finished_Goods_Locations:35])>0) & (ok=1)
	$today:=4D_Current_date
	$three:=Add to date:C393($today; 0; -3; 0)  //-(3*30)
	$six:=Add to date:C393($today; 0; -6; 0)  //-(6*30)
	$nine:=Add to date:C393($today; 0; -9; 0)  //-(9*30)
	$twelve:=Add to date:C393($today; 0; -12; 0)  //-(12*30)
	
	C_TEXT:C284(xTitle; xText)
	xTitle:="Aged F/G Inventory, by Date Glued and using NRV "+String:C10($today; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
	xText:=""+$t+""+$t+""+$t+""+$t+"≤ 3 Mths"+$t+$t+"3 < Mths ≤ 6"+$t+$t+"6 < Mths ≤ 9"+$t+$t+"9 < Mths ≤ 12"+$t+$t+"12 < Mths"+$t+$t+"Glued=00/00/00"+$t+$cr
	xText:=xText+"SALESMAN"+$t+"CUSTOMER"+$t+"CPN"+$t+"Location"+$t+"Qty"+$t+"Value"+$t+"Qty"+$t+"Value"+$t+"Qty"+$t+"Value"+$t+"Qty"+$t+"Value"+$t+"Qty"+$t+"Value"+$t+"Qty"+$t+"Value"+$t+"Glued"+$t+"Line"+$t+"Desc"+$cr
	C_TIME:C306($docRef)
	
	docName:="AgeFGinventory_"+fYYMMDD($today)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
	$docRef:=util_putFileName(->docName)
	
	SEND PACKET:C103($docRef; xTitle+$CR+$CR)
	SEND PACKET:C103($docRef; xText)
	xText:=""
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16; >; [Finished_Goods_Locations:35]QtyOH:9; <)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]Location:2; $aLoc; [Finished_Goods_Locations:35]QtyOH:9; $aQty; [Finished_Goods_Locations:35]CustID:16; $aCust; [Finished_Goods_Locations:35]Jobit:33; $aJi)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	$numLoc:=Size of array:C274($aCPN)
	ARRAY DATE:C224($aGlued; $numLoc)
	ARRAY REAL:C219($aValue; $numLoc)
	ARRAY TEXT:C222($aSalesman; $numLoc)
	ARRAY TEXT:C222($aCustName; $numLoc)
	ARRAY TEXT:C222($aLine; $numLoc)
	ARRAY TEXT:C222($aDesc; $numLoc)
	//TRACE
	uThermoInit(Size of array:C274($aCPN); "Aging inventory by glue date")
	
	For ($i; 1; Size of array:C274($aCPN))
		uThermoUpdate($i)
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$aCust{$i})
		If (Records in selection:C76([Customers:16])>0)
			$aSalesman{$i}:=[Customers:16]SalesmanID:3
			$aCustName{$i}:=[Customers:16]Name:2
		Else 
			$aSalesman{$i}:="n/a"
			$aCustName{$i}:="N/A"
		End if 
		
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$aCPN{$i})
		If (Records in selection:C76([Finished_Goods:26])>0)
			$aLine{$i}:=[Finished_Goods:26]Line_Brand:15
			$aDesc{$i}:=[Finished_Goods:26]CartonDesc:3
		Else 
			$aLine{$i}:="n/a"
			$aDesc{$i}:="N/A"
		End if 
		
		If (qryJMI($aJi{$i})>0)
			$aGlued{$i}:=[Job_Forms_Items:44]Glued:33
			$aValue{$i}:=[Job_Forms_Items:44]PldCostTotal:21*$aQty{$i}/1000
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
			If (Records in selection:C76([Customers_Order_Lines:41])>0)
				If ([Customers_Order_Lines:41]Price_Per_M:8<[Job_Forms_Items:44]PldCostTotal:21)
					$aValue{$i}:=[Customers_Order_Lines:41]Price_Per_M:8*$aQty{$i}/1000
				End if 
			End if   //orderline 
			
			// • mel (4/12/05, 17:00:26) don't use orderlines' date if gluedate is wrong.
			SET QUERY LIMIT:C395(0)
			If ($aGlued{$i}=!00-00-00!)
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$aJi{$i}; *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
				If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
					SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionDate:3; $aTransDate)
					SORT ARRAY:C229($aTransDate; >)
					$aGlued{$i}:=$aTransDate{1}
					[Job_Forms_Items:44]Glued:33:=$aGlued{$i}
					SAVE RECORD:C53([Job_Forms_Items:44])
				End if 
			End if 
			
			If ($aGlued{$i}=!00-00-00!)
				$aGlued{$i}:=[Job_Forms_Items:44]Completed:39
				[Job_Forms_Items:44]Glued:33:=$aGlued{$i}
				SAVE RECORD:C53([Job_Forms_Items:44])
			End if 
			
		Else 
			SET QUERY LIMIT:C395(0)
			$aValue{$i}:=0
		End if   //jmi
		xText:=xText+$aSalesman{$i}+$t+$aCustName{$i}+$t+$aCPN{$i}+$t+$aLoc{$i}+$t
		Case of 
			: ($aGlued{$i}=!00-00-00!)
				xText:=xText+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+String:C10($aQty{$i})+$t+String:C10($aValue{$i}; "########0.00")
			: ($aGlued{$i}>=$three)
				xText:=xText+String:C10($aQty{$i})+$t+String:C10($aValue{$i}; "########0.00")+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""
			: ($aGlued{$i}>=$six)
				xText:=xText+""+$t+""+$t+String:C10($aQty{$i})+$t+String:C10($aValue{$i}; "########0.00")+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""
			: ($aGlued{$i}>=$nine)
				xText:=xText+""+$t+""+$t+""+$t+""+$t+String:C10($aQty{$i})+$t+String:C10($aValue{$i}; "########0.00")+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""
				FG_setKillStatus($aLoc{$i}; $aJi{$i}; 9)
			: ($aGlued{$i}>=$twelve)
				xText:=xText+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+String:C10($aQty{$i})+$t+String:C10($aValue{$i}; "########0.00")+$t+""+$t+""+$t+""+$t+""
				FG_setKillStatus($aLoc{$i}; $aJi{$i}; 12)
			Else   //over 12
				xText:=xText+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t+String:C10($aQty{$i})+$t+String:C10($aValue{$i}; "########0.00")+$t+""+$t+""
				FG_setKillStatus($aLoc{$i}; $aJi{$i}; 13)
		End case 
		
		//If (Position("FX";$aLoc{$i})>0) & ($aGlued{$i}<=$nine)
		//If (Not(ELC_isEsteeLauderCompany ($aCust{$i})))
		//FG_setKillStatus ($aLoc{$i};$aJi{$i};1)
		//End if 
		//End if 
		
		xText:=xText+$t+String:C10($aGlued{$i}; System date short:K1:1)+$t+$aLine{$i}+$t+$aDesc{$i}+$t+$aJi{$i}+$cr
		
		If (Length:C16(xText)>20000)
			SEND PACKET:C103($docRef; xText)
			xText:=""
		End if 
		
	End for 
	uThermoClose
	SET QUERY LIMIT:C395(0)
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; Char:C90(13)+Char:C90(13)+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	If (Count parameters:C259=0)
		$err:=util_Launch_External_App(docName)
	End if 
	xTitle:=""
	xText:=""
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	REDUCE SELECTION:C351([Customers:16]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	BEEP:C151
	BEEP:C151
End if 