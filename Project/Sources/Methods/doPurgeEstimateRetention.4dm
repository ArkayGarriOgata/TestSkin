//%attributes = {"publishedWeb":true}
//PM:  doPurgeEstimateRetentioniffNum)  100199  mlb
//remove all parts of an estimate not related to 
//the specified differential
//NOTE THAT RELATE MANY is all ready called prior to this
//•100199  mlb  UPR 1987 [EST_PSPECS] wrongly purged

C_TEXT:C284($diffNum; $1)

$diffNum:=$1
$estimate:=[Estimates:17]EstimateNo:1
//*See if Status promotion is required
If (([Estimates:17]Status:30="New") | ([Estimates:17]Status:30="RFQ") | ([Estimates:17]Status:30="Estimated") | ([Estimates:17]Status:30="Priced") | ([Estimates:17]Status:30="Quoted"))
	If ($2="j")
		[Estimates:17]Status:30:="Budget"
		r73:=r73+1
	Else 
		If ([Customers_Orders:40]Status:10="Accepted") | ([Customers_Orders:40]Status:10="Budget@")
			[Estimates:17]Status:30:="Accepted Order"
		Else 
			[Estimates:17]Status:30:="Ordered"
		End if 
		r72:=r72+1
	End if 
	[Estimates:17]ModDate:37:=4D_Current_date
	[Estimates:17]ModWho:38:="PURG"
	SAVE RECORD:C53([Estimates:17])
End if   //reset status

//*save which job differetial is being retained so can skip next time
$doPurge:=False:C215  //assume already done
$specialSet:=False:C215

