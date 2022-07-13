//(S) bInclude`•5/8/95 created chip upr 1519

C_DATE:C307($Date)

If (Records in set:C195("UserSet")#0)
	uConfirm("Delete the Selected (highlighted) CC Records when Done?"; "No"; "Delete")
	$Delete:=(OK=0)
	CREATE SET:C116([Cost_Centers:27]; "CCCurrent")
	USE SET:C118("UserSet")
	CREATE SET:C116([Cost_Centers:27]; "Created")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
	Else 
		
		ARRAY LONGINT:C221($_CCCurrent; 0)
		ARRAY LONGINT:C221($_Created; 0)
		
	End if   // END 4D Professional Services : January 2019 
	
	FIRST RECORD:C50([Cost_Centers:27])
	$Count:=Records in set:C195("UserSet")
	
	For ($i; 1; $Count)
		CREATE SET:C116([Cost_Centers:27]; "InUse")
		DUPLICATE RECORD:C225([Cost_Centers:27])
		[Cost_Centers:27]pk_id:72:=Generate UUID:C1066
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Cost_Centers]z_SYNC_ID;->[Cost_Centers]z_SYNC_DATA)
		
		Repeat 
			$Date:=Date:C102(Request:C163("Enter a New Date for: "+[Cost_Centers:27]Description:3))
			
			Case of 
				: (OK=0)
					$Date:=!00-00-00!
					uConfirm("Without a New Effectivity Date, Duplication will be Canceled."+" Enter New Effectivity Date?"; "New"; "Cancel")
				: ($Date<(4D_Current_date-30)) & ($Date#!00-00-00!)
					ALERT:C41("Date Entered is to Far in the Past."+<>sCR+"Date May NOT be More than +/- 30 Days from Today.")
				: ($Date>(4D_Current_date+30)) & ($Date#!00-00-00!)
					ALERT:C41("Date Entered is to Far in the Future."+<>sCR+"Date May NOT be More than +/- 30 Days from Today.")
			End case 
		Until (($Date#!00-00-00!) & (($Date>=(4D_Current_date-30)) & ($Date<=(4D_Current_date+30)))) | (OK=0)
		
		If (OK=0)
			$i:=$Count+1
		Else 
			[Cost_Centers:27]EffectivityDate:13:=$Date
			SAVE RECORD:C53([Cost_Centers:27])
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				ADD TO SET:C119([Cost_Centers:27]; "Created")
				ADD TO SET:C119([Cost_Centers:27]; "CCCurrent")
				
				
			Else 
				
				APPEND TO ARRAY:C911($_Created; Record number:C243([Cost_Centers:27]))
				APPEND TO ARRAY:C911($_CCCurrent; Record number:C243([Cost_Centers:27]))
				
			End if   // END 4D Professional Services : January 2019 
			USE SET:C118("InUse")
			NEXT RECORD:C51([Cost_Centers:27])
			CREATE SET:C116([Cost_Centers:27]; "InUse")
		End if 
	End for 
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
	Else 
		
		CREATE SET FROM ARRAY:C641([Cost_Centers:27]; $_Created; "4D_Ps_Set")
		UNION:C120("Created"; "4D_Ps_Set"; "Created")
		CREATE SET FROM ARRAY:C641([Cost_Centers:27]; $_CCCurrent; "4D_Ps_Set")
		UNION:C120("CCCurrent"; "4D_Ps_Set"; "CCCurrent")
		CLEAR SET:C117("4D_Ps_Set")
		
	End if   // END 4D Professional Services : January 2019 
	
	If ($Delete) & (OK=1)  //ok from above
		uConfirm("Delete Original Cost Center Records?")
		If (OK=1)
			USE SET:C118("InUse")
			DELETE SELECTION:C66([Cost_Centers:27])
		End if 
	End if 
	CLEAR SET:C117("InUse")
	USE SET:C118("Created")
	CLEAR SET:C117("Created")
	OBJECT SET ENABLED:C1123(bRestore; True:C214)
	
Else 
	ALERT:C41("You Need to Select, (highlight), One or More Records, First.")
End if 