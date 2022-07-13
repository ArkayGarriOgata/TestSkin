//$msg:="Shift Card "+"FIND--"+String(dDateBegin;Internal date short special)+","+String(dDateEnd;Internal date short special)+",'"+sOperator+"',"+String(cb1)+String(cb2)+String(cb3)+","+cost_center+String(rb0)+String(rb1)+String(rb2)+String(rb3)+String(rb4)
//utl_LogfileServer (<>zResp;$msg)
// Modified by: Garri Ogata (10/27/17)  added "472" to gluers

If (dDateBegin=!00-00-00!)
	dDateBegin:=Current date:C33
	dDateEnd:=dDateBegin
End if 

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dDateBegin; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dDateEnd)
	
	Case of   //wanting a perticular shift
		: (Length:C16(sOperator)>0)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Operator:27=sOperator)
			
		: (cb1=1) & (cb2=1) & (cb3=1)
			//don't subquery
			
		: (cb1=1) & (cb2=1) & (cb3=0)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=1; *)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]Shift:18=2)
			
		: (cb1=0) & (cb2=1) & (cb3=1)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=2; *)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]Shift:18=3)
			
		: (cb1=1) & (cb2=0) & (cb3=1)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=1; *)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]Shift:18=3)
			
		: (cb1=1)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=1)
			
		: (cb2=1)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=2)
			
		: (cb3=1)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=3)
			
	End case 
	
Else 
	
	Case of   //wanting a perticular shift
			
		: (Length:C16(sOperator)>0)
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Operator:27=sOperator; *)
			
		: (cb1=1) & (cb2=1) & (cb3=1)
			//don't subquery
			
		: (cb1=1) & (cb2=1) & (cb3=0)
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=1; *)
			QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]Shift:18=2; *)
			
		: (cb1=0) & (cb2=1) & (cb3=1)
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=2; *)
			QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]Shift:18=3; *)
			
		: (cb1=1) & (cb2=0) & (cb3=1)
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=1; *)
			QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]Shift:18=3; *)
			
		: (cb1=1)
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=1; *)
			
		: (cb2=1)
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=2; *)
			
		: (cb3=1)
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Shift:18=3; *)
	End case 
	
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dDateBegin; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dDateEnd)
	
	
End if   // END 4D Professional Services : January 2019 query selection

If (Length:C16(cost_center)>0)  //something entered
	If (Position:C15(cost_center; <>PRESSES)=0)
		If (Length:C16(cost_center)=3)  //specific rather than no subquery
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=cost_center)
		End if 
		
	Else 
		QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=cost_center; *)
		QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=("5"+Substring:C12(cost_center; 2; 2)))  //cold foil press designation
	End if 
	
Else   //find by group
	
	$cnt_of_presses:=0  // Modified by: Mel Bohince (3/18/17)
	
	Case of 
		: (rb0=1)  // Modified by: Mel Bohince (3/18/17) 
			//cost_center was set to 429 by radio button
			$press_ids:=txt_Trim(<>SHEETERS)  //load all presses in an array for a build query below
			$cnt_of_presses:=Num:C11(util_TextParser(16; $press_ids; Character code:C91(" "); 13))
			
		: (rb1=1)
			$press_ids:=txt_Trim(<>PRESSES)  //load all presses in an array for a build query below
			$cnt_of_presses:=Num:C11(util_TextParser(16; $press_ids; Character code:C91(" "); 13))
			
		: (rb2=1)
			$press_ids:=txt_Trim(<>STAMPERS+" "+<>EMBOSSERS)  //load all presses in an array for a build query below
			$cnt_of_presses:=Num:C11(util_TextParser(16; $press_ids; Character code:C91(" "); 13))
			
		: (rb3=1)
			$press_ids:=txt_Trim(<>BLANKERS)  //load all presses in an array for a build query below
			$cnt_of_presses:=Num:C11(util_TextParser(16; $press_ids; Character code:C91(" "); 13))
			
		: (rb4=1)
			$press_ids:=txt_Trim(<>GLUERS)  //load all presses in an array for a build query below
			$press_ids:=$press_ids+CorektSpace+"472"  // Modified by: Garri Ogata (10/27/17) 
			$cnt_of_presses:=Num:C11(util_TextParser(16; $press_ids; Character code:C91(" "); 13))
			
		Else   // Modified by: Mel Bohince (3/18/17) 
			$cnt_of_presses:=0  //dont search with an empty array
	End case 
	
	//$msg:=Change string("    ";<>zResp;1)+" - "+"Shift Card "+"  Find by group '"+String($cnt_of_presses)+"'"
	//$pid:=Execute on server("utl_Logfile";0;"rpc:utl_Logfile";"wiretap.log";$msg)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		If ($cnt_of_presses>0)  // Modified by: Mel Bohince (3/18/17) 
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=util_TextParser(1); *)
			For ($press; 2; $cnt_of_presses)
				QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=util_TextParser($press); *)
			End for 
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61])
		End if 
		
	Else 
		
		
		If ($cnt_of_presses>0)  // Modified by: Mel Bohince (3/18/17) 
			ARRAY TEXT:C222($_CostCenterID; $cnt_of_presses)
			For ($press; 1; $cnt_of_presses)
				$_CostCenterID{$press}:=util_TextParser($press)
			End for 
			QUERY SELECTION WITH ARRAY:C1050([Job_Forms_Machine_Tickets:61]CostCenterID:2; $_CostCenterID)
			
		End if 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if   //by cc or group

ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16; >)

//$msg:=Change string("    ";<>zResp;1)+" - "+"Shift Card "+"END--Sorted and displayed recs: "+String(Records in selection([Job_Forms_Machine_Tickets]))
//$pid:=Execute on server("utl_Logfile";0;"rpc:utl_Logfile";"wiretap.log";$msg)

