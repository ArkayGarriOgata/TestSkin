//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceTestControlNumber() -> 
//@author mlb - 6/28/02  12:51

//report any fg which isn't carrying the latest control#
READ ONLY:C145([Finished_Goods_Specifications:98])
READ ONLY:C145([Finished_Goods:26])

ALL RECORDS:C47([Finished_Goods_Specifications:98])
$numFGS:=Records in selection:C76([Finished_Goods_Specifications:98])
ORDER BY:C49([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1; >; [Finished_Goods_Specifications:98]ControlNumber:2; <)
uThermoInit($numFGS; "Testing Control Numbers")
$lastCPN:=""
//Ps 4d Laghzaoui i have change the position the ligne 7 what was CREATE EMPTY SET([Finished_Goods];"oldControlNum") to ligne 16
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	CREATE EMPTY SET:C140([Finished_Goods:26]; "oldControlNum")
	
	For ($i; 1; $numFGS)
		If ([Finished_Goods_Specifications:98]FG_Key:1#$lastCPN)
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Finished_Goods_Specifications:98]FG_Key:1)
			If ([Finished_Goods:26]ControlNumber:61#[Finished_Goods_Specifications:98]ControlNumber:2)
				ADD TO SET:C119([Finished_Goods:26]; "oldControlNum")
			End if 
			$lastCPN:=[Finished_Goods_Specifications:98]FG_Key:1
		End if 
		NEXT RECORD:C51([Finished_Goods_Specifications:98])
		uThermoUpdate($i)
	End for 
	uThermoClose
	
Else 
	//laghzaoui remove next and query and add
	
	ARRAY TEXT:C222($_FG_Key; 0)
	ARRAY TEXT:C222($_ControlNumber; 0)
	ARRAY TEXT:C222($_FG_KEY1; 0)
	ARRAY TEXT:C222($_ControlNumber1; 0)
	ARRAY LONGINT:C221($_records_numbers; 0)
	ARRAY LONGINT:C221($_oldControlNum; 0)
	
	GET FIELD RELATION:C920([Finished_Goods_Specifications:98]FG_Key:1; $lienAller; $lienRetour)
	SET FIELD RELATION:C919([Finished_Goods_Specifications:98]FG_Key:1; Automatic:K51:4; Do not modify:K51:1)
	
	SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]FG_Key:1; $_FG_Key; \
		[Finished_Goods_Specifications:98]ControlNumber:2; $_ControlNumber; \
		[Finished_Goods:26]FG_KEY:47; $_FG_KEY1; \
		[Finished_Goods:26]ControlNumber:61; $_ControlNumber1; \
		[Finished_Goods:26]; $_records_numbers)
	
	SET FIELD RELATION:C919([Finished_Goods_Specifications:98]FG_Key:1; $lienAller; $lienRetour)
	
	For ($i; 1; $numFGS; 1)
		If ($_FG_Key{$i}#$lastCPN)
			If ($_ControlNumber{$i}#$_ControlNumber1{$i})
				
				APPEND TO ARRAY:C911($_oldControlNum; $_records_numbers{$i})
				
			End if 
			$lastCPN:=$_FG_Key{$i}
		End if 
		
		uThermoUpdate($i)
	End for 
	uThermoClose
	CREATE SET FROM ARRAY:C641([Finished_Goods:26]; $_oldControlNum; "oldControlNum")
	
End if   // END 4D Professional Services : January 2019 

CONFIRM:C162("Restrict to those on the Press Schedule?"; "Restrict"; "All")
If (OK=0)
	USE SET:C118("oldControlNum")
	CLEAR SET:C117("oldControlNum")
Else 
	$printingSchd:=PS_qryPrintingOnly
	SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $aJobSeq)
	ARRAY TEXT:C222($aJF; $printingSchd)
	$job:=0
	For ($i; 1; $printingSchd)
		$jf:=Substring:C12($aJobSeq{$i}; 1; 8)
		$hit:=Find in array:C230($aJF; $jf)
		If ($hit=-1)
			$job:=$job+1
			$aJF{$job}:=$jf
		End if 
	End for 
	ARRAY TEXT:C222($aJF; $job)
	
	QUERY WITH ARRAY:C644([Job_Forms_Items:44]JobForm:1; $aJF)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		util_outerJoin(->[Finished_Goods:26]ProductCode:1; ->[Job_Forms_Items:44]ProductCode:3)
		CREATE SET:C116([Finished_Goods:26]; "schedForPrint")
		
		
	Else 
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
		RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Finished_Goods:26])
		zwStatusMsg(""; "")
		CREATE SET:C116([Finished_Goods:26]; "schedForPrint")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
		
		INTERSECTION:C121("oldControlNum"; "schedForPrint"; "trouble")
		USE SET:C118("trouble")
		CLEAR SET:C117("trouble")
		CLEAR SET:C117("oldControlNum")
		CLEAR SET:C117("schedForPrint")
		
	Else 
		//reduce one set
		
		INTERSECTION:C121("oldControlNum"; "schedForPrint"; "oldControlNum")
		USE SET:C118("oldControlNum")
		CLEAR SET:C117("oldControlNum")
		CLEAR SET:C117("schedForPrint")
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 