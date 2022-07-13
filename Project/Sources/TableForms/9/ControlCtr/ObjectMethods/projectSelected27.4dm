Pjt_setReferId(pjtId)

<>PassThrough:=True:C214
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	QUERY:C277([ProductionSchedules_BlockTimes:136]; [ProductionSchedules_BlockTimes:136]ProjectNumber:2=pjtId)
	If (Records in selection:C76([ProductionSchedules_BlockTimes:136])>0)
		CREATE SET:C116([ProductionSchedules_BlockTimes:136]; "◊PassThroughSet")
		ViewSetter(2; ->[ProductionSchedules_BlockTimes:136])
	Else 
		BEEP:C151
		CONFIRM:C162("There are no BlockTimes for this project."; "Create"; "Try Again")
		If (ok=1)
			ViewSetter(1; ->[ProductionSchedules_BlockTimes:136])
		End if 
	End if   //
	
Else 
	SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
	QUERY:C277([ProductionSchedules_BlockTimes:136]; [ProductionSchedules_BlockTimes:136]ProjectNumber:2=pjtId)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	If (Records in set:C195("◊PassThroughSet")>0)
		ViewSetter(2; ->[ProductionSchedules_BlockTimes:136])
	Else 
		BEEP:C151
		CONFIRM:C162("There are no BlockTimes for this project."; "Create"; "Try Again")
		If (ok=1)
			ViewSetter(1; ->[ProductionSchedules_BlockTimes:136])
		End if 
	End if   //
	
End if   // END 4D Professional Services : January 2019 
