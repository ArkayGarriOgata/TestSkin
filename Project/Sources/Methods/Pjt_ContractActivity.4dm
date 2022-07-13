//%attributes = {}
// Method: Pjt_ContractActivity () -> 
// ----------------------------------------------------
// by: mel: 08/18/05, 11:08:42
// ----------------------------------------------------

C_LONGINT:C283($run; $numberOfRuns)
C_BOOLEAN:C305($break)
C_TEXT:C284($t; $cr)
C_TIME:C306($docRef)

$pjtId:=$1
$t:=Char:C90(9)
$r:=Char:C90(13)
C_TEXT:C284(xTitle; xText; docName)
xTitle:=""
xText:=""
docName:=pjtName+".txt"
$docRef:=util_putFileName(->docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$r+$r)
	
	xText:=xText+"CONTRACT SUMMARY FOR  "+Uppercase:C13(pjtCustName)+"'s "+Uppercase:C13(pjtName)+$r+$r
	
	zwStatusMsg("Contract Summary"; "Loading jobs")
	QUERY:C277([Jobs:15]; [Jobs:15]ProjectNumber:18=$pjtId)  //;*)
	//QUERY([JOB]; & ;[JOB]JobNo>83260) `limitor
	$numberOfRuns:=Records in selection:C76([Jobs:15])
	xText:=xText+"There are "+String:C10($numberOfRuns)+" runs planned for this contract."+$r+$r
	
	xText:=xText+"CLOSING DATE"+$t+"PRINT DATE"+$t+"RUN #"+$t+"RUN_QTY"+$t+"RELEASED_QTY"+$t+"INVENTORY_QTY"+$t+"CUMULATIVE"+$t+"BUDGET"+$t+"DIFF_CUM-BUD"+$t+"PLAN_CHANGE"+$r
	$break:=False:C215
	
	ORDER BY:C49([Jobs:15]; [Jobs:15]JobNo:1; >)
	$cumulative:=0
	$budget:=0
	
	uThermoInit($numRecs; "Updating Records")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($run; 1; $numberOfRuns)
			If ($break)
				$run:=$run+$numberOfRuns
			End if 
			
			If (Length:C16(xText)>25000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			RELATE MANY:C262([Jobs:15])
			ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; >)
			
			While (Not:C34(End selection:C36([Job_Forms:42])))
				$hits:=qryJML([Job_Forms:42]JobFormID:5)
				$hits:=qryJMI([Job_Forms:42]JobFormID:5+"@")
				If ($hits>0)
					$produce:=String:C10(Sum:C1([Job_Forms_Items:44]Qty_Want:24))
				Else 
					$produce:="0"
				End if 
				$cumulative:=$cumulative+Num:C11($produce)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					util_outerJoin(->[Finished_Goods_Locations:35]ProductCode:1; ->[Job_Forms_Items:44]ProductCode:3)
					
				Else 
					
					zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Locations:35])+" file. Please Wait...")
					ARRAY TEXT:C222($_ProductCode; 0)
					DISTINCT VALUES:C339([Job_Forms_Items:44]ProductCode:3; $_ProductCode)
					QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode)
					zwStatusMsg(""; "")
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				If (Records in selection:C76([Finished_Goods_Locations:35])>0)
					$inventory:=String:C10(Sum:C1([Finished_Goods_Locations:35]QtyOH:9))
				Else 
					$inventory:="0"
				End if 
				$budget:=$budget+(Num:C11($produce)+Num:C11($inventory))
				
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					util_outerJoin(->[Customers_ReleaseSchedules:46]ProductCode:11; ->[Job_Forms_Items:44]ProductCode:3)
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
					
					
				Else 
					
					zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Customers_ReleaseSchedules:46])+" file. Please Wait...")
					ARRAY TEXT:C222($_ProductCode; 0)
					DISTINCT VALUES:C339([Job_Forms_Items:44]ProductCode:3; $_ProductCode)
					QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode)
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
					zwStatusMsg(""; "")
					
				End if   // END 4D Professional Services : January 2019 query selection
				If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
					$releases:=String:C10(Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6))
				Else 
					$releases:="0"
				End if 
				
				xText:=xText+String:C10([Job_Forms_Master_Schedule:67]GateWayDeadLine:42; System date short:K1:1)+$t+String:C10([Job_Forms_Master_Schedule:67]PressDate:25; System date short:K1:1)+$t+String:C10($run)+"~"+[Job_Forms:42]JobFormID:5+$t+$produce+$t+$releases+$t+$inventory+$t+String:C10($cumulative)+$t+String:C10($budget)+$t+String:C10($cumulative-$budget)+$t+""+$r
				NEXT RECORD:C51([Job_Forms:42])
			End while 
			
			NEXT RECORD:C51([Jobs:15])
			uThermoUpdate($run)
		End for 
		
		
	Else 
		//change relate many by query and two next and order by sort
		
		ARRAY LONGINT:C221($_JobNo; 0)
		SELECTION TO ARRAY:C260([Jobs:15]JobNo:1; $_JobNo)
		
		For ($run; 1; $numberOfRuns)
			If ($break)
				$run:=$run+$numberOfRuns
			End if 
			
			If (Length:C16(xText)>25000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobNo:2=$_JobNo{$run})
			ARRAY TEXT:C222($_JobFormID; 0)
			SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $_JobFormID)
			SORT ARRAY:C229($_JobFormID; >)
			
			For ($Iter; 1; Size of array:C274($_JobFormID); 1)
				$hits:=qryJML($_JobFormID{$Iter})
				$hits:=qryJMI($_JobFormID{$Iter}+"@")
				If ($hits>0)
					$produce:=String:C10(Sum:C1([Job_Forms_Items:44]Qty_Want:24))
				Else 
					$produce:="0"
				End if 
				$cumulative:=$cumulative+Num:C11($produce)
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Locations:35])+" file. Please Wait...")
				ARRAY TEXT:C222($_ProductCode; 0)
				DISTINCT VALUES:C339([Job_Forms_Items:44]ProductCode:3; $_ProductCode)
				QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode)
				zwStatusMsg(""; "")
				
				If (Records in selection:C76([Finished_Goods_Locations:35])>0)
					$inventory:=String:C10(Sum:C1([Finished_Goods_Locations:35]QtyOH:9))
				Else 
					$inventory:="0"
				End if 
				$budget:=$budget+(Num:C11($produce)+Num:C11($inventory))
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Customers_ReleaseSchedules:46])+" file. Please Wait...")
				ARRAY TEXT:C222($_ProductCode; 0)
				DISTINCT VALUES:C339([Job_Forms_Items:44]ProductCode:3; $_ProductCode)
				QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode)
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
				zwStatusMsg(""; "")
				
				If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
					$releases:=String:C10(Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6))
				Else 
					$releases:="0"
				End if 
				
				xText:=xText+String:C10([Job_Forms_Master_Schedule:67]GateWayDeadLine:42; System date short:K1:1)+$t+String:C10([Job_Forms_Master_Schedule:67]PressDate:25; System date short:K1:1)+$t+String:C10($run)+"~"+$_JobFormID{$Iter}+$t+$produce+$t+$releases+$t+$inventory+$t+String:C10($cumulative)+$t+String:C10($budget)+$t+String:C10($cumulative-$budget)+$t+""+$r
				
			End for 
			
			uThermoUpdate($run)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	uThermoClose
	
	zwStatusMsg("PJT SUMMARY"; "Done")
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
	$err:=util_Launch_External_App(docName)
End if 

zwStatusMsg(""; "")