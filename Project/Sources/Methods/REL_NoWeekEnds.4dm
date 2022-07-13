//%attributes = {}
// Method: REL_NoWeekEnds () -> 
// ----------------------------------------------------
// by: mel: 06/22/05, 16:23:58
// ----------------------------------------------------
// Description:
// don't schedule on weekends
// Modified by: mel (1/19/10) back to Friday before instead of thursday

C_DATE:C307($1; $0)
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

READ WRITE:C146([Customers_ReleaseSchedules:46])
If (Count parameters:C259=0)
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>4D_Current_date; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		
		$break:=False:C215
		$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])
		
		
		uThermoInit($numRecs; "Updating Records")
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			$day:=Day number:C114([Customers_ReleaseSchedules:46]Sched_Date:5)
			Case of   //move weekends to friday
				: ($day=1)  //Sunday
					[Customers_ReleaseSchedules:46]Sched_Date:5:=[Customers_ReleaseSchedules:46]Sched_Date:5-2
					SAVE RECORD:C53([Customers_ReleaseSchedules:46])
				: ($day=7)  //Saturday
					[Customers_ReleaseSchedules:46]Sched_Date:5:=[Customers_ReleaseSchedules:46]Sched_Date:5-1
					SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			End case 
			
			
			NEXT RECORD:C51([Customers_ReleaseSchedules:46])
			uThermoUpdate($i)
		End for 
		
	Else 
		//4D ps/you can use just three query
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>4D_Current_date; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		
		ARRAY LONGINT:C221($_record_number; 0)
		ARRAY LONGINT:C221($_record_number1; 0)
		ARRAY LONGINT:C221($_record_number7; 0)
		ARRAY DATE:C224($_Sched_Date; 0)
		
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]; $_record_number; [Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date)
		
		For ($Iter; 1; Size of array:C274($_record_number); 1)
			
			Case of 
				: (Day number:C114($_Sched_Date{$Iter})=1)
					APPEND TO ARRAY:C911($_record_number1; $_record_number{$Iter})
				: (Day number:C114($_Sched_Date{$Iter})=7)
					APPEND TO ARRAY:C911($_record_number7; $_record_number{$Iter})
			End case 
			
		End for 
		
		//critiria 1
		
		CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_record_number1)
		APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5:=[Customers_ReleaseSchedules:46]Sched_Date:5-2)
		
		//critiria 2
		CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_record_number7)
		APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5:=[Customers_ReleaseSchedules:46]Sched_Date:5-1)
		
	End if   // END 4D Professional Services : January 2019 First record
	
	uThermoClose
	
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	
Else 
	$day:=Day number:C114($1)
	Case of   //move weekends to friday
		: ($day=1)  //Sunday
			$0:=$1-2
		: ($day=7)  //Saturday
			$0:=$1-1
		Else 
			$0:=$1
	End case 
End if 