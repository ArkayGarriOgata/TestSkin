//%attributes = {"publishedWeb":true}
//(p) RMReturn
//upr 1265 10/14/94
//upr 1261 10/27/94
//1651
//•upr 0235 1/2/97 -cs - changes in charge code mean we have to insure that the
//  three new fields get populated as the records are created
//•2/13/97  get company for xfer from bin NOT from po_item
//• 8/12/97 cs return system is NOT updateing PO_Item received quantities
//  inserted code to do this
//• 11/4/97 cs created this procedure from script
//• 11/4/97 cs when posting to a non existant Bin retunr Qty gets placed
//  against PO but NO xFer is created.
//•121698  Systems G3  UPR convert to po units
//• mlb - 10/22/02  15:33 reverse the amount from job that was direct Purchased
// • mel (10/14/04, 14:38:49) reverse outof the JobSummarry report
// Modified by: Mel Bohince (5/4/17) use rRealShippingUOM which is converted from the amt entered on dialog
C_REAL:C285(rRealShippingUOM)

uClearSelection(->[Purchase_Orders_Items:12])
READ WRITE:C146([Purchase_Orders_Items:12])
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
<>fContinue:=True:C214
fLockNLoad(->[Purchase_Orders_Items:12])

If (<>fContinue)  //not canceled while positing
	If (rReal1#0)  //rReal1 is in our issue UOM
		//poi received is in shipping uom
		rRealShippingUOM:=rReal1*([Purchase_Orders_Items:12]FactNship2cost:29/[Purchase_Orders_Items:12]FactDship2cost:37)
		[Purchase_Orders_Items:12]Qty_Received:14:=Round:C94(([Purchase_Orders_Items:12]Qty_Received:14-rRealShippingUOM); 2)
		// Modified by: Mel Bohince (5/4/17) no conversion needed on qty open
		//[Purchase_Orders_Items]Qty_Open:=Round([Purchase_Orders_Items]Qty_Open+(rReal1*([Purchase_Orders_Items]FactNship2cost/[Purchase_Orders_Items]FactDship2cost));2)
		[Purchase_Orders_Items:12]Qty_Open:27:=[Purchase_Orders_Items:12]Qty_Shipping:4-[Purchase_Orders_Items:12]Qty_Received:14
		SAVE RECORD:C53([Purchase_Orders_Items:12])
		
		Case of 
			: ([Raw_Materials_Groups:22]ReceiptType:13=1) | (Records in selection:C76([Raw_Materials_Locations:25])>0)  //upr 1265
				If (Records in selection:C76([Raw_Materials_Locations:25])#0)
					[Raw_Materials_Locations:25]ModWho:22:=<>zResp
					[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
					[Raw_Materials_Locations:25]QtyOH:9:=Round:C94([Raw_Materials_Locations:25]QtyOH:9-rReal1; 2)
					[Raw_Materials_Locations:25]QtyAvailable:13:=Round:C94([Raw_Materials_Locations:25]QtyAvailable:13-rReal1; 2)
					$CompanyId:=[Raw_Materials_Locations:25]CompanyID:27  //•2/13/97 save off company for xfer record
					SAVE RECORD:C53([Raw_Materials_Locations:25])
					If ([Raw_Materials_Locations:25]QtyOH:9=0) & (Not:C34([Raw_Materials_Locations:25]PiDoNotDelete:24) & ([Raw_Materials_Locations:25]ConsignmentQty:26=0))  //10/13/94
						DELETE RECORD:C58([Raw_Materials_Locations:25])
					Else 
						UNLOAD RECORD:C212([Raw_Materials_Locations:25])
					End if 
					//next create transfer OUT record
					If (dDate=!00-00-00!)  //1651
						dDate:=4D_Current_date
					End if 
					
					CREATE RECORD:C68([Raw_Materials_Transactions:23])
					[Raw_Materials_Transactions:23]ReferenceNo:14:=sCriterion4
					RmXferPopulate($CompanyID)
					SAVE RECORD:C53([Raw_Materials_Transactions:23])
					zwStatusMsg("RETURN"; String:C10(rReal1)+" of "+sCriterion2+" was returned")
					
				Else 
					BEEP:C151
					REJECT:C38
					ALERT:C41("No Bin record exists."+Char:C90(13)+"No Return posted. ")  //• 11/4/97 cs inform user
				End if 
				
			: ([Raw_Materials_Groups:22]ReceiptType:13=2)
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt"; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]POItemKey:4=sCriterion2)
				$test:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				If ($test<rReal1)
					BEEP:C151
					CONFIRM:C162("You are returning more than has been received, Continue?")
				Else 
					OK:=1
				End if 
				
				If (OK=1)
					CREATE RECORD:C68([Raw_Materials_Transactions:23])
					RmXferPopulate($CompanyID)
					SAVE RECORD:C53([Raw_Materials_Transactions:23])
					zwStatusMsg("RETURN"; String:C10(rReal1)+" of "+sCriterion2+" was returned")
					//• mlb - 10/22/02  15:33 reverse the amount from job that was direct Purchased
					SET QUERY LIMIT:C395(1)
					QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=sCriterion2; *)
					QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15; *)
					QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
					SET QUERY LIMIT:C395(0)
					If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
						DUPLICATE RECORD:C225([Raw_Materials_Transactions:23])
						[Raw_Materials_Transactions:23]pk_id:32:=Generate UUID:C1066
						[Raw_Materials_Transactions:23]Qty:6:=rReal1
						[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94([Raw_Materials_Transactions:23]Qty:6*[Raw_Materials_Transactions:23]ActCost:9; 2))
						[Raw_Materials_Transactions:23]viaLocation:11:="WIP"
						[Raw_Materials_Transactions:23]Location:15:="Vendor"
						[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
						[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
						[Raw_Materials_Transactions:23]Reason:5:="Direct Purchase Return"
						// deleted 5/15/20: gns_ams_clear_sync_fields(->[Raw_Materials_Transactions]z_SYNC_ID;->[Raw_Materials_Transactions]z_SYNC_DATA)
						
						SAVE RECORD:C53([Raw_Materials_Transactions:23])
						// • mel (10/14/04, 15:12:03)
						// Modified by: Mel Bohince (6/30/16) add comments
						READ WRITE:C146([Job_Forms_CloseoutSummaries:87])
						QUERY:C277([Job_Forms_CloseoutSummaries:87]; [Job_Forms_CloseoutSummaries:87]JobForm:1=[Raw_Materials_Transactions:23]JobForm:12)
						If (Records in selection:C76([Job_Forms_CloseoutSummaries:87])>0)
							[Job_Forms_CloseoutSummaries:87]TotalMaterial:20:=[Job_Forms_CloseoutSummaries:87]TotalMaterial:20-[Raw_Materials_Transactions:23]ActExtCost:10  //reduce matl by rtn amt$
							[Job_Forms_CloseoutSummaries:87]TotalCost:22:=[Job_Forms_CloseoutSummaries:87]TotalMaterial:20+[Job_Forms_CloseoutSummaries:87]TotalConversion:21  //recalc ttl cost
							[Job_Forms_CloseoutSummaries:87]ActContrib:14:=[Job_Forms_CloseoutSummaries:87]TotalCost:22-[Job_Forms_CloseoutSummaries:87]ActSP:18  //recalc contribution
							[Job_Forms_CloseoutSummaries:87]ActPV:15:=Round:C94([Job_Forms_CloseoutSummaries:87]ActContrib:14/[Job_Forms_CloseoutSummaries:87]ActSP:18; 3)  //recalc pv
							[Job_Forms_CloseoutSummaries:87]ContribVar:16:=[Job_Forms_CloseoutSummaries:87]ActContrib:14-[Job_Forms_CloseoutSummaries:87]BookContrib:12  //recalc variance
							SAVE RECORD:C53([Job_Forms_CloseoutSummaries:87])
							REDUCE SELECTION:C351([Job_Forms_CloseoutSummaries:87]; 0)
						End if 
						
					End if 
					
				Else 
					BEEP:C151
					REJECT:C38
					zwStatusMsg("ABORT"; "Invalid Return Quantity. No Return posted. ")  //• 11/4/97 cs inform user
				End if 
				
			: ([Raw_Materials_Groups:22]ReceiptType:13=3)
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt"; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]POItemKey:4=sCriterion2)
				$test:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				If ($test<rReal1)
					BEEP:C151
					CONFIRM:C162("You are returning more than has been received, Continue?")
				Else 
					OK:=1
				End if 
				
				If (OK=1)
					CREATE RECORD:C68([Raw_Materials_Transactions:23])
					RmXferPopulate($CompanyID)
					SAVE RECORD:C53([Raw_Materials_Transactions:23])
					zwStatusMsg("RETURN"; String:C10(rReal1)+" of "+sCriterion2+" was returned")
					
				Else 
					BEEP:C151
					REJECT:C38
					zwStatusMsg("ABORT"; "Invalid Return Quantity. No Return posted. ")  //• 11/4/97 cs inform user
				End if 
		End case 
		
		rReal1:=0
		rRealShippingUOM:=0
		sCriterion2:=""
		sCriterion1:=""
		sCriterion3:=""
		sCriterion4:=""
		GOTO OBJECT:C206(sCriterion2)
		
	End if   //!0
	
Else   //• 8/12/97 cs isure user knows that nothing happened
	ALERT:C41("Transaction aborted by user."+Char:C90(13)+"No Return was posted. ")
End if 
REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)