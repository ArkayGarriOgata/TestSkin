If (Form event code:C388=On Load:K2:1)
	rbProd:=1
	If (<>Est2Zoom#"")
		sPONum:=<>Est2Zoom
		<>Est2Zoom:=""
		Est_pickDifferential
		
	Else 
		OBJECT SET ENABLED:C1123(bPick; False:C215)
		$yearDigit:=Substring:C12(String:C10(Year of:C25(Current date:C33)); 4; 1)  // Modified by: Mel Bohince (2/12/16) 
		sPONum:=$yearDigit+"-0000.00"
		ARRAY TEXT:C222(asBull; 0)
		ARRAY TEXT:C222(asDiff; 0)
		ARRAY TEXT:C222(asCaseID; 0)
		asDiff:=0
		asCaseID:=0
		asBull:=0
	End if   //coming direct from an estimate
	
End if   //on load