//%attributes = {"publishedWeb":true}
//mRptBinSt: Finished Goods Stock Status Report
//•112296   remove page breaking

<>filePtr:=->[Finished_Goods_Locations:35]
uSetUp(1; 1)
SET WINDOW TITLE:C213(fNameWindow(filePtr)+" Bin Status Report")
NumRecs1:=fSelectBy  //generic search equal or range on any four fields 
If (OK=1)
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		ARRAY TEXT:C222(aLoc; 0)
		ARRAY TEXT:C222(aLoc; Records in table:C83([WMS_AllowedLocations:73]))
		util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "BinStatusRpt")
		FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "BinStatusRpt")
		PRINT SETTINGS:C106
		If (OK=1)
			iPage:=1
			iOnPage:=1
			C_LONGINT:C283(iPageOffset)
			iPageOffset:=0
			aQtyOH:=0
			
			//----------SET UP MAIN HEADER----------
			xReptTitle:="Finished Goods Bin Status Report"
			xComment:="The Report is sorted by Finished Goods Location"
			MESSAGES OFF:C175
			ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2; >; [Finished_Goods_Locations:35]JobFormItem:32; >)
			ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9)
			BREAK LEVEL:C302(1)  //•112296    removed the ;1
			PRINT SELECTION:C60([Finished_Goods_Locations:35]; *)
			MESSAGES ON:C181
		End if   //print settings
		FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "List")
		ARRAY TEXT:C222(aLoc; 0)
	End if 
End if 