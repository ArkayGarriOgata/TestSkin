//%attributes = {}
// Method: HPP_ErrorMsg () -> 
// ----------------------------------------------------
// by: mel: 01/18/05, 15:43:05
// ----------------------------------------------------
// Description:
// provide error message for given error code.
// uses most recent error set in unless there was a parameter
// ----------------------------------------------------

C_LONGINT:C283($1)
C_TEXT:C284($msg)

If (Count parameters:C259=1)
	hpp_errorCode:=$1  // redundant
End if 
$msg:=""
Case of   //decode HHP error message
	: (hpp_errorCode>=0)
		$msg:=""
	: (hpp_errorCode=-1)
		$msg:="unrecognized Host Command"
	: (hpp_errorCode=-2)
		$msg:="extraneous characters found after a valid Host Command"
	: (hpp_errorCode=-3)
		$msg:="the command is missing a left parenthesis"
	: (hpp_errorCode=-4)
		$msg:="the command is missing a right parenthesis"
	: (hpp_errorCode=-5)
		$msg:="the command is missing a string parameter"
	: (hpp_errorCode=-6)
		$msg:=" the command is missing a numeric parameter"
	: (hpp_errorCode=-7)
		$msg:="the command is missing a label descriptor for a parameter"
	: (hpp_errorCode=-8)
		$msg:="the command is missing a comma"
	: (hpp_errorCode=-9)
		$msg:="there is not enough memory available to run the command because the resident scr"+"ipt has depleted memory resources"
	: (hpp_errorCode=-10)
		$msg:=" the host routine name is not recognized"
	: (hpp_errorCode=-11)
		$msg:="the command contains an extraneous comma"
	: (hpp_errorCode=-200)
		$msg:="scanner ID is valid, but the scanner did not respond. Possibly due to out of ran"+"ge."
	: (hpp_errorCode=-201)
		$msg:="scanner ID is not valid"
	: (hpp_errorCode=-20001)
		$msg:="HHP_Connect failed before connecting to the serial port."
	: (hpp_errorCode=-20002)
		$msg:="HHP_Connect says "+hhp_scannerID+" is not responding."
	: (hpp_errorCode=-20003)
		$msg:="HHP_Get says "+hhp_scannerID+" expected, but other received."
	: (hpp_errorCode=-20004)
		$msg:="HHP_Send says Unexpected send request."
	: (hpp_errorCode=-20005)
		$msg:="HHP_Get says empty read."
	: (hpp_errorCode<0)
		$msg:="Unrecognized Error Code"
End case 

If (Length:C16($msg)>0)
	ALERT:C41(String:C10(hpp_errorCode)+" - "+$msg+Char:C90(13)+hpp_errorSource)
End if 
hpp_errorSource:=""