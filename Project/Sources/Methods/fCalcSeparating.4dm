//%attributes = {}
// Method: fCalcSeparating () -> 
// ----------------------------------------------------
// by: mel: 06/27/05, 14:38:19
// ----------------------------------------------------
// Description:
// per sheet charges
// `exact $/sheet, an approximation of runhrs and rate with round-off error
// ----------------------------------------------------

C_LONGINT:C283($1; $sheets)
C_REAL:C285($perSheetRate)

$sheets:=$1
[Estimates_Machines:20]Qty_Gross:22:=$sheets
[Estimates_Machines:20]Qty_Waste:23:=0
[Estimates_Machines:20]Qty_Net:24:=$sheets

$perSheetRate:=[Estimates_Machines:20]Flex_Field3:20/100  //convert cents to dollars
[Estimates_Machines:20]CostOOP:28:=$perSheetRate*$sheets
[Estimates_Machines:20]CostLabor:13:=[Estimates_Machines:20]CostOOP:28*([Cost_Centers:27]MHRlaborSales:4/[Cost_Centers:27]MHRoopSales:7)
[Estimates_Machines:20]CostOverhead:15:=[Estimates_Machines:20]CostOOP:28-[Estimates_Machines:20]CostLabor:13
[Estimates_Machines:20]CostScrap:12:=0

//now guestimate the rate and hours
[Estimates_Machines:20]RunningRate:31:=Round:C94([Cost_Centers:27]MHRoopSales:7/$perSheetRate; 0)
[Estimates_Machines:20]RunningHrs:32:=Round:C94(($sheets/[Estimates_Machines:20]RunningRate:31); 2)