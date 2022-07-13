//OM: aToFind() -> 
//@author mlb - 2/20/02  09:48
If (aToFind#0)
	If (Position:C15(aToFind{aToFind}; [Purchase_Orders_Chg_Orders:13]ChgOrdDesc:7)=0)
		If (Length:C16([Purchase_Orders_Chg_Orders:13]ChgOrdDesc:7)>0)
			[Purchase_Orders_Chg_Orders:13]ChgOrdDesc:7:=[Purchase_Orders_Chg_Orders:13]ChgOrdDesc:7+"; "
		End if 
		[Purchase_Orders_Chg_Orders:13]ChgOrdDesc:7:=[Purchase_Orders_Chg_Orders:13]ChgOrdDesc:7+aToFind{aToFind}
	Else 
		BEEP:C151
	End if 
End if 