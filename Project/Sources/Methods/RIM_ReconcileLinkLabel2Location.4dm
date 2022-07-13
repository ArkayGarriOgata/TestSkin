//%attributes = {}
// _______
// Method: RIM_ReconcileLinkLabel2Location   ( ) ->
// By: Mel Bohince @ 11/15/21, 11:26:50
// Description
// set the foreign key of the selected labels to the pk_id
// of a location record having the same po, if po is in
// more than 1 location, option for Roanoke or Vista is given
// ----------------------------------------------------

If (Records in set:C195("$ListboxSet2")>0)
	CUT NAMED SELECTION:C334([Raw_Material_Labels:171]; "hold")
	USE SET:C118("$ListboxSet2")
	
	FIRST RECORD:C50([Raw_Material_Labels:171])  //use set had saved current record
	
	//determine which location's record pkid should be used
	C_OBJECT:C1216($rml_es; $rml_e)
	C_TEXT:C284($pk_id)
	//get the po we're dealing with and get its pk_id
	$rml_es:=ds:C1482.Raw_Materials_Locations.query("POItemKey = :1"; [Raw_Material_Labels:171]POItemKey:3)
	Case of 
		: ($rml_es.length=1)  //po in single location, get its key
			$pk_id:=$rml_es.first().pk_id
			
		: ($rml_es.length>1)  //po in single location, get its key
			uConfirm("Which warehouse?"; "Roanoke"; "Vista")
			If (ok=1)
				$location:="Roanoke"
			Else 
				$location:="Vista"
			End if 
			
			$rml_e:=$rml_es.query("Location = :1"; $location).first()
			If ($rml_e#Null:C1517)
				$pk_id:=$rml_e.pk_id
			Else 
				uConfirm("Location "+$location+" with PO "+[Raw_Material_Labels:171]POItemKey:3+" was not found.")
				$pk_id:="Not Found"
			End if 
			
		Else 
			$pk_id:=""  //this label must be an orphan
	End case 
	
	If ($pk_id#"Not Found")
		
		While (Not:C34(End selection:C36([Raw_Material_Labels:171])))
			[Raw_Material_Labels:171]RM_Location_fk:13:=$pk_id
			SAVE RECORD:C53([Raw_Material_Labels:171])
			NEXT RECORD:C51([Raw_Material_Labels:171])
		End while 
		
	End if 
	//restore label selction, some how this removes the new links
	USE NAMED SELECTION:C332("hold")
	
	LOAD RECORD:C52([Raw_Materials_Locations:25])
	RELATE MANY:C262([Raw_Materials_Locations:25]pk_id:32)
	ORDER BY:C49([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2; >)
	
Else 
	uConfirm("Select some labels first."; "Ok"; "I knew that")
	
End if 