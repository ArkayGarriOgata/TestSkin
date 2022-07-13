$n:=Records in set:C195("UserSet")
If ($n=0)
	ALERT:C41("There are no selected records.")
Else 
	If ($n=1)
		CONFIRM:C162("Do you really want to delete this record?")
	Else 
		CONFIRM:C162("Do you really want to delete these "+String:C10($n)+" record?")
	End if 
	If (OK=1)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CREATE SET:C116(Current form table:C627->; "saved")
			COPY SET:C600("UserSet"; "GlobSet")
			DIFFERENCE:C122("saved"; "GlobSet"; "saved")
			USE SET:C118("UserSet")
			DELETE SELECTION:C66(Current form table:C627->)
			USE SET:C118("saved")
			CLEAR SET:C117("saved")
			CLEAR SET:C117("GlobSet")
			
		Else 
			
			CREATE SET:C116(Current form table:C627->; "$saved")
			DIFFERENCE:C122("$saved"; "UserSet"; "$saved")
			USE SET:C118("UserSet")
			DELETE SELECTION:C66(Current form table:C627->)
			USE SET:C118("$saved")
			CLEAR SET:C117("$saved")
			
		End if   // END 4D Professional Services : January 2019 
		
	End if 
End if 