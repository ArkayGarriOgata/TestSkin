//%attributes = {"publishedWeb":true}
//PM: REL_shippedLateRpt({date}) -> create a selection of late releases
//@author mlb - 3/18/03  09:45
// • mel (9/17/03, 16:58:28) change to match CustomerView with Promise date
//see also REL_OntimeReportCustomerView
// • mel (11/12/03, 16:25:22) fixed old ref to sched that should have been promise
// • mel (4/2/04, 11:59:12) change to match Internal View [ReleaseSchedule]Sched_Date
// • mel (6/10/04, 10:04:36) change to 3 day grace

C_DATE:C307($1; $2; dDateBegin; dDateEnd; $allowedEarly; $allowedLate)
C_LONGINT:C283($early; $tolerance)

If (Count parameters:C259=2)
	dDateBegin:=$1
	dDateEnd:=$2
	$continue:=True:C214
	
Else 
	dDateBegin:=4D_Current_date-1
	dDateEnd:=4D_Current_date
	ERASE WINDOW:C160
	DIALOG:C40([zz_control:1]; "DateRange2")
	If (ok=1)
		$continue:=True:C214
		If (bSearch=1)
			zwStatusMsg("ON TIME"; "Ad hoc")
			QUERY:C277([Customers_ReleaseSchedules:46])
		Else 
			zwStatusMsg("ON TIME CHK"; "From "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1))
		End if 
	End if 
End if 

