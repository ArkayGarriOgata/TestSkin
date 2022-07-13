$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		If (Not:C34(Read only state:C362([Job_Forms_Machines:43])))
			If (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>SHEETERS)>0)  //convert to lf
				If ([Job_Forms:42]ShortGrain:48)
					$length:=[Job_Forms:42]Width:23
				Else 
					$length:=[Job_Forms:42]Lenth:24
				End if 
				[Job_Forms_Machines:43]Actual_RunRate:39:=[Job_Forms_Machines:43]Actual_RunRate:39*($length/12)
			End if 
		End if 
		
	: ($e=On Clicked:K2:4)
		//GET HIGHLIGHTED RECORDS([Job_Forms_Machines];"clickedCSpec")
		
	: ($e=On Double Clicked:K2:5)
		
End case 
