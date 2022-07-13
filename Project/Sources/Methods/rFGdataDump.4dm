//%attributes = {"publishedWeb":true}
//Procedure: rFGdataDump()  111798  mlb
//export facts about FG inventory, orders and releases
//•1/26/01  mlb  add option to show items without invnetory
// • mel (6/8/04, 15:32:07)filter to only promo's on demand

C_LONGINT:C283($i; $relitem; $orditem; $numFound; $qtyWIP)
C_TEXT:C284(xTitle; xText; xRemark)
C_TIME:C306($docRef)
C_BOOLEAN:C305($onlyPromo; $showDestinations; $showOpenOrders; $showWithOutInventory)  // • mel (6/8/04, 15:32:07)
C_DATE:C307(dDateEnd)
C_TEXT:C284($t; $cr)

$t:=Char:C90(9)
$cr:=Char:C90(13)
dDateEnd:=Add to date:C393(4D_Current_date; 0; 6; 0)
dDateEnd:=Date:C102(Request:C163("Consume forecasts out to:"; String:C10(dDateEnd; <>MIDDATE)))
tCust:=Request:C163("Report on which Customer name:"; "@")

If (OK=1) & (dDateEnd#!00-00-00!) & (Length:C16(tCust)#0)
	C_BOOLEAN:C305($listPrice; $showOpenOrders; $showWithOutInventory)
	//CONFIRM("Show F/G's Contract Price?";"Show";"Hide")
	//If (ok=1)
	$listPrice:=True:C214
	//Else 
	//$listPrice:=True  `always show
	//End if 
	
	CONFIRM:C162("List the open PO's for each product code?"; "No"; "Show")
	If (OK=1)
		$showOpenOrders:=False:C215
	Else 
		$showOpenOrders:=True:C214
	End if 
	
	CONFIRM:C162("Which Order Type?"; "All"; "Promotional")
	If (OK=1)
		$onlyPromo:=False:C215
	Else 
		$onlyPromo:=True:C214
	End if 
	
	CONFIRM:C162("List items with orders or releases, but no inventory?"; "Yes"; "No")  //•1/26/01  mlb  
	If (OK=1)
		$showWithOutInventory:=True:C214
	Else 
		$showWithOutInventory:=False:C215
	End if 
	
	CONFIRM:C162("List Shipto destinations?"; "Yes"; "No")  //•1/26/01  mlb  
	If (OK=1)
		$showDestinations:=True:C214
	Else 
		$showDestinations:=False:C215
	End if 
	
	docName:="FG_Inv_Ord_Fcst"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->docName)
	If (OK=1)
		
		xTitle:="F/G Facts - "+fYYMMDD(4D_Current_date)+$cr
		SEND PACKET:C103($docRef; xTitle)
		xText:="Custid"+$t+"Line"+$t+"CPN"+$t+"Qty_OH"+$t+"Qty_FG"+$t+"Qty_CC"+$t+"Qty_EX"+$t+"Qty_BH"+$t+"Open Ords"+$t+"OverRun"+$t+"Open Rels"+$t+"ExcessOfOrd"+$t+"ExcessOfFrcst"+$t+"RKConPrice"+$t+"PAYUSE"+$t+"WIP Yield"+$t+"CartonDescription"
		
		If ($showDestinations)
			xText:=xText+$t+"Destinations"
		End if 
		
		If ($showOpenOrders)
			xText:=xText+$t+"PO1"+$t+"PO1_OpenQty"+$t+"PO1_RelQty"+$t+"PO2"+$t+"PO2_OpenQty"+$t+"PO2_RelQty"+$t+"PO3"+$t+"PO3_OpenQty"+$t+"PO3_RelQty"
		End if 
		
		xText:=xText+$cr
		
		<>FgBatchDat:=!00-00-00!
		<>OrdBatchDat:=!00-00-00!
		BatchFGinventor(0; tCust)
		BatchOrdcalc(0; tCust)
		BatchRelCalc(0; tCust; dDateEnd)
		
		//*Consolidate a maste fgkey list  `•1/26/01  mlb  
		ARRAY TEXT:C222($aFGmasterList; 0)
		COPY ARRAY:C226(<>aFGKey; $aFGmasterList)
		
		If ($showWithOutInventory)
			For ($i; 1; Size of array:C274(<>aOrdKey))
				$hit:=Find in array:C230(<>aFGKey; <>aOrdKey{$i})
				If ($hit=-1)
					$newElement:=Size of array:C274($aFGmasterList)+1
					INSERT IN ARRAY:C227($aFGmasterList; $newElement; 1)
					$aFGmasterList{$newElement}:=<>aOrdKey{$i}
				End if 
			End for 
			
			For ($i; 1; Size of array:C274(<>aRelKey))
				$hit:=Find in array:C230(<>aFGKey; <>aRelKey{$i})
				If ($hit=-1)
					$newElement:=Size of array:C274($aFGmasterList)+1
					INSERT IN ARRAY:C227($aFGmasterList; $newElement; 1)
					$aFGmasterList{$newElement}:=<>aRelKey{$i}
				End if 
			End for 
			SORT ARRAY:C229($aFGmasterList; >)
		End if   //•1/26/01  mlb  
		
		//ALERT("Size of array($aFGmasterList) = "+String(Size of array($aFGmasterList)))
		uThermoInit(Size of array:C274($aFGmasterList); "Reporting...")
		For ($i; 1; Size of array:C274($aFGmasterList))
			$numFound:=qryFinishedGood("#KEY"; $aFGmasterList{$i})
			
			If ($onlyPromo)
				If ([Finished_Goods:26]OrderType:59="Promotional")
					$continue:=True:C214
				Else 
					$continue:=False:C215
				End if 
			Else 
				$continue:=True:C214
			End if 
			
			If ($continue)
				If ($numFound>0)
					$line:=[Finished_Goods:26]Line_Brand:15
				Else 
					$line:="n/f"
				End if 
				
				$fgitem:=Find in array:C230(<>aFGKey; $aFGmasterList{$i})
				If ($fgitem>-1)  //show the inventory
					xText:=xText+Substring:C12(<>aFGKey{$fgitem}; 1; 5)+$t+$line+$t+Substring:C12(<>aFGKey{$fgitem}; 7)+$t+String:C10(<>aQty_OH{$fgitem})+$t+String:C10(<>aQty_FG{$fgitem})+$t+String:C10(<>aQty_CC{$fgitem})+$t+String:C10(<>aQty_EX{$fgitem})+$t+String:C10(<>aQty_BH{$fgitem})+$t
				Else 
					xText:=xText+Substring:C12($aFGmasterList{$i}; 1; 5)+$t+$line+$t+Substring:C12($aFGmasterList{$i}; 7)+$t+"0"+$t+"0"+$t+"0"+$t+"0"+$t+"0"+$t
				End if 
				
				$orditem:=Find in array:C230(<>aOrdKey; $aFGmasterList{$i})
				If ($orditem>-1)  //show the orders
					xText:=xText+String:C10(<>aQty_Open{$orditem})+$t+String:C10(<>aQty_ORun{$orditem})+$t
				Else 
					xText:=xText+"0"+$t+"0"+$t
				End if 
				
				$relitem:=Find in array:C230(<>aRelKey; $aFGmasterList{$i})
				If ($relitem>-1)  //show the releases
					xText:=xText+String:C10(<>aRel_Open{$relitem})+$t
				Else 
					xText:=xText+"0"+$t
				End if 
				
				$row:=String:C10($i+2)
				xText:=xText+"=IF(D"+$row+">(I"+$row+"+J"+$row+"),D"+$row+"-(I"+$row+"+J"+$row+"),0)"+$t
				xText:=xText+"=IF(D"+$row+">K"+$row+",D"+$row+"-K"+$row+",0)"+$t
				If ($listPrice)
					If ($numFound>0)
						xText:=xText+String:C10([Finished_Goods:26]RKContractPrice:49)
					Else 
						xText:=xText+"n/f"
					End if 
				Else 
					xText:=xText+""
				End if 
				
				If ($fgitem>-1)
					xText:=xText+$t+String:C10(<>aQty_PAYUSE{$fgitem})+$t
				Else 
					xText:=xText+$t+"0"+$t
				End if 
				
				$qtyWIP:=0
				$numJMI:=qryJMI("@"; 0; Substring:C12($aFGmasterList{$i}; 7))
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				If (Records in selection:C76([Job_Forms_Items:44])>0)
					ARRAY LONGINT:C221($aQty; 0)
					ARRAY LONGINT:C221($aActQty; 0)
					SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Yield:9; $aQty; [Job_Forms_Items:44]Qty_Actual:11; $aActQty)
					For ($jobit; 1; Size of array:C274($aQty))
						$openProduction:=$aQty{$jobit}-$aActQty{$jobit}
						If ($openProduction<0)  //excess
							$openProduction:=0
						End if 
						$qtyWIP:=$qtyWIP+$openProduction
					End for 
					ARRAY LONGINT:C221($aQty; 0)
					ARRAY LONGINT:C221($aActQty; 0)
				End if 
				xText:=xText+String:C10($qtyWIP)
				xRemark:=[Finished_Goods:26]CartonDesc:3
				xRemark:=Replace string:C233(xRemark; $cr; "<cr>")
				xRemark:=Replace string:C233(xRemark; $t; "<tab>")
				xRemark:=Replace string:C233(xRemark; Char:C90(Double quote:K15:41); "<q>")
				txt_Gremlinizer(->xRemark)
				
				xText:=xText+$t+xRemark
				
				If ($showDestinations)
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=Substring:C12($aFGmasterList{$i}; 7); *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
					$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
					SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Shipto:10; $aDest)
					
					$dest:=""
					
					For ($rel; 1; $numRels)
						If (Length:C16($aDest{$rel})=5)
							If (Position:C15($aDest{$rel}; $dest)=0)
								$dest:=$dest+$aDest{$rel}+"-"+ADDR_getCity($aDest{$rel})+" "
							End if 
						End if 
					End for 
					
					xText:=xText+$t+$dest
				End if 
				
				If ($showOpenOrders)
					QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=Substring:C12($aFGmasterList{$i}; 7))
					$numPOs:=qryOpenOrdLines(""; "*")
					SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOL; [Customers_Order_Lines:41]Qty_Open:11; $aQty; [Customers_Order_Lines:41]PONumber:21; $aPO)
					SORT ARRAY:C229($aOL; $aQty; $aPO; >)
					
					For ($po; 1; $numPOs)
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$aOL{$po}; *)
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
						If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
							$rels:=Sum:C1([Customers_ReleaseSchedules:46]OpenQty:16)
						Else 
							$rels:=0
						End if 
						xText:=xText+$t+$aPO{$po}+$t+String:C10($aQty{$po})+$t+String:C10($rels)
					End for 
				End if 
				
				xText:=xText+$cr
				If (Length:C16(xText)>20000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
			End if   //continue
			
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		SEND PACKET:C103($docRef; xText)
		CLOSE DOCUMENT:C267($docRef)
		//// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		$err:=util_Launch_External_App(docName)
		BEEP:C151
	End if   //open doc
	
Else 
	ALERT:C41("Report cancelled")
End if   //did search
REDUCE SELECTION:C351([Finished_Goods:26]; 0)