If ($continue)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>=dDateBegin; *)  // get the releases that shipped on the target date
	
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7<=dDateEnd; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Qty:6#0)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) create empty set
		
		CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "shippedLate")
		
	Else 
		
		ARRAY LONGINT:C221($_shippedLate; 0)
		
	End if   // END 4D Professional Services : January 2019 
	
	C_LONGINT:C283($i; $numRecs)
	C_BOOLEAN:C305($break)
	$break:=False:C215
	$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])
	
	If ($numRecs>0)
		ARRAY TEXT:C222($aEsteeCompany; 0)  //lauder has special rules
		
		uThermoInit($numRecs; "Looking for late shipments")
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($i; 1; $numRecs)
				If ($break)
					$i:=$i+$numRecs
				End if 
				
				$dayOfWeek:=Day number:C114([Customers_ReleaseSchedules:46]Sched_Date:5)  //[ReleaseSchedule]Sched_Date)
				
				Case of 
					: (False:C215) & (Find in array:C230($aEsteeCompany; [Customers_ReleaseSchedules:46]CustID:12)>-1)
						Case of 
							: ($dayOfWeek=Thursday:K10:16)
								$tolerance:=4
							: ($dayOfWeek=Friday:K10:17)
								$tolerance:=4
							: ($dayOfWeek=Saturday:K10:18)
								$tolerance:=3
							Else 
								$tolerance:=2
						End case 
						
						If ([Customers_ReleaseSchedules:46]Actual_Date:7>([Customers_ReleaseSchedules:46]Promise_Date:32+$tolerance))
							ADD TO SET:C119([Customers_ReleaseSchedules:46]; "shippedLate")
						End if 
						
					: (False:C215) & ([Customers_ReleaseSchedules:46]CustID:12="00045")  //special rules for Chanel
						Case of 
							: ($dayOfWeek=Wednesday:K10:15)
								$tolerance:=5
							: ($dayOfWeek=Thursday:K10:16)
								$tolerance:=5
							: ($dayOfWeek=Friday:K10:17)
								$tolerance:=5
							: ($dayOfWeek=Saturday:K10:18)
								$tolerance:=4
							Else 
								$tolerance:=3
						End case 
						
						Case of 
							: ($dayOfWeek=Monday:K10:13)
								$early:=6
							: ($dayOfWeek=Tuesday:K10:14)
								$early:=6
							: ($dayOfWeek=Wednesday:K10:15)
								$early:=6
							: ($dayOfWeek=Thursday:K10:16)
								$early:=6
							: ($dayOfWeek=Saturday:K10:18)
								$early:=5
							: ($dayOfWeek=Sunday:K10:19)
								$early:=6
							Else 
								$early:=4
						End case 
						
						If ([Customers_ReleaseSchedules:46]Actual_Qty:8>=[Customers_ReleaseSchedules:46]Sched_Qty:6)
							$allowedEarly:=[Customers_ReleaseSchedules:46]Sched_Date:5-$early
							$allowedLate:=[Customers_ReleaseSchedules:46]Sched_Date:5+$tolerance
							If ([Customers_ReleaseSchedules:46]Sched_Date:5>=$allowedEarly) & ([Customers_ReleaseSchedules:46]Sched_Date:5<=$allowedLate)
								//good
								
							Else 
								ADD TO SET:C119([Customers_ReleaseSchedules:46]; "shippedLate")
							End if 
						Else   //shipped short
							
							ADD TO SET:C119([Customers_ReleaseSchedules:46]; "shippedLate")
						End if 
						
					Else   //***** default rule
						Case of 
							: (True:C214)  // • mel (6/10/04, 10:04:07)
								$tolerance:=0  //3 08/12/04
								
							: ($dayOfWeek=Sunday:K10:19)
								$tolerance:=5
							: ($dayOfWeek=Saturday:K10:18)
								$tolerance:=6
							Else 
								$tolerance:=7  //to give 5 bizness days
								
						End case 
						
						If ([Customers_ReleaseSchedules:46]Actual_Date:7<=([Customers_ReleaseSchedules:46]Sched_Date:5+$tolerance))
							//good
						Else 
							ADD TO SET:C119([Customers_ReleaseSchedules:46]; "shippedLate")
						End if 
				End case 
				
				NEXT RECORD:C51([Customers_ReleaseSchedules:46])
				uThermoUpdate($i)
			End for 
			
			
		Else 
			
			//laghzaoui replate add to set and next
			ARRAY TEXT:C222($_CustID; 0)
			ARRAY DATE:C224($_Actual_Date; 0)
			ARRAY DATE:C224($_Promise_Date; 0)
			ARRAY LONGINT:C221($_Actual_Qty; 0)
			ARRAY LONGINT:C221($_Sched_Qty; 0)
			ARRAY DATE:C224($_Sched_Date; 0)
			ARRAY LONGINT:C221($_record_number; 0)
			
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustID:12; $_CustID; \
				[Customers_ReleaseSchedules:46]Actual_Date:7; $_Actual_Date; \
				[Customers_ReleaseSchedules:46]Promise_Date:32; $_Promise_Date; \
				[Customers_ReleaseSchedules:46]Actual_Qty:8; $_Actual_Qty; \
				[Customers_ReleaseSchedules:46]Sched_Qty:6; $_Sched_Qty; \
				[Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date; \
				[Customers_ReleaseSchedules:46]; $_record_number)
			
			For ($i; 1; $numRecs; 1)
				If ($break)
					$i:=$i+$numRecs
				End if 
				
				$dayOfWeek:=Day number:C114($_Sched_Date{$i})  //[ReleaseSchedule]Sched_Date)
				
				Case of 
					: (False:C215) & (Find in array:C230($aEsteeCompany; $_CustID{$i})>-1)
						Case of 
							: ($dayOfWeek=Thursday:K10:16)
								$tolerance:=4
							: ($dayOfWeek=Friday:K10:17)
								$tolerance:=4
							: ($dayOfWeek=Saturday:K10:18)
								$tolerance:=3
							Else 
								$tolerance:=2
						End case 
						
						If ($_Actual_Date{$i}>($_Promise_Date{$i}+$tolerance))
							APPEND TO ARRAY:C911($_shippedLate; $_record_number{$i})
						End if 
						
					: (False:C215) & ($_CustID{$i}="00045")  //special rules for Chanel
						Case of 
							: ($dayOfWeek=Wednesday:K10:15)
								$tolerance:=5
							: ($dayOfWeek=Thursday:K10:16)
								$tolerance:=5
							: ($dayOfWeek=Friday:K10:17)
								$tolerance:=5
							: ($dayOfWeek=Saturday:K10:18)
								$tolerance:=4
							Else 
								$tolerance:=3
						End case 
						
						Case of 
							: ($dayOfWeek=Monday:K10:13)
								$early:=6
							: ($dayOfWeek=Tuesday:K10:14)
								$early:=6
							: ($dayOfWeek=Wednesday:K10:15)
								$early:=6
							: ($dayOfWeek=Thursday:K10:16)
								$early:=6
							: ($dayOfWeek=Saturday:K10:18)
								$early:=5
							: ($dayOfWeek=Sunday:K10:19)
								$early:=6
							Else 
								$early:=4
						End case 
						
						If ($_Actual_Qty{$i}>=$_Sched_Qty{$i})
							$allowedEarly:=$_Sched_Date{$i}-$early
							$allowedLate:=$_Sched_Date{$i}+$tolerance
							If ($_Sched_Date{$i}>=$allowedEarly) & ($_Sched_Date{$i}<=$allowedLate)
								//good
								
							Else 
								APPEND TO ARRAY:C911($_shippedLate; $_record_number{$i})
							End if 
						Else   //shipped short
							
							APPEND TO ARRAY:C911($_shippedLate; $_record_number{$i})
						End if 
						
					Else   //***** default rule
						Case of 
							: (True:C214)  // • mel (6/10/04, 10:04:07)
								$tolerance:=0  //3 08/12/04
								
							: ($dayOfWeek=Sunday:K10:19)
								$tolerance:=5
							: ($dayOfWeek=Saturday:K10:18)
								$tolerance:=6
							Else 
								$tolerance:=7  //to give 5 bizness days
								
						End case 
						
						If ($_Actual_Date{$i}<=($_Sched_Date{$i}+$tolerance))
							//good
						Else 
							
							APPEND TO ARRAY:C911($_shippedLate; $_record_number{$i})
							
						End if 
				End case 
				
				uThermoUpdate($i)
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 
		uThermoClose
		
	Else 
		BEEP:C151
		zwStatusMsg(""; "No releases scheduled with that criterian.")
	End if 
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) create empty set
		
		USE SET:C118("shippedLate")
		CLEAR SET:C117("shippedLate")
		
	Else 
		
		
		CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_shippedLate)
		
		
	End if   // END 4D Professional Services : January 2019 
	
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerLine:28; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
	SET WINDOW TITLE:C213(String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+" F/G Releases Shipped Late, Zero Tolerance")
End if 