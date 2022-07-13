//bDupPSpec2   Duplicate Process cc record 5/3/95
C_DATE:C307($newDate; $OldDate)
$OldDate:=[Cost_Centers:27]EffectivityDate:13
$newDate:=Date:C102(Request:C163("Enter name of new Effectivity Date: "; String:C10(4D_Current_date; <>SHORTDATE)))
If (ok=1)
	If ($newDate#$OldDate)
		If (($newDate>(4D_Current_date-32)) & ($newDate<=(4D_Current_date+32)))
			DUPLICATE RECORD:C225([Cost_Centers:27])
			[Cost_Centers:27]pk_id:72:=Generate UUID:C1066
			[Cost_Centers:27]EffectivityDate:13:=$newDate
			[Cost_Centers:27]ModDate:16:=4D_Current_date
			[Cost_Centers:27]ModWho:17:=<>zResp
			<>RecordSaved:=True:C214
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Cost_Centers]z_SYNC_ID;->[Cost_Centers]z_SYNC_DATA)
			
			ON ERR CALL:C155("eSaveRecError")
			SAVE RECORD:C53([Cost_Centers:27])
			ON ERR CALL:C155("")
			If (<>RecordSaved)
				MODIFY RECORD:C57([Cost_Centers:27]; *)
			Else 
				BEEP:C151
				ALERT:C41("Record not saved, call the administrator.")
				<>RecordSaved:=True:C214
			End if 
			
		Else   //suspect date
			BEEP:C151
			ALERT:C41("New Effectivity date must be within ±32 days of today.")
		End if 
	Else   //same date
		BEEP:C151
		ALERT:C41("You must enter a different effectivity date.")
	End if   //different date  
End if   //ok
//