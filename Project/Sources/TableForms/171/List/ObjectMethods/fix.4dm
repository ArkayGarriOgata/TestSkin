// _______
// Method: [Raw_Material_Labels].List.fix   ( ) ->
// By: Mel Bohince @ 07/12/19, 14:21:42
// Description
// attempt to find a valid foreign key from [Raw_Materials_Locations] to put in [Raw_Material_Labels]
// ----------------------------------------------------


ARRAY LONGINT:C221($_record_machines; 0)
LONGINT ARRAY FROM SELECTION:C647([Raw_Material_Labels:171]; $_record_machines)

//the fk may look good, but the RML record may be gone, if so make fk null
ALL RECORDS:C47([Raw_Material_Labels:171])

While (Not:C34(End selection:C36([Raw_Material_Labels:171])))
	RELATE ONE:C42([Raw_Material_Labels:171]RM_Location_fk:13)
	If (Records in selection:C76([Raw_Materials_Locations:25])<1)
		[Raw_Material_Labels:171]RM_Location_fk:13:=""
		SAVE RECORD:C53([Raw_Material_Labels:171])
	End if 
	NEXT RECORD:C51([Raw_Material_Labels:171])
End while 


//find the null and badly formed UUIDs and try to re establish the fk, by way of the trigger without changing last touched timestamp
QUERY BY FORMULA:C48([Raw_Material_Labels:171]; \
(\
([Raw_Material_Labels:171]RM_Location_fk:13="00000000000000000000000000000000")\
 | ([Raw_Material_Labels:171]RM_Location_fk:13="20202020202020202020202020202020")\
 | (Is field value Null:C964([Raw_Material_Labels:171]RM_Location_fk:13))\
))

APPLY TO SELECTION:C70([Raw_Material_Labels:171]; [Raw_Material_Labels:171]skipTrigger:14:=True:C214)

CREATE SELECTION FROM ARRAY:C640([Raw_Material_Labels:171]; $_record_machines)