//%attributes = {}
// Method: HHP_Connect () -> 
// ----------------------------------------------------
// by: mel: 01/17/05, 15:13:48
// ----------------------------------------------------
// Description:
// open a socket on the serial port
// and construct data members
// ----------------------------------------------------

C_TEXT:C284(hhp_scannerID; $scanner; hpp_prompt; hpp_response; hpp_value; hpp_hostCommand; hpp_errorSource)  //global to this process
C_LONGINT:C283($0; hpp_errorCode; hpp_portSettings; hpp_window)  //return 0 if success

hhp_scannerID:=""
$scanner:=""
hpp_prompt:=""
hpp_hostCommand:=""
hpp_response:=""
hpp_value:=""
hpp_errorCode:=-20001  //pessimistic start
hpp_errorSource:="While opening serial port."
hpp_portSettings:=0
hpp_window:=NewWindow(400; 800; 2; 8; "Scan Log")

If (Count parameters:C259=0)  //open up the serial port
	hpp_portSettings:=Num:C11(Request:C163("Serial Port Setting:"; String:C10(MacOS serial port:K31:2+Speed 19200:K31:14+Data bits 8:K31:23+Parity none:K31:17+Protocol none:K31:16+Stop bits one:K31:24)))
	If (OK=1)
		If (hpp_portSettings#10)  //then we're working with the serial port
			SET CHANNEL:C77(hpp_portSettings)
		Else   //testing by writing to a file
			SET CHANNEL:C77(hpp_portSettings; "scanner.txt")
		End if 
		hhp_scannerID:="S"+"BASE"  //
		$errCode:=HPP_Send("scanners?")  //SBASE,2,4,B515,4,CAD8
		$scanner:=Request:C163("Scanner id:"; hpp_value)
		
		If (OK=1) & (Length:C16($scanner)>0)
			hhp_scannerID:="S"+$scanner
			$errCode:=HPP_Send("check")
			If ($errCode=0)
				hpp_errorCode:=0
			Else 
				hpp_errorSource:="While checking communication with scanner."
				hpp_errorCode:=-20002
			End if 
		End if 
	End if 
	
Else   //close
	SET CHANNEL:C77(11)
	CLOSE WINDOW:C154(hpp_window)
	hpp_errorCode:=0
End if 

$0:=hpp_errorCode