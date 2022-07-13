//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 03/28/07, 13:48:13
// ----------------------------------------------------
// Method: Job_beforeOnLoadModAct()  --> 
// Description
// preprocess somethings
// ----------------------------------------------------

C_TEXT:C284($1)
C_BOOLEAN:C305(serverMethodDone)

serverMethodDone:=False:C215

If (Length:C16($1)=8)
	READ WRITE:C146([Job_Forms_Items:44])
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$1)
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		DISTINCT VALUES:C339([Job_Forms_Items:44]ItemNumber:7; $aJobit)
		ARRAY LONGINT:C221($aMTqty; Size of array:C274($aJobit))
		
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; $aMTJobit; [Job_Forms_Machine_Tickets:61]Good_Units:8; $aGood)
		
		C_LONGINT:C283($i; $numElements)
		$numElements:=Size of array:C274($aJobit)
		
		For ($i; 1; $numElements)
			$aMTqty{$i}:=0
			For ($j; 1; Size of array:C274($aMTJobit))
				If ($aMTJobit{$j}=$aJobit{$i})
					$aMTqty{$i}:=$aMTqty{$i}+$aGood{$j}
				End if 
			End for 
		End for 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			FIRST RECORD:C50([Job_Forms_Items:44])
			
		Else 
			
			// see line 18
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		For ($i; 1; Records in selection:C76([Job_Forms_Items:44]))
			$hit:=Find in array:C230($aJobit; [Job_Forms_Items:44]ItemNumber:7)
			If ($hit>-1)
				[Job_Forms_Items:44]Qty_MachTicket:36:=$aMTqty{$hit}
				$aMTqty{$hit}:=0
			Else 
				[Job_Forms_Items:44]Qty_MachTicket:36:=0
			End if 
			SAVE RECORD:C53([Job_Forms_Items:44])
			NEXT RECORD:C51([Job_Forms_Items:44])
		End for 
		
	End if 
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	
End if 

serverMethodDone:=True:C214
Repeat   //waiting till client resets serverMethodDone
	DELAY PROCESS:C323(Current process:C322; 30)
	IDLE:C311
Until (Not:C34(serverMethodDone))