If ($2="j")
	If ([Estimates:17]RetainDiffJob:58#$diffNum)
		[Estimates:17]RetainDiffJob:58:=$diffNum
		SAVE RECORD:C53([Estimates:17])
		$doPurge:=True:C214
	End if 
	
Else   //on order
	If ([Estimates:17]RetainDiffOrd:57#$diffNum)
		[Estimates:17]RetainDiffOrd:57:=$diffNum
		SAVE RECORD:C53([Estimates:17])
		$doPurge:=True:C214
	End if 
	
	QUERY:C277([Jobs:15]; [Jobs:15]EstimateNo:6=$estimate)  //•070595 MLB
	If (Records in selection:C76([Jobs:15])>0)
		If (([Jobs:15]CaseScenario:7#$diffNum))
			[Estimates:17]RetainDiffJob:58:=[Jobs:15]CaseScenario:7
			SAVE RECORD:C53([Estimates:17])
			QryPurgeEstprts
			QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=[Jobs:15]CaseScenario:7)
			
			CREATE SET:C116([Estimates_Differentials:38]; "holdDiff")  //•100199  mlb  UPR 1987
			QUERY SELECTION:C341([Estimates_Differentials:38]; [Estimates_Differentials:38]diffNum:3=[Jobs:15]CaseScenario:7)  //•100199  mlb  UPR 1987
			$pSpec:=[Estimates_Differentials:38]ProcessSpec:5  //•100199  mlb  UPR 1987
			USE SET:C118("holdDiff")  //•100199  mlb  UPR 1987
			CLEAR SET:C117("holdDiff")  //•100199  mlb  UPR 1987
			QUERY SELECTION:C341([Estimates_PSpecs:57]; [Estimates_PSpecs:57]ProcessSpec:2=$pSpec)  //•100199  mlb  UPR 1987
			
			QUERY SELECTION:C341([Estimates_Differentials:38]; [Estimates_Differentials:38]diffNum:3=[Jobs:15]CaseScenario:7)
			QUERY SELECTION:C341([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=($estimate+[Jobs:15]CaseScenario:7))
			QUERY SELECTION:C341([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=($estimate+[Jobs:15]CaseScenario:7+"@"))
			QUERY SELECTION:C341([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=($estimate+[Jobs:15]CaseScenario:7+"@"))
			QUERY SELECTION:C341([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=($estimate+[Jobs:15]CaseScenario:7+"@"))
			
			CREATE SET:C116([Estimates_Carton_Specs:19]; "splCartons")
			CREATE SET:C116([Estimates_Differentials:38]; "spldif")
			CREATE SET:C116([Estimates_DifferentialsForms:47]; "splForm")
			CREATE SET:C116([Estimates_Machines:20]; "splMachines")
			CREATE SET:C116([Estimates_Materials:29]; "splMaterials")
			CREATE SET:C116([Estimates_FormCartons:48]; "splitems")
			CREATE SET:C116([Estimates_PSpecs:57]; "splpspec")
			
			$specialSet:=True:C214
		End if 
	End if 
End if   //do purge

If ($doPurge)  //we already did this one                  
	QryPurgeEstprts  //RELATE MANY is called within
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		CREATE SET:C116([Estimates_Carton_Specs:19]; "cspec1")
		QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=$diffNum; *)
		QUERY SELECTION:C341([Estimates_Carton_Specs:19];  | ; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)
		CREATE SET:C116([Estimates_Carton_Specs:19]; "cspec2")
		DIFFERENCE:C122("cspec1"; "cspec2"; "result")
		USE SET:C118("result")
		CLEAR SET:C117("cspec1")
		CLEAR SET:C117("cspec2")
		CLEAR SET:C117("result")
		
	Else 
		
		QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11#$diffNum; *)
		QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11#<>sQtyWorksht)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	CREATE SET:C116([Estimates_Differentials:38]; "holdDiff")  //•100199  mlb  UPR 1987
	QUERY SELECTION:C341([Estimates_Differentials:38]; [Estimates_Differentials:38]diffNum:3=$diffNum)  //•100199  mlb  UPR 1987
	$pSpec:=[Estimates_Differentials:38]ProcessSpec:5  //•100199  mlb  UPR 1987
	USE SET:C118("holdDiff")  //•100199  mlb  UPR 1987
	CLEAR SET:C117("holdDiff")  //•100199  mlb  UPR 1987
	QUERY SELECTION:C341([Estimates_PSpecs:57]; [Estimates_PSpecs:57]ProcessSpec:2#$pSpec)  //•100199  mlb  UPR 1987
	
	QUERY SELECTION:C341([Estimates_Differentials:38]; [Estimates_Differentials:38]diffNum:3#$diffNum)
	QUERY SELECTION:C341([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1#($estimate+$diffNum))
	QUERY SELECTION:C341([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1#($estimate+$diffNum+"@"))
	QUERY SELECTION:C341([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1#($estimate+$diffNum+"@"))
	QUERY SELECTION:C341([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2#($estimate+$diffNum+"@"))
	
	If ($specialSet)
		CREATE SET:C116([Estimates_Carton_Specs:19]; "nrmCartons")
		CREATE SET:C116([Estimates_Differentials:38]; "nrmdif")
		CREATE SET:C116([Estimates_DifferentialsForms:47]; "nrmForm")
		CREATE SET:C116([Estimates_Machines:20]; "nrmMachines")
		CREATE SET:C116([Estimates_Materials:29]; "nrmMaterials")
		CREATE SET:C116([Estimates_FormCartons:48]; "nrmitems")
		CREATE SET:C116([Estimates_PSpecs:57]; "nrmpspec")
		
		DIFFERENCE:C122("nrmCartons"; "splCartons"; "nrmCartons")
		DIFFERENCE:C122("nrmdif"; "spldif"; "nrmdif")
		DIFFERENCE:C122("nrmForm"; "splForm"; "nrmForm")
		DIFFERENCE:C122("nrmMachines"; "splMachines"; "nrmMachines")
		DIFFERENCE:C122("nrmMaterials"; "splMaterials"; "nrmMaterials")
		DIFFERENCE:C122("nrmitems"; "splitems"; "nrmitems")
		DIFFERENCE:C122("nrmSubForms"; "splSubForms"; "nrmSubForms")
		DIFFERENCE:C122("nrmpspec"; "splpspec"; "nrmpspec")
		
		USE SET:C118("nrmCartons")
		USE SET:C118("nrmdif")
		USE SET:C118("nrmForm")
		USE SET:C118("nrmMachines")
		USE SET:C118("nrmMaterials")
		USE SET:C118("nrmitems")
		USE SET:C118("nrmpspec")
		
		CLEAR SET:C117("nrmCartons")
		CLEAR SET:C117("nrmdif")
		CLEAR SET:C117("nrmForm")
		CLEAR SET:C117("nrmMachines")
		CLEAR SET:C117("nrmMaterials")
		CLEAR SET:C117("nrmitems")
		CLEAR SET:C117("nrmpspec")
		CLEAR SET:C117("splCartons")
		CLEAR SET:C117("spldif")
		CLEAR SET:C117("splForm")
		CLEAR SET:C117("splMachines")
		CLEAR SET:C117("splMaterials")
		CLEAR SET:C117("splitems")
		CLEAR SET:C117("splSubForms")
		CLEAR SET:C117("splpspec")
	End if 
	
	uPurgeEstCount
	doPurgeEstBits  //• 12/18/97 cs 
	$0:=Replace string:C233($estimate; "."; $2)  //mark as special on the report
	
Else   //done on prior purge
	$0:=Replace string:C233($estimate; "."; "*")  //mark as special on the report
End if   //retained

REMOVE FROM SET:C561([Estimates:17]; "DeleteThese")  //take it out of the set