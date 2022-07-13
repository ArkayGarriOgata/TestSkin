//%attributes = {"publishedWeb":true}
//(P) gCalcBudget
//• 4/14/98 cs Nan checking

[Job_Forms:42]EstWasteSheets:34:=[Job_Forms:42]EstGrossSheets:27-[Job_Forms:42]EstNetSheets:28
[Job_Forms:42]QtyYield:30:=[Job_Forms:42]EstNetSheets:28*[Job_Forms:42]NumberUp:26
[Job_Forms:42]Pld_CostTtl:14:=uNANCheck([Job_Forms:42]Pld_CostTtlLabor:20+[Job_Forms:42]Pld_CostTtlOH:21+[Job_Forms:42]EstS_ECost:31+[Job_Forms:42]Pld_CostTtlMatl:19)
If (([Job_Forms:42]QtyWant:22#0) & ([Job_Forms:42]Pld_CostTtl:14#0))
	[Job_Forms:42]EstCost_M:29:=uNANCheck(Round:C94(([Job_Forms:42]Pld_CostTtl:14/[Job_Forms:42]QtyWant:22)*1000; 2))
Else 
	[Job_Forms:42]EstCost_M:29:=0
End if 