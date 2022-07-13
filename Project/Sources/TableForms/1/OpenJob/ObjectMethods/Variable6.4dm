//(s) [control]openjob.bPick 
//• 4/23/97 cs found that I get an error if there is no estimate entered and 
//the neter key is hit
If (Size of array:C274(asBull)>0)  //• 4/23/97 cs 
	$i:=Find in array:C230(asBull; "•")
	If ($i=-1)
		ALERT:C41("You must select a differential.")
		REJECT:C38
	Else 
		ACCEPT:C269
	End if 
Else   //• 4/23/97 cs  
	ALERT:C41("You must select an Estimate on which to base a new Job.")
	REJECT:C38
End if 