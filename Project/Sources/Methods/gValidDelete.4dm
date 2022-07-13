//%attributes = {"publishedWeb":true}
//gValidDelete: Check for a valid Delete.
//$1 pointer to file to delete from
//9/21/94, now called by doDeleteRecord
//mod 12/12/94 chip 1234
//4/26/95 upr 1469 chip
//• 4/30/98 cs added delete for id numbers
// Modified by: Garri (2/28/20) 
// Modified by: Garri (9/8/21) added JML_Delete (with warning)
Case of 
	: (Count parameters:C259=0)
		BEEP:C151
		ALERT:C41("Trash not operational for this layout")
		
	: (Count parameters:C259=1)
		BEEP:C151
		
		zdeffileptr:=$1
		fCnclTrn:=False:C215
		
		Case of 
			: (zdeffileptr=(->[Job_Forms_Master_Schedule:67]))
				
				JML_Delete
				
			: (zDefFilePtr=(->[x_id_numbers:3]))
				gDeleteRecord(->[x_id_numbers:3])
			: (zdeffileptr=(->[y_accounting_departments:4]))
				gDepartmentDel
			: (zdeffileptr=(->[Users:5]))
				gUserDel
			: (zdeffileptr=(->[Salesmen:32]))
				gSalesmanDel
			: (zdeffileptr=(->[Vendors:7]))
				gVendorDel
			: (zdeffileptr=(->[Customers:16]))
				gCustomerDel
			: (zdeffileptr=(->[Purchase_Orders_Clauses:14]))
				gPOClauseDel
			: (zdeffileptr=(->[Purchase_Orders:11]))
				gPODel
			: (zdeffileptr=(->[Purchase_Orders_Chg_Orders:13]))
				gPOCODel
			: (zdeffileptr=(->[Purchase_Orders_Items:12]))
				gPOItemDel
				
			: (zDefFilePtr=(->[Purchase_Orders_Releases:79]))
				gDeleteRecord(->[Purchase_Orders_Releases:79])
				
			: (zdeffileptr=(->[Customers_Addresses:31]))
				gCCAddrDel
			: (zdeffileptr=(->[Addresses:30]))
				gCustAddrDel
			: (zdeffileptr=(->[Contacts:51]))
				gContactDel
			: (zdeffileptr=(->[Customers_Contacts:52]))
				gCContDel
			: (zdeffileptr=(->[Vendors_Contacts:53]))
				gVendContDel
			: (zdeffileptr=(->[Customers_Orders:40]))
				gCustOrdDel
			: (zdeffileptr=(->[Customers_Order_Lines:41]))
				gCOLineDel
			: (zdeffileptr=(->[Customers_Order_Change_Orders:34]))
				gCOChgHstDel
			: (zdeffileptr=(->[Customers_ReleaseSchedules:46]))
				gRelSchDel
			: (zdeffileptr=(->[Jobs:15]))
				gJobDel
			: (zdeffileptr=(->[Job_Forms:42]))
				gJobFormDel
			: (zdeffileptr=(->[Job_Forms_Machines:43]))
				gBudgetsDel
			: (zdeffileptr=(->[Cost_Centers:27]))
				gCCDel
			: (zdeffileptr=(->[Raw_Materials_Groups:22]))
				RMG_groupDelete
			: (zdeffileptr=(->[Raw_Materials:21]))
				RM_Delete_IfNotReferenced
			: (zdeffileptr=(->[Raw_Materials_Transactions:23]))
				RM_XFerDelete
			: (zdeffileptr=(->[Raw_Materials_Locations:25]))
				RM_BinsDelete
			: (zdeffileptr=(->[Finished_Goods_Classifications:45]))
				gFGGrpDel
			: (zdeffileptr=(->[Finished_Goods:26]))
				gFndGdsDel
			: (zdeffileptr=(->[Finished_Goods_Transactions:33]))
				FG_DeleteXfer
			: (zdeffileptr=(->[Finished_Goods_Locations:35]))
				FG_DeleteBin
				
			: (zdeffileptr=(->[QA_Corrective_Actions:105]))
				If (User in group:C338(Current user:C182; "RoleQA_Mgr"))
					gDeleteRecord(->[QA_Corrective_Actions:105])
				Else 
					uConfirm("Only RoleQA_Mgr's can delete CAR's"; "OK"; "Help")
				End if 
				
			: (zdeffileptr=(->[QA_Corrective_ActionsReason:106]))
				If (User in group:C338(Current user:C182; "RoleQA_Mgr"))
					gDeleteRecord(->[QA_Corrective_ActionsReason:106])
				Else 
					uConfirm("Only RoleQA_Mgr's can delete CAR's Reasons"; "OK"; "Help")
				End if 
				
			: (zdeffileptr=(->[QA_Corrective_ActionsLocations:107]))
				If (User in group:C338(Current user:C182; "RoleQA_Mgr"))
					gDeleteRecord(->[QA_Corrective_ActionsLocations:107])
				Else 
					uConfirm("Only RoleQA_Mgr's can delete CAR's Locations"; "OK"; "Help")
				End if 
				
			: (zdeffileptr=(->[Estimates:17]))
				gEstDel
			: (zdeffileptr=(->[Estimates_Differentials:38]))
				gCaseScenDel
			: (zdeffileptr=(->[Estimates_DifferentialsForms:47]))
				gCaseFormDel
				
			: (zdeffileptr=(->[Estimates_Materials:29]))
				gDeleteRecord(->[Estimates_Materials:29])
				
			: (zdeffileptr=(->[Estimates_Machines:20]))
				gDeleteRecord(->[Estimates_Machines:20])
				
			: (zdeffileptr=(->[Process_Specs:18]))
				gPSpecDel
			: (zdeffileptr=(->[Estimates_Carton_Specs:19]))
				gCSpecDel
				
			: (zdeffileptr=(->[WMS_WarehouseOrders:146]))
				gDeleteRecord(->[WMS_WarehouseOrders:146])
				
			: (zdeffileptr=(->[x_fiscal_calendars:63]))
				gFCDel
				
			: (zDefFilePtr=(->[Purchase_Order_Comm_Clauses:83]))  //4/26/95 upr 1469 chip
				gDelItemClaws
				
			: (zDefFilePtr=(->[Customers_Bills_of_Lading:49]))  //4/26/95 upr 1469 chip
				BOL_DeleteBillOfLading
				
			: (zDefFilePtr=(->[Job_MakeVsBuy:97]))
				gDeleteRecord(->[Job_MakeVsBuy:97])
				
			: (zDefFilePtr=(->[Finished_Goods_SizeAndStyles:132]))
				//gDeleteRecord (->[Finished_Goods_SizeAndStyles])
				
				rfc_Delete  // Modified by: Garri (2/28/20) 
				
			: (zDefFilePtr=(->[Tool_Drawers:151]))
				gDeleteRecord(->[Tool_Drawers:151])
				
			: (zDefFilePtr=(->[WMS_AllowedLocations:73]))
				gDeleteRecord(->[WMS_AllowedLocations:73])
				
			: (zDefFilePtr=(->[Job_Forms_Machine_Tickets:61]))
				gDeleteRecord(->[Job_Forms_Machine_Tickets:61])
				
			: (zDefFilePtr=(->[Raw_Material_Labels:171]))
				gDeleteRecord(->[Raw_Material_Labels:171])
				
			: (zDefFilePtr=(->[Job_Forms_Loads:162]))
				gDeleteRecord(->[Job_Forms_Loads:162])
				
			: (zDefFilePtr=(->[edi_Outbox:155]))
				If ([edi_Outbox:155]SentTimeStamp:4<40)
					gDeleteRecord(->[edi_Outbox:155])
				Else 
					uConfirm("You cannot delete a message that was marked as sent."; "Ok"; "Shucks")
				End if 
				
			Else 
				BEEP:C151
				ALERT:C41("Trash not operational for this layout")
		End case 
		
End case 