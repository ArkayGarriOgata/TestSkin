//%attributes = {"publishedWeb":true}
//mRptMtrlMov: Finished Goods Material Movement Report

C_LONGINT:C283($i; $j)

If (Records in selection:C76([Finished_Goods:26])>0)
	$winRef:=NewWindow(250; 180; 6; 1; "")
	DIALOG:C40([zz_control:1]; "Sel_Month")
	CLOSE WINDOW:C154($winRef)
	util_PAGE_SETUP(->[Finished_Goods:26]; "FGRptHdr1")
	PRINT SETTINGS:C106
	If (OK=1)
		maxPixels:=552
		iPage:=1
		pixels:=0
		rQtyOH:=0
		rQtyOO:=0
		rQtyBO:=0
		rTotQtyOH:=0
		rTotQtyOO:=0
		rTotQtyBO:=0
		fNewRM:=True:C214
		fPrtFlg:=True:C214
		//----------SET UP MAIN HEADER----------
		xReptTitle:="Material Movement Report"
		xComment:="The Report is printed by Finished Goods Location and Date."
		Print form:C5([Finished_Goods:26]; "FGRptHdr1")
		pixels:=pixels+62
		//If multiple items print additional header2
		While (Not:C34(End selection:C36([Finished_Goods:26])))
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1)
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
					
					ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2; >)
					FIRST RECORD:C50([Finished_Goods_Locations:35])
					
					
				Else 
					
					ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2; >)
					// see previous line
					
					
				End if   // END 4D Professional Services : January 2019 First record
				// 4D Professional Services : after Order by , query or any query type you don't need First record  
				For ($i; 1; Records in selection:C76([Finished_Goods_Locations:35]))
					sBin:=[Finished_Goods_Locations:35]Location:2
					rBegQty:=[Finished_Goods_Locations:35]BeginQty:3
					QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=[Finished_Goods_Locations:35]Location:2)
					If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
						ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3; >)
						uChkButtonFG
						If (fPrtFlg=True:C214)
							If (fNewRM=True:C214)
								uChk4RoomFGPB(75; 62; "FGRptHdr1")
								Print form:C5([Finished_Goods:26]; "FGLocatHdr2")
								pixels:=pixels+37
								fNewRM:=False:C215
							End if 
							uChk4RoomFGPB(38; 99; "FGRptHdr1"; "FGLocatHdr2")
							Print form:C5([Finished_Goods:26]; "FGLocatBinNo")
							pixels:=pixels+22
							For ($j; 1; Records in selection:C76([Finished_Goods_Transactions:33]))
								uChkButtonFG
								If (fPrtFlg=True:C214)
									If ([Finished_Goods_Transactions:33]JobForm:5#"")
										sCriterion1:="Receipt"
										sItemNumber:=[Finished_Goods_Transactions:33]JobNo:4+"-"+[Finished_Goods_Transactions:33]JobForm:5
										gQtyChangedFG
									End if 
									If ([Finished_Goods_Transactions:33]OrderItem:16#"")
										sCriterion1:="Issue"
										sItemNumber:=[Finished_Goods_Transactions:33]OrderNo:15+"-"+[Finished_Goods_Transactions:33]OrderItem:16
										gQtyChangedMFG
									End if 
									dRMdate:=[Finished_Goods_Transactions:33]XactionDate:3
									// Take out lowerline when FG Input complete
									rQtyOH:=[Finished_Goods_Transactions:33]Qty:6
									uChk4RoomFGPB(44; 99; "FGRptHdr1"; "FGLocatHdr2")
									Print form:C5([Finished_Goods:26]; "FGLocatDet")
									pixels:=pixels+16
									rQtyOH:=0
									rQtyOO:=0
									rQtyBO:=0
								End if 
								NEXT RECORD:C51([Finished_Goods_Transactions:33])
							End for 
							uChk4RoomFGPB(28; 99; "FGRptHdr1"; "FGLocatHdr2")
							Print form:C5([Finished_Goods:26]; "FGLocatTot")
							pixels:=pixels+28
						End if 
					End if 
					rTotQtyOH:=0
					rTotQtyOO:=0
					rTotQtyBO:=0
					NEXT RECORD:C51([Finished_Goods_Locations:35])
				End for 
			End if 
			NEXT RECORD:C51([Finished_Goods:26])
			fNewRM:=True:C214
		End while 
		PAGE BREAK:C6
	End if 
End if 