//%attributes = {}
// Method: eBag_findPriorJobs () -> 
// ----------------------------------------------------
// by: mel: 11/20/03, 14:42:00
// ----------------------------------------------------

C_LONGINT:C283($i; $j; $newsize; $hit; $pid)
C_TEXT:C284($1; $likeJob)

If (Count parameters:C259=1)
	<>jobform:=$1
	$pid:=New process:C317("eBag_findPriorJobs"; <>lMinMemPart; "Old Jobs")
	If (False:C215)
		eBag_findPriorJobs
	End if 
Else 
	$likeJob:=<>jobform
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$likeJob)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN)
	ARRAY TEXT:C222(aOldJobforms; 0)
	
	READ ONLY:C145([Job_Forms_Items:44])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		For ($i; 1; Size of array:C274($aCPN))
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$aCPN{$i}; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]JobForm:1#$likeJob)
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]JobForm:1; $ajf)
			For ($j; 1; Size of array:C274($ajf))
				$hit:=Find in array:C230(aOldJobforms; $ajf{$j})
				If ($hit=-1)
					$newsize:=Size of array:C274(aOldJobforms)+1
					ARRAY TEXT:C222(aOldJobforms; $newsize)
					aOldJobforms{$newsize}:=$ajf{$j}
				End if 
			End for 
		End for 
		
		If (Size of array:C274(aOldJobforms)>0)
			QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; aOldJobforms)
			CREATE SET:C116([Job_Forms:42]; "◊PassThroughSet")
			<>PassThrough:=True:C214
			<>JFActivity:=3
			ViewSetter(3; ->[Job_Forms:42])
			
		Else 
			BEEP:C151
			ALERT:C41("No prior jobs found.")
		End if 
	Else 
		//reduce query on the loop
		
		QUERY WITH ARRAY:C644([Job_Forms_Items:44]ProductCode:3; $aCPN)
		QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1#$likeJob)
		DISTINCT VALUES:C339([Job_Forms_Items:44]JobForm:1; $ajf)
		For ($j; 1; Size of array:C274($ajf))
			$hit:=Find in array:C230(aOldJobforms; $ajf{$j})
			If ($hit=-1)
				$newsize:=Size of array:C274(aOldJobforms)+1
				ARRAY TEXT:C222(aOldJobforms; $newsize)
				aOldJobforms{$newsize}:=$ajf{$j}
			End if 
		End for 
		
		
		
		If (Size of array:C274(aOldJobforms)>0)
			SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
			QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; aOldJobforms)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			<>PassThrough:=True:C214
			<>JFActivity:=3
			ViewSetter(3; ->[Job_Forms:42])
			
		Else 
			BEEP:C151
			ALERT:C41("No prior jobs found.")
		End if 
	End if   // END 4D Professional Services : January 2019 query selection
	
	
End if 