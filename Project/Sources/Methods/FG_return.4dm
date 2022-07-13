//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: FG_return

//upr 89 7/28/94
//7/29/94
//upr 108 8/17/94
//9/13/94
//BAK UPR 1237 9/26/94
//upr 1326 03/09/95 chip
//4/27/95 upr 1252 chip
//4/28/95 upr 1475 chip stop invoice number from being overwritten on credit memo
//•080395  MLB  UPR 1490
//•022897  MLB  recalc qtyOpen

C_LONGINT:C283($arkayRel; $err)
C_BOOLEAN:C305($continue)
C_DATE:C307($xactionDate)
C_TEXT:C284($billto; $shipto)

$xactionDate:=4D_Current_date
//search for valid raw material
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=sCriterion1; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]CustID:2=sCriterion2)
If (Records in selection:C76([Finished_Goods:26])=0)
	uRejectAlert("Invalid F/G code!")
Else 
	READ WRITE:C146([Customers_Order_Lines:41])
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=sCriterion6)
	If (Records in selection:C76([Customers_Order_Lines:41])=0)
		uRejectAlert("Invalid Order Item number!")
	Else 
		//check to make sure order item matches otehr elements
		//product code, cust ID,
		If (([Customers_Order_Lines:41]ProductCode:5#sCriterion1) | ([Customers_Order_Lines:41]CustID:4#sCriterion2))
			uRejectAlert("Order Item does not match cust id or cpn.")
		Else 
			If (Locked:C147([Customers_Order_Lines:41]))
				uLockMessage(->[Customers_Order_Lines:41])
			Else 
				$body:="Jobit: "+JMI_makeJobIt(sCriterion5; i1)+" for "+String:C10(rReal1)+" cartons."
				EMAIL_Sender("Return of "+sCriterion1; ""; $body; "john.sheridan@arkay.com"+Char:C90(9)+"john.ranson@arkay.com")
				
				START TRANSACTION:C239
				If (Substring:C12(sCriter12; 1; 1)="R")
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=sCriterion6)
					Case of 
						: (Records in selection:C76([Customers_ReleaseSchedules:46])=1)
							$arkayRel:=[Customers_ReleaseSchedules:46]ReleaseNumber:1
							
						: (Records in selection:C76([Customers_ReleaseSchedules:46])=0)
							$arkayRel:=0
							
						Else 
							QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=(JMI_makeJobIt(sCriterion5; i1)); *)
							QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="ship")
							If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
								$hit:=Position:C15("/"; [Finished_Goods_Transactions:33]OrderItem:16)
								$arkayRel:=Num:C11(Substring:C12([Finished_Goods_Transactions:33]OrderItem:16; $hit+1))
							Else 
								$arkayRel:=0
							End if 
							
					End case 
					
				Else 
					$arkayRel:=Num:C11(sCriter12)
				End if 
				
				If (OK=0)
					$continue:=False:C215
				Else 
					$continue:=True:C214
					READ WRITE:C146([Customers_ReleaseSchedules:46])
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=$arkayRel)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])=1)
						$continue:=True:C214
						//MOD BAK UPR 1237 9/26/94
						READ WRITE:C146([Customers_Orders:40])
						QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_Order_Lines:41]OrderNumber:1)
						//End Of Mod BAK 9/26/94
						[Customers_Order_Lines:41]Qty_Returned:35:=[Customers_Order_Lines:41]Qty_Returned:35+rReal1
						//[OrderLines]Qty_Open:=[OrderLines]Qty_Open+rReal1`•022897  MLB  recalc qtyOpen
						[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]Qty_Shipped:10+[Customers_Order_Lines:41]Qty_Returned:35  //•022897  MLB  recalc qtyOpen
						If ([Customers_Order_Lines:41]Qty_Open:11>0)
							If ([Customers_Order_Lines:41]Status:9="Closed")
								[Customers_Order_Lines:41]Status:9:="Accepted"
							End if 
							If ([Customers_Orders:40]Status:10="Closed")
								[Customers_Orders:40]Status:10:="Accepted"
								SAVE RECORD:C53([Customers_Orders:40])
							End if 
						End if 
						SAVE RECORD:C53([Customers_Order_Lines:41])
						
						//MOD BAK UPR 1237 9/26/94
						dAppDate:=4D_Current_date
						
						$invoiceNum:=Invoice_GetNewNumber
						$billto:=[Customers_ReleaseSchedules:46]Billto:22
						$shipto:=[Customers_ReleaseSchedules:46]Shipto:10
						
						$err:=Invoice_NewReturn([Customers_Order_Lines:41]OrderLine:3; $invoiceNum; rReal1)
						
						//API_SendInvTran (254;255;$invoiceNum;$arkayRel;$billto;$shipto;$cpn;$custPO
						//«;$custRel;$BOLnum;$FOB;$subamt;$custID;"NEW";$Remark)  `4/28/95
						
						[Customers_ReleaseSchedules:46]ChangeLog:23:=[Customers_ReleaseSchedules:46]ChangeLog:23+Char:C90(13)+String:C10(rReal1)+" returned on "+String:C10(4D_Current_date; 1)
						SAVE RECORD:C53([Customers_ReleaseSchedules:46])
						
					Else 
						BEEP:C151
						ALERT:C41("Release number "+String:C10($arkayRel)+" was not found.")
						$continue:=False:C215
					End if 
					
				End if   //release num OK   
				
				If ($continue)
					//search for TO bin
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=sCriterion1; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=sCriterion2; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2=sCriterion4; *)  //Examining
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Jobit:33=(JMI_makeJobIt(sCriterion5; i1)))
					If (Records in selection:C76([Finished_Goods_Locations:35])=0)
						CONFIRM:C162("Create a new bin record?"+Char:C90(13)+sCriterion1+":"+sCriterion2+"/"+sCriterion5+"@"+sCriterion4)
						If (OK=1)
							$continue:=True:C214
							FG_makeLocation
						Else 
							$continue:=False:C215
						End if   //new rec    
					Else 
						If (Locked:C147([Finished_Goods_Locations:35]))  //locked, can't continue
							uLockMessage(->[Finished_Goods_Locations:35])
							$continue:=False:C215
						Else 
							$continue:=True:C214
						End if 
					End if 
					
					If ($continue)
						uChgFGqty(1)
						FG_SaveBinLocation($xactionDate)
						FG_loadJobAndOrder
						//next create transfer IN out record
						
						//BAK 9/27/94 for FG Cost of Sales by Job Report - can't find Invoice #
						$sCriter6:=sCriterion6
						sCriterion6:=sCriterion6+"/"+String:C10($arkayRel)  //assign Release #
						FGX_post_transaction($xactionDate; 1; "Return")
						
						sCriterion6:=$sCriter6  //put back the way it was
						//End Of Mod
						
						READ WRITE:C146([Customers:16])
						QUERY:C277([Customers:16]; [Customers:16]ID:1=sCriterion2)
						If (Not:C34([Customers:16]ReturnedFG:39))
							[Customers:16]ReturnedFG:39:=True:C214
							SAVE RECORD:C53([Customers:16])
						End if 
						//upr 108
						CREATE RECORD:C68([Customers_ReleaseSchedules:46])
						[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
						[Customers_ReleaseSchedules:46]OrderNumber:2:=Num:C11(Substring:C12(sCriterion6; 1; 5))
						[Customers_ReleaseSchedules:46]OrderLine:4:=sCriterion6
						[Customers_ReleaseSchedules:46]Shipto:10:=$shipto
						[Customers_ReleaseSchedules:46]InvoiceNumber:9:=$invoiceNum
						[Customers_ReleaseSchedules:46]Billto:22:=$billto
						[Customers_ReleaseSchedules:46]ProductCode:11:=sCriterion1
						[Customers_ReleaseSchedules:46]CustID:12:=sCriterion2
						[Customers_ReleaseSchedules:46]CustomerRefer:3:="Rtn: "+String:C10(rReal1)
						[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
						[Customers_ReleaseSchedules:46]Actual_Date:7:=$xactionDate
						[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
						[Customers_ReleaseSchedules:46]ChangeLog:23:=String:C10(rReal1)+" returned on "+String:C10(4D_Current_date; 1)
						If (Substring:C12(sCriter12; 1; 1)="R")
							[Customers_ReleaseSchedules:46]Expedite:35:="RGA#"+sCriter12
							[QA_Corrective_Actions:105]QtyReturned:28:=[QA_Corrective_Actions:105]QtyReturned:28+rReal1
							SAVE RECORD:C53([QA_Corrective_Actions:105])
						End if 
						SAVE RECORD:C53([Customers_ReleaseSchedules:46])
					End if 
				End if 
				
				If ($continue)
					VALIDATE TRANSACTION:C240
				Else 
					CANCEL TRANSACTION:C241
				End if 
			End if 
		End if 
	End if 
End if 

UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
UNLOAD RECORD:C212([Customers_Order_Lines:41])
UNLOAD RECORD:C212([Finished_Goods:26])
UNLOAD RECORD:C212([Customers:16])
UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
UNLOAD RECORD:C212([Customers_Orders:40])
UNLOAD RECORD:C212([Job_Forms_Items:44])
UNLOAD RECORD:C212([QA_Corrective_Actions:105])