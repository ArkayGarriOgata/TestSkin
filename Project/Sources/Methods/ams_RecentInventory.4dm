//%attributes = {"publishedWeb":true}
//PM: ams_RecentInventory(date) -> set name
//@author mlb - 7/1/02  10:05
//*Test inventory age by date glued
C_DATE:C307($cutOffDate; $1; $glueDate)
C_LONGINT:C283($i; $numFGL; $numJMI; $circa)
C_TEXT:C284($0)

$0:=""

READ ONLY:C145([Finished_Goods_Locations:35])

If (Count parameters:C259=1)
	$cutOffDate:=$1
	READ ONLY:C145([Finished_Goods_Locations:35])
	READ ONLY:C145([Job_Forms_Items:44])
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	
	uThermoInit($numFGL; "testing inventory age")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record with empty set
		ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33; >)
		//CREATE SET([FG_Locations];"allLocations")
		CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "recentGlueDate")
		$numFGL:=Records in selection:C76([Finished_Goods_Locations:35])
		For ($i; 1; $numFGL)
			$glueDate:=JMI_getGlueDate([Finished_Goods_Locations:35]Jobit:33; "use X")
			
			If ($glueDate=!00-00-00!)  //not sure, so keep if new job
				$circa:=Num:C11(Substring:C12([Finished_Goods_Locations:35]Jobit:33; 1; 5))
				If ($circa>85495)  //2007
					ADD TO SET:C119([Finished_Goods_Locations:35]; "recentGlueDate")
				End if 
			Else 
				If ($glueDate>=$cutOffDate)
					ADD TO SET:C119([Finished_Goods_Locations:35]; "recentGlueDate")
				End if 
			End if 
			
			NEXT RECORD:C51([Finished_Goods_Locations:35])
			uThermoUpdate($i)
		End for 
		
		
	Else 
		
		//Laghzaoui reduce add to set and next
		
		$numFGL:=Records in selection:C76([Finished_Goods_Locations:35])
		
		ARRAY TEXT:C222($_Jobit; 0)
		ARRAY LONGINT:C221($_record_number; 0)
		ARRAY LONGINT:C221($_record_final; 0)
		
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; $_Jobit; [Finished_Goods_Locations:35]; $_record_number)
		SORT ARRAY:C229($_Jobit; $_record_number; >)
		
		For ($i; 1; $numFGL; 1)
			$glueDate:=JMI_getGlueDate($_Jobit{$i}; "use X")
			If ($glueDate=!00-00-00!)  //not sure, so keep if new job
				$circa:=Num:C11(Substring:C12($_Jobit{$i}; 1; 5))
				If ($circa>85495)  //2007
					
					APPEND TO ARRAY:C911($_record_final; $_record_number{$i})
					
				End if 
			Else 
				If ($glueDate>=$cutOffDate)
					
					APPEND TO ARRAY:C911($_record_final; $_record_number{$i})
					
				End if 
			End if 
			
			
			uThermoUpdate($i)
		End for 
		
		CREATE SET FROM ARRAY:C641([Finished_Goods_Locations:35]; $_record_final; "recentGlueDate")
		
		
		
	End if   // END 4D Professional Services : January 2019 
	uThermoClose
	
	//DIFFERENCE("allLocations";"recentGlueDate";"recentGlueDate")
	//USE SET("recentGlueDate")
	$0:="recentGlueDate"
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	//CLEAR SET("allLocations")
Else 
	CLEAR SET:C117("recentGlueDate")
End if 
