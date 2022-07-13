//%attributes = {"publishedWeb":true}
//zwStatusTherm 101499 mlb

C_TEXT:C284($1; $2)
C_LONGINT:C283($3)
C_TIME:C306(ThermoElapse)
//utl_Trace 
//If (Count parameters>=1)
//While (Semaphore("$isStatusBuzy"))
//IDLE
//DELAY PROCESS(Current process;10)
//End while 

//If (True)  ` (◊PLATFORM=Macintosh 68K)
Case of 
	: ($1="update")
		<>Thermometer:=Int:C8(($3/<>ThemoMax)*100)
		//◊Thermometer:=◊Thermometer+$ThemoIncrement
		<>Status1:="Please Wait..."
		<>Status2:=" "+(String:C10(<>ThemoMax)+":"+<>ThemoWhat)
		<>StatusPage:=0
		POST OUTSIDE CALL:C329(<>StatusBar)
		
	: ($1="init")
		zCursorMgr("beachBallOff")
		zCursorMgr("watch")
		<>ThemoMax:=$3
		<>Thermometer:=0
		<>ThemoWhat:=$2
		<>Status1:="Please Wait..."
		<>Status2:=" "+(String:C10(<>ThemoMax)+":"+<>ThemoWhat)
		<>StatusPage:=2
		ThermoElapse:=Current time:C178
		SHOW PROCESS:C325(<>StatusBar)  //•020298  MLB 
		POST OUTSIDE CALL:C329(<>StatusBar)
		
	: ($1="close")
		ThermoElapse:=Current time:C178-ThermoElapse
		<>Thermometer:=0
		<>ThemoIncrement:=0
		<>StatusPage:=1
		<>Status1:="Finished "+String:C10(ThermoElapse; HH MM SS:K7:1)
		<>Status2:=<>ThemoWhat
		<>ThemoWhat:=""
		POST OUTSIDE CALL:C329(<>StatusBar)
		zCursorMgr("restore")
End case 