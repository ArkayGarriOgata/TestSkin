QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
rOnHand:=0
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	While (Not:C34(End selection:C36([Raw_Materials_Locations:25])))
		rOnHand:=rOnHand+[Raw_Materials_Locations:25]QtyOH:9
		NEXT RECORD:C51([Raw_Materials_Locations:25])
	End while   //  Sum([RM_BINS]QtyOH)
	
Else 
	
	ARRAY REAL:C219($_QtyOH; 0)
	
	SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]QtyOH:9; $_QtyOH)
	
	For ($Iter; 1; Size of array:C274($_QtyOH); 1)
		rOnHand:=rOnHand+$_QtyOH{$Iter}
		
	End for 
	
End if   // END 4D Professional Services : January 2019 First record
