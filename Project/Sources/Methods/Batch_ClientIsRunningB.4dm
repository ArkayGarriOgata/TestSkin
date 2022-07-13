//%attributes = {}
//Method:  Batch_ClientIsRunningB=>bBatchClientIsRunning
//Description:  This method verifies if the batch client is logged into aMs
//  Switch this to use 

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($0; $bBatchClientIsRunning)
	
	ARRAY TEXT:C222($atClients; 0)
	ARRAY LONGINT:C221($anMethods; 0)
	
	$bBatchClientIsRunning:=False:C215
	
	$tBatchClient:="Administrator"
	
	GET REGISTERED CLIENTS:C650($atClients; $anMethods)
	
End if   //Done initialize

$bBatchClientIsRunning:=(Find in array:C230($atClients; $tBatchClient)#CoreknNoMatchFound)

$0:=$bBatchClientIsRunning

