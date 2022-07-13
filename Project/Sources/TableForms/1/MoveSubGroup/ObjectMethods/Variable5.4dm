//(s) [user]preference'iminutes
Case of 
	: (tsubgroup="")
		ALERT:C41("You MUST enter a Subgroup to which any selected subgroups are to be moved.")
		GOTO OBJECT:C206(tsubgroup)
		REJECT:C38
		
	: (Find in array:C230(aBullet; "√")=-1)
		ALERT:C41("You must select at least one Subgroup to move From.")
		REJECT:C38
		
	Else   //doit
		NewWindow(200; 50; 0; -720)
		CU_LocateSubgrp  //locate records and create sets(named the file name) of those found records
		//xTitle:="Material Subgroup moves"
		//xText:="Moved all materials From subgroup(s):"+Char(13)+xText+Char
		//«(13)+"To subgroup:"+String(iComm;"00")+"_"+tSubgroup
		//rPrintText 
		CU_SubGroupChng(tSubGroup; String:C10(i4))
		CLOSE WINDOW:C154
		BEEP:C151
		xTitle:="Use Popup->"
		tSubGroup:=""
		i4:=0
		$Loc:=Find in array:C230(aBullet; "√")
		While ($Loc>-1)
			aBullet{$Loc}:=""
			$Loc:=Find in array:C230(aBullet; "√"; $Loc+1)
		End while 
		
End case 

//