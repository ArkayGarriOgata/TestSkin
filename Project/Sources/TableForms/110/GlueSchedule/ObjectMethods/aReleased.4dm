If (User in group:C338(Current user:C182; "Role_Glue_Scheduling"))
	
	Case of 
		: (Form event code:C388=On Clicked:K2:4)  // Modified by: Mel Bohince (8/18/21) disabled
			If (aGlueListBox<=Size of array:C274(aGlueListBox)) & (aGlueListBox#0)
				If (Position:C15("FIX REL "; aComment{aGlueListBox})=0)
					aComment{aGlueListBox}:="FIX REL "+String:C10(aReleased{aGlueListBox}; Internal date short special:K1:4)+"^"+aComment{aGlueListBox}
				Else 
					aComment{aGlueListBox}:=Substring:C12(aComment{aGlueListBox}; Position:C15("^"; aComment{aGlueListBox})+1)
				End if 
				PSG_MasterArray("store"; aGlueListBox)
			End if 
			
		: (Form event code:C388=On Double Clicked:K2:5)
			READ ONLY:C145([Customers_ReleaseSchedules:46])
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=aCPN{aGlueListBox}; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5=aReleased{aGlueListBox})
			pattern_PassThru(->[Customers_ReleaseSchedules:46])
			ViewSetter(2; ->[Customers_ReleaseSchedules:46])
			If (Position:C15("FIX REL "; aComment{aGlueListBox})=0)
				aComment{aGlueListBox}:="FIX REL "+String:C10(aReleased{aGlueListBox}; Internal date short special:K1:4)+"^"+aComment{aGlueListBox}
			End if 
			
	End case 
	
End if 

