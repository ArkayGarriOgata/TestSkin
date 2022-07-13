//%attributes = {"publishedWeb":true}
//mRptStkSt: Finished Goods Stock Status Report

C_LONGINT:C283($i)

MESSAGES OFF:C175
If (Records in selection:C76([Finished_Goods:26])>0)
	util_PAGE_SETUP(->[Finished_Goods:26]; "FGRptHdr1")
	PRINT SETTINGS:C106
	If (OK=1)
		maxPixels:=552
		iPage:=1
		pixels:=0
		aQtyOH:=0
		//----------SET UP MAIN HEADER----------
		xReptTitle:="Finished Goods Stock Status Report"
		xComment:="The Report is printed by Finished Goods Product Code"
		t9:="Cust: Product Code"
		t8:="Location"
		Print form:C5([Finished_Goods:26]; "FGRptHdr1")
		pixels:=pixels+62
		//If multiple items print additional header2
		While (Not:C34(End selection:C36([Finished_Goods:26])))
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1)
			sPartNo:=[Finished_Goods_Locations:35]CustID:16+": "+[Finished_Goods_Locations:35]ProductCode:1
			sDesc:=[Finished_Goods:26]CartonDesc:3
			If ([Finished_Goods:26]Bill_and_Hold_Qty:108=0)
				sBillAndHold:=""
			Else 
				sBillAndHold:="Bill&Hold Qty = "+String:C10([Finished_Goods:26]Bill_and_Hold_Qty:108; "#,###,##0")
			End if 
			
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2; >)
				uChk4RoomFGPB(82; 38; "FGRptHdr1")
				Print form:C5([Finished_Goods:26]; "FGItemHdr2")
				pixels:=pixels+38
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
					
					FIRST RECORD:C50([Finished_Goods_Locations:35])
					
					
				Else 
					
					// see line 33
					
					
				End if   // END 4D Professional Services : January 2019 First record
				// 4D Professional Services : after Order by , query or any query type you don't need First record  
				For ($i; 1; Records in selection:C76([Finished_Goods_Locations:35]))
					sBin:=[Finished_Goods_Locations:35]Location:2
					aDetQtyOH:=[Finished_Goods_Locations:35]QtyOH:9
					t10:=[Finished_Goods_Locations:35]JobForm:19+"."+String:C10([Finished_Goods_Locations:35]JobFormItem:32; "00")
					aQtyOH:=aQtyOH+[Finished_Goods_Locations:35]QtyOH:9
					dDate:=[Finished_Goods_Locations:35]OrigDate:27
					uChk4RoomFGPB(14; 100; "FGRptHdr1"; "FGItemHdr2")
					Print form:C5([Finished_Goods:26]; "FGItemDtl")
					pixels:=pixels+14
					NEXT RECORD:C51([Finished_Goods_Locations:35])
				End for 
				uChk4RoomFGPB(30; 100; "FGRptHdr1"; "FGItemHdr2")
				Print form:C5([Finished_Goods:26]; "FGItemTot")
				pixels:=pixels+30
				aQtyOH:=0
			End if 
			NEXT RECORD:C51([Finished_Goods:26])
		End while 
		PAGE BREAK:C6
	End if 
End if 
MESSAGES ON:C181