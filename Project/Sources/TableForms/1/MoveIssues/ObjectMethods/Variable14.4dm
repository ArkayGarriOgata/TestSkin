//(s) [contro]RmMove.bok
//• 1/27/98 cs setup reporting
//• 6/9/98 cs stop printing report
Case of 
	: (Size of array:C274(aBullet)=0)
		ALERT:C41("You need to enter a valid 'From' Jobform.")
	: (Find in array:C230(abullet; "√")<0)
		ALERT:C41("You Must select at least one Material to move")
	: (sJobform="")
		ALERT:C41("You need to enter a destination Jobform.")
	Else 
		uMsgWindow("Moving Issues "+Char:C90(13)+"from "+tsubgroup+" to "+sJobform)
		$Loc:=0
		
		Repeat 
			$Loc:=Find in array:C230(aBullet; "√"; $Loc+1)
			
			If ($Loc>0)
				GOTO RECORD:C242([Raw_Materials_Transactions:23]; aRmRecNo{$Loc})
				fLockNLoad(->[Raw_Materials_Transactions:23])
				[Raw_Materials_Transactions:23]JobForm:12:=sJobForm
				SAVE RECORD:C53([Raw_Materials_Transactions:23])
			End if 
		Until ($Loc<0)
		RM_MoveIssues("*")  //clear dialog
		CLOSE WINDOW:C154
End case 
GOTO OBJECT:C206(tsubgroup)
//