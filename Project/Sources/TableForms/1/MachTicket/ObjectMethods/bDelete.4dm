C_LONGINT:C283($del)  //(S)bOK: [MACH_ACT_JOB]'MachTicket

If ((Size of array:C274(adMADate)>0) & (adMADate>0))
	uConfirm(" Delete selected machine ticket entry?"; "Delete"; "Cancel")
	If (OK=1)
		$del:=adMADate
		DELETE FROM ARRAY:C228(adMADate; $del; 1)
		DELETE FROM ARRAY:C228(asMAJob; $del; 1)
		DELETE FROM ARRAY:C228(aiMASeq; $del; 1)
		DELETE FROM ARRAY:C228(asMACC; $del; 1)
		DELETE FROM ARRAY:C228(aiMAItemNo; $del; 1)
		DELETE FROM ARRAY:C228(arMAMRHours; $del; 1)
		DELETE FROM ARRAY:C228(arMARHours; $del; 1)
		DELETE FROM ARRAY:C228(arMADTHours; $del; 1)
		DELETE FROM ARRAY:C228(asMADTCat; $del; 1)
		DELETE FROM ARRAY:C228(alMAGood; $del; 1)
		DELETE FROM ARRAY:C228(alMAWaste; $del; 1)
		DELETE FROM ARRAY:C228(asP_C; $del; 1)
		DELETE FROM ARRAY:C228(aiShift; $del; 1)
		DELETE FROM ARRAY:C228(aMRcode; $del; 1)
		i:=i-1
		gClearMT
		//If (Size of array(adMADate)>0)
		gMTsetArrays
		k:=0
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		If (Size of array:C274(adMADate)=0)
			OBJECT SET ENABLED:C1123(bOK; False:C215)
			OBJECT SET ENABLED:C1123(bOKStay; False:C215)
		End if 
	End if 
Else 
	BEEP:C151
End if 