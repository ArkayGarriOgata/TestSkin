//%attributes = {}
//Method: JFMs_Rprt_CustomerClosingDate
//Description:  This is to help out with closing dates...
//.  For testing run User_StatusChange this changes <>zResp which is used in User_AllowedRecords

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nNumberOfCustomers)
	
	C_COLLECTION:C1488($cCustomer)
	
	C_OBJECT:C1216($eJobFormItem)
	C_OBJECT:C1216($esJobFormItem)
	C_OBJECT:C1216($eJobFormsMasterSchedule)
	C_OBJECT:C1216($esJobFormsMasterSchedule)
	
	ARRAY TEXT:C222($atCustomer; 0)
	
	ARRAY TEXT:C222($atRprtCustomer; 0)
	ARRAY TEXT:C222($atRprtJobForm; 0)
	ARRAY TEXT:C222($atRprtProductCode; 0)
	ARRAY TEXT:C222($atRprtClosingDate; 0)
	ARRAY TEXT:C222($atRprtHaveReadyDate; 0)
	
	$nNumberOfCustomers:=User_AllowedRecords(Table name:C256(->[Customers:16]))  // Modified by: Mel Bohince (4/16/21) 
	$cCustomer:=New collection:C1472()
	SELECTION TO ARRAY:C260([Customers:16]Name:2; $atCustomer)
	ARRAY TO COLLECTION:C1563($cCustomer; $atCustomer)
	
	$eJobFormItem:=New object:C1471()
	$esJobFormItem:=New object:C1471()
	$eJobFormsMasterSchedule:=New object:C1471()
	$esJobFormsMasterSchedule:=New object:C1471()
	
End if   //Done initialize

$esJobFormsMasterSchedule:=ds:C1482.Job_Forms_Master_Schedule.query("Customer in :1 and PlannerReleased # :2 and DateClosingMet = :3"; $cCustomer; "00/00/00"; "00/00/00")

For each ($eJobFormsMasterSchedule; $esJobFormsMasterSchedule)  //Master schedule
	
	$esJobFormItem:=ds:C1482.Job_Forms_Items.query("JobForm = :1"; $eJobFormsMasterSchedule.JobForm)
	
	For each ($eJobFormItem; $esJobFormItem)  //Job form item
		
		APPEND TO ARRAY:C911($atRprtCustomer; $eJobFormsMasterSchedule.Customer)
		APPEND TO ARRAY:C911($atRprtJobForm; $eJobFormsMasterSchedule.JobForm)
		APPEND TO ARRAY:C911($atRprtProductCode; $eJobFormItem.ProductCode)
		APPEND TO ARRAY:C911($atRprtClosingDate; String:C10($eJobFormsMasterSchedule.GateWayDeadLine))
		APPEND TO ARRAY:C911($atRprtHaveReadyDate; String:C10($eJobFormsMasterSchedule.OrigRevDate))
		
	End for each   //Done job form item
	
End for each   //Done master schedule

MULTI SORT ARRAY:C718($atRprtCustomer; >; $atRprtJobForm; >; $atRprtProductCode; >; $atRprtClosingDate; $atRprtHaveReadyDate)