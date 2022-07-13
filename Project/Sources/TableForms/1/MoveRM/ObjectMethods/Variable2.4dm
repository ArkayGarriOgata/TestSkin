//(s) [contro]RmMove.bok
//• 1/27/98 cs setup reporting
//• 6/9/98 cs stop printing report
Case of 
	: (Find in array:C230(abullet; "√")<0)
		ALERT:C41("You Must select at least one Material to move")
		
	: (aSubGroup=0)  //no destination selected
		ALERT:C41("You Must select a Destination Subgroup")
		
	Else 
		NewWindow(200; 50; 0; -720)
		CU_MoveRmLocate
		//xTitle:="Materials moved between Subgroups"
		//xText:="Moved Materials:"+Char(13)+xText+"to New Comodity Key:"+Char
		//«(13)+String(iComm;"00")+"-"+aSubgroup{aSubgroup}
		//rPrintText 
		CU_SubGroupChng(aSubgroup{aSubgroup}; "*")  //second Param suppres deletion of RM_Group record
		RM_MoveClear  //clear 'From' areas
		ARRAY TEXT:C222(aSubgroup; 0)  //clear 'To' areas
		aSubGroup:=0
		iComm:=0
		i4:=0
		CLOSE WINDOW:C154
		xText:=""
End case 
//