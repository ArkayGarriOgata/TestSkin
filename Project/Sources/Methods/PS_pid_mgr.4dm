//%attributes = {}
// Method: PS_pid_mgr () -> 
// ---------------------------
// by: mel: 06/16/04, 14:49:00
// ---------------------------
// Modified by: Mel Bohince (6/3/21) use Storage cache

C_LONGINT:C283($numCC; $index; $3; $0)
C_TEXT:C284($1; $2)

$0:=0

If (Count parameters:C259>=2)
	$index:=Find in array:C230(<>psCC; $2)
End if 

Case of 
	: ($index=-1)  //invalid cost center
		$0:=-1
		
	: ($1="index")
		$0:=$index
		
	: ($1="pid")
		$0:=<>psPID{$index}
		
	: ($1="setpid")
		<>psPID{$index}:=$3
		$0:=<>psPID{$index}
		
	: ($1="win")
		$0:=<>psWIN{$index}
		
	: ($1="setwin")
		<>psWIN{$index}:=$3
		$0:=<>psWIN{$index}
		
	: ($1="callpid")
		For ($index; 1; Size of array:C274(<>psPID))
			POST OUTSIDE CALL:C329(<>psPID{$index})
		End for 
		$0:=Size of array:C274(<>psPID)
		
	: ($1="init")
		
		If (True:C214)
			// Modified by: Mel Bohince (6/3/21) use Storage cache
			$numCC:=CostCtrBuildPidArrays(".")  //all should have period in the group, e.g. 80.FINISHING 
			
		Else   //old way
			ARRAY TEXT:C222(<>psCC; 0)  //key, such as C/C's id "412"
			ARRAY LONGINT:C221(<>psPID; 0)  //storage for process IDs
			ARRAY LONGINT:C221(<>psWIN; 0)  //storage for window references
			ARRAY TEXT:C222(<>psDESC; 0)  //storage for the desc = menu item text
			
			CostCtrCurrent("init"; "00/00/00")
			COPY ARRAY:C226(aStdCC; <>psCC)
			ARRAY TEXT:C222(<>psDESC; Size of array:C274(aCostCtrDes))
			For ($i; 1; Size of array:C274(aCostCtrDes))
				<>psDESC{$i}:=Substring:C12(aCostCtrDes{$i}; 1; 50)
			End for 
			
		End if   //new way
		
		APPEND TO ARRAY:C911(<>psCC; "9xx")
		APPEND TO ARRAY:C911(<>psCC; "All")
		APPEND TO ARRAY:C911(<>psCC; "D/C")
		APPEND TO ARRAY:C911(<>psCC; "AllGluers")
		
		APPEND TO ARRAY:C911(<>psDESC; "Outside Service")
		APPEND TO ARRAY:C911(<>psDESC; "All Presses")
		APPEND TO ARRAY:C911(<>psDESC; "All Die Cutters")
		APPEND TO ARRAY:C911(<>psDESC; "All Gluers")
		
		$numCC:=Size of array:C274(<>psCC)
		ARRAY LONGINT:C221(<>psPID; $numCC)
		ARRAY LONGINT:C221(<>psWIN; $numCC)
		
		If (False:C215)  // Modified by: Mel Bohince (1/16/20) 
			$numCC:=Size of array:C274(<>psCC)+3
			SORT ARRAY:C229(<>psCC; <>psDESC; >)
			
			ARRAY TEXT:C222(<>psCC; $numCC)
			<>psCC{$numCC-2}:="9xx"  //for outside gluers
			<>psCC{$numCC-1}:="All"  // for the all presses
			<>psCC{$numCC}:="D/C"  //for the all Die Cutters
			
			ARRAY LONGINT:C221(<>psPID; $numCC)
			ARRAY LONGINT:C221(<>psWIN; $numCC)
			ARRAY TEXT:C222(<>psDESC; $numCC)
		End if 
		
	Else   //find by description
		$index:=Find in array:C230(<>psDESC; $1)
		If ($index>-1)
			$0:=Num:C11(<>psCC{$index})
		End if 
End case 