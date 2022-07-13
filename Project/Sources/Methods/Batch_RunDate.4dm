//%attributes = {"publishedWeb":true}
//Method: Batch_RunDate(Get|Set;"name";->date;->timestamp) 022499  MLB
//manage the batch date records

C_TEXT:C284($1)
C_TEXT:C284($2)
C_POINTER:C301($3; $4; $5)
C_LONGINT:C283($0)

$0:=-20000

READ WRITE:C146([z_batch_run_dates:77])
QUERY:C277([z_batch_run_dates:77]; [z_batch_run_dates:77]BatchType:4=$2)
If (Records in selection:C76([z_batch_run_dates:77])=0)  //first time create it
	CREATE RECORD:C68([z_batch_run_dates:77])
	[z_batch_run_dates:77]BatchType:4:=$2
	SAVE RECORD:C53([z_batch_run_dates:77])
End if 

Case of 
	: (Not:C34(fLockNLoad(->[z_batch_run_dates:77]; "*")))  //cant get the lock
		$0:=-20001
		utl_Logfile("PS_Exchange_Data_with_Flex.Log"; $1+" locked")
		//BEEP
		
	: ($1="Mark")
		[z_batch_run_dates:77]LastMachTicProc:2:=TSTimeStamp  //set to ready
		[z_batch_run_dates:77]LastRun:1:=0  //mark as unsent
		[z_batch_run_dates:77]LastDate:3:=!00-00-00!
		$0:=[z_batch_run_dates:77]LastMachTicProc:2
		SAVE RECORD:C53([z_batch_run_dates:77])
		//utl_Logfile ("PS_Exchange_Data_with_Flex.Log";$1+" Prod Sched changed at "+TS2String ([z_batch_run_dates]LastMachTicProc))
		
	: ($1="Test")
		If ([z_batch_run_dates:77]LastMachTicProc:2>0)  //it was marked to send
			[z_batch_run_dates:77]LastRun:1:=TSTimeStamp
			[z_batch_run_dates:77]LastMachTicProc:2:=0  //mark as sent
			[z_batch_run_dates:77]LastDate:3:=4D_Current_date
			$0:=[z_batch_run_dates:77]LastRun:1
			SAVE RECORD:C53([z_batch_run_dates:77])
		Else 
			$0:=0
		End if 
		
	: ($1="Get")
		$3->:=[z_batch_run_dates:77]LastDate:3
		If (Count parameters:C259>=4)
			$4->:=[z_batch_run_dates:77]LastRun:1
		End if 
		If (Count parameters:C259>=5)
			$5->:=[z_batch_run_dates:77]LastMachTicProc:2
		End if 
		$0:=0
		
	: ($1="Set")
		[z_batch_run_dates:77]LastDate:3:=$3->
		If (Count parameters:C259>=4)
			[z_batch_run_dates:77]LastRun:1:=$4->
		End if 
		If (Count parameters:C259>=5)
			[z_batch_run_dates:77]LastMachTicProc:2:=$5->
		End if 
		SAVE RECORD:C53([z_batch_run_dates:77])
		$0:=0
		
	Else 
		BEEP:C151
		TRACE:C157
End case 
REDUCE SELECTION:C351([z_batch_run_dates:77]; 0)