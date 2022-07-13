//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): mel
// ----------------------------------------------------
// Method: JOB_BAG_ReportPrint
// Description
// given some hilited jobform records, print the jobbags
// see also print btn on jobform input
// ----------------------------------------------------
// Modified by: mel (2/10/10) remove multi print settings

C_LONGINT:C283($i; $numJobBags)

$numJobBags:=Records in set:C195("UserSet")
If ($numJobBags#0)  //bSelect button from selectionList layout  
	ON EVENT CALL:C190("eCancelPrint")
	CUT NAMED SELECTION:C334([Job_Forms:42]; "CurrentSel")  //• 5/7/97 cs `•020499  MLB  chg to cut
	
	$winRef:=Open form window:C675([Job_Forms:42]; "JobBagPrintOptions"; 5)
	C_LONGINT:C283(cb1; cb2; cb3; cb4; cb5; cb6)  //
	DIALOG:C40([Job_Forms:42]; "JobBagPrintOptions")
	CLOSE WINDOW:C154($winRef)
	If (OK=1)
		zSetUsageLog(->[Job_Forms:42]; "multi jobbag"; String:C10(cb1)+String:C10(cb2)+String:C10(cb3)+String:C10(cb4)+String:C10(cb5)+String:C10(cb6))
		util_PAGE_SETUP(->[Jobs:15]; "JBN_Head1")  // Modified by: Mel Bohince (4/23/20) 
		PRINT SETTINGS:C106
		
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
			
			For ($i; 1; $numJobBags)
				USE SET:C118("UserSet")
				GOTO SELECTED RECORD:C245([Job_Forms:42]; $i)
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms:42]JobFormID:5)
				QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)  //•042999  MLB  
				//TRACE
				
				If (Not:C34(Job_Bag_Validate))  //•020499  MLB move validation to separate proc  
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
				
				If (Not:C34(<>fContinue))  //if the printing is stopped by user
					$i:=$numJobBags+1
					<>fContinue:=True:C214
				End if 
			End for 
			
		Else 
			
			USE SET:C118("UserSet")
			ARRAY LONGINT:C221($_record_number; 0)
			LONGINT ARRAY FROM SELECTION:C647([Job_Forms:42]; $_record_number)
			
			For ($i; 1; $numJobBags)
				
				GOTO RECORD:C242([Job_Forms:42]; $_record_number{$i})
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms:42]JobFormID:5)
				QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)  //•042999  MLB  
				//TRACE
				
				If (Not:C34(Job_Bag_Validate))  //•020499  MLB move validation to separate proc  
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
				
				If (Not:C34(<>fContinue))  //if the printing is stopped by user
					$i:=$numJobBags+1
					<>fContinue:=True:C214
				End if 
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	End if   //options
	
	USE NAMED SELECTION:C332("CurrentSel")  //• 5/7/97 cs   
	ON EVENT CALL:C190("")
	
Else 
	BEEP:C151
	ALERT:C41("Select the forms that you wish to print.")
End if 