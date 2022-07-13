//%attributes = {}
//Method:  JfMt_Rprt_HPIndigoEval
//Description: This report is for HP Indigo to determine effectiveness

If (True:C214)  //Initialize
	
	C_DATE:C307($dStart; $dEnd)
	C_TEXT:C284($tCostCenterID)
	
	C_OBJECT:C1216($esJobFormsMachineTickets; $eJobFormsMachineTicket)
	C_OBJECT:C1216($esJobFormsItems)
	C_OBJECT:C1216($eJobFormsItems; $eJobFormsMachines; $eJobFormsMaterials)
	
	C_OBJECT:C1216($oProgress)
	
	C_LONGINT:C283($nLoop; $nNumberOfLoops)
	
	
	ARRAY TEXT:C222($atMachineCenter; 0)  //.  [Job_Forms_Machine_Tickets]CostCenterID
	ARRAY TEXT:C222($atJobNumber; 0)  //.  [Job_Forms_Machine_Tickets]JobForm
	ARRAY TEXT:C222($atSubForm; 0)  //.  orderby.[Job_Forms_Machine_Tickets]Subform desc
	
	ARRAY TEXT:C222($atNumberUp; 0)  //[Job_Forms_Items]NumberUp
	ARRAY TEXT:C222($atColors; 0)  //[Job_Forms_Machines]Flex_field1
	ARRAY TEXT:C222($atPaperType; 0)  //[Job_Forms_Materials]Raw_Matl_Code
	
	ARRAY TEXT:C222($atSheetSizeH; 0)  //[Job_Forms]Lenth
	ARRAY TEXT:C222($atSheetSizeW; 0)  //[Job_Forms]Width
	
	ARRAY TEXT:C222($atMakeReadyHours; 0)  //.  Sum([Job_Forms_Machine_Tickets]MR_Act)
	ARRAY TEXT:C222($atRunHours; 0)  //.  Sum([Job_Forms_Machine_Tickets]Run_Act
	ARRAY TEXT:C222($atSheetsToPress; 0)  //.  Sum([Job_Forms_Machine_Tickets]Good_Units
	
	ARRAY TEXT:C222($atCartonQty; 0)  //[Job_Forms]QtyYield
	
	ARRAY POINTER:C280($apColumn; 0)
	
	$esJobFormsMachineTickets:=New object:C1471()
	$eJobFormsMachineTicket:=New object:C1471()
	$esJobFormsItems:=New object:C1471()
	$eJobFormsItems:=New object:C1471()
	$eJobFormsMachines:=New object:C1471()
	$eJobFormsMaterials:=New object:C1471()
	$oProgress:=New object:C1471()
	
	APPEND TO ARRAY:C911($atMachineCenter; "Machine Center")
	APPEND TO ARRAY:C911($atJobNumber; "Job Number")
	APPEND TO ARRAY:C911($atSubForm; "Sub Form")
	
	APPEND TO ARRAY:C911($atNumberUp; "#Up")
	APPEND TO ARRAY:C911($atColors; "Colors")
	APPEND TO ARRAY:C911($atPaperType; "Paper Type/Stock")
	
	APPEND TO ARRAY:C911($atSheetSizeH; "Sheet Size H")
	APPEND TO ARRAY:C911($atSheetSizeW; "Sheet Size W")
	APPEND TO ARRAY:C911($atMakeReadyHours; "Make Ready Hrs")
	
	APPEND TO ARRAY:C911($atRunHours; "Run Hrs")
	APPEND TO ARRAY:C911($atSheetsToPress; "Sheets to press")
	APPEND TO ARRAY:C911($atCartonQty; "Carton Qty")
	
	APPEND TO ARRAY:C911($apColumn; ->$atMachineCenter)
	APPEND TO ARRAY:C911($apColumn; ->$atJobNumber)
	APPEND TO ARRAY:C911($apColumn; ->$atSubForm)
	
	APPEND TO ARRAY:C911($apColumn; ->$atNumberUp)
	APPEND TO ARRAY:C911($apColumn; ->$atColors)
	APPEND TO ARRAY:C911($apColumn; ->$atPaperType)
	
	APPEND TO ARRAY:C911($apColumn; ->$atSheetSizeH)
	APPEND TO ARRAY:C911($apColumn; ->$atSheetSizeW)
	APPEND TO ARRAY:C911($apColumn; ->$atMakeReadyHours)
	
	APPEND TO ARRAY:C911($apColumn; ->$atRunHours)
	APPEND TO ARRAY:C911($apColumn; ->$atSheetsToPress)
	APPEND TO ARRAY:C911($apColumn; ->$atCartonQty)
	
	$tUniqueJobNumber:=CorektBlank
	
	$rMakeReadyHours:=0
	$rRunHours:=0
	$rSheetsToPress:=0
	
	$bFirst:=True:C214
	
	//Query parameters
	
	$dStart:=!2021-07-01!
	$dEnd:=!2021-07-31!
	
	$tCostCenterID:="418"
	
End if   //Done initialize

