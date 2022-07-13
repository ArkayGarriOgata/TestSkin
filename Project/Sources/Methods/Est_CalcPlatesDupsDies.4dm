//%attributes = {"publishedWeb":true}
//PM:  Est_CalcPlatesDupsDies  9/13/99  MLB
//formerly  `fCalcSpecials() 
//This procedure calcuates separate totals for Plates, dups, & dies   
//-JML   9/9/93, 
//mlb 11/09/93
//upr 1429, 1443 3/13/93
//• 4/23/97 cs added checks for no records found in searches
//•072998  MLB  add roanoke depts
// Modified by: Mel Bohince (1/28/19) moved '|' on line 123 to line 124

C_REAL:C285($labor; $burden; $matl; $ot)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	If ([Estimates_Differentials:38]BreakOutSpls:18)
		Est_LogIt("Breaking out Plates, Dies, and Dupes")
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
		CREATE SET:C116([Estimates_Machines:20]; "operations")
		
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
		CREATE SET:C116([Estimates_Materials:29]; "spl_Materials")
		
		QUERY SELECTION:C341([Estimates_Machines:20]; [Estimates_Machines:20]CostCtrID:4="401"; *)  //PLATES
		QUERY SELECTION:C341([Estimates_Machines:20];  | ; [Estimates_Machines:20]CostCtrID:4="402"; *)  //•072998  MLB  
		QUERY SELECTION:C341([Estimates_Machines:20];  | ; [Estimates_Machines:20]CostCtrID:4="403")  //•072998  MLB  
		If (Records in selection:C76([Estimates_Machines:20])>0)  //• 4/23/97 cs 
			$labor:=Sum:C1([Estimates_Machines:20]CostLabor:13)
			$burden:=Sum:C1([Estimates_Machines:20]CostOverhead:15)
			$ot:=Sum:C1([Estimates_Machines:20]CostOvertime:41)
		Else 
			$labor:=0
			$burden:=0
			$ot:=0
		End if 
		
		QUERY SELECTION:C341([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6="04@")
		If (Records in selection:C76([Estimates_Materials:29])>0)  //• 4/23/97 cs 
			$matl:=Sum:C1([Estimates_Materials:29]Cost:11)
		Else 
			$matl:=0
		End if 
		[Estimates_DifferentialsForms:47]Cost_Plates:21:=$labor+$burden+$matl+$ot
		
		USE SET:C118("operations")  //*DIES
		QUERY SELECTION:C341([Estimates_Machines:20]; [Estimates_Machines:20]CostCtrID:4="442"; *)
		QUERY SELECTION:C341([Estimates_Machines:20];  | ; [Estimates_Machines:20]CostCtrID:4="443")  //•072998  MLB    
		If (Records in selection:C76([Estimates_Machines:20])>0)  //• 4/23/97 cs 
			$labor:=Sum:C1([Estimates_Machines:20]CostLabor:13)
			$burden:=Sum:C1([Estimates_Machines:20]CostOverhead:15)
			$ot:=Sum:C1([Estimates_Machines:20]CostOvertime:41)
		Else 
			$labor:=0
			$burden:=0
			$ot:=0
		End if 
		
		USE SET:C118("spl_Materials")
		QUERY SELECTION:C341([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6="13-Laser Dies"; *)  //  `upr 1429 3/13/93
		QUERY SELECTION:C341([Estimates_Materials:29];  | ; [Estimates_Materials:29]Commodity_Key:6="71@")
		If (Records in selection:C76([Estimates_Materials:29])>0)  //• 4/23/97 cs 
			$matl:=Sum:C1([Estimates_Materials:29]Cost:11)
		Else 
			$matl:=0
		End if 
		[Estimates_DifferentialsForms:47]Cost_Dies:22:=$labor+$burden+$matl+$ot
		
		USE SET:C118("spl_Materials")  //*DUPES
		QUERY SELECTION:C341([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6="07-Embossing@")  //upr 1429 3/13/93
		If (Records in selection:C76([Estimates_Materials:29])>0)  //• 4/23/97 cs 
			$matl:=Sum:C1([Estimates_Materials:29]Cost:11)
		Else 
			$matl:=0
		End if 
		[Estimates_DifferentialsForms:47]Cost_Dups:20:=$matl  //$labor+$burden
		
		CLEAR SET:C117("operations")
		CLEAR SET:C117("spl_Materials")
	End if 
	
Else 
	
	If ([Estimates_Differentials:38]BreakOutSpls:18)
		Est_LogIt("Breaking out Plates, Dies, and Dupes")
		
		QUERY:C277([Estimates_Machines:20];  | ; [Estimates_Machines:20]CostCtrID:4="402"; *)
		QUERY:C277([Estimates_Machines:20];  | ; [Estimates_Machines:20]CostCtrID:4="403"; *)
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]CostCtrID:4="401"; *)
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
		
		If (Records in selection:C76([Estimates_Machines:20])>0)  //• 4/23/97 cs 
			$labor:=Sum:C1([Estimates_Machines:20]CostLabor:13)
			$burden:=Sum:C1([Estimates_Machines:20]CostOverhead:15)
			$ot:=Sum:C1([Estimates_Machines:20]CostOvertime:41)
		Else 
			$labor:=0
			$burden:=0
			$ot:=0
		End if 
		
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3; *)
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6="04@")
		
		If (Records in selection:C76([Estimates_Materials:29])>0)  //• 4/23/97 cs 
			$matl:=Sum:C1([Estimates_Materials:29]Cost:11)
		Else 
			$matl:=0
		End if 
		[Estimates_DifferentialsForms:47]Cost_Plates:21:=$labor+$burden+$matl+$ot
		
		QUERY:C277([Estimates_Machines:20];  | ; [Estimates_Machines:20]CostCtrID:4="443"; *)
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]CostCtrID:4="442"; *)
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
		
		If (Records in selection:C76([Estimates_Machines:20])>0)  //• 4/23/97 cs 
			$labor:=Sum:C1([Estimates_Machines:20]CostLabor:13)
			$burden:=Sum:C1([Estimates_Machines:20]CostOverhead:15)
			$ot:=Sum:C1([Estimates_Machines:20]CostOvertime:41)
		Else 
			$labor:=0
			$burden:=0
			$ot:=0
		End if 
		
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6="71@"; *)  // Modified by: Mel Bohince (1/28/19) removed leading '|'
		QUERY:C277([Estimates_Materials:29];  | ; [Estimates_Materials:29]Commodity_Key:6="13-Laser Dies"; *)  // Modified by: Mel Bohince (1/28/19) added '|'
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
		
		If (Records in selection:C76([Estimates_Materials:29])>0)  //• 4/23/97 cs 
			$matl:=Sum:C1([Estimates_Materials:29]Cost:11)
		Else 
			$matl:=0
		End if 
		[Estimates_DifferentialsForms:47]Cost_Dies:22:=$labor+$burden+$matl+$ot
		
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3; *)
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6="07-Embossing@")
		If (Records in selection:C76([Estimates_Materials:29])>0)  //• 4/23/97 cs 
			$matl:=Sum:C1([Estimates_Materials:29]Cost:11)
		Else 
			$matl:=0
		End if 
		[Estimates_DifferentialsForms:47]Cost_Dups:20:=$matl  //$labor+$burden
		
	End if 
	
End if   // END 4D Professional Services : January 2019 query selection
