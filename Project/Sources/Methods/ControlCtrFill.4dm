//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/27/13, 10:07:10
// ----------------------------------------------------
// Method: ControlCtrFill
// ----------------------------------------------------

C_POINTER:C301($pWhichOne; $1)

$pWhichOne:=$1

Case of 
	: ($pWhichOne=->[Finished_Goods_SizeAndStyles:132])
		ControlCtrManageLB("SSFillLB")
		
	: ($pWhichOne=->[Finished_Goods_Color_SpecMaster:128])
		ControlCtrManageLB("Color")
		
	: ($pWhichOne=->[Finished_Goods_Specifications:98])
		ControlCtrManageLB("ArtFillLB")
		
	: ($pWhichOne=->[Estimates:17])
		ControlCtrManageLB("FilterEstimates")
		
	: ($pWhichOne=->[Customers_Order_Lines:41])
		ControlCtrManageLB("OrderFillLB")
		
	: (($pWhichOne=->[JTB_Job_Transfer_Bags:112]) | ($pWhichOne=->[JPSI_Job_Physical_Support_Items:111]))
		ControlCtrManageLB("SuptItem")
		
	: ($pWhichOne=->[Job_Forms:42])
		ControlCtrManageLB("JobFillLB")
		
End case 