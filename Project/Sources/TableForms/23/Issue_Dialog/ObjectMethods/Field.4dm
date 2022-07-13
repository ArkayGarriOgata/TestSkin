tText:=""
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Raw_Materials_Transactions:23]JobForm:12)
If (Records in selection:C76([Job_Forms:42])=0)
	tText:=[Raw_Materials_Transactions:23]JobForm:12+" was not found."
	uConfirm(tText; "Ok"; "Help")
	[Raw_Materials_Transactions:23]JobForm:12:=""
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]JobForm:12)
	
Else 
	<>jobform:=[Raw_Materials_Transactions:23]JobForm:12
	If (sMsg#"eBag")
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Job_Forms:42]JobFormID:5)
		SELECTION TO ARRAY:C260([Job_Forms_Machines:43]Sequence:5; $aSeq; [Job_Forms_Machines:43]CostCenterID:4; $aCC)
		$msg:="Sequences: "+Char:C90(13)
		C_LONGINT:C283($i)
		For ($i; 1; Size of array:C274($aSeq))
			$msg:=$msg+String:C10($aSeq{$i}; "000")+":"+$aCC{$i}+Char:C90(13)  //", "
		End for 
		//zwStatusMsg ("HINT";$msg)
		tText:=$msg
	End if 
End if 
