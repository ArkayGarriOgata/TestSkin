//%attributes = {"publishedWeb":true}
//PM: PS_qryReadyToPlate() -> 
//@author mlb - 6/27/02  15:20

C_TEXT:C284($1; $cc)
If (Count parameters:C259=1)
	$cc:=$1
Else 
	$cc:="413"
End if 
C_REAL:C285($0)

uConfirm("New or old way?"; "New"; "Old")
If (ok=0)
	utl_Logfile("benchmark.log"; Current method name:C684+" Begin old way")
	
	If ($cc#"All")  //look seq of one press without plates or cyrels
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]PlatesReady:18=!00-00-00!; *)
		QUERY:C277([ProductionSchedules:110];  | ; [ProductionSchedules:110]CyrelsReady:19=!00-00-00!; *)
		QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]CostCenter:1=$cc)
	Else 
		PS_qryPrintingOnly
		QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]PlatesReady:18=!00-00-00!; *)
		QUERY SELECTION:C341([ProductionSchedules:110];  | ; [ProductionSchedules:110]CyrelsReady:19=!00-00-00!)
	End if 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		CREATE EMPTY SET:C140([ProductionSchedules:110]; "preflighted")
		For ($i; 1; Records in selection:C76([ProductionSchedules:110]))
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=(Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)))
			uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Job_Forms_Items:44]ProductCode:3; 1)
			QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]Preflight:66=False:C215)
			If (Records in selection:C76([Finished_Goods:26])=0)
				ADD TO SET:C119([ProductionSchedules:110]; "preflighted")
			End if 
			
			NEXT RECORD:C51([ProductionSchedules:110])
		End for 
		
	Else 
		
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[ProductionSchedules:110])+" file. Please Wait...")
		ARRAY TEXT:C222($_JobSequence; 0)
		ARRAY LONGINT:C221($_ProductionSchedules_NB; 0)
		ARRAY LONGINT:C221($_ProductionSchedules_NB_not; 0)
		
		SELECTION TO ARRAY:C260(\
			[ProductionSchedules:110]JobSequence:8; $_JobSequence; \
			[ProductionSchedules:110]; $_ProductionSchedules_NB)
		
		$Nb_size:=Size of array:C274($_JobSequence)
		ARRAY TEXT:C222($_JobSequence_copie; $Nb_size)
		For ($Iter; 1; $Nb_size; 1)
			$_JobSequence_copie{$Iter}:=Substring:C12($_JobSequence{$Iter}; 1; 8)
		End for 
		
		ARRAY TEXT:C222($_JobSequence_copie_2; 0)
		
		QUERY WITH ARRAY:C644([Job_Forms_Items:44]JobForm:1; $_JobSequence_copie)
		QUERY SELECTION:C341([Job_Forms_Items:44]; [Finished_Goods:26]Preflight:66=False:C215)
		DISTINCT VALUES:C339([Job_Forms_Items:44]JobForm:1; $_JobSequence_copie_2)
		For ($Iter; 1; $Nb_size; 1)
			If (Find in array:C230($_JobSequence_copie_2; $_JobSequence_copie{$Iter})=-1)
				APPEND TO ARRAY:C911($_ProductionSchedules_NB_not; $_ProductionSchedules_NB{$Iter})
			End if 
		End for 
		
		CREATE SET FROM ARRAY:C641([ProductionSchedules:110]; $_ProductionSchedules_NB_not; "preflighted")
		
		zwStatusMsg(""; "")
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	
Else   //new way
	utl_Logfile("benchmark.log"; Current method name:C684+" Begin new way")
	
	
	//Build a hash of jobform, cpn and preflighted for the give costcenter
	ARRAY TEXT:C222($aCPNs; 0)
	ARRAY TEXT:C222($aJF; 0)
	ARRAY BOOLEAN:C223($aPreFlighted; 0)
	//get the items on each job using
	//subquery of jobforms on sched that need plates
	If ($cc="ALL")
		$match:="%"
	Else 
		$match:=$cc
	End if 
	
	Begin SQL
		select ProductCode, JobForm from Job_Forms_Items where JobForm in 
		(select distinct(substring(JobSequence,1,8)) from ProductionSchedules where CostCenter like :$match and (PlatesReady<'1990-01-01' or CyrelsReady<'1990-01-01'))
		into :$aCPNs, :$aJF;
	End SQL
	//now using that list of cpns' get the preflight state from the fg record
	QUERY WITH ARRAY:C644([Finished_Goods:26]ProductCode:1; $aCPNs)
	SELECTION TO ARRAY:C260([Finished_Goods:26]ProductCode:1; $aFG; [Finished_Goods:26]Preflight:66; $aPF)
	
	//merge the preflight state into the arrays having the jobform
	C_LONGINT:C283($i; $numElements)
	$numElements:=Size of array:C274($aCPNs)
	ARRAY BOOLEAN:C223($aPreFlighted; $numElements)
	
	uThermoInit($numElements; "Processing Array")
	For ($i; 1; $numElements)
		$hit:=Find in array:C230($aFG; $aCPNs{$i})
		If ($hit>-1)
			$aPreFlighted{$i}:=$aPF{$hit}
		Else 
			$aPreFlighted{$i}:=False:C215
		End if 
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	
	//if all items are not preflighted, then plating cannot proceed
	CREATE EMPTY SET:C140([ProductionSchedules:110]; "preflighted")
	If (Size of array:C274($aJF)>0)  //some protection
		
		ARRAY TEXT:C222($aDistinctJobfrom; 0)
		ARRAY BOOLEAN:C223($aReadyToPlate; 0)
		
		SORT ARRAY:C229($aJF; $aCPNs; $aPreFlighted; >)
		
		$ready:=True:C214
		$jobCPN:=1
		$lastJF:=$aJF{$jobCPN}
		
		While ($jobCPN<=Size of array:C274($aJF)) & ($lastJF#"EOF")
			If ($aJF{$jobCPN}#$lastJF)  //finish last and start something new
				APPEND TO ARRAY:C911($aDistinctJobfrom; $lastJF)
				APPEND TO ARRAY:C911($aReadyToPlate; $ready)
				$lastJF:=$aJF{$jobCPN}
				$ready:=True:C214
				
			Else   //look for something not preflighted
				
				If (Not:C34($aPreFlighted{$jobCPN}))
					$ready:=False:C215
					
					Repeat   //skip to find the next job
						If ($jobCPN<Size of array:C274($aJF))  //array bounds
							$jobCPN:=$jobCPN+1
						Else 
							$lastJF:="EOF"
						End if 
					Until ($lastJF#$aJF{$jobCPN})
					
				Else 
					//go to next row
					$jobCPN:=$jobCPN+1
				End if   //preflight test
				
			End if   //change in jf
			
		End while   //each aJF
		APPEND TO ARRAY:C911($aDistinctJobfrom; $lastJF)
		APPEND TO ARRAY:C911($aReadyToPlate; $ready)
		
		If ($cc#"All")  //look seq of one press without plates or cyrels
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]PlatesReady:18=!00-00-00!; *)
			QUERY:C277([ProductionSchedules:110];  | ; [ProductionSchedules:110]CyrelsReady:19=!00-00-00!; *)
			QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]CostCenter:1=$cc)
		Else 
			PS_qryPrintingOnly
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]PlatesReady:18=!00-00-00!; *)
			QUERY SELECTION:C341([ProductionSchedules:110];  | ; [ProductionSchedules:110]CyrelsReady:19=!00-00-00!)
			
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
		End if 
		
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($i; 1; Records in selection:C76([ProductionSchedules:110]))
				$jf:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
				$hit:=Find in array:C230($aDistinctJobfrom; $jf)
				If ($hit>-1)
					If ($aReadyToPlate{$hit})
						ADD TO SET:C119([ProductionSchedules:110]; "preflighted")
					End if 
				End if 
				
				NEXT RECORD:C51([ProductionSchedules:110])
			End for 
			
			
		Else 
			//Laghzaoui replace next and add to set 
			
			ARRAY TEXT:C222($_JobSequence; 0)
			ARRAY LONGINT:C221($_record_number; 0)
			ARRAY LONGINT:C221($_record_finale; 0)
			
			SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $_JobSequence; \
				[ProductionSchedules:110]; $_record_number)
			
			For ($i; 1; Size of array:C274($_JobSequence); 1)
				$jf:=Substring:C12($_JobSequence{$i}; 1; 8)
				$hit:=Find in array:C230($aDistinctJobfrom; $jf)
				If ($hit>-1)
					If ($aReadyToPlate{$hit})
						
						APPEND TO ARRAY:C911($_record_finale; $_record_number{$i})
						
					End if 
				End if 
				
			End for 
			
			CREATE SET FROM ARRAY:C641([ProductionSchedules:110]; $_record_finale; "preflighted")
			
		End if   // END 4D Professional Services : January 2019 
		
	End if   //got some aJf's to look at
	
End if   //new way

uConfirm("Highlight or Subset?"; "Hi-lite"; "Subset")
If (ok=1)
	COPY SET:C600("preflighted"; "UserSet")
	HIGHLIGHT RECORDS:C656
Else 
	USE SET:C118("preflighted")
End if 
CLEAR SET:C117("preflighted")
If (Records in selection:C76([ProductionSchedules:110])>0)
	$0:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
	ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >; [ProductionSchedules:110]StartDate:4; >)
Else 
	$0:=0
End if 

zwStatusMsg("SCHED"; $cc+" has been refreshed")
utl_Logfile("benchmark.log"; Current method name:C684+" End "+$cc)


