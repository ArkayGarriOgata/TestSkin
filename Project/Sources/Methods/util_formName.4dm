//%attributes = {}
// -------
// Method: util_formName   ( ) -> [table]form
// By: Mel Bohince @ 04/10/17, 16:10:04
// Description
// return form table and name
// ----------------------------------------------------
C_TEXT:C284($0)
C_POINTER:C301($1)
C_LONGINT:C283($tblNum)
$tblNum:=Table:C252($1)  //cant do it inline
$0:="["+Table name:C256($tblNum)+"]"+Current form name:C1298
