//%attributes = {"publishedWeb":true}
//PM: RM_MillProduction() -> 
//@author mlb - 7/9/02  11:34

C_TEXT:C284($1)
C_LONGINT:C283($2)
C_TEXT:C284($3)
C_DATE:C307($4)

If (Count parameters:C259=0)
	$id:=New process:C317("RM_MillProduction"; <>lMinMemPart; "RM_MillProduction"; ""; 0; ""; !00-00-00!)
	If (False:C215)
		RM_MillProduction
	End if 
	
Else 
	READ ONLY:C145([Purchase_Orders_Items:12])
	READ ONLY:C145([Purchase_Orders:11])
	READ ONLY:C145([Raw_Materials_Groups:22])
	READ ONLY:C145([Vendors:7])
	READ WRITE:C146([Raw_Materials_Locations:25])
	READ WRITE:C146([Raw_Materials_Transactions:23])
	
	REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
	REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
	REDUCE SELECTION:C351([Vendors:7]; 0)
	REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
	REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
	REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
	
	If (Length:C16($1)=0)  //show ui, no poitem given
		$winRef:=Open form window:C675([zz_control:1]; "RMboardAtMill"; 8)
		DIALOG:C40([zz_control:1]; "RMboardAtMill")
		CLOSE WINDOW:C154($winRef)
		REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
		REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
		REDUCE SELECTION:C351([Vendors:7]; 0)
		REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
		REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
		REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
		
	Else 
		If (RM_MillProductionLookup(sCriterion2))
			RM_MillProductionPost
		End if 
	End if 
End if 