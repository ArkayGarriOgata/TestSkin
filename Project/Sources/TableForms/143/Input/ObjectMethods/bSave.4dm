

If (sRecordStatus="New Note")
	[QA_Corrective_Actions_Notes:143]Note:5:="________________"+Char:C90(13)+String:C10(4D_Current_date; Internal date short:K1:7)+" @ "+String:C10(4d_Current_time; HH MM AM PM:K7:5)+" by "+Current user:C182+": "+tNote+Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38)+tHoldNoteField
Else 
	
	[QA_Corrective_Actions_Notes:143]Note:5:=tNote
	
End if 

SAVE RECORD:C53([QA_Corrective_Actions_Notes:143])
