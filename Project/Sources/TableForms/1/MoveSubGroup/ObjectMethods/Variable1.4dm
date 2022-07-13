//(s) aCommCode [comtrol]MoveRm
If (aCommCode#0)
	tSubgroup:=""
	i4:=Num:C11(Substring:C12(aCommCode{aCommCode}; 1; 2))
	MESSAGES OFF:C175
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=i4; *)
	QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]SubGroup:10#"")
	If (Records in selection:C76([Raw_Materials_Groups:22])>0)
		DISTINCT VALUES:C339([Raw_Materials_Groups:22]SubGroup:10; axText)
		GOTO OBJECT:C206(tSubgroup)
		
	Else 
		ALERT:C41("Invalid Commodity Selection.")
		aCommCode:=0
		axText:=0
		ARRAY TEXT:C222(axText; 0)
	End if 
	MESSAGES ON:C181
End if 
//