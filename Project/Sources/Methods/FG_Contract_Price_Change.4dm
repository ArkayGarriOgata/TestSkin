//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/31/10, 14:12:23
// ----------------------------------------------------
// Method: FG_Contract_Price_Change(cpn;new_price)
// Description
// update teh rk_contract price
// ----------------------------------------------------

C_TEXT:C284($1)
C_REAL:C285($2)

READ WRITE:C146([Finished_Goods:26])

$numFG:=qryFinishedGood("#CPN"; $1)
If ($numFG>0)
	[Finished_Goods:26]RKContractPrice:49:=$2
	SAVE RECORD:C53([Finished_Goods:26])
End if 
UNLOAD RECORD:C212([Finished_Goods:26])