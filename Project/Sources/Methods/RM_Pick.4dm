//%attributes = {"publishedWeb":true}
//(P) gRMPick: pick Raw Good listing
//• 5/5/97 cs cleanup code, minor rewrite to print selection
//  rewrite of report operation

C_TEXT:C284($JobForm)
C_BOOLEAN:C305($Continue)

$Continue:=False:C215
windowTitle:="Job R/M Pick List"
$winRef:=OpenFormWindow(->[Job_Forms_Materials:55]; "Input"; ->windowTitle; windowTitle)  //;"wCloseOption")
SET MENU BAR:C67(4)
FORM SET INPUT:C55([Job_Forms_Materials:55]; "Input")
Repeat 
	$JobForm:=Request:C163("Select a Job Form from which to Pick:"; <>jobform)
	If (OK=1)
		windowTitle:="Job R/M Pick List for "+$jobform
		SET WINDOW TITLE:C213(windowTitle)
		
		Case of   //• 5/5/97 cs test for failed entry, wierd entry
			: ($JobForm="")
				ALERT:C41("You did not enter a Jobform.")
				If (OK=1)
					BEEP:C151  //ALL RECORDS([Material_Job])
					$Continue:=False:C215  //True
				Else 
					$Continue:=False:C215
					OK:=1  //• 5/5/97 cs allow repeat loop to continue
				End if 
			: (Character code:C91($JobForm[[Length:C16($JobForm)]])=Character code:C91("@")) | (Character code:C91($JobForm[[1]])=Character code:C91("@"))  //• 5/5/97 cs if "@" exists do not add again
				QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$JobForm)  //get desired job form
				$Continue:=True:C214
			Else 
				QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$JobForm+"@")  //get desired job form
				$Continue:=True:C214
		End case 
		// SEARCH([Material_Job]; & [Machine_Job]RawGoodsID#"")  `and raw goods only
		
		If ($Continue)
			// Repeat `• 5/5/97 cs  why??
			ORDER BY:C49([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1; >; [Job_Forms_Materials:55]Sequence:3; >)
			FORM SET OUTPUT:C54([Job_Forms_Materials:55]; "RMPickList")
			CREATE SET:C116([Job_Forms_Materials:55]; "Currentset")
			MODIFY SELECTION:C204([Job_Forms_Materials:55]; *)
			If (bPrint=1)
				rRMPickList
			End if 
			//  Until (bNext=1) | (bPrint=1) | (bCancel=1)
		End if 
	End if 
	CLEAR SET:C117("CurrentSet")
Until (OK=0)

CLOSE WINDOW:C154($winRef)
uWinListCleanup