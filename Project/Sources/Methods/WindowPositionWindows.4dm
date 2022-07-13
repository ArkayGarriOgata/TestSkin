//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/17/12, 12:50:41
// ----------------------------------------------------
// Method: WindowPositionWindows
// Description:
// This is the list of supported windows.
// Check the method WindowPositionDo and match up the Window Titles.
// ----------------------------------------------------

C_BOOLEAN:C305($0; $bOKDoIt)
C_TEXT:C284($tWinTitle; $1)

$tWinTitle:=$1
$bOKDoIt:=True:C214

Case of 
	: ($tWinTitle="Address Palette")
	: ($tWinTitle="Cost Center Palette")
	: ($tWinTitle="Customer Order Palette")
	: ($tWinTitle="Customer Palette")
	: ($tWinTitle="Department Palette")
	: ($tWinTitle="eBag")
	: ($tWinTitle="EDI Event")
	: ($tWinTitle="Estimate Palette")
	: ($tWinTitle="Finished Goods Palette")
	: ($tWinTitle="Jobs Palette")
	: ($tWinTitle="Purchasing Palette")
	: ($tWinTitle="Raw Material Palette")
	: ($tWinTitle="Requisitions Palette")
	: ($tWinTitle="Sales Rep's Palette")
	: ($tWinTitle="QA Palette")
	: ($tWinTitle="@Schedule")
	: ($tWinTitle="Estimates@")
	: ($tWinTitle="Customer_Invoices@")
	Else 
		$bOKDoIt:=False:C215
End case 

$0:=$bOKDoIt