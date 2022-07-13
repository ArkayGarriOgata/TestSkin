//%attributes = {"publishedWeb":true}
//PM: Job_getPrevNextOperation(jobSeq;->allOp)  `;->nextOp) -> 
//@author mlb - 3/25/02  15:16

If (False:C215)  //• mlb - 7/31/02  10:12, store in JML instead
	CUT NAMED SELECTION:C334([Job_Forms_Machines:43]; "holdOps")
	
	C_TEXT:C284($1; $jobSeq; $jf)
	C_LONGINT:C283($seq; $this)
	$jobSeq:=$1
	$jf:=Substring:C12($jobSeq; 1; 8)
	$seq:=Num:C11(Substring:C12($jobSeq; 10))
	C_POINTER:C301($ptrAllOp; $2)  //;$ptrNextOp;$3)
	$ptrAllOp:=$2
	//$ptrNextOp:=$3
	
	READ ONLY:C145([Job_Forms_Machines:43])
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$jf)
	ARRAY INTEGER:C220($aSeq; 0)
	ARRAY TEXT:C222($aCC; 0)
	ARRAY REAL:C219($aQty; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Machines:43]Sequence:5; $aSeq; [Job_Forms_Machines:43]CostCenterID:4; $aCC; [Job_Forms_Machines:43]Actual_Qty:19; $aQty)
	REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
	SORT ARRAY:C229($aSeq; $aCC; >)
	If (True:C214)
		$operations:=""
		For ($i; 1; Size of array:C274($aCC))
			If ($aQty{$i}=0)
				$operations:=$operations+$aCC{$i}+" "
			Else 
				$operations:=$operations+$aCC{$i}+"*"
			End if 
		End for 
		$ptrAllOp->:=$operations
	Else 
		//$this:=Find in array($aSeq;$seq)
		//If ($this>1)
		//$ptrPrevOp->:=$aCC{$this-1}
		//End if 
		//If ($this<Size of array($aSeq))
		//$ptrNextOp->:=$aCC{$this+1}
		//End if 
	End if 
	
	$0:=Size of array:C274($aSeq)
	
	USE NAMED SELECTION:C332("holdOps")
	
Else 
	$0:=0
End if 