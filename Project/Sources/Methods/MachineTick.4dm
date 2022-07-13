//%attributes = {"publishedWeb":true}
//Procedure: MachineTick()  120397  MLB
//create a data structure of machine tickets
//•011298  MLB  UPR 1914, scale down the cost by the portion of billings
//•052098  MLB   new method

C_TEXT:C284($1)
C_POINTER:C301($2)
C_LONGINT:C283($i; $numMT; $0)
C_REAL:C285($labor; $burden)
C_TEXT:C284($cr)

$cr:=Char:C90(13)

Case of 
	: ($1="init")
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
			//*   Load the MT's
			MESSAGE:C88(" Loading "+String:C10(Records in selection:C76([Job_Forms_Machine_Tickets:61]))+" Machine Tickets"+$cr)
			ARRAY TEXT:C222(aJF; 0)
			ARRAY TEXT:C222(aCC; 0)
			ARRAY REAL:C219(aMR; 0)
			ARRAY REAL:C219(aRun; 0)
			SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]JobForm:1; aJF; [Job_Forms_Machine_Tickets:61]CostCenterID:2; aCC; [Job_Forms_Machine_Tickets:61]MR_Act:6; aMR; [Job_Forms_Machine_Tickets:61]Run_Act:7; aRun)
			REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
			$numMT:=Size of array:C274(aJF)
			$0:=$numMT
			
		Else 
			$0:=0
		End if 
		
	: ($1="apply")  //•052098  MLB  new method
		MESSAGE:C88(" Allocating Sales & Contribution"+$cr)
		//*Allocate the cost of each MT to the job cost, segregate by plant
		$numMT:=Size of array:C274(aJF)
		For ($i; 1; $numMT)  //post the cost to either roan or haup in the job
			$labor:=(aMR{$i}+aRun{$i})*CostCtrCurrent("Labor"; aCC{$i})
			$burden:=(aMR{$i}+aRun{$i})*CostCtrCurrent("Burden"; aCC{$i})
			If (($labor+$burden)>0)  //tally to the job 
				Job_Form("cc"; aJF{$i}; Num:C11(aCC{$i}))
				If (Position:C15(aCC{$i}; <>ROANOKE_CCs)>0)  //Roanoke receives cost
					Job_Form("roanC"; aJF{$i}; $labor; $burden)
				Else   //Hauppauge receives cost
					Job_Form("haupC"; aJF{$i}; $labor; $burden)
				End if 
			End if 
		End for   //i           
		
	: ($1="kill")
		ARRAY TEXT:C222(aJF; 0)
		ARRAY TEXT:C222(aCC; 0)
		ARRAY REAL:C219(aMR; 0)
		ARRAY REAL:C219(aRun; 0)
		
	Else 
		BEEP:C151
		ALERT:C41($1+"Message not supported by MachineTick")
End case 