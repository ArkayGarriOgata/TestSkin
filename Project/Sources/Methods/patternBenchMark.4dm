//%attributes = {}
// -------
// Method: patternBenchMark   ( ) ->
// By: Mel Bohince @ 02/07/19, 14:41:19
// Description
// 
// ----------------------------------------------------
$benchmark:=True:C214  //benchmark

If ($benchmark)
	$testComment:=Request:C163("Name of test:"; "4D-PS_change "+String:C10(<>modification4D_14_01_19); "Go"; "Go anyway")
	$startMillisec:=Milliseconds:C459  //benchmark
End if 

//do something
For (i; 1; 10000)
	If (True:C214)  //option 1
		
	Else   //option 2
		
	End if 
	IDLE:C311
End for 

If ($benchmark)
	$durationSec:=(Milliseconds:C459-$startMillisec)/1000  //benchmark
	utl_Logfile("benchmark.log"; Current method name:C684+": "+$testComment+" took "+String:C10($durationSec)+" seconds")
End if 