//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 05/21/13, 14:41:00
// ----------------------------------------------------
// Method: FillInClassification
// Description:
// Looks for the word "Wrap" in $1, if it is found it will
//  ask the user if he/she would like to fill in $2 with
//  "23" and $3 with "Wrap".
// $1 = Table
// $2 = Pointer to field to search
// $3 = Pointer to field to fill in with "23"
// ----------------------------------------------------

C_TEXT:C284($tTable; $1)
C_POINTER:C301($pSearch; $2; $pClass; $3)

$tTable:=$1
$pSearch:=$2
$pClass:=$3

//Does $pSearch contain the word "wrap"?
If (Position:C15("wrap"; $pSearch->)#0)  // Modified by: Mark Zinke (12/3/13) Wrap used to be plural.
	uConfirm("Would you like to have the classification set to "+Char:C90(Double quote:K15:41)+"23:Wrap"+Char:C90(Double quote:K15:41)+"?")
	If (baOK=1)
		$pClass->:="23"
		
		If ($tTable="FG")
			If ([Finished_Goods_Classifications:45]Class:1#[Finished_Goods:26]ClassOrType:28)
				QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Finished_Goods:26]ClassOrType:28)
				[Finished_Goods:26]ModFlag:31:=True:C214
			End if 
			
			If ([Finished_Goods:26]GL_Income_Code:22#[Finished_Goods_Classifications:45]GL_income_code:3)
				[Finished_Goods:26]GL_Income_Code:22:=[Finished_Goods_Classifications:45]GL_income_code:3
				[Finished_Goods:26]ModFlag:31:=True:C214
			End if 
			
		Else 
			If ([Estimates_Carton_Specs:19]Classification:72#"00") & ([Estimates_Carton_Specs:19]Classification:72#"__") & ([Estimates_Carton_Specs:19]Classification:72#"")
				QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Estimates_Carton_Specs:19]Classification:72)
				If (Records in selection:C76([Finished_Goods_Classifications:45])=0)
					uConfirm("Invalid Classification."; "OK"; "Help")
					[Estimates_Carton_Specs:19]Classification:72:=Old:C35([Estimates_Carton_Specs:19]Classification:72)
					GOTO OBJECT:C206([Estimates_Carton_Specs:19]Classification:72)
				End if 
			End if 
		End if 
		
	End if 
End if 