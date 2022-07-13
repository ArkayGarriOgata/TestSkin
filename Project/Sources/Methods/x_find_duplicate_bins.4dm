//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/26/09, 14:55:44
// ----------------------------------------------------
// Method: x_find_duplicate_bins
// Description
// look for bin records of the same jobit and location
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (10/23/13) update for rama reasons
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location#"FG:AV@")  //not rama or transit
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33; >; [Finished_Goods_Locations:35]Location:2; >; [Finished_Goods_Locations:35]skid_number:43; >)
	
	C_LONGINT:C283($i; $numRecs)
	$numRecs:=Records in selection:C76([Finished_Goods_Locations:35])
	$i:=0
	$lastJobit:=""
	$lastBin:=""
	$lastRecNo:=0
	$lastPallet:=""  // Modified by: Mel Bohince (10/23/13) update for rama reasons
	ARRAY LONGINT:C221($aQty; 0)
	ARRAY TEXT:C222($aJobit; 0)
	ARRAY TEXT:C222($aBin; 0)
	CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "dupes")
	uThermoInit($numRecs; "Updating Records")
	While (Not:C34(End selection:C36([Finished_Goods_Locations:35])))
		If ([Finished_Goods_Locations:35]Jobit:33=$lastJobit)
			If ([Finished_Goods_Locations:35]Location:2=$lastBin)
				If ([Finished_Goods_Locations:35]skid_number:43=$lastPallet)  // Modified by: Mel Bohince (10/23/13) update for rama reasons
					ADD TO SET:C119([Finished_Goods_Locations:35]; "dupes")
					APPEND TO ARRAY:C911($aJobit; [Finished_Goods_Locations:35]Jobit:33)
					APPEND TO ARRAY:C911($aBin; [Finished_Goods_Locations:35]Location:2)
					APPEND TO ARRAY:C911($aQty; [Finished_Goods_Locations:35]QtyOH:9)
				Else 
					$lastPallet:=[Finished_Goods_Locations:35]skid_number:43
				End if 
			Else 
				$lastBin:=[Finished_Goods_Locations:35]Location:2
			End if 
			
		Else 
			$lastJobit:=[Finished_Goods_Locations:35]Jobit:33
			$lastBin:=[Finished_Goods_Locations:35]Location:2
		End if 
		
		
		//SAVE RECORD([Finished_Goods_Locations])
		NEXT RECORD:C51([Finished_Goods_Locations:35])
		uThermoUpdate($i)
		$i:=$i+1
	End while 
	uThermoClose
	
	
	USE SET:C118("dupes")
	DELETE SELECTION:C66([Finished_Goods_Locations:35])
	CLEAR SET:C117("dupes")
	
	CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "updates")
	For ($i; 1; Size of array:C274($aJobit))
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$aJobit{$i}; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2=$aBin{$i})
		If (Records in selection:C76([Finished_Goods_Locations:35])>0)
			ADD TO SET:C119([Finished_Goods_Locations:35]; "updates")
			[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+$aQty{$i}
			SAVE RECORD:C53([Finished_Goods_Locations:35])
		End if 
	End for 
	
	USE SET:C118("updates")
	CLEAR SET:C117("updates")
	
	
	
Else 
	
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	
	C_LONGINT:C283($i; $numRecs)
	$numRecs:=Records in selection:C76([Finished_Goods_Locations:35])
	$i:=0
	$lastJobit:=""
	$lastBin:=""
	$lastRecNo:=0
	$lastPallet:=""  // Modified by: Mel Bohince (10/23/13) update for rama reasons
	ARRAY LONGINT:C221($aQty; 0)
	ARRAY TEXT:C222($aJobit; 0)
	ARRAY TEXT:C222($aBin; 0)
	
	ARRAY TEXT:C222($_Jobit; 0)
	ARRAY TEXT:C222($_Location; 0)
	ARRAY TEXT:C222($_pallet_id; 0)
	ARRAY LONGINT:C221($_QtyOH; 0)
	ARRAY LONGINT:C221($_record_number_Finale; 0)
	ARRAY LONGINT:C221($_record_number; 0)
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; $_Jobit; \
		[Finished_Goods_Locations:35]Location:2; $_Location; \
		[Finished_Goods_Locations:35]skid_number:43; $_pallet_id; \
		[Finished_Goods_Locations:35]QtyOH:9; $_QtyOH; \
		[Finished_Goods_Locations:35]; $_record_number)
	
	//correct bug last release 03-28-2019
	MULTI SORT ARRAY:C718($_Jobit; >; $_Location; >; $_pallet_id; >; $_QtyOH; $_record_number; >)
	
	uThermoInit($numRecs; "Updating Records")
	
	For ($i; 1; Size of array:C274($_Jobit); 1)
		
		If ($_Jobit{$i}=$lastJobit)
			If ($_Location{$i}=$lastBin)
				If ($_pallet_id{$i}=$lastPallet)
					
					APPEND TO ARRAY:C911($_record_number_Finale; $_record_number{$i})
					APPEND TO ARRAY:C911($aJobit; $_Jobit{$i})
					APPEND TO ARRAY:C911($aBin; $_Location{$i})
					APPEND TO ARRAY:C911($aQty; $_QtyOH{$i})
					
				Else 
					
					$lastPallet:=$_pallet_id{$i}
					
				End if 
			Else 
				
				$lastBin:=$_Location{$i}
				
			End if 
			
		Else 
			$lastJobit:=$_Jobit{$i}
			$lastBin:=$_Location{$i}
		End if 
		uThermoUpdate($i)
		
	End for 
	
	uThermoClose
	
	CREATE SELECTION FROM ARRAY:C640([Finished_Goods_Locations:35]; $_record_number_Finale)
	DELETE SELECTION:C66([Finished_Goods_Locations:35])
	
	QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]Jobit:33; $aJobit)
	QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Locations:35]Location:2; $aBin)
	ARRAY LONGINT:C221($_record_number_Finale; 0)
	
	C_LONGINT:C283($Position; $Positon1)
	C_TEXT:C284($Jobit; $Location)
	
	While (Not:C34(End selection:C36([Finished_Goods_Locations:35])))
		
		$Jobit:=[Finished_Goods_Locations:35]Jobit:33
		$Location:=[Finished_Goods_Locations:35]Location:2
		$Position:=Find in array:C230($aJobit; $Jobit)
		$Positon1:=Find in array:C230($aBin; $Location)
		
		If (($Positon1=$Position) & ($Positon1>0))
			
			[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+$aQty{$Positon1}
			SAVE RECORD:C53([Finished_Goods_Locations:35])
			APPEND TO ARRAY:C911($_record_number_Finale; Record number:C243([Finished_Goods_Locations:35]))
			
		End if 
		
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End while 
	
	CREATE SELECTION FROM ARRAY:C640([Finished_Goods_Locations:35]; $_record_number_Finale)
	
	
End if   // END 4D Professional Services : January 2019 
