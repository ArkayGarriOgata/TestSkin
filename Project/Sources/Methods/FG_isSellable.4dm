//%attributes = {"publishedWeb":true}
//PM: FG_isSellable(cust;cpn) -> bool
//@author mlb - 5/4/01  15:56
//• mlb - 5/9/01  13:31 remove contract price criterion

C_BOOLEAN:C305($0)
C_TEXT:C284($1; $2)

$0:=False:C215

Case of 
	: (Count parameters:C259=2)
		$numFG:=qryFinishedGood($1; $2)
	: (Count parameters:C259=1)
		$numFG:=qryFinishedGood("#KEY"; $1)
	Else 
		$numFG:=0
End case 

If ($numFG>0)
	//If ([Finished_Goods]RKContractPrice#0)
	If ([Finished_Goods:26]FRCST_NumberOfReleases:69>0)
		$0:=True:C214
	End if 
End if 