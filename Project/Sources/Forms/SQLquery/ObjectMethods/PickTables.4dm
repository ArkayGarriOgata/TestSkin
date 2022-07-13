// _______
// Method: SQLquery.PickTables   ( ) ->
// By: Mel Bohince 
// Description
// 
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Begin Drag Over:K2:44)  // Modified by: Mel Bohince (4/7/20) change to set Text to pasteboard
		SET TEXT TO PASTEBOARD:C523(axFiles{Box4})
		
	: (Form event code:C388=On Clicked:K2:4)
		ARRAY TEXT:C222(aFieldNames; 0)
		
		If (local_db)
			ams_get_fields(axFileNums{Box4})
			
		Else 
			$table_id:=axFileNums{Box4}
			
			If (WMS_SQL_Login)
				
				Begin SQL
					SELECT column_name 
					from _user_columns 
					where table_id = :$table_id
					INTO :aFieldNames
				End SQL
				SQL LOGOUT:C872
				
			Else 
				tText:="Could not log into WMS, \rclose window and try again."
			End if 
			
		End if 
		
	: (Form event code:C388=On Double Clicked:K2:5)
		$prefix:=Substring:C12(tText; 1; cursorPosition-1)
		$suffix:=Substring:C12(tText; cursorPosition)
		tText:=$prefix+axFiles{Box4}+$suffix
		GOTO OBJECT:C206(tText)
End case 
