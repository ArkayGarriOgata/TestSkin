C_TEXT:C284($tMsg)

$tMsg:="Are you sure this has been reported to customer?"+Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38)
$tMsg:=$tMsg+"Once clicked you cannot change the date."

uConfirm($tMsg; "Today's Date"; "Cancel")

If (oK=1)
	[QA_Corrective_Actions:105]DateReported:22:=4D_Current_date
	SAVE RECORD:C53([QA_Corrective_Actions:105])
End if 

//••••••••••eop••••••••••