//Script: bInclude()  052096  MLB
//mark the selected contact records with user specified initials

If (Not:C34(Read only state:C362([Contacts:51])))
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		CREATE EMPTY SET:C140([Contacts:51]; "mark")
		COPY SET:C600("UserSet"; "UserSelected")
		UNION:C120("mark"; "UserSelected"; "mark")
		CLEAR SET:C117("UserSelected")
		
	Else 
		
		COPY SET:C600("UserSet"; "mark")
		
	End if   // END 4D Professional Services : January 2019 
	
	If (Records in set:C195("mark")>0)
		C_LONGINT:C283($i)
		C_TEXT:C284($initials)
		$initials:=Substring:C12(Request:C163("Use whose initials?"; <>zResp); 1; 4)
		If (ok=1)
			CUT NAMED SELECTION:C334([Contacts:51]; "before")
			
			USE SET:C118("mark")
			CLEAR SET:C117("mark")
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				FIRST RECORD:C50([Contacts:51])  //•051596  MLB  
				For ($i; 1; Records in selection:C76([Contacts:51]))
					CREATE RECORD:C68([Contacts_Tags:183])
					[Contacts_Tags:183]UserID:1:=$initials
					[Contacts_Tags:183]id_added_by_converter:2:=[Contacts:51]WhoseContact:37
					SAVE RECORD:C53([Contacts_Tags:183])
					NEXT RECORD:C51([Contacts:51])
				End for 
				
			Else 
				
				ARRAY LONGINT:C221($_WhoseContact; 0)
				SELECTION TO ARRAY:C260([Contacts:51]WhoseContact:37; $_WhoseContact)
				
				For ($i; 1; Size of array:C274($_WhoseContact); 1)
					CREATE RECORD:C68([Contacts_Tags:183])
					[Contacts_Tags:183]UserID:1:=$initials
					[Contacts_Tags:183]id_added_by_converter:2:=$_WhoseContact{$i}
					SAVE RECORD:C53([Contacts_Tags:183])
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			USE NAMED SELECTION:C332("before")
		End if   //ok
		
	Else 
		BEEP:C151
		ALERT:C41("You must select the contacts you wish to mark.")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("You must be in 'Modify' mode to mark these contacts.")
End if 