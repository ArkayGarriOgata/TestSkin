//%attributes = {"publishedWeb":true}
//PM: SF_GetNumOfShifts(date) -> 0,1,2,or3
//@author mlb - 2/22/02  10:28
//  //v1.0.0-PJK (12/23/15) completely rewrote
//$1=Date
//$2=Dept
//{$3}= optional parameter (TRUE/FALSE) to create the record if it doesn't exist

C_DATE:C307($1)
C_LONGINT:C283($0; $month; $day)
C_TEXT:C284($2; $ttDept)  //not used in orig ver

If (False:C215)
	//C_DATE($1;$dDate)
	//C_TEXT($2;$ttDept;$ttValue)
	//C_BOOLEAN($3;$fCreate)
	//C_TEXT($0)  //v1.0.0-PJK (12/23/15) changed from LONGINT to TEXT for the return value
	//$dDate:=$1
	//$ttDept:=$2
	//$fCreate:=False
	//If (Count parameters>2)
	//$fCreate:=$3
	//End if 
	//  //v1.0.0-PJK (12/23/15) completely rewrote
	
	//$ttValue:=SF_GetDefaultShifts ($dDate)  // get the default value
	
	//QUERY([ProductionSchedules_Shifts];[ProductionSchedules_Shifts]Dept=$ttDept;*)
	//QUERY([ProductionSchedules_Shifts]; & ;[ProductionSchedules_Shifts]ShiftDate=$dDate)
	
	
	
	
	//If (Records in selection([ProductionSchedules_Shifts])>0)
	//$ttValue:=[ProductionSchedules_Shifts]Value
	
	//Else   // no record found
	//If ($fCreate)  // If we are creating the records
	//CREATE RECORD([ProductionSchedules_Shifts])
	//[ProductionSchedules_Shifts]Dept:=$ttDept
	//[ProductionSchedules_Shifts]ShiftDate:=$dDate
	//[ProductionSchedules_Shifts]Value:=$ttValue
	//SAVE RECORD([ProductionSchedules_Shifts])
	
	//End if 
	//End if 
	
	
	
	//UNLOAD RECORD([ProductionSchedules_Shifts])
	//$0:=$ttValue
	
Else   //original
	
	
	$month:=Month of:C24($1)
	$day:=Day of:C23($1)
	$0:=0
	
	Case of 
		: ($month<1)  //fail
		: ($month>12)  //fail
		: ($day<1)  //fail
		: ($day>31)  //fail
		Else 
			$0:=aSFcalendar{$month}{$day}
	End case 
End if 