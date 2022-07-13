// _______
// Method: [zz_control].PhyInvEvent.PIreports   ( ) ->
// By: Mel Bohince @ 12/22/21, 11:22:37
// Description
// launch phy inv related reports
// REPLACING PiAllPiReports ( )
// ----------------------------------------------------
// Modified by: MelvinBohince (1/10/22) add other reports required at the end of PI

C_COLLECTION:C1488($reportChoices_c)
$reportChoices_c:=New collection:C1472

$reportChoices_c.push("RM Tag Report...")
$reportChoices_c.push("Roll Stock Labels")
$reportChoices_c.push("RM Before After")
$reportChoices_c.push("RM On Hand Export")
$reportChoices_c.push("RM Transactions...")
$reportChoices_c.push("(-")

$reportChoices_c.push("FG Before After...")
$reportChoices_c.push("FG Outside Service")
$reportChoices_c.push("FG FIFO")
$reportChoices_c.push("FG Aged FiFo...")
$reportChoices_c.push("FG_Location_Export")
$reportChoices_c.push("(-")

$reportChoices_c.push("WIP On Hand")
$reportChoices_c.push("WIP Inventory")

C_TEXT:C284($menu_items)
$menu_items:=$reportChoices_c.join(";")

GET MOUSE:C468($clickX; $clickY; $mouse_btn)

If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
	$user_choice:=Pop up menu:C542($menu_items)-1
	If ($user_choice>-1)
		$reportName:=$reportChoices_c[$user_choice]
	Else 
		$reportName:="no selected item"
	End if 
	
	Case of 
		: ($reportName="RM Tag Report...")
			RMX_PI_Tag_Rpt
			
		: ($reportName="Roll Stock Labels")
			RIM_Physical_InventoryRpt2
			
		: ($reportName="RM Before After")
			RML_PI_BeforeAfter_Rpt
			
		: ($reportName="RM On Hand Export")
			//RM_onHandbyLocation ("@";"@")  // Removed by: MelvinBohince (1/10/22) 
			RM_onHandRptToText  // Added by: MelvinBohince (1/10/22) 
			
		: ($reportName="RM Transactions...")
			RM_TransactionExport  // Added by: MelvinBohince (1/10/22) 
			
			//--------
			
		: ($reportName="FG Before After...")
			FGL_PI_BeforeAfter_Rpt
			
		: ($reportName="FG Outside Service")
			FGL_PI_OutsideService_Rpt
			
		: ($reportName="FG FIFO")
			JIC_Regenerate("@")
			JIC_inventoryRpt
			
		: ($reportName="FG Aged FiFo...")
			rptAgeFGfifo
			
		: ($reportName="FG_Location_Export")
			FG_Location_Export
			//see also doFGRptRecords
			
			//--------
			
			
		: ($reportName="WIP On Hand")
			WIP_Job_Load_Rpt
			
		: ($reportName="WIP Inventory")
			If (fGetDateRange(->dDateBegin; ->dDateEnd)=1)
				rptWIPinventory(dDateBegin; dDateEnd; ""; cb1; 1)  //090298
			End if 
			
			
			
		Else   //1,3,4
			//pass
	End case 
	
Else 
	uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
End if 

