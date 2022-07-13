//(s) aCommCode [comtrol]MoveRm
If (aCommCode2#0)
	ARRAY TEXT:C222(aText; 0)
	ARRAY TEXT:C222(aBullet; Size of array:C274(aText))
	iComm:=Num:C11(Substring:C12(aCommCode2{aCommCode2}; 1; 2))
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=iComm)
	//QUERY([RM_GROUP]; & ;[RM_GROUP]SubGroup # "")  `remove blanks from list
	If (Records in selection:C76([Raw_Materials_Groups:22])>0)
		xTitle:=aCommCode2{aCommCode2}
		MESSAGES OFF:C175
		DISTINCT VALUES:C339([Raw_Materials_Groups:22]SubGroup:10; aText)
		SORT ARRAY:C229(aText; >)
		ARRAY TEXT:C222(aBullet; Size of array:C274(aText))
		MESSAGES ON:C181
	Else 
		ALERT:C41("Invalid Commodity Selection.")
		aCommCode2:=0
		aText:=0
		xTitle:="Use Popup->"
		//MoveRMClear 
	End if 
End if 
//