// ----------------------------------------------------
// User name (OS): MLB
// ----------------------------------------------------
// Object Method: [Job_Forms].Input.bPrint
// Description:
// Sitting on a jobform record, print the jobbag
// See also JOB_BAG_ReportPrint
// Modified by: Mel Bohince (9/13/13) 
// ----------------------------------------------------

C_LONGINT:C283(cb1; cb2; cb3; cb4; cb5; cb6)

SAVE RECORD:C53([Job_Forms:42])

$winRef:=Open form window:C675([Job_Forms:42]; "JobBagPrintOptions"; 5)
DIALOG:C40([Job_Forms:42]; "JobBagPrintOptions")
CLOSE WINDOW:C154($winRef)

If (OK=1)
	If (Not:C34(Job_Bag_Validate))  //•020499  MLB move validation to separate proc 
		zSetUsageLog(->[Job_Forms:42]; "single jobbag"; String:C10(cb1)+String:C10(cb2)+String:C10(cb3)+String:C10(cb4)+String:C10(cb5)+String:C10(cb6))
		util_PAGE_SETUP(->[Jobs:15]; "JBN_Head1")  // Modified by: Mark Zinke (4/17/13) Moved here. We don't need them unless Job is validated.
		PRINT SETTINGS:C106
		JOB_BAG_Report([Job_Forms:42]JobFormID:5)
		
		If (cb6=1)
			Jobform_print_layout_pdf([Job_Forms:42]JobFormID:5)
		End if 
		
		If (cb2=1)
			If (Not:C34(<>Auto_Ink_Issue))  // Modified by: Mel Bohince (9/13/13) 
				$Printed:=InkPO([Job_Forms:42]JobFormID:5; "no prn set")
			End if 
		End if 
	End if 
End if 