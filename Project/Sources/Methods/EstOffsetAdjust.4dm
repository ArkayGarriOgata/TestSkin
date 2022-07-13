//%attributes = {"publishedWeb":true}
//(f) EstOffsetAdjust
//Reset the estimate offset to correspond to the start of the year
//called from beforeEst
//• 1/9/98 cs created
//•010499  MLB  repaired, change to function

C_TEXT:C284($prefix; $optionChar)
C_TEXT:C284($revision)
C_TEXT:C284($estid; $0)  //•010499  MLB  constrain to 9 char as in 1-3456.89
C_LONGINT:C283($year)

$revision:=".00"
$estid:="-15000"  //pesimistic   6*2547.01

//*Load the files ID sequence record
READ WRITE:C146([x_id_numbers:3])
QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=fileNum)

//*Create Id record if required
If (Records in selection:C76([x_id_numbers:3])#1)
	CREATE RECORD:C68([x_id_numbers:3])  //lock not required
	[x_id_numbers:3]Table_Number:1:=fileNum
	SAVE RECORD:C53([x_id_numbers:3])  //keep, the lock try not to let two folk create a new est id rec
	//*    create sequencer
	[x_id_numbers:3]ID_No:2:=Num:C11(Request:C163("Please enter starting Estimate ID number: "; "1"))
	//*    create prefix
	$prefix:=String:C10(Year of:C25(4D_Current_date)-1990)
	$prefix:=$prefix[[Length:C16($prefix)]]  //get the last character, every ten years duplicates will occur
	[x_id_numbers:3]Prefix:4:=Substring:C12(Request:C163("Please enter a Estimate prefix character:"; $prefix); 1; 1)
	[x_id_numbers:3]Usage:5:="ESTIMATE"
	[x_id_numbers:3]ServerDesignation:7:=<>SERVER_DESIGNATION
	$year:=Year of:C25(4D_Current_date)  //this years end
	[x_id_numbers:3]EffectiveThru:6:=Date:C102("12/31/"+String:C10($year))  //last day of the year
	SAVE RECORD:C53([x_id_numbers:3])
End if 

//*Make sure id record is loaded and locked
If (fLockNLoad(->[x_id_numbers:3]))
	
	//*Test if sequencer should be rolled over `•010499  MLB 
	If (4D_Current_date>[x_id_numbers:3]EffectiveThru:6)
		//*    roll prefix
		$prefix:=String:C10(Year of:C25(4D_Current_date)-1990)
		[x_id_numbers:3]Prefix:4:=$prefix[[Length:C16($prefix)]]  //get the last character, every ten years duplicates will occur
		
		[x_id_numbers:3]ID_No:2:=1  // rolled over counter
		
		If ([x_id_numbers:3]EffectiveThru:6#!00-00-00!)
			$year:=Year of:C25([x_id_numbers:3]EffectiveThru:6)+1  // rolled over year
		Else 
			$year:=Year of:C25(4D_Current_date)  //this years end
		End if 
		[x_id_numbers:3]EffectiveThru:6:=Date:C102("12/31/"+String:C10($year))  //last day of the year
		
		SAVE RECORD:C53([x_id_numbers:3])
	End if 
	$optionChar:=[x_id_numbers:3]ServerDesignation:7  //"-"  `delimit yr from seq
	$estid:=[x_id_numbers:3]Prefix:4+$optionChar+String:C10([x_id_numbers:3]ID_No:2; "0000")+$revision  //*Return next ID sequence
	[x_id_numbers:3]ID_No:2:=[x_id_numbers:3]ID_No:2+1  //*Update Counter
	SAVE RECORD:C53([x_id_numbers:3])
	
Else   //*  if locked and not waited for, return -1
	BEEP:C151
	ALERT:C41("Next ID_NUMBER process stopped by user")
	CANCEL:C270
	$estid:="-15001"
End if   //locked

REDUCE SELECTION:C351([x_id_numbers:3]; 0)  //*Unload the sequence record
READ ONLY:C145([x_id_numbers:3])
$0:=$estid