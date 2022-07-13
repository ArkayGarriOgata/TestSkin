//(S) bInclude
If (Records in set:C195("UserSet")#0)
	uConfirm("Delete the Selected (highlighted) RM Groups when Done?"; "No"; "Delete")
	$Delete:=(OK=0)
	CREATE SET:C116([Raw_Materials_Groups:22]; "RmCurrent")
	USE SET:C118("UserSet")
	CREATE SET:C116([Raw_Materials_Groups:22]; "Created")
	FIRST RECORD:C50([Raw_Materials_Groups:22])
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
	Else 
		ARRAY LONGINT:C221($_RmCurrent; 0)
		ARRAY LONGINT:C221($_Created; 0)
		
	End if   // END 4D Professional Services : January 2019 
	
	For ($i; 1; Records in set:C195("UserSet"))
		CREATE SET:C116([Raw_Materials_Groups:22]; "InUse")
		DUPLICATE RECORD:C225([Raw_Materials_Groups:22])
		[Raw_Materials_Groups:22]pk_id:28:=Generate UUID:C1066
		[Raw_Materials_Groups:22]Description:2:=[Raw_Materials_Groups:22]Description:2+" TWO"
		[Raw_Materials_Groups:22]EffectivityDate:15:=4D_Current_date
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Raw_Materials_Groups]z_SYNC_ID;->[Raw_Materials_Groups]z_SYNC_DATA)
		SAVE RECORD:C53([Raw_Materials_Groups:22])
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			ADD TO SET:C119([Raw_Materials_Groups:22]; "Created")
			ADD TO SET:C119([Raw_Materials_Groups:22]; "RmCurrent")
			
			
		Else 
			
			APPEND TO ARRAY:C911($_Created; Record number:C243([Raw_Materials_Groups:22]))
			APPEND TO ARRAY:C911($_RmCurrent; Record number:C243([Raw_Materials_Groups:22]))
			
		End if   // END 4D Professional Services : January 2019 
		USE SET:C118("InUse")
		NEXT RECORD:C51([Raw_Materials_Groups:22])
		CREATE SET:C116([Raw_Materials_Groups:22]; "InUse")
	End for 
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
	Else 
		
		CREATE SET FROM ARRAY:C641([Raw_Materials_Groups:22]; $_Created; "4d_Ps_Set")
		UNION:C120("Created"; "4d_Ps_Set"; "Created")
		CREATE SET FROM ARRAY:C641([Raw_Materials_Groups:22]; $_RmCurrent; "4d_Ps_Set")
		UNION:C120("RmCurrent"; "4d_Ps_Set"; "RmCurrent")
		CLEAR SET:C117("4d_Ps_Set")
		
	End if   // END 4D Professional Services : January 2019 
	
	
	If ($Delete)
		uConfirm("Delete Original RM Group Records?")
		If (OK=1)
			USE SET:C118("InUse")
			DELETE SELECTION:C66([Raw_Materials_Groups:22])
		End if 
	End if 
	CLEAR SET:C117("InUse")
	USE SET:C118("Created")
	CLEAR SET:C117("Created")
	OBJECT SET ENABLED:C1123(bRestore; True:C214)
	
Else 
	ALERT:C41("You Need to Select, (highlight), One or More Records, First.")
End if 
//EOS