//%attributes = {}
// -------
// Method: Que_test   ( ) ->
// By: Mel Bohince @ 06/08/17, 11:13:07
// Description
// 
// ----------------------------------------------------
// /// DRIVER, copy to 0test and run
//$when:=TSTimeStamp +10
//Que_AddToQueue ($when;"Que_test";"client";"repeat")

//$when:=$when+60
//For (i;1;10)
//Que_AddToQueue ($when;"Que_test";"client";String(i))
//uConfirm ("quit?";"Yes";"No")
//If (ok=1)
//i:=i+10
//Else 
//$when:=$when+60
//End if 
//End for 
// ?? 
//ALERT(TS2String (TSTimeStamp ))
utl_Logfile("que_scheduler"; "Que_test ran")

If (Count parameters:C259=1)
	uConfirm("Do "+$1+" again?"; "Yes"; "No")
	If (ok=1)
		$nextRun:=TSTimeStamp+(63*1)
		Que_AddToQueue($nextRun; "Que_test"; "client"; $1)
		//ALERT("next set to "+TS2String ($nextRun))
	End if 
	
End if 
