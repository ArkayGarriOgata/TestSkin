//%attributes = {}
// -------
// Method: api_Schedule   ( ) ->
// By: Mel Bohince @ 06/07/17, 15:49:52
// Description
// 
// ----------------------------------------------------

C_LONGINT:C283($i; $numElements)
C_TEXT:C284($jobform; $1; $0; $res; $salerep; $coord; $plnr)
C_OBJECT:C1216($obj_by_value)
C_DATE:C307($fence)
$fence:=Add to date:C393(Current date:C33; 0; 0; 5)

C_BOOLEAN:C305($debug)
$debug:=False:C215

READ ONLY:C145([ProductionSchedules:110])


If (Count parameters:C259=0) & (Not:C34($debug))  //rtn a collection
	//$0:=Selection to JSON([ProductionSchedules];[ProductionSchedules]CostCenter;[ProductionSchedules]Priority;[ProductionSchedules]JobSequence;[ProductionSchedules]StartDate;[ProductionSchedules]Customer;[ProductionSchedules]JobInfo)
	
	
Else   //got me some params
	
	If (Not:C34($debug))
		$cc:=$1
	Else 
		$cc:="452"
	End if 
	
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=$cc; *)
	QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Completed:23=0; *)
	QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]StartDate:4<=$fence)
	If (Records in selection:C76([ProductionSchedules:110])>0)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3)
			C_OBJECT:C1216($Schedule)
			OB SET:C1220($Schedule; "costcenter"; $cc)
			
			ARRAY OBJECT:C1221($items; 0)
			C_OBJECT:C1216($item)
			
			For ($i; 1; Records in selection:C76([ProductionSchedules:110]))
				OB SET:C1220($item; "customer"; [ProductionSchedules:110]Customer:11; "priority"; [ProductionSchedules:110]Priority:3; "job_sequence"; [ProductionSchedules:110]JobSequence:8; "start_date"; String:C10([ProductionSchedules:110]StartDate:4; Internal date short special:K1:4))
				OB SET:C1220($item; "start_time"; String:C10([ProductionSchedules:110]StartTime:5; HH MM:K7:2); "duration"; String:C10([ProductionSchedules:110]DurationSeconds:9; HH MM:K7:2); "details"; [ProductionSchedules:110]JobInfo:58)
				
				OB SET:C1220($item; "Visit"; String:C10([ProductionSchedules:110]CustomerVisit:24); "process"; String:C10([ProductionSchedules:110]ProcessColors:21); "fixed"; String:C10([ProductionSchedules:110]FixedStart:12); "cold_foil"; String:C10([ProductionSchedules:110]ColdFoil:76))
				$obj_by_value:=OB Copy:C1225($item)
				APPEND TO ARRAY:C911($items; $obj_by_value)
				NEXT RECORD:C51([ProductionSchedules:110])
			End for 
			OB SET ARRAY:C1227($Schedule; "jobs"; $items)
		Else 
			
			C_OBJECT:C1216($Schedule)
			OB SET:C1220($Schedule; "costcenter"; $cc)
			
			ARRAY OBJECT:C1221($items; 0)
			C_OBJECT:C1216($item)
			
			ARRAY TEXT:C222($_Customer; 0)
			ARRAY LONGINT:C221($_Priority; 0)
			ARRAY TEXT:C222($_JobSequence; 0)
			ARRAY DATE:C224($_StartDate; 0)
			ARRAY TIME:C1223($_StartTime; 0)
			ARRAY TIME:C1223($_Duration; 0)
			ARRAY TEXT:C222($_JobInfo; 0)
			ARRAY BOOLEAN:C223($_CustomerVisit; 0)
			ARRAY BOOLEAN:C223($_ProcessColors; 0)
			ARRAY BOOLEAN:C223($_FixedStart; 0)
			ARRAY BOOLEAN:C223($_ColdFoil; 0)
			
			SELECTION TO ARRAY:C260([ProductionSchedules:110]Customer:11; $_Customer; [ProductionSchedules:110]Priority:3; $_Priority; [ProductionSchedules:110]JobSequence:8; $_JobSequence; [ProductionSchedules:110]StartDate:4; $_StartDate; [ProductionSchedules:110]StartTime:5; $_StartTime; [ProductionSchedules:110]DurationSeconds:9; $_Duration; [ProductionSchedules:110]JobInfo:58; $_JobInfo; [ProductionSchedules:110]CustomerVisit:24; $_CustomerVisit; [ProductionSchedules:110]ProcessColors:21; $_ProcessColors; [ProductionSchedules:110]FixedStart:12; $_FixedStart; [ProductionSchedules:110]ColdFoil:76; $_ColdFoil)
			
			SORT ARRAY:C229($_Priority; $_Customer; $_JobSequence; $_StartDate; $_StartTime; $_Duration; $_JobInfo; $_JobInfo; $_CustomerVisit; $_ProcessColors; $_FixedStart; $_ColdFoil)
			
			For ($i; 1; Size of array:C274($_Customer); 1)
				
				OB SET:C1220($item; "customer"; $_Customer{$i}; "priority"; $_Priority{$i}; "job_sequence"; $_JobSequence{$i}; "start_date"; String:C10($_StartDate{$i}; Internal date short special:K1:4))
				OB SET:C1220($item; "start_time"; String:C10($_StartTime{$i}; HH MM:K7:2); "duration"; String:C10($_Duration{$i}; HH MM:K7:2); "details"; $_JobInfo{$i})
				OB SET:C1220($item; "Visit"; String:C10($_CustomerVisit{$i}); "process"; String:C10($_ProcessColors{$i}); "fixed"; String:C10($_FixedStart{$i}); "cold_foil"; String:C10($_ColdFoil{$i}))
				$obj_by_value:=OB Copy:C1225($item)
				APPEND TO ARRAY:C911($items; $obj_by_value)
				
			End for 
			OB SET ARRAY:C1227($Schedule; "jobs"; $items)
		End if   // END 4D Professional Services : January 2019 First record
		
		$res:=JSON Stringify:C1217($Schedule; *)
		If ($debug)
			utl_LogIt("init")
			utl_LogIt($res)
			utl_LogIt("show")
		Else 
			$0:=$res
		End if 
		
	Else 
		$res:="404 "+$cc+" not found"
	End if 
	
End if   //count parameters

REDUCE SELECTION:C351([ProductionSchedules:110]; 0)

