//%attributes = {}
//Method:  Prgr_0000_Explain
//Description:  This method will wrap some of the 4D Progress component
//. it is wrapped to help future proof and to create a best practices for the component
//. it will also show an example of how to use it

//Example of progress 

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($esTable; $eTable)
	C_OBJECT:C1216($oProgress)
	
	C_BOOLEAN:C305($bProgress)
	C_LONGINT:C283($nLoop; $nNumberOfLoops)
	
	$nNumberOfLoops:=500
	
	$oProgress:=New object:C1471()
	
End if   //Done Initialize

//****   FOR LOOP   ****

$oProgress.nProgressID:=Prgr_NewN
$oProgress.nNumberOfLoops:=$nNumberOfLoops
$oProgress.tTitle:="Window Title"

For ($nLoop; 1; $nNumberOfLoops)  // As long as progress is not stopped...
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		$oProgress.nLoop:=$nLoop
		$oProgress.tMessage:="Message at bottom"
		
		Prgr_Message($oProgress)
		
		DELAY PROCESS:C323(Current process:C322; 2)  //Do Code
		
	Else   //Progress canceled
		
		$nLoop:=$nNumberOfLoops+1  //Cancel loop
		
	End if   //Done progress
	
End for   // Final closing of progress bar (the Stop button itself does nothing)

Prgr_Quit($oProgress)

//****   DONE FOR LOOP   ****


//****   FOR EACH LOOP   ****

$bProgress:=True:C214
$nLoop:=0
$nNumberOfLoops:=$esTable.length

$oProgress.nProgressID:=Prgr_NewN
$oProgress.nNumberOfLoops:=$nNumberOfLoops
$oProgress.tTitle:="Window Title"

For each ($eTable; $esTable) While ($bProgress)
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		$oProgress.nLoop:=$nLoop+1
		$oProgress.tMessage:="Message at bottom"
		
		Prgr_Message($oProgress)
		
		DELAY PROCESS:C323(Current process:C322; 2)  //Do Code
		
	Else   //Progress canceled
		
		$bProgress:=False:C215  //Cancel loop
		
	End if   //Done progress
	
End for each 

Prgr_Quit($oProgress)

//****   DONE FOR EACH LOOP   ****
