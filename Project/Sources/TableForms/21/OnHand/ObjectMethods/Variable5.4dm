//Script: rOnHand()  
//•080996  MLB  use arrays
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	MESSAGES OFF:C175
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
	rOnHand:=0
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)
		ARRAY REAL:C219($aQty; 0)
		SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]QtyOH:9; $aQty)
		C_LONGINT:C283($i)
		For ($i; 1; Size of array:C274($aQty))
			rOnHand:=rOnHand+$aQty{$i}
		End for 
		ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19; >)
		FIRST RECORD:C50([Raw_Materials_Locations:25])
	End if 
	
	If (False:C215)
		FIRST RECORD:C50([Raw_Materials_Locations:25])
		While (Not:C34(End selection:C36([Raw_Materials_Locations:25])))
			rOnHand:=rOnHand+[Raw_Materials_Locations:25]QtyOH:9
			NEXT RECORD:C51([Raw_Materials_Locations:25])
		End while   //  Sum([RM_BINS]QtyOH)
	End if 
	MESSAGES ON:C181
	//
Else 
	
	//you don't neeed first record after order by
	MESSAGES OFF:C175
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
	rOnHand:=0
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)
		ARRAY REAL:C219($aQty; 0)
		SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]QtyOH:9; $aQty)
		C_LONGINT:C283($i)
		For ($i; 1; Size of array:C274($aQty))
			rOnHand:=rOnHand+$aQty{$i}
		End for 
		ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19; >)
	End if 
	
	MESSAGES ON:C181
	//
End if   // END 4D Professional Services : January 2019 First record
