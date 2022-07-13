//%attributes = {"publishedWeb":true}
//util_SetSaver("save"|"restore";tablenumber;setname)->1= success

C_TEXT:C284($1; $3)
C_LONGINT:C283($2; $4; $0)
util_deleteDocument("tempSetDocument")
$0:=0  //fail closed

Case of 
	: ($1="save")
		SAVE SET:C184($3; "tempSetDocument")
		If (ok=1)
			CREATE RECORD:C68([x_saved_sets:127])
			[x_saved_sets:127]TableNumber:1:=$2
			[x_saved_sets:127]tsTimeStamp:2:=TSTimeStamp
			[x_saved_sets:127]SetName:3:=$3
			DOCUMENT TO BLOB:C525("tempSetDocument"; [x_saved_sets:127]TheSetBlob:4)
			If (ok=0)
				EMAIL_Sender("util_SetSaver"; ""; "Regenerate FIFO, blob save failure"; "mel.bohince@arkay.com")
			End if 
			SAVE RECORD:C53([x_saved_sets:127])
			REDUCE SELECTION:C351([x_saved_sets:127]; 0)
			
		Else 
			BEEP:C151
			EMAIL_Sender("util_SetSaver"; ""; "Regenerate FIFO, save set failure"; "mel.bohince@arkay.com")
		End if 
		$0:=ok
		
	: ($1="restore")
		$tablePtr:=Table:C252($2)
		READ WRITE:C146([x_saved_sets:127])
		QUERY:C277([x_saved_sets:127]; [x_saved_sets:127]TableNumber:1=$2; *)
		QUERY:C277([x_saved_sets:127];  & ; [x_saved_sets:127]SetName:3=$3)
		If (Records in selection:C76([x_saved_sets:127])>0)
			BLOB TO DOCUMENT:C526("tempSetDocument"; [x_saved_sets:127]TheSetBlob:4)
			If (ok=0)
				EMAIL_Sender("util_SetSaver"; ""; "Regenerate FIFO, blob restore failure"; "mel.bohince@arkay.com")
			End if 
			
			LOAD SET:C185($tablePtr->; $3; "tempSetDocument")
			If (ok=0)
				EMAIL_Sender("util_SetSaver"; ""; "Regenerate FIFO, set restore failure"; "mel.bohince@arkay.com")
			End if 
			
			USE SET:C118($3)
			
			If (Count parameters:C259>3)
				DELETE RECORD:C58([x_saved_sets:127])
				REDUCE SELECTION:C351([x_saved_sets:127]; 0)
			Else 
				REDUCE SELECTION:C351([x_saved_sets:127]; 0)
			End if 
			$0:=ok
			
		Else 
			CREATE EMPTY SET:C140($tablePtr->; $3)
			USE SET:C118($3)
		End if 
		
End case 

util_deleteDocument("tempSetDocument")