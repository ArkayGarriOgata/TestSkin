//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 03/29/07, 15:37:31
// ----------------------------------------------------
// Method: 000_version_number()  --> 
// Description:
// Set version info
// ----------------------------------------------------
//!2019-01-25! includes query optimization by 4D
//04/07/2017 has Footprints migration to v16 work

C_DATE:C307(<>dLASTUPDATE)
C_TEXT:C284(<>sVERSION; $0)

<>dLASTUPDATE:=!2022-06-29!

<>sVERSION:=String:C10(Month of:C24(<>dLASTUPDATE); "00")+String:C10(Day of:C23(<>dLASTUPDATE); "00")  //displayed on MainPalette

$0:=<>sVERSION





