//%attributes = {"publishedWeb":true}
//(P) ChrgCodeParse
//small utility to parse charge codes into their component pieces
//Returns - string - portion of charge code requested
//Params - 1 - code to parse
//            - 2 - number indicating which part of code 
//                     1 -> company, 2 -> Department, 3 -> Expense/Gen Ledg code
//created 12/3/96
//Chip
//Returns  String

C_TEXT:C284($1; $Code)
C_LONGINT:C283($2; $Option; $Company; $Expense; $Depart)
C_TEXT:C284($0)

$Code:=$1
$Option:=$2
$Company:=1
$Expense:=3
$Depart:=2

If (Position:C15("-"; $Code)>0)  //parse charge code which contains "-"
	Case of 
		: ($Option=$Company)
			$0:=uParseString($Code; 1; "-")
		: ($Option=$Depart)
			$0:=uParseString($Code; 2; "-")
		: ($Option=$Expense)
			$0:=uParseString($Code; 3; "-")
	End case 
Else 
	Case of 
		: ($Option=$Company)
			$0:=Substring:C12($Code; 1; 1)
		: ($Option=$Depart)
			$0:=Substring:C12($Code; 2; 4)
		: ($Option=$Expense)
			$0:=Substring:C12($Code; 6)
	End case 
End if 