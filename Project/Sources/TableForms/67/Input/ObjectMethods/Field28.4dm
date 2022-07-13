//(s)jobnumber [jobmastercontrol]
JML_AutoUpdate
If (Length:C16([Job_Forms_Master_Schedule:67]JobForm:4)=8)
	READ ONLY:C145([JTB_Job_Transfer_Bags:112])
	QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Jobform:3=[Job_Forms_Master_Schedule:67]JobForm:4)
	tText:=""
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($i; 1; Records in selection:C76([JTB_Job_Transfer_Bags:112]))
			tText:=tText+"JTB: "+[JTB_Job_Transfer_Bags:112]ID:1+" at "+[JTB_Job_Transfer_Bags:112]Location:4+"  "
			NEXT RECORD:C51([JTB_Job_Transfer_Bags:112])
		End for 
		
		
	Else 
		
		ARRAY TEXT:C222($_ID; 0)
		ARRAY TEXT:C222($_Location; 0)
		
		SELECTION TO ARRAY:C260([JTB_Job_Transfer_Bags:112]ID:1; $_ID; [JTB_Job_Transfer_Bags:112]Location:4; $_Location)
		
		For ($i; 1; Size of array:C274($_ID); 1)
			
			tText:=tText+"JTB: "+$_ID{$i}+" at "+$_Location{$i}+"  "
			
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 First record
End if 