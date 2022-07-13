//• 5/5/97 cs added code to print a bullet if this is a batch ink
//added code to print components of a batch ink
If (Form event code:C388=On Display Detail:K2:22)  //(LP) [Budgets]RMPickRpt
	Case of 
		: (fBatch)  //this is printing a batch ink
			QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Parent_Raw_Matl:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				uRelateSelect(->[Raw_Materials_Locations:25]Raw_Matl_Code:1; ->[Raw_Materials_Components:60]Compnt_Raw_Matl:2)
				
			Else 
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Raw_Materials_Locations:25])+" file. Please Wait...")
				ARRAY TEXT:C222($_Compnt_Raw_Matl; 0)
				DISTINCT VALUES:C339([Raw_Materials_Components:60]Compnt_Raw_Matl:2; $_Compnt_Raw_Matl)
				QUERY WITH ARRAY:C644([Raw_Materials_Locations:25]Raw_Matl_Code:1; $_Compnt_Raw_Matl)
				zwStatusMsg(""; "")
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19; >; [Raw_Materials_Locations:25]Location:2; >)
			sBullet:=""
			
		: ([Job_Forms_Materials:55]Raw_Matl_Code:7#"")  //printing a normal pick list
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
			ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19; >; [Raw_Materials_Locations:25]Location:2; >)
			If (Find in array:C230(aRmCode; [Job_Forms_Materials:55]Raw_Matl_Code:7)>0)  //• 5/5/97 cs 
				ADD TO SET:C119([Job_Forms_Materials:55]; "BatchInk")
				sBullet:="•"
			Else 
				sBullet:=""
			End if 
		Else 
			uClearSelection(->[Raw_Materials_Locations:25])
			sBullet:=""
	End case 
End if 
//EOLP