$esJobFormsMachineTickets:=ds:C1482.Job_Forms_Machine_Tickets.query\
("DateEntered >= :1 and DateEntered <= :2 and CostCenterID = :3"; \
$dStart; $dEnd; $tCostCenterID).orderBy("JobForm asc, Subform desc")

$oProgress.nProgressID:=Prgr_NewN
$oProgress.nNumberOfLoops:=$esJobFormsMachineTickets.length
$oProgress.tTitle:="Cost Center"+CorektSpace+$tCostCenterID+CorektSpace

For each ($eJobFormsMachineTicket; $esJobFormsMachineTickets)  //JobFormsMachineTickets
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		$tJobNumber:=$eJobFormsMachineTicket.JobForm
		
		$esJobFormsItems:=ds:C1482.Job_Forms_Items.query("JobForm = :1"; $tJobNumber)
		
		$oProgress.nLoop:=$nLoop+1
		$oProgress.tMessage:="Job Number"+CorektSpace+$tJobNumber
		
		Prgr_Message($oProgress)
		
		Case of   //Append
				
			: ($bFirst)  //Prime
				
				$tCostCenterID:=$eJobFormsMachineTicket.CostCenterID
				
				$tUniqueJobNumber:=$tJobNumber
				
				$tSubForm:=Choose:C955(\
					($eJobFormsMachineTicket.Subform=0); \
					"1"; \
					String:C10($eJobFormsMachineTicket.Subform))
				
				$rMakeReadyHours:=$eJobFormsMachineTicket.MR_Act
				$rRunHours:=$eJobFormsMachineTicket.Run_Act
				$rSheetsToPress:=$eJobFormsMachineTicket.Good_Units
				
				$tSheetSizeH:=String:C10($eJobFormsMachineTicket.JOB_FORM.Lenth)
				$tSheetSizeW:=String:C10($eJobFormsMachineTicket.JOB_FORM.Width)
				
				$bFirst:=False:C215
				
			: ($tUniqueJobNumber=$tJobNumber)  //Same add
				
				$rMakeReadyHours:=$rMakeReadyHours+$eJobFormsMachineTicket.MR_Act
				$rRunHours:=$rRunHours+$eJobFormsMachineTicket.Run_Act
				$rSheetsToPress:=$rSheetsToPress+$eJobFormsMachineTicket.Good_Units
				
			: ($esJobFormsItems.length=0)
				
			Else   //Good append
				
				$eJobFormsItems:=$esJobFormsItems.first()
				$eJobFormsMachines:=ds:C1482.Job_Forms_Machines.query("JobForm = :1"; $tUniqueJobNumber).first()
				$eJobFormsMaterials:=ds:C1482.Job_Forms_Materials.query("JobForm = :1"; $tUniqueJobNumber).first()
				
				APPEND TO ARRAY:C911($atMachineCenter; $tCostCenterID)
				APPEND TO ARRAY:C911($atJobNumber; $tUniqueJobNumber)
				APPEND TO ARRAY:C911($atSubForm; $tSubForm)
				
				APPEND TO ARRAY:C911($atNumberUp; String:C10($eJobFormsItems.NumberUp))
				APPEND TO ARRAY:C911($atColors; String:C10($eJobFormsMachines.Flex_field1))
				APPEND TO ARRAY:C911($atPaperType; $eJobFormsMaterials.Raw_Matl_Code)
				
				APPEND TO ARRAY:C911($atSheetSizeH; $tSheetSizeH)
				APPEND TO ARRAY:C911($atSheetSizeW; $tSheetSizeW)
				APPEND TO ARRAY:C911($atMakeReadyHours; String:C10($rMakeReadyHours))
				
				APPEND TO ARRAY:C911($atRunHours; String:C10($rRunHours))
				APPEND TO ARRAY:C911($atSheetsToPress; String:C10($rSheetsToPress))
				APPEND TO ARRAY:C911($atCartonQty; $tCartonQty)
				
				$tCostCenterID:=$eJobFormsMachineTicket.CostCenterID
				
				$tUniqueJobNumber:=$tJobNumber
				
				$tSubForm:=Choose:C955(\
					($eJobFormsMachineTicket.Subform=0); \
					"1"; \
					String:C10($eJobFormsMachineTicket.Subform))
				
				$rMakeReadyHours:=$eJobFormsMachineTicket.MR_Act
				$rRunHours:=$eJobFormsMachineTicket.Run_Act
				$rSheetsToPress:=$eJobFormsMachineTicket.Good_Units
				
				$tSheetSizeH:=String:C10($eJobFormsMachineTicket.JOB_FORM.Lenth)
				$tSheetSizeW:=String:C10($eJobFormsMachineTicket.JOB_FORM.Width)
				
				$tCartonQty:=String:C10($eJobFormsMachineTicket.JOB_FORM.QtyYield)
				
		End case   //Done append
		
	End if   //Done progress
	
End for each   //Done jobFormsMachineTickets

Prgr_Quit($oProgress)

Core_Array_ToDocument(->$apColumn)  //This will ask for file name and directory
