//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/07/14, 10:49:56
// ----------------------------------------------------
// Method: sCopyEstimateNewValues
// Description:
// Fills in new information for the copied estimate.
// ----------------------------------------------------

[Estimates:17]CreatedBy:59:=<>zResp
[Estimates:17]EstimatedBy:14:=<>zResp
[Estimates:17]DateEstimated:64:=4D_Current_date
[Estimates:17]DateEstimatedTime:65:=4d_Current_time
[Estimates:17]DateOriginated:19:=4D_Current_date
Cust_GetTerms([Estimates:17]Cust_ID:2; ->[Estimates:17]Terms:7; ->[Estimates:17]FOB:8; ->[Estimates:17]ShippingVia:6)
Cust_getTeam([Estimates:17]Cust_ID:2; ->[Estimates:17]Sales_Rep:13; ->[Estimates:17]SaleCoord:46; ->[Estimates:17]PlannedBy:16)