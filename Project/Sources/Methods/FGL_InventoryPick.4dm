//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/10/07, 14:50:35
// ----------------------------------------------------
// Method: FGL_InventoryPick({release number | 0})  --> 
// Description
// display inventory by oldest first with certain locations 
// given higher priority
// `sort by glue dates, and shelf with fx and bh at the bottom
// ----------------------------------------------------
// Modified by: Mel Bohince (4/11/17) try to limit shipping from fg-ship'd only, repealled the next day
// ----------------------------------------------------
C_LONGINT:C283($0; $1; $i; $hit; $numLocations)
C_TEXT:C284($for_Customer)
ARRAY TEXT:C222(aCustid; 0)
ARRAY TEXT:C222(aJobit; 0)
ARRAY TEXT:C222(aLocation; 0)
ARRAY LONGINT:C221(aQty; 0)
ARRAY LONGINT:C221($aShelf; 0)
ARRAY DATE:C224(aGlued; 0)
ARRAY LONGINT:C221($aPriority; 0)
ARRAY LONGINT:C221(aRecNo; 0)
ARRAY TEXT:C222(aCPN; 0)
ARRAY TEXT:C222(aPallet; 0)

$numLocations:=0

If (Count parameters:C259=1)
	If ($1>0)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=$1)
	Else 
		REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
		$numLocations:=0
	End if 
End if 

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	$for_Customer:=[Customers_ReleaseSchedules:46]CustID:12
	
	READ ONLY:C145([Job_Forms_Items:44])
	READ ONLY:C145([Finished_Goods_Locations:35])
	
	If (Not:C34(<>Rama_Palette_Entry))  //in-house
		
		If (User in group:C338(Current user:C182; "ShipFromAnywhere"))  // Modified by: Mel Bohince (4/11/17) //this allows me to retreat
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]QtyOH:9>0; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2#"FG:AV@")  //not on consignment
			
		Else 
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:V_SHIP@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="FG:R_SHIP@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="FG:OS@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]QtyOH:9>0)
			
		End if 
		
	Else   //obsolete
		zwStatusMsg("WARNING"; "Restrict access because Rama palette is open")
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]QtyOH:9>0; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]skid_number:43#"000@"; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:AV=@")
	End if 
	
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]; aRecNo; [Finished_Goods_Locations:35]CustID:16; aCustid; [Finished_Goods_Locations:35]Jobit:33; aJobit; [Finished_Goods_Locations:35]Location:2; aLocation; [Finished_Goods_Locations:35]QtyOH:9; aQty; [Finished_Goods_Locations:35]Tier:39; $aShelf; [Finished_Goods_Locations:35]ProductCode:1; aCPN; [Finished_Goods_Locations:35]skid_number:43; aPallet)
		$numLocations:=Size of array:C274(aCustid)
		//sort by glue dates, and shelf 
		
		SORT ARRAY:C229(aJobit; aCustid; aLocation; aQty; aRecNo; $aShelf; aCPN; aPallet; >)
		ARRAY DATE:C224(aGlued; $numLocations)
		READ WRITE:C146([Finished_Goods_Locations:35])  //going to test for locked record
		SET QUERY LIMIT:C395(1)
		For ($i; 1; $numLocations)
			$hit:=qryJMI(aJobit{$i})
			If ($hit>0)
				aGlued{$i}:=[Job_Forms_Items:44]Glued:33
			Else 
				aGlued{$i}:=!00-00-00!
			End if 
			
			If (aCustid{$i}=$for_Customer)
				aCustid{$i}:=" √ "
			End if 
			
			GOTO RECORD:C242([Finished_Goods_Locations:35]; aRecNo{$i})
			If (Not:C34(fLockNLoad(->[Finished_Goods_Locations:35])))
				aLocation{$i}:=Substring:C12("LOCKED"+aLocation{$i}; 1; 30)
			End if 
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
				
				UNLOAD RECORD:C212([Finished_Goods_Locations:35])
				
			Else 
				
				// you have goto record on line 88
				
			End if   // END 4D Professional Services : January 2019 
			
		End for 
		
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
		Else 
			UNLOAD RECORD:C212([Finished_Goods_Locations:35])
		End if   // END 4D Professional Services : January 2019 
		
		READ ONLY:C145([Finished_Goods_Locations:35])
		SET QUERY LIMIT:C395(0)
		MULTI SORT ARRAY:C718(aGlued; >; aJobit; >; $aShelf; >; aLocation; >; aQty; >; aCustid; aRecNo; aCPN; aPallet)
		
		//prioritize locations by "Type"  with fx and bh at the bottom
		ARRAY LONGINT:C221($aPriority; $numLocations)
		$priority:=1
		For ($i; 1; $numLocations)
			Case of 
				: (Position:C15("CC"; aLocation{$i})>0)
					$aPriority{$i}:=100+$priority
					
				: (Position:C15("XC"; aLocation{$i})>0)
					$aPriority{$i}:=200+$priority
					
				: (Position:C15("EX"; aLocation{$i})>0)
					$aPriority{$i}:=300+$priority
					
				: (Position:C15("FX"; aLocation{$i})>0)
					$aPriority{$i}:=500+$priority
					
				: (Position:C15("BH"; aLocation{$i})>0)
					$aPriority{$i}:=1000+$priority
					
				Else   //hopefully FG
					$aPriority{$i}:=$priority
			End case 
			$priority:=$priority+1
		End for 
		SORT ARRAY:C229($aPriority; aGlued; aJobit; aCustid; aLocation; aQty; $aShelf; aRecNo; aCPN; aPallet; >)
		
	End if 
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
End if 
$0:=$numLocations