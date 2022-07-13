//(s) i4 [control]moveRm
If (Find in array:C230(aCommCode; String:C10(Self:C308->; "00")+"@")>-1)
	MESSAGES OFF:C175
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=i4; *)
	QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]SubGroup:10#"")
	If (Records in selection:C76([Raw_Materials_Groups:22])>0)
		DISTINCT VALUES:C339([Raw_Materials_Groups:22]SubGroup:10; axText)
		RM_MoveSubgroup("F")
		GOTO OBJECT:C206(tSubgroup)
		
	Else 
		ALERT:C41("Invalid Commodity Number.")
		i4:=0
		axText:=0
		ARRAY TEXT:C222(axText; 0)
		RM_MoveClear
		GOTO OBJECT:C206(i4)
	End if 
	MESSAGES ON:C181
End if 
//