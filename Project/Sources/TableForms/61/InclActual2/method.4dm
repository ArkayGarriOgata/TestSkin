// _______
// Method: [Job_Forms_Machine_Tickets].InclActual2   ( ) ->
// ----------------------------------------------------
// Modified by: Mel Bohince (6/9/21) 

$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		
		If (Length:C16([Job_Forms_Machine_Tickets:61]CostCenterID:2)>=3)
			aMachDesc:=""
			$cc:=CostCtrCurrent("desc"; [Job_Forms_Machine_Tickets:61]CostCenterID:2; ->aMachDesc)  // Modified by: Mel Bohince (6/9/21) 
			//If ($cc<=Size of array(aCostCtrDes)) & ($cc#0)
			//aMachDesc:=aCostCtrDes{$cc}  //zzDESC
			//Else 
			//aMachDesc:="Element "+String($cc)+" N/A"
			//End if 
		Else 
			aMachDesc:="C/C id not specified"
		End if 
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Job_Forms_Machine_Tickets:61]; "clickedIncluded")
		
	: ($e=On Double Clicked:K2:5)
		
End case 


//EOP