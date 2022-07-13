//%attributes = {}
// ----------
// Method: trigger_RM_xfers
///-------------
// User name (OS): Mel Bohince
// Date and time: 04/16/12, 14:49:41
// ---------------
// Description
// set the time of the transaction if †00:00:00†
// ------------------
// Modified by: Mel Bohince (1/9/15) have transaction update bin, job, & alloc
// Modified by: Mel Bohince (3/18/18) use [Raw_Materials_Transactions]RM_Label_Id field in line 46 not variable
// Modified by: Mel Bohince (6/11/18) check fro locked bin record
// Modified by: Mel Bohince (4/11/19) negatives and zeros are not helpful
// Modified by: Garri Ogata (8/23/21) 1500 or less is not helpful
// Modified by: Mel Bohince (12/17/21) add '.log' at line 67 so Console would see the file.
// Modified by: MelvinBohince (2/3/22) increase qty issued on allocation for cold foil instead of deleting

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		If ([Raw_Materials_Transactions:23]XferTime:25=?00:00:00?)
			[Raw_Materials_Transactions:23]XferTime:25:=4d_Current_time
		End if 
		
		If (Position:C15("RMX_Issue_Dialog"; [Raw_Materials_Transactions:23]Reason:5)>0)  // Modified by: Mel Bohince (1/9/15) have transaction update bin, job, & alloc
			///////Relieve Inventory
			$qtyRelieved:=[Raw_Materials_Transactions:23]Qty:6*-1  //issues are saved as negatives, so flip it
			
			READ WRITE:C146([Raw_Materials_Locations:25])
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=[Raw_Materials_Transactions:23]POItemKey:4; *)
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=[Raw_Materials_Transactions:23]viaLocation:11)
			If (Records in selection:C76([Raw_Materials_Locations:25])>0)
				If (fLockNLoad(->[Raw_Materials_Locations:25]; "no msg"))  // Modified by: Mel Bohince (6/11/18) 
					[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9-$qtyRelieved
					[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13-$qtyRelieved
					[Raw_Materials_Locations:25]QtyCommitted:11:=[Raw_Materials_Locations:25]QtyCommitted:11-$qtyRelieved
					
					If ([Raw_Materials_Locations:25]QtyOH:9=0) & (Not:C34([Raw_Materials_Locations:25]PiDoNotDelete:24)) & ([Raw_Materials_Locations:25]ConsignmentQty:26=0)  //• mlb - 2/5/03  16:43
						DELETE RECORD:C58([Raw_Materials_Locations:25])
					Else 
						SAVE RECORD:C53([Raw_Materials_Locations:25])
						UNLOAD RECORD:C212([Raw_Materials_Locations:25])
					End if 
					
				Else 
					RM_BinCreateNegative
					utl_LogfileServer(<>zResp; "[Raw_Materials_Locations] record locked during RMX_Issue_Dialog, negative bin created"; "recordlock.log")
				End if 
				
			Else   // Modified by: Mel Bohince (8/31/18) create a negative
				RM_BinCreateNegative
			End if 
			
			// Modified by: Mel Bohince (3/10/18) 
			///////Handle roll records
			If (Length:C16([Raw_Materials_Transactions:23]RM_Label_Id:34)>0)
				READ WRITE:C146([Raw_Material_Labels:171])
				QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2=[Raw_Materials_Transactions:23]RM_Label_Id:34)
				If (Records in selection:C76([Raw_Material_Labels:171])=1)
					If (fLockNLoad(->[Raw_Material_Labels:171]; "no msg"))
						//If ([Raw_Material_Labels]Qty>$qtyRelieved)  // Modified by: Mel Bohince (4/11/19) 
						If (([Raw_Material_Labels:171]Qty:8-$qtyRelieved)>1500)  //Modified by: Garri Ogata (8/20/21)
							[Raw_Material_Labels:171]Qty:8:=[Raw_Material_Labels:171]Qty:8-$qtyRelieved
							SAVE RECORD:C53([Raw_Material_Labels:171])
							UNLOAD RECORD:C212([Raw_Material_Labels:171])
						Else 
							utl_Logfile("RM_Labels.log"; "Deleted label "+[Raw_Material_Labels:171]Label_id:2+" quantity was "+String:C10([Raw_Material_Labels:171]Qty:8-$qtyRelieved)+" poi: "+[Raw_Material_Labels:171]POItemKey:3)
							DELETE RECORD:C58([Raw_Material_Labels:171])  // Modified by: Mel Bohince (4/11/19) negatives and zeros are not helpful
						End if 
					End if 
					
				Else 
					utl_LogfileServer(<>zResp; "RM Label '"+[Raw_Materials_Transactions:23]RM_Label_Id:34+"' could not be updated "; "recordlock.log")
				End if 
			End if 
			
			///////Handle Allocations
			READ WRITE:C146([Raw_Materials_Allocations:58])
			Case of 
				: (([Raw_Materials_Transactions:23]CommodityCode:24=1) | ([Raw_Materials_Transactions:23]CommodityCode:24=12) | ([Raw_Materials_Transactions:23]CommodityCode:24=20))  //board or sensor labels
					QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1; *)  //the issued rm should match the planned rm
					QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]JobForm:3=[Raw_Materials_Transactions:23]JobForm:12)
					If (Records in selection:C76([Raw_Materials_Allocations:58])>0)
						If (fLockNLoad(->[Raw_Materials_Allocations:58]))
							[Raw_Materials_Allocations:58]Qty_Issued:6:=[Raw_Materials_Allocations:58]Qty_Issued:6+$qtyRelieved  //will still show on allocation report prefixed with a bullet •
							[Raw_Materials_Allocations:58]Date_Issued:7:=4D_Current_date
							SAVE RECORD:C53([Raw_Materials_Allocations:58])
						Else 
							utl_LogfileServer(<>zResp; "Issue against '"+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+"' allocation failed on job "+[Raw_Materials_Transactions:23]JobForm:12+", Delete the board allocation manually!"; "recordlock.log")
						End if 
					End if 
					
				: ([Raw_Materials_Transactions:23]CommodityCode:24=9)  //cold foil 
					QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]commdityKey:13="09@"; *)  //the issued rm may or may not match the planned rm
					//QUERY([Raw_Materials_Allocations]; | ;[Raw_Materials_Allocations]commdityKey="05@";*)
					QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]JobForm:3=[Raw_Materials_Transactions:23]JobForm:12)
					If (Records in selection:C76([Raw_Materials_Allocations:58])>0)
						If (fLockNLoad(->[Raw_Materials_Allocations:58]))
							[Raw_Materials_Allocations:58]Qty_Issued:6:=[Raw_Materials_Allocations:58]Qty_Issued:6+$qtyRelieved  //will still show on allocation report prefixed with a bullet •
							[Raw_Materials_Allocations:58]Date_Issued:7:=4D_Current_date
							SAVE RECORD:C53([Raw_Materials_Allocations:58])
						Else 
							utl_LogfileServer(<>zResp; "Issue against '"+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+"' allocation failed on job "+[Raw_Materials_Transactions:23]JobForm:12+", Delete the board allocation manually!"; "recordlock.log")
						End if 
						
						//$locked:=util_DeleteSelection (->[Raw_Materials_Allocations])  //assuming cold foil is issued all at once, so no reason for allocations records to remain
					End if 
					//If ($locked>0)
					//utl_LogfileServer (<>zResp;"Issue against '"+[Raw_Materials_Transactions]Raw_Matl_Code+"' allocation failed on job "+[Raw_Materials_Transactions]JobForm+", Delete the coldfoil allocation manually!";"recordlock.log")
					//End if 
			End case 
			UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
			
			///////Handle Jobforms BOM, not critical, updated during closeout anyway
			READ WRITE:C146([Job_Forms_Materials:55])
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Raw_Materials_Transactions:23]JobForm:12; *)
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Sequence:3=[Raw_Materials_Transactions:23]Sequence:13)  //mlb 10/27/10
			//QUERY([Job_Forms_Materials]; & ;[Job_Forms_Materials]Raw_Matl_Code=[Raw_Materials_Transactions]Raw_Matl_Code)
			If (Records in selection:C76([Job_Forms_Materials:55])>0)
				If (Not:C34(Locked:C147([Job_Forms_Materials:55])))  //optimistic here, there is a recalc later anyway 
					[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck([Job_Forms_Materials:55]Actual_Qty:14+$qtyRelieved)
					[Job_Forms_Materials:55]Actual_Price:15:=[Job_Forms_Materials:55]Actual_Price:15+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
					SAVE RECORD:C53([Job_Forms_Materials:55])
				End if 
			End if   //found jfm
			UNLOAD RECORD:C212([Job_Forms_Materials:55])
			
		End if   //rmx dialog
		
End case   //db event