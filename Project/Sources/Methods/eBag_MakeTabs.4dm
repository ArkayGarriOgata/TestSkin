//%attributes = {"publishedWeb":true}
//PM: eBag_MakeTabs(jobform) -> 
//@author mlb - 5/30/02  10:12
// Modified by: Mel Bohince (6/9/21) use storage

C_LONGINT:C283(ieBagTabs)
C_REAL:C285($cc_found)

utl_ListReplace(->ieBagTabs; 0)

If (Length:C16($1)=8)
	USE SET:C118("machines")
	SELECTION TO ARRAY:C260([Job_Forms_Machines:43]; $aRecNo; [Job_Forms_Machines:43]Sequence:5; $aSeq; [Job_Forms_Machines:43]CostCenterID:4; $aCC)
	REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
	SORT ARRAY:C229($aSeq; $aCC; $aRecNo; >)
	APPEND TO LIST:C376(ieBagTabs; "Specs"; -1)
	For ($i; 1; Size of array:C274($aSeq))
		$aCC{$i}:=Replace string:C233($aCC{$i}; "!"; "")
		$desc:=""
		$cc_found:=CostCtrCurrent("Desc"; $aCC{$i}; ->$desc)
		//$desc:=aCostCtrDes{$cc}
		If ((Position:C15($aCC{$i}; <>EMBOSSERS)>0) | (Position:C15($aCC{$i}; <>STAMPERS)>0))
			GOTO RECORD:C242([Job_Forms_Machines:43]; $aRecNo{$i})
			$desc:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]CostCenterID:4)
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
				
				UNLOAD RECORD:C212([Job_Forms_Machines:43])
			Else 
				
				//you have goto record
				
			End if   // END 4D Professional Services : January 2019 
			
		End if 
		
		APPEND TO LIST:C376(ieBagTabs; String:C10($aSeq{$i}; "000")+"-"+$aCC{$i}+" "+Substring:C12($desc; 1; 6); $aRecNo{$i})
	End for 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
		
	Else 
		
		UNLOAD RECORD:C212([Job_Forms_Machines:43])
		
	End if   // END 4D Professional Services : January 2019 
	
	//APPEND TO LIST(ieBagTabs;"Items";-3)
	//APPEND TO LIST(ieBagTabs;"BOM";-4)
	
Else 
	APPEND TO LIST:C376(ieBagTabs; "Enter a Job Form number or scan a Job Transfer Bag"; 0)
End if 

//REDRAW LIST(ieBagTabs)
