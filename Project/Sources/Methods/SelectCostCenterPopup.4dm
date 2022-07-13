//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: SelectCostCenterPopup - Created `v1.0.0-PJK (12/21/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
//$1=Machine to use as a LIKE machine group

C_TEXT:C284($0; $1; $ttMachine; $ttMainRef; $ttMenuItem)

$ttMachine:=$1

If ($ttMachine="All")
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ProdCC:39=True:C214)
	ARRAY TEXT:C222($sttGroups; 0)
	DISTINCT VALUES:C339([Cost_Centers:27]cc_Group:2; $sttGroups)
	$ttMainRef:=Create menu:C408
	
	For ($i; 1; Size of array:C274($sttGroups))
		$ttGroup:=$sttGroups{$i}
		$xlSubMenu:=Create menu:C408
		
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ProdCC:39=True:C214)
		QUERY:C277([Cost_Centers:27];  & ; [Cost_Centers:27]cc_Group:2=$ttGroup)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
			
			ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]ID:1; >)
			For ($j; 1; Records in selection:C76([Cost_Centers:27]))
				GOTO SELECTED RECORD:C245([Cost_Centers:27]; $j)
				$ttMenuItem:=[Cost_Centers:27]ID:1+" - "+[Cost_Centers:27]Description:3
				APPEND MENU ITEM:C411($xlSubMenu; $ttMenuItem)
				SET MENU ITEM PARAMETER:C1004($xlSubMenu; -1; $ttMenuItem)
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_ID1; 0)
			ARRAY TEXT:C222($_Description1; 0)
			
			SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $_ID1; \
				[Cost_Centers:27]Description:3; $_Description1)
			
			SORT ARRAY:C229($_ID1; $_Description1; >)
			
			For ($j; 1; Size of array:C274($_ID1); 1)
				
				$ttMenuItem:=$_ID1{$j}+" - "+$_Description1{$j}
				
				APPEND MENU ITEM:C411($xlSubMenu; $ttMenuItem)
				SET MENU ITEM PARAMETER:C1004($xlSubMenu; -1; $ttMenuItem)
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		APPEND MENU ITEM:C411($ttMainRef; $ttGroup; $xlSubMenu)
		
	End for 
	
	
Else 
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$ttMachine)
	$ttGroup:=[Cost_Centers:27]cc_Group:2
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ProdCC:39=True:C214; *)
	QUERY:C277([Cost_Centers:27];  & ; [Cost_Centers:27]cc_Group:2=$ttGroup)
	$ttMainRef:=Create menu:C408
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
		
		For ($i; 1; Records in selection:C76([Cost_Centers:27]))
			GOTO SELECTED RECORD:C245([Cost_Centers:27]; $i)
			$ttMenuItem:=[Cost_Centers:27]ID:1+" - "+[Cost_Centers:27]Description:3
			APPEND MENU ITEM:C411($ttMainRef; $ttMenuItem)
			SET MENU ITEM PARAMETER:C1004($ttMainRef; -1; $ttMenuItem)
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_ID; 0)
		ARRAY TEXT:C222($_Description; 0)
		
		SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $_ID; \
			[Cost_Centers:27]Description:3; $_Description)
		
		For ($i; 1; Size of array:C274($_Description); 1)
			
			$ttMenuItem:=$_ID{$i}+" - "+$_Description{$i}
			APPEND MENU ITEM:C411($ttMainRef; $ttMenuItem)
			SET MENU ITEM PARAMETER:C1004($ttMainRef; -1; $ttMenuItem)
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

$ttMachine:=Dynamic pop up menu:C1006($ttMainRef)  //Use of menu
$ttMachineID:=GetNextField(->$ttMachine; " - ")

RELEASE MENU:C978($ttMainRef)



$0:=$ttMachineID