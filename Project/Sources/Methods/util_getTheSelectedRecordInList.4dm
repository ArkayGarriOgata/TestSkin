//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/27/06, 14:08:00
// ----------------------------------------------------
// Method: util_getTheSelectedRecordInList(->textFieldToDisplay)
// Description:
// Set the record number of a record selected in list
// use in the form event=on timer which was sent by included's on Selected Change
// ---------------------------------------------------

C_POINTER:C301($1; $ptrSubFormTable; $2; $ptrOpenIncludedButton)
C_LONGINT:C283($0; $n)
C_TEXT:C284($3; $buttonLabel; $4; $buttonLabelPlural)

$ptrSubFormTable:=$1
$ptrOpenIncludedButton:=$2
$buttonLabel:=$3
$buttonLabelPlural:=$4

GET HIGHLIGHTED RECORDS:C902($ptrSubFormTable->; "SelectedSubRecords")
$n:=Records in set:C195("SelectedSubRecords")
If ($n#0)
	CUT NAMED SELECTION:C334($ptrSubFormTable->; "CustomersContacts")
	USE SET:C118("SelectedSubRecords")
	Case of 
		: (Records in set:C195("SelectedSubRecords")=1)
			OBJECT SET ENABLED:C1123($ptrOpenIncludedButton->; True:C214)
			OBJECT SET TITLE:C194($ptrOpenIncludedButton->; "Open "+$buttonLabel)
		: (Records in set:C195("SelectedSubRecords")>1)
			OBJECT SET TITLE:C194($ptrOpenIncludedButton->; "Open "+$buttonLabelPlural)
			OBJECT SET ENABLED:C1123($ptrOpenIncludedButton->; True:C214)
		Else 
			OBJECT SET ENABLED:C1123($ptrOpenIncludedButton->; False:C215)
	End case 
	
	USE NAMED SELECTION:C332("CustomersContacts")
	HIGHLIGHT RECORDS:C656("SelectedSubRecords")
	
Else 
	OBJECT SET ENABLED:C1123($ptrOpenIncludedButton->; False:C215)
End if 
CLEAR SET:C117("SelectedSubRecords")
$0:=$n