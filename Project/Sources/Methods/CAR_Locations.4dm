//%attributes = {"publishedWeb":true}
//PM: CAR_Locations() -> 
//@author mlb - 10/24/01  16:23

C_TEXT:C284($1)
C_LONGINT:C283($2; $i)

Case of 
	: ($1="init")
		ARRAY LONGINT:C221(<>aCAR_LocationsRec; 0)
		ARRAY TEXT:C222(<>aCAR_Locations; 0)
		//ARRAY TEXT($aContact;0)
		ALL RECORDS:C47([QA_Corrective_ActionsLocations:107])
		SELECTION TO ARRAY:C260([QA_Corrective_ActionsLocations:107]; <>aCAR_LocationsRec; [QA_Corrective_ActionsLocations:107]Location:1; <>aCAR_Locations)  //;[CorrectiveActionLocations]Contact1;$aContact)
		//For ($i;1;Size of array(◊aCAR_LocationsRec))
		//◊aCAR_Locations{$i}:=◊aCAR_Locations{$i}+"; "+$aContact{$i}
		//End for 
		//ARRAY TEXT($aContact;0)
		SORT ARRAY:C229(<>aCAR_Locations; <>aCAR_LocationsRec; >)
		$0:=Size of array:C274(<>aCAR_Locations)
		
	: ($1="size")
		ARRAY LONGINT:C221(<>aCAR_LocationsRec; $2)
		ARRAY TEXT:C222(<>aCAR_Locations; $2)
		$0:=Size of array:C274(<>aCAR_Locations)
		
	: ($1="set")
		If (Length:C16([QA_Corrective_Actions:105]Location:6)>0)
			$0:=Find in array:C230(<>aCAR_Locations; [QA_Corrective_Actions:105]Location:6)  //+"@")
			<>aCAR_Locations:=$0
			<>aCAR_LocationsRec:=$0
			If ($0>0)
				GOTO RECORD:C242([QA_Corrective_ActionsLocations:107]; <>aCAR_LocationsRec{$0})
			Else 
				REDUCE SELECTION:C351([QA_Corrective_ActionsLocations:107]; 0)
			End if 
			
		Else 
			REDUCE SELECTION:C351([QA_Corrective_ActionsLocations:107]; 0)
		End if 
		
	: ($1="sizeOf")
		$0:=Size of array:C274(<>aCAR_Locations)
		
	: ($1="update")
		ViewSetter(2; ->[QA_Corrective_ActionsLocations:107])
		
	: ($1="new")
		ViewSetter(1; ->[QA_Corrective_ActionsLocations:107])
		
End case 