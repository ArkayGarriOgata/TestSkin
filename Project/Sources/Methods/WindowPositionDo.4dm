//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/20/12, 08:54:38
// ----------------------------------------------------
// Method: WindowPositionDo
// Description:
// Performs the actual work to open the windows.
// Only the windows supported will pass this method.
// If the process is hidden it is brought to the front.
// Some existing methods already check for hidden status.
// There is already a current record when this method is called.
// Check the method WindowPositionWindows and match up the Window Titles.
// ----------------------------------------------------

C_LONGINT:C283($xlSize; $xlID; $xlErr)
C_TEXT:C284($tPre)

$xlSize:=<>lMinMemPart

Case of 
	: ([WindowSets:185]WindowTitle:3="Address Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Address Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("gCaddEvent"; "$Address Palette")
		Else 
			WindowPositionMove("Address Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Cost Center Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Standards Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("gCCEvent"; "$Standards Palette")
		Else 
			WindowPositionMove("Cost Center Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Customer Order Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Customers' Order Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("gCustOrdEvent"; "$Customers' Order Palette")
		Else 
			WindowPositionMove("Customer Order Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Customer Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Customers Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("gCustEvent"; "$Customers Palette")
		Else 
			WindowPositionMove("Customer Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Department Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Department Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("DeptPallet"; "$Department Palette")
		Else 
			WindowPositionMove("Department Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="EDI Event")
		$xlPosition:=Find in array:C230(<>aPrcsName; "EDI_Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("EDI_openPalette"; "$EDI_Palette")
		Else 
			WindowPositionMove("EDI Event")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Estimate Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Estimating Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("ESTIMATE_OpenPalette"; "$Estimating Palette")
		Else 
			WindowPositionMove("Estimate Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Finished Goods Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Finished Goods Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("FG_OpenPalette"; "$Finished Goods Palette")
		Else 
			WindowPositionMove("Finished Goods Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Jobs Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Jobs Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("JOB_OpenPalette"; "$Jobs Palette")
		Else 
			WindowPositionMove("Jobs Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Purchasing Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Purchasing Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("PO_OpenPalette"; "$Purchasing Palette")
		Else 
			WindowPositionMove("Purchasing Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="QA Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "QA Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("QA_openPalette"; "$QA Palette")
		Else 
			WindowPositionMove("QA Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Raw Material Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Raw Material Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("RM_OpenPalette"; "$Raw Material Palette")
		Else 
			WindowPositionMove("Raw Material Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Requisitions Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Requistion Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("gReqEvent"; "$Requistion Palette")
		Else 
			WindowPositionMove("Requisitions Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Sales Rep's Palette")
		$xlPosition:=Find in array:C230(<>aPrcsName; "Sales Reps' Palette")
		If ($xlPosition=-1)
			$xlErr:=uSpawnPalette("gSaleEvent"; "$Sales Reps' Palette")
		Else 
			WindowPositionMove("Sales Rep's Palette")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="@Supply & Demand")  //Ask Me Window
		$xlErr:=New process:C317("sAskMe"; $xlSize; "AskMe:F/G"; *)
		If ($xlID#0)
			WindowPositionMove("Finished Goods@")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Job_Forms_Master@")
		JML_ShowListing
		
	: ([WindowSets:185]WindowTitle:3="eBag")
		$xlErr:=New process:C317("eBag_UI"; $xlSize*2; "eBag"; *)
		If ($xlID#0)
			WindowPositionMove("eBag")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="Gluing Schedule")
		$xlErr:=New process:C317("PS_Gluers"; $xlSize; "Glueing Schedule"; *)
		If ($xlID#0)
			WindowPositionMove("Gluing Schedule")
		End if 
		
	: ([WindowSets:185]WindowTitle:3="@Schedule")
		$tPre:=Substring:C12([WindowSets:185]WindowTitle:3; 1; 3)
		$xlErr:=PS_PressScheduleUI($tPre)  //WindowPositionMove is inside this method
		
	: ([WindowSets:185]WindowTitle:3="Estimates@")
		<>Activitiy:=4
		ViewSetter(2; ->[Estimates:17])
		
End case 

[WindowSets:185]ProcID:12:=$xlErr
SAVE RECORD:C53([WindowSets:185])