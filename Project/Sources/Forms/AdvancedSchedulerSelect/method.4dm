
C_REAL:C285($xrLeft)
C_LONGINT:C283($xlDays; $xlEnd; $xlHeight; $xlSeconds; $xlSize; $xlStart; $xlWidth)
C_LONGINT:C283($xlLeft; $xlTop; $xlRight; $xlBottom)
C_PICTURE:C286($iPict)
C_DATE:C307(dStart; dLast)
C_TIME:C306(hStart; hLast)
Case of 
	: (Form event code:C388=On Load:K2:1)
		
		
		ARRAY TEXT:C222(sttMachine; 0)
		ARRAY TEXT:C222(sttSchDateTime; 0)
		ARRAY PICTURE:C279(siGraph; 0)
		
		SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; sttMachine)
		$xlSize:=Size of array:C274(sttMachine)
		
		ARRAY TEXT:C222(sttSchDateTime; $xlSize)
		ARRAY PICTURE:C279(siGraph; $xlSize)
		$xlWidth:=357
		$xlHeight:=20
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >)
			FIRST RECORD:C50([ProductionSchedules:110])
			
		Else 
			
			ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >)
			
		End if   // END 4D Professional Services : January 2019 First record
		
		dStart:=[ProductionSchedules:110]StartDate:4
		hStart:=[ProductionSchedules:110]StartTime:5
		LAST RECORD:C200([ProductionSchedules:110])
		dLast:=[ProductionSchedules:110]StartDate:4
		hLast:=[ProductionSchedules:110]StartTime:5
		
		
		
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
			
			ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8; >)
			For ($i; 1; $xlSize)
				GOTO SELECTED RECORD:C245([ProductionSchedules:110]; $i)
				sttMachine{$i}:=[ProductionSchedules:110]JobSequence:8
				sttSchDateTime{$i}:=String:C10([ProductionSchedules:110]StartDate:4; System date short:K1:1)+" @ "+String:C10([ProductionSchedules:110]StartTime:5; System time short:K7:9)
				siGraph{$i}:=BuildDateDot($xlWidth; [ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5; [ProductionSchedules:110]EndDate:6; [ProductionSchedules:110]EndTime:7; dStart; dLast)
				
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_JobSequence; 0)
			ARRAY DATE:C224($_StartDate; 0)
			ARRAY TIME:C1223($_StartTime; 0)
			ARRAY DATE:C224($_EndDate; 0)
			ARRAY TIME:C1223($_EndTime; 0)
			
			SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $_JobSequence; \
				[ProductionSchedules:110]StartDate:4; $_StartDate; \
				[ProductionSchedules:110]StartTime:5; $_StartTime; \
				[ProductionSchedules:110]EndDate:6; $_EndDate; \
				[ProductionSchedules:110]EndTime:7; $_EndTime)
			
			SORT ARRAY:C229($_JobSequence; \
				$_StartDate; \
				$_StartTime; \
				$_EndDate; \
				$_EndTime; >)
			
			$xlSize:=Size of array:C274($_EndDate)
			
			
			For ($i; 1; $xlSize)
				sttMachine{$i}:=$_JobSequence{$i}
				sttSchDateTime{$i}:=String:C10($_StartDate{$i}; System date short:K1:1)+" @ "+String:C10($_StartTime{$i}; System time short:K7:9)
				siGraph{$i}:=BuildDateDot($xlWidth; $_StartDate{$i}; $_StartTime{$i}; $_EndDate{$i}; $_EndTime{$i}; dStart; dLast)
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		$ttText:=[ProductionSchedules:110]JobSequence:8
		ttText:="Job Form Schedule:  "+GetNextField(->$ttText; ".")
		ttText:=ttText+"."+GetNextField(->$ttText; ".")
		
		UNLOAD RECORD:C212([ProductionSchedules:110])
		
End case 



