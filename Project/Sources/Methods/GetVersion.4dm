//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 12/07/15, 10:47:15
// ----------------------------------------------------
// Method: GetVersion
// Description
// 
//
// Parameters
// ----------------------------------------------------


//$1=->Text version variable
//$2=->Longint version variable
C_POINTER:C301($1; $2)
C_BLOB:C604($obVers)
C_TIME:C306($rDocRef)


//$1->:=GetDBVers   //v3.9.7-PJK (8/6/14) rewrote using Standard Component
$2->:=Num:C11(Replace string:C233($1->; "."; ""))  //v3.9.7-PJK (8/6/14)
