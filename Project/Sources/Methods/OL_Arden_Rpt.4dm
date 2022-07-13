//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/12/08, 16:02:35
// ----------------------------------------------------
// Method: OL_Arden_Rpt
// ----------------------------------------------------

READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods_PackingSpecs:91])
READ ONLY:C145([Job_Forms_Items:44])

C_TEXT:C284($1; xTitle; xText; docName)  //email distribution list
C_TEXT:C284($t; $r)
C_DATE:C307($today)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$r:=Char:C90(13)
$today:=4D_Current_date
xTitle:=""
xText:=""

$custId:=Request:C163("Enter the Customer ID;"; "00074")
If (OK=1) & (Length:C16($custId)=5)
	Case of 
		: ($custid="00074")
			docName:="Arden_Rpt_"+fYYMMDD($today; 1)+".xls"
		Else 
			docName:=$custid+"_Rpt_"+fYYMMDD($today; 1)+".xls"
	End case 
	xTitle:=docName
	
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$custId; *)
	QUERY:C277([Customers_Order_Lines:41];  & [Customers_Order_Lines:41]Status:9#"C@")
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5; >; [Customers_Order_Lines:41]OrderLine:3; >)
			
			SEND PACKET:C103($docRef; xTitle+$r+$r)
			xText:="PRODUCT_CODE"+$t+"LINE"+$t+"DESCRIPTION"+$t+"PO_NUM"+$t+"ORDERLINE"+$t+"QTY_OPEN"+$t+"QTY_RELEASED"+$t+"QTY_ONHAND"+$t+"QTY_SHIPABLE"+$t+"CASE_COUNT"+$t+"SKID_COUNT"+$t+"OPEN_JOBS"+$t+"QTY_PLANNED"+$t+"QTY_PRODUCED"+$r
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				While (Not:C34(End selection:C36([Customers_Order_Lines:41])))
					xText:=xText+[Customers_Order_Lines:41]ProductCode:5+$t
					
					$numFound:=qryFinishedGood($custid; [Customers_Order_Lines:41]ProductCode:5)
					xText:=xText+[Finished_Goods:26]Line_Brand:15+$t
					xText:=xText+[Finished_Goods:26]CartonDesc:3+$t
					
					xText:=xText+[Customers_Order_Lines:41]PONumber:21+$t
					xText:=xText+[Customers_Order_Lines:41]OrderLine:3+$t
					xText:=xText+String:C10([Customers_Order_Lines:41]Qty_Open:11)+$t
					
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3; *)
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						$qty_released:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
					Else 
						$qty_released:=0
					End if 
					xText:=xText+String:C10($qty_released)+$t
					
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16=$custid)
					SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aBin; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
					$total_onhand:=0
					$total_shipable:=0
					For ($i; 1; Size of array:C274($aBin))
						$total_onhand:=$total_onhand+$aQty{$i}
						If (Position:C15("FG"; $aBin{$i})>0)
							$total_shipable:=$total_shipable+$aQty{$i}
						End if 
					End for 
					xText:=xText+String:C10($total_onhand)+$t
					xText:=xText+String:C10($total_shipable)+$t
					
					xText:=xText+String:C10(PK_getCaseCount([Finished_Goods:26]OutLine_Num:4))+$t
					xText:=xText+String:C10(PK_getSkidCount([Finished_Goods:26]OutLine_Num:4))+$t
					
					xText:=xText+JMI_plannedProduction([Customers_Order_Lines:41]ProductCode:5; [Customers_Order_Lines:41]OrderLine:3)+$t
					xText:=xText+String:C10(JMI_getPlannedQty([Customers_Order_Lines:41]ProductCode:5))+$t
					xText:=xText+String:C10(JMI_getProducedQty([Customers_Order_Lines:41]ProductCode:5))+$r
					
					NEXT RECORD:C51([Customers_Order_Lines:41])
					If (Length:C16(xText)>20000)
						SEND PACKET:C103($docRef; xText)
						xText:=""
					End if 
				End while 
				
				
			Else 
				
				ARRAY TEXT:C222($_OrderLine; 0)
				ARRAY TEXT:C222($_ProductCode; 0)
				ARRAY LONGINT:C221($_Qty_Open; 0)
				ARRAY TEXT:C222($_PONumber; 0)
				
				SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $_OrderLine; [Customers_Order_Lines:41]ProductCode:5; $_ProductCode; [Customers_Order_Lines:41]Qty_Open:11; $_Qty_Open; [Customers_Order_Lines:41]PONumber:21; $_PONumber)
				
				For ($Iter; 1; Size of array:C274($_OrderLine); 1)
					xText:=xText+$_ProductCode{$Iter}+$t
					
					$numFound:=qryFinishedGood($custid; $_ProductCode{$Iter})
					xText:=xText+[Finished_Goods:26]Line_Brand:15+$t
					xText:=xText+[Finished_Goods:26]CartonDesc:3+$t
					
					xText:=xText+$_PONumber{$Iter}+$t
					xText:=xText+$_OrderLine{$Iter}+$t
					xText:=xText+String:C10($_Qty_Open{$Iter})+$t
					
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$_OrderLine{$Iter}; *)
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						$qty_released:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
					Else 
						$qty_released:=0
					End if 
					xText:=xText+String:C10($qty_released)+$t
					
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$_ProductCode{$Iter}; *)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16=$custid)
					SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aBin; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
					$total_onhand:=0
					$total_shipable:=0
					For ($i; 1; Size of array:C274($aBin))
						$total_onhand:=$total_onhand+$aQty{$i}
						If (Position:C15("FG"; $aBin{$i})>0)
							$total_shipable:=$total_shipable+$aQty{$i}
						End if 
					End for 
					xText:=xText+String:C10($total_onhand)+$t
					xText:=xText+String:C10($total_shipable)+$t
					
					xText:=xText+String:C10(PK_getCaseCount([Finished_Goods:26]OutLine_Num:4))+$t
					xText:=xText+String:C10(PK_getSkidCount([Finished_Goods:26]OutLine_Num:4))+$t
					
					xText:=xText+JMI_plannedProduction($_ProductCode{$Iter}; $_OrderLine{$Iter})+$t
					xText:=xText+String:C10(JMI_getPlannedQty($_ProductCode{$Iter}))+$t
					xText:=xText+String:C10(JMI_getProducedQty($_ProductCode{$Iter}))+$r
					
					If (Length:C16(xText)>20000)
						SEND PACKET:C103($docRef; xText)
						xText:=""
					End if 
				End for 
				
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			SEND PACKET:C103($docRef; xText)
			SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
			CLOSE DOCUMENT:C267($docRef)
			// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
			BEEP:C151
			If (Count parameters:C259=1)
				xTitle:=$custid+"_Rpt_"+fYYMMDD($today; 1)+".xls"
				EMAIL_Sender(xTitle; ""; "Open attached spreadsheet with Excel."; $1; docName)
				util_deleteDocument(docName)
			Else 
				$err:=util_Launch_External_App(docName)
			End if 
		Else 
			BEEP:C151
		End if 
	Else 
		BEEP:C151
	End if 
End if 