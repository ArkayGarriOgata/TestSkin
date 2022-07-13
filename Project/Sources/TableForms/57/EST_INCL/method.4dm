//
$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		$numFound:=0
		SET QUERY DESTINATION:C396(Into variable:K19:4; $numFound)
		QUERY:C277([Process_Specs_Machines:28]; [Process_Specs_Machines:28]ProcessSpec:1=[Process_Specs:18]ID:1; *)
		QUERY:C277([Process_Specs_Machines:28];  & ; [Process_Specs_Machines:28]CustID:2=[Process_Specs:18]Cust_ID:4)
		numProcess:=$numFound
		QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs:18]ID:1; *)
		QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]CustID:2=[Process_Specs:18]Cust_ID:4)
		numMat:=$numFound
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Estimates_PSpecs:57]; "clickedPSpec")
		
	: ($e=On Double Clicked:K2:5)
		GET HIGHLIGHTED RECORDS:C902([Estimates_PSpecs:57]; "clickedPSpec")
		CUT NAMED SELECTION:C334([Estimates_PSpecs:57]; "hold")
		USE SET:C118("clickedPSpec")
		SELECTION TO ARRAY:C260([Estimates_PSpecs:57]ProcessSpec:2; $aPSpecs)
		$numCollection:=Size of array:C274($aPSpecs)
		ARRAY TEXT:C222($aPSpecKey; $numCollection)
		For ($i; 1; $numCollection)
			$aPSpecKey{$i}:=[Estimates:17]Cust_ID:2+":"+$aPSpecs{$i}
		End for 
		
		If (iMode=1)
			$mode:=2
			READ WRITE:C146([Process_Specs:18])
		Else 
			$mode:=iMode
			If ($mode<3)
				READ WRITE:C146([Process_Specs:18])
			Else 
				READ ONLY:C145([Process_Specs:18])
			End if 
		End if 
		
		
		QUERY WITH ARRAY:C644([Process_Specs:18]PSpecKey:106; $aPSpecKey)
		
		//CREATE SET([Process_Specs];"◊PassThroughSet")
		//◊PassThrough:=True
		
		//ViewSetter ($mode;->[Process_Specs])
		
		If ($mode=3)
			DISPLAY SELECTION:C59([Process_Specs:18]; *)
		Else 
			MODIFY RECORD:C57([Process_Specs:18]; *)
		End if 
		UNLOAD RECORD:C212([Process_Specs:18])
		
		USE NAMED SELECTION:C332("hold")
		HIGHLIGHT RECORDS:C656([Estimates_PSpecs:57]; "clickedPSpec")
End case 
