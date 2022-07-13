// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/05/12, 14:15:14
// ----------------------------------------------------
// Method: [Raw_Materials_Transactions].Rama_Transactions.Button3
// Description:
// Prints the transactions either As Is or subtotaled by GCAST.
// ----------------------------------------------------

C_LONGINT:C283($i)
C_TEXT:C284($tMsg; $tResponse)

$tMsg:="Would you like to print the transactions "+Char:C90(34)+"By Date"+Char:C90(34)+" or subtotaled by GCAST?"

$tResponse:=(YesNoCancel($tMsg; "By Date"; "Subtotaled"; "Print Rama Transactions"))
Case of 
	: ($tResponse="Yes")
		Rama_PrintTransactions(1)  //Yes is "By Date"
		
	: ($tResponse="No")
		Rama_PrintTransactions(0)  //Yes is "By Date"
		
End case 