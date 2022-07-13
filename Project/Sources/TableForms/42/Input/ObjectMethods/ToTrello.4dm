// -------
// Method: [Job_Forms].Input.ToTrello   ( ) ->
// By: Mel Bohince @ 06/01/16, 16:46:53
// Description
// email job info to make a Trello card
// ----------------------------------------------------

READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
$telloEmail:=[zz_control:1]TrelloBoardEmailAddress:55
REDUCE SELECTION:C351([zz_control:1]; 0)

If (Length:C16($telloEmail)>0)
	//get the routing
	//QUERY([Job_Forms_Machines];[Job_Forms_Machines]JobForm=$aJobforms{$job})
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		COPY NAMED SELECTION:C331([Job_Forms_Machines:43]; "routing")
		
	Else 
		
		ARRAY LONGINT:C221($_routing; 0)
		LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Machines:43]; $_routing)
		
	End if   // END 4D Professional Services : January 2019 
	
	SELECTION TO ARRAY:C260([Job_Forms_Machines:43]; $aRecNo; [Job_Forms_Machines:43]CostCenterID:4; $cc; [Job_Forms_Machines:43]JobSequence:8; $route; [Job_Forms_Machines:43]Planned_Qty:10; $want)
	SORT ARRAY:C229($route; $cc; $want; $aRecNo; >)
	//REDUCE SELECTION([Job_Forms_Machines];0)
	$lengthRoute:=Size of array:C274($route)
	
	// Modified by: Mel Bohince (5/21/16) add mnemonic to assist if downstream is a slow operation
	$mnemonic:="-"
	$handLabor:=" 501 503 505 "
	For ($operation; 1; $lengthRoute)
		$budCC:=String:C10(Num:C11($cc{$operation}))
		Case of   //see uInit_CostCenterGroups
			: (Position:C15($budCC; <>SHEETERS)>0)
				$mnemonic:="B"  //replace the hyphen which meant sheeted stock
			: (Position:C15($budCC; <>PRESSES)>0)
				$mnemonic:=$mnemonic+"P"
			: (Position:C15($budCC; <>LAMINATERS)>0)
				$mnemonic:=$mnemonic+"L"
			: (Position:C15($budCC; <>STAMPERS)>0) | (Position:C15($budCC; <>EMBOSSERS)>0)
				GOTO RECORD:C242([Job_Forms_Machines:43]; $aRecNo{$operation})
				$desc:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]CostCenterID:4)  //see also CostCtr_Description_Tweak for emb v stamp
				If (Position:C15("Embossing"; $desc)>0)
					$mnemonic:=$mnemonic+"E"
				Else 
					$mnemonic:=$mnemonic+"S"
				End if 
				UNLOAD RECORD:C212([Job_Forms_Machines:43])
			: (Position:C15($budCC; <>BLANKERS)>0)
				$mnemonic:=$mnemonic+"D"
			: (Position:C15($budCC; $handLabor)>0)
				$mnemonic:=$mnemonic+"H"
			: (Position:C15($budCC; <>GLUERS)>0)
				$mnemonic:=$mnemonic+"G"
			Else 
				$mnemonic:=$mnemonic+"O"
		End case 
	End for 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("routing")
		CLEAR NAMED SELECTION:C333("routing")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Job_Forms_Machines:43]; $_routing)
		
	End if   // END 4D Professional Services : January 2019 
	
	$subject:=[Job_Forms:42]JobFormID:5+"- ["+$mnemonic+"]"
	
	If (Position:C15("E"; $mnemonic)>0)
		$subject:=$subject+" #EMBOSSES"
	End if 
	
	If (Position:C15("L"; $mnemonic)>0)
		$subject:=$subject+" #LAMINATES"
	End if 
	
	$body:=CUST_getName([Job_Forms:42]cust_id:82)+"'s "+[Job_Forms:42]CustomerLine:62+" "
	EMAIL_Sender($subject; ""; $body; $telloEmail)
	
Else 
	BEEP:C151
End if 