//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/25/07, 11:36:17
// ----------------------------------------------------
// Method: app_get_new_id
// Description:
// This won't work because of case insensitivity and even with semaphore it is not multi-user safe.
// ----------------------------------------------------

C_TEXT:C284($pKey; $1; $2)
C_TEXT:C284($pairs; $0; $tick)
C_LONGINT:C283(<>last_tickcount; $tickcount)
C_DATE:C307($date)
C_TEXT:C284($time)

Case of 
	: (Count parameters:C259=0)  //encode
		
		Repeat   //space this out
			$date:=4D_Current_date  //get server date/time; this is a problem if run in a local process
			$time:=String:C10(4d_Current_time)
			$date_time:=Char:C90(<>id_hash_table{(Year of:C25($date)-2000)})+Char:C90(<>id_hash_table{Month of:C24($date)})+Char:C90(<>id_hash_table{Day of:C23($date)})+Char:C90(<>id_hash_table{Num:C11($time[[1]]+$time[[2]])})+Char:C90(<>id_hash_table{Num:C11($time[[4]]+$time[[5]])})+Char:C90(<>id_hash_table{Num:C11($time[[7]]+$time[[8]])})
			$tickcount:=Tickcount:C458
			IDLE:C311
		Until ($tickcount#<>last_tickcount)
		
		//get the last 3 numbers
		$tick_str:=String:C10($tickcount)
		
		$tick:=String:C10(Num:C11(Substring:C12($tick_str; Length:C16($tick_str)-2)); "000")
		
		$pKey:=$date_time+<>SERVER_ID+$tick
		
		<>last_tickcount:=$tickcount
		
		$0:=$pKey
		
	: ($1="init")
		//use character 0-9, A-Z, a-x ascii value to represent 0 - 59, substituting 1 for 2 chars
		//then use a pair to find the index in the map and return the value representing the date/time
		ARRAY INTEGER:C220(<>id_hash_table; 59)
		<>last_tickcount:=Tickcount:C458
		
		$start:=0
		For ($num; $start; 9)
			<>id_hash_table{$num}:=$num+48  //Char(7+48) = "7"
		End for 
		
		$start:=$num
		For ($num; $start; ($start+25))
			<>id_hash_table{$num}:=$num+55  //Char(10+55) = "A"
		End for 
		
		$start:=$num
		For ($num; $start; ($start+23))
			<>id_hash_table{$num}:=$num+61  //Char(59+61) = "x"
		End for 
		
		<>SERVER_ID:="R"
		$0:="ready"
		
	: ($1="decode")
		//decode
		$pKey:=$2
		$pairs:=""
		For ($i; 1; Length:C16($pKey)-3)
			$index:=Find in array:C230(<>id_hash_table; Character code:C91($pKey[[$i]]))  //get a letters ascii value and use that to find the map index which was the orig value
			$pairs:=$pairs+String:C10($index; "00")
		End for 
		$server:=Char:C90(Num:C11($pKey[[7]]))
		$0:=Substring:C12($pairs; 3; 2)+"/"+Substring:C12($pairs; 5; 2)+"/"+Substring:C12($pairs; 1; 2)+"-"+Substring:C12($pairs; 7; 2)+":"+Substring:C12($pairs; 9; 2)+":"+Substring:C12($pairs; 11; 2)+"-"+$server+"-"+Char:C90(Num:C11($pKey[[8]]))+Char:C90(Num:C11($pKey[[9]]))
		
End case 