//%attributes = {"publishedWeb":true}
//(P) uProcessLookup`assign arrays for process list
//• 6/12/97 cs allowed user to see palletts, allow only admin to see user proc

C_LONGINT:C283($i; $numTasks; $Pos; $state)
C_TEXT:C284($procName)
C_LONGINT:C283($t)

$procName:=""
$state:=0
$pidTime:=0

If (Count parameters:C259>0)
	$pid:=$1
	$hit:=Find in array:C230(<>aPrcsNum; $pid)
	If ($hit>-1)
		DELETE FROM ARRAY:C228(<>aPrcsNum; $hit; 1)
		DELETE FROM ARRAY:C228(<>aPrcsName; $hit; 1)
	End if 
	
Else 
	$numTasks:=Count tasks:C335
	ARRAY TEXT:C222(<>aPrcsName; $numTasks)
	//ARRAY TEXT(◊aPrcsStatus;$numTasks)
	ARRAY LONGINT:C221(<>aPrcsNum; $numTasks)
	$Pos:=0
	
	For ($i; 1; $numTasks)
		PROCESS PROPERTIES:C336($i; $procName; $state; $pidTime)
		Case of   //check special processes
			: ($state=-1)  //killed, skip
				$procName:=""
			: ($Procname="")
				//nothing
			: ($ProcName="•@") | ($ProcName="$•@")  //• 6/12/97 cs 
				$ProcName:=""  //Never show Bulletted processes
			: ($ProcName="$ReportManager")  //• 6/12/97 cs 
				$ProcName:=""  // Remove from list to view 
			: ($ProcName="$ProcessList")  //• 6/12/97 cs 
				$ProcName:=""  // Remove from list to view       
			: ($ProcName="Restore Log")  //• 6/12/97 cs 
				$ProcName:=""  // Remove from list to view   
			: ($ProcName="$Event Manager")  // no need to see this, skip"
				$procName:=""
			: ($ProcName="$StatusBar")  // no need to see this, skip"
				$procName:=""
			: ($ProcName="$numTasksestLocal")  // no need to see this, skip"
				$procName:=""
				
			: ($ProcName[[1]]="$")  // display pallete names `• 6/12/97 cs 
				$procName:=Replace string:C233($ProcName; "$"; "")  //• 6/12/97 cs 
			: ($ProcName="Cache Manager")  // no need to see this, skip
				$procName:=""
			: ($ProcName="Process PopUp")  // no need to see this, skip
				$procName:=""
			: ($ProcName="Apple Events Manager")  // no need to see this, skip
				$procName:=""
			: ($ProcName="User/Runtime process") & (Not:C34(User in group:C338(Current user:C182; "Administration")))  //• 6/12/97 cs 
				$ProcName:=""  // rename to something more meaningful 
		End case 
		
		If ($ProcName#"")
			$Pos:=$Pos+1
			If ($Pos<=Size of array:C274(<>aPrcsName))
				<>aPrcsName{$Pos}:=$ProcName
				<>aPrcsNum{$Pos}:=$i
			End if 
			
			//• 6/12/97 cs  removed below since I am no longer displaying this info
			//  ◊aPrcsStatus{$Pos}:=nProcessStatus ($State)
		End if 
		
	End for 
	ARRAY TEXT:C222(<>aPrcsName; $Pos)  //reduce to actual size
	ARRAY LONGINT:C221(<>aPrcsNum; $Pos)
End if 