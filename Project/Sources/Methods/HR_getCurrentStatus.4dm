//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/14/05, 16:03:29
// ----------------------------------------------------
// Method: HR_getCurrentStatus
// ----------------------------------------------------

C_TEXT:C284($0; $buffer)
C_TEXT:C284($r; $1)

$r:=Char:C90(13)

$buffer:=":::::::: CURRENT STATUS ::::::::"+$r
$buffer:=$buffer+"Job Title     : "+[Users:5]BusTitle:5+$r
$buffer:=$buffer+"Department    : "+[Users:5]Dept:31+$r
$buffer:=$buffer+"Classification: "+[Users:5]Classification:49+$r
$buffer:=$buffer+"Grade         : "+[Users:5]Grade:51+$r
$buffer:=$buffer+"Shift         : "+[Users:5]Shift:52+$r
$buffer:=$buffer+"Hours         : "+String:C10([Users:5]HrPerWeek:50)+$r
$buffer:=$buffer+"Salary        : "+String:C10([Users:5]Salary:53; "#,###,##0.00")+"/"+[Users:5]SalaryUnit:54+$r
$buffer:=$buffer+"Reason for chg: "+[Users:5]ReasonForChange:55+$r
$buffer:=$buffer+"Last Change   : "+String:C10([Users:5]DateChgEffective:56; Internal date short:K1:7)+$r
$buffer:=$buffer+"Approved By   : "+[Users:5]LastApprovers:57+$r

$0:=$buffer