//%attributes = {"publishedWeb":true}
//Procedure: uContractPrice(est num)  010699  MLB
//apply contract pricing to a selection of carton specs

C_LONGINT:C283($numCartons)
C_TEXT:C284($0)

READ WRITE:C146([Estimates_Carton_Specs:19])
QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$1)
$numCartons:=Records in selection:C76([Estimates_Carton_Specs:19])

If ($numCartons>0)
	ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]ProductCode:5; >)
	READ ONLY:C145([Finished_Goods:26])
	For ($i; 1; $numCartons)
		//•050396  MLB  UPR 184
		[Estimates_Carton_Specs:19]PriceWant_Per_M:28:=uNANCheck(SetContractCost([Estimates_Carton_Specs:19]CustID:6; [Estimates_Carton_Specs:19]ProductCode:5; ->[Estimates_Carton_Specs:19]CostWant_Per_M:25; ->[Estimates_Carton_Specs:19]CostMatl_Per_M:66; ->[Estimates_Carton_Specs:19]CostLabor_Per_M:64; ->[Estimates_Carton_Specs:19]CostOH_Per_M:65; ->[Estimates_Carton_Specs:19]CostScrap_Per_M:67))
		[Estimates_Carton_Specs:19]PriceYield_PerM:30:=uNANCheck([Estimates_Carton_Specs:19]PriceWant_Per_M:28)
		[Estimates_Carton_Specs:19]CostYield_Per_M:26:=uNANCheck([Estimates_Carton_Specs:19]CostWant_Per_M:25)
		[Estimates_Carton_Specs:19]CostYldMatl:70:=uNANCheck([Estimates_Carton_Specs:19]CostMatl_Per_M:66)
		[Estimates_Carton_Specs:19]CostYldLabor:68:=uNANCheck([Estimates_Carton_Specs:19]CostLabor_Per_M:64)
		[Estimates_Carton_Specs:19]CostYldOH:69:=uNANCheck([Estimates_Carton_Specs:19]CostOH_Per_M:65)
		[Estimates_Carton_Specs:19]CostYldSE:71:=uNANCheck([Estimates_Carton_Specs:19]CostScrap_Per_M:67)
		
		SAVE RECORD:C53([Estimates_Carton_Specs:19])
		
		NEXT RECORD:C51([Estimates_Carton_Specs:19])
	End for 
	$0:="•C•"
	
Else   //numCartons
	BEEP:C151
	ALERT:C41("No cartons to apply contract pricing.")
	$0:=""
End if 