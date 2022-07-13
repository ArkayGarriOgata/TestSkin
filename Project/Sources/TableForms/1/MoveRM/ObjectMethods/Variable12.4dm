//(s) aCommCode [comtrol]MoveRm
If (Self:C308->#0)
	iComm:=Num:C11(Substring:C12(Self:C308->{Self:C308->}; 1; 2))
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=iComm)
	
	If (Records in selection:C76([Raw_Materials_Groups:22])>0)
		MESSAGES OFF:C175
		
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]SubGroup:10#"")  //remove blanks from list
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
		
		DISTINCT VALUES:C339([Raw_Materials_Groups:22]SubGroup:10; aSubGroup)
		aSubgroup:=0  //clear any selected item
		MESSAGES ON:C181
	Else 
		ALERT:C41("Invalid Commodity Selection.")
		Self:C308->:=0
		aSubGroup:=0
		ARRAY TEXT:C222(aSubgroup; 0)
	End if 
End if 
//