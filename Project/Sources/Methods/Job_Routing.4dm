//%attributes = {}
//  // -------
//  // Method: Job_Routing   ( msg ; jobform{seq}) -> text
//  // By: Mel Bohince @ 07/28/16, 15:29:49
//  // Description
//  // refactor from job_wip_kanban, get the budgeted routing of a job
//  // ----------------------------------------------------
//C_TEXT($0;$1;$2)

//Case of 
//: ($1="init")
//  //get the routing
//QUERY([Job_Forms_Machines];[Job_Forms_Machines]JobForm=$2)
//SELECTION TO ARRAY([Job_Forms_Machines];$aRecNo;[Job_Forms_Machines]CostCenterID;$cc;[Job_Forms_Machines]JobSequence;$route;[Job_Forms_Machines]Planned_Qty;$want)
//SORT ARRAY($route;$cc;$want;$aRecNo;>)
//REDUCE SELECTION([Job_Forms_Machines];0)
//$lengthRoute:=Size of array($route)

//  // Modified by: Mel Bohince (5/21/16) add mnemonic to assist if downstream is a slow operation
//$mnemonic:="-"
//$handLabor:=" 501 503 505 "
//For ($operation;1;$lengthRoute)
//$budCC:=String(Num($cc{$operation}))
//Case of   //see uInit_CostCenterGroups
//: (Position($budCC;<>SHEETERS)>0)
//$mnemonic:="B"  //replace the hyphen which meant sheeted stock
//: (Position($budCC;<>PRESSES)>0)
//$mnemonic:=$mnemonic+"P"
//: (Position($budCC;<>LAMINATERS)>0)
//$mnemonic:=$mnemonic+"L"
//: (Position($budCC;<>STAMPERS)>0) | (Position($budCC;<>EMBOSSERS)>0)
//GOTO RECORD([Job_Forms_Machines];$aRecNo{$operation})
//$desc:=CostCtr_Description_Tweak (->[Job_Forms_Machines]CostCenterID)  //see also CostCtr_Description_Tweak for emb v stamp
//If (Position("Embossing";$desc)>0)
//$mnemonic:=$mnemonic+"E"
//Else 
//$mnemonic:=$mnemonic+"S"
//End if 
//UNLOAD RECORD([Job_Forms_Machines])
//: (Position($budCC;<>BLANKERS)>0)
//$mnemonic:=$mnemonic+"D"
//: (Position($budCC;$handLabor)>0)
//$mnemonic:=$mnemonic+"H"
//: (Position($budCC;<>GLUERS)>0)
//$mnemonic:=$mnemonic+"G"
//Else 
//$mnemonic:=$mnemonic+"O"
//End case 
//End for 
//$0:=$mnemonic

//: ($1="nextCC")
//$hit:=Find in array($route;$mtJseq{$seq})  //how far did we get and 
//If ($hit>-1)  //whew, this is normal, 
//If ($hit<$lengthRoute)  //looks like there will be another sequence,  and where are they going
//  //what happens next in the route?
//If ($isComplete>0)  //move qty to next seq
//$next:=$hit+1
//$nextCC:=Replace string($cc{$next};"!";"")  //ignore the unbudgeted additons
//If ($nextCC="SFM")  //ignore semi finished good extractions
//$next:=$next+1
//$nextCC:=Replace string($cc{$next};"!";"")
//End if 

//Else   //seq not complete so leave qty at this seq
//$nextCC:=$mtCC{$seq}
//End if 

//If ((Position($nextCC;<>EMBOSSERS)>0) | (Position($nextCC;<>STAMPERS)>0))  // ugly little test to see if this is stamping or embossing
//GOTO RECORD([Job_Forms_Machines];$aRecNo{$hit+1})
//$desc:=CostCtr_Description_Tweak (->[Job_Forms_Machines]CostCenterID)  //see also CostCtr_Description_Tweak for emb v stamp
//If (Position("Embossing";$desc)>0)
//$nextCC:="552"
//End if 
//UNLOAD RECORD([Job_Forms_Machines])
//End if 

//Else   //last operation still happening
//$nextCC:=$cc{$hit}  //, or gone to outside service
//End if   //less than the end of the route

//$0:=$nextCC

//: ($1="nextSeq")


//End case 
