//%attributes = {}
//Method: COM_TimeOut()  091498  MLB

//based on John Moore's WaitTimedOut

C_BOOLEAN:C305($0)
C_LONGINT:C283($TicksToWait; $params)
C_LONGINT:C283(com_delay; $3; com_maxWait; $2; com_Counter; $1)

$params:=Count parameters:C259

utl_Trace

Case of 
	: ($params=1)  //reset
		com_Counter:=$1
		$0:=False:C215  //
		
	: ($params=3)  //set up
		com_Counter:=$1
		com_maxWait:=$2  //in seconds
		com_delay:=$3  //in ticks
		
		$0:=False:C215
		
	Else   //zero params 
		
		If (com_delay>0)
			DELAY PROCESS:C323(Current process:C322; com_delay)
			$TicksToWait:=com_maxWait*60
			com_Counter:=com_Counter+com_delay
			If (com_Counter>$TicksToWait)
				$0:=True:C214  //it's timed out
				com_Counter:=0  //reset counter
				
			Else 
				$0:=False:C215  //keep trying
				
			End if 
			
		Else 
			$0:=False:C215  //always return false with timeout of 0 (i.e., no timeout)
			
		End if 
End case 