//%attributes = {"publishedWeb":true}
//(p)PiAllPiReports
//mod 10/3/94 chip
//• 2/28/97 cs upr 1858 - replaced all old reports with new ones
//•031699  MLB  UPR add tag report
//  ◊fileptr is set in each case element because the original file passed may not 
//  correct for every report

C_TEXT:C284($WhichRpt)
C_LONGINT:C283(lTktJobQty; lPageNum)
C_DATE:C307(dDate; dDateEnd; sDateBegin)
C_TIME:C306(tTime; vDoc)
C_BOOLEAN:C305(fSave)

$WhichRpt:=<>WhichRpt
dDate:=4D_Current_date
dDateEnd:=4D_Current_date
tTime:=4d_Current_time
vDoc:=?00:00:00?

Case of 
	: ($WhichRpt="On-Hand RM w/Costs")
		<>filePtr:=->[Raw_Materials:21]
		doRMRptRecords
		uClearSelection(->[Raw_Materials:21])
		uClearSelection(->[Raw_Materials_Locations:25])
		uClearSelection(->[Raw_Materials_Transactions:23])
		
	: ($WhichRpt="On-Hand RM w/o Costs")
		<>filePtr:=->[Raw_Materials:21]
		doRMRptRecords
		uClearSelection(->[Raw_Materials:21])
		uClearSelection(->[Raw_Materials_Locations:25])
		uClearSelection(->[Raw_Materials_Transactions:23])
		
	: ($WhichRpt="Costed Examining Inventory") | ($WhichRpt="Costed Bill & Hold Inventory") | ($WhichRpt="Costed Finished Goods Inventory")
		// designed to run from month end suite set up like it is being called from there 
		<>filePtr:=->[Finished_Goods:26]
		If (Size of array:C274(<>MthEndSuite)=0)
			arrMthEndSuite
		End if 
		Case of 
			: (Position:C15("Examining"; $WhichRpt)>0)
				util_PAGE_SETUP(->[Finished_Goods:26]; "FGcostingRpt2")
			: (Position:C15("Bill & Hold"; $WhichRpt)>0)
				util_PAGE_SETUP(->[Finished_Goods:26]; "FGcostingRpt1")
			: (Position:C15("Finished"; $WhichRpt)>0)
				util_PAGE_SETUP(->[Finished_Goods:26]; "FGcostingRpt1")
		End case 
		PRINT SETTINGS:C106
		If (OK=1)
			$Report:=Find in array:C230(<>MthEndSuite; $WhichRpt)
			uConfirm("Save Report to Disk?")
			fSave:=(OK=1)
			If (fSave)
				vDoc:=Create document:C266($WhichRpt)
			End if 
			rCostdInventRpt($Report)
			uClearSelection(->[Finished_Goods:26])
			uClearSelection(->[Finished_Goods_Locations:35])
			uClearSelection(->[Job_Forms_Items:44])
		End if 
		
	: ($WhichRpt="Stock Status")
		<>FilePtr:=->[Finished_Goods:26]
		uSetUp(1; 1)
		NumRecs1:=fSelectBy  //generic search equal or range on any four fields 
		If (OK=1)
			SET WINDOW TITLE:C213(fNameWindow(FilePtr)+" "+$WhichRpt)
			mRptStkSt
		End if 
		
	: ($WhichRpt="F/G Bin Status")
		<>filePtr:=->[Finished_Goods_Locations:35]
		mRptBinSt
		
		//: ($WhichRpt="PI RM Verify")
		//◊FilePtr:=»[RM_BINS]
		//NewWindow (500;350;0;0;$WhichRpt)
		//uConfirm ("Save Report to Disk?")
		//fSave:=(OK=1)
		//rPiRmCountSheet ("*")
		
	: ($WhichRpt="PI RM Count Sheet")
		//◊FilePtr:=->[RM_BINS]
		//NewWindow (500;350;0;0;$WhichRpt)
		//uConfirm ("Save Report to Disk?")
		//fSave:=(OK=1)
		rPiRmCountSheet
		
	: ($WhichRpt="PI RM Adjust w Cost")
		<>FilePtr:=->[Raw_Materials_Transactions:23]
		NewWindow(500; 350; 0; 0; $WhichRpt)
		uConfirm("Save Report to Disk?")
		fSave:=(OK=1)
		rPiRmAdjwCost
		
	: ($WhichRpt="RM Adjustment Log")
		<>filePtr:=->[Raw_Materials_Transactions:23]
		rRptRMadjustmen
		
	: ($WhichRpt="RM Tag Report")  //•031699  MLB  UPR 
		<>filePtr:=->[Raw_Materials_Transactions:23]
		//rRptRMreceipts ("Tags")  // Modified by: Mel Bohince (12/20/21) replaced with RMX_PI_Tag_Rpt
		RMX_PI_Tag_Rpt  // Modified by: Mel Bohince (12/20/21) 
		
	: ($WhichRpt="PI RM Inventory Comparision")
		<>FilePtr:=->[Raw_Materials_Locations:25]
		NewWindow(500; 350; 0; 0; $WhichRpt)
		uConfirm("Save Report to Disk?")
		fSave:=(OK=1)
		rPiRmAdjSumry
		
	: ($WhichRpt="F/G Transaction Log")
		<>filePtr:=->[Finished_Goods_Transactions:33]
		MRptFGTrans
		
	: ($WhichRpt="PI F/G Adjust w Cost")
		NewWindow(500; 350; 0; 0; $WhichRpt)
		uConfirm("Save Report to Disk?")
		fSave:=(OK=1)
		rPiFgAdjwCost
		
	: ($WhichRpt="PI F/G Count Sheet")
		<>filePtr:=->[Finished_Goods_Locations:35]
		rPIFgCountSheet
		
	: ($WhichRpt="PI F/G Inventory Comparision")
		NewWindow(500; 350; 0; 0; $WhichRpt)
		uConfirm("Save Report to Disk?")
		fSave:=(OK=1)
		rPiFgAdjSumry
		
	: ($WhichRpt="Found Inventory Forms")
		PiFoundInvTmplt
		
	: ($WhichRpt="WIP Inventory Forms")
		PiWipInvForms
		
	: ($WhichRpt="F/G Tag Sort")  //• mlb - 4/20/01  14:45
		PItagSortReport
		
	: ($WhichRpt="Roll Stock")
		RIM_Physical_InventoryRpt
End case 

fSave:=False:C215
CLOSE WINDOW:C154