//%attributes = {}
//Method:  Core_Time_DelayUntilR (hStartAt)=>nTicksToDelay
//Description:  This method will return ticks to wait till hStartAt

If (True:C214)  //Initialize 
	
	C_TIME:C306($1; $hStartAt)
	
	C_REAL:C285($0; $rTicksToDelay)
	
	C_REAL:C285($rkTicksMaxDelay)
	
	C_LONGINT:C283($nDelayHours)
	C_LONGINT:C283($nDelayMinutes; $nDelaySeconds)
	
	C_TIME:C306($hCurrentTime; $hDelay)
	
	C_LONGINT:C283($nNumberOfParameters)
	$nNumberOfParameters:=Count parameters:C259
	
	$hStartAt:=$1
	
	$hCurrentTime:=Current time:C178(*)
	
	$rTicksToDelay:=0
	$rkTicksMaxDelay:=79999999
	
End if   //Done Initialize

If ($hStartAt>$hCurrentTime)  //Valid start at
	
	$hDelay:=($hStartAt-$hCurrentTime)
	
	$nDelayHours:=($hDelay\3600)
	$nDelayMinutes:=(($hDelay\60)%60)
	$nDelaySeconds:=($hDelay%60)
	
	$rTicksToDelay:=\
		$nDelayHours*(60*60*60)+\
		$nDelayMinutes*(60*60)+\
		$nDelaySeconds*60
	
End if   //Done valid start at

If ($rTicksToDelay>$rkTicksMaxDelay)
	
	$rTicksToDelay:=$rkTicksMaxDelay
	
End if 

$0:=$rTicksToDelay
