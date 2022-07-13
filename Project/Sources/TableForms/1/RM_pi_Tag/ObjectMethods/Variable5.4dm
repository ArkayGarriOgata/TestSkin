Case of 
	: (sCriterion3="r")
		sCriterion3:="Roanoke"
	: (sCriterion3="v")
		sCriterion3:="Vista"
	: (sCriterion3="h")
		sCriterion3:="Hauppauge"
End case 

Case of 
	: (sCriterion3="Roanoke")
		tText:="2"
	: (sCriterion3="Vista")
		tText:="2"
	: (sCriterion3="Hauppauge")
		tText:="1"
End case 

If (sVerifyLocation(Self:C308))
	If (Records in selection:C76([Raw_Materials_Locations:25])>1)  //already found by POitem script
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Location:2=sCriterion3)
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
	End if 
	
	Case of 
		: (Records in selection:C76([Raw_Materials_Locations:25])=0)
			//it will be created during post
			
		: (fLockNLoad(->[Raw_Materials_Locations:25]))
			If (Length:C16(tText)=0)
				tText:=[Raw_Materials_Locations:25]CompanyID:27
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41("Bin record is in use. Try again later.")
			//sCriterion3:=""
			rReal1:=0
			GOTO OBJECT:C206(sCriterion3)
	End case 
	
End if   //loaction validation
//