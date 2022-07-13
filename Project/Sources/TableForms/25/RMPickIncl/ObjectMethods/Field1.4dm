QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Parent_Raw_Matl:1=[Raw_Materials_Locations:25]Raw_Matl_Code:1)
If (Records in selection:C76([Raw_Materials_Components:60])>0)
	ORDER BY:C49([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Compnt_Raw_Matl:2; >)
End if 