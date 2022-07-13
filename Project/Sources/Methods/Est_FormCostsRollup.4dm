//%attributes = {"publishedWeb":true}
//PM:  t_FormCostsRollup($lastGross)  091099  mlb
//roll up the sequence and material info
//•100599  mlb  make $1 optional, not used in Est_ChangeRates

C_LONGINT:C283($1)

[Estimates_DifferentialsForms:47]CostTtlMatl:17:=Sum:C1([Estimates_Materials:29]Cost:11)
[Estimates_DifferentialsForms:47]CostTtlOH:16:=Sum:C1([Estimates_Machines:20]CostOverhead:15)
[Estimates_DifferentialsForms:47]CostTtlLabor:15:=Sum:C1([Estimates_Machines:20]CostLabor:13)
[Estimates_DifferentialsForms:47]Cost_Scrap:24:=Sum:C1([Estimates_Machines:20]CostScrap:12)
[Estimates_DifferentialsForms:47]Cost_Overtime:25:=Sum:C1([Estimates_Machines:20]CostOvertime:41)
[Estimates_DifferentialsForms:47]CostTTL:18:=[Estimates_DifferentialsForms:47]CostTtlOH:16+[Estimates_DifferentialsForms:47]CostTtlLabor:15+[Estimates_DifferentialsForms:47]CostTtlMatl:17+[Estimates_DifferentialsForms:47]Cost_Scrap:24+[Estimates_DifferentialsForms:47]Cost_Overtime:25
If (Count parameters:C259=1)
	[Estimates_DifferentialsForms:47]SheetsQtyGross:19:=$1
	[Estimates_DifferentialsForms:47]Spoilage_Pct:28:=uNANCheck(Round:C94(((($1-PlannedNet)/PlannedNet)*100); 2))
End if 
[Estimates_DifferentialsForms:47]Cost_Yield_Adds:27:=uNANCheck(Sum:C1([Estimates_Machines:20]OOP_YldAddition:45))
[Estimates_DifferentialsForms:47]Cost_Yield_Adds:27:=uNANCheck([Estimates_DifferentialsForms:47]Cost_Yield_Adds:27+Sum:C1([Estimates_Materials:29]Matl_YieldAdds:26))