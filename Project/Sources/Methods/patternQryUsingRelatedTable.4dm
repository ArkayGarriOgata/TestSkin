//%attributes = {}
// -------
// Method: patternQryUsingRelatedTable   ( ) ->
// By: Mel Bohince @ 03/27/19, 08:01:05
// Description
// example of a better way if a relation exists
// ----------------------------------------------------

// see DieBoardGetImpressions
C_BOOLEAN:C305($betterWay)
$betterWay:=True:C214
C_DATE:C307($dDate)
C_TEXT:C284($ttOutline)
C_LONGINT:C283($xlUpNum)
$ttOutline:="A0testOL"
$xlUpNum:=16
$dDate:=Add to date:C393(Current date:C33; -1; 0; 0)

If (Not:C34($betterWay))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]OutlineNumber:65=$ttOutline; *)  // Get Job_Forms records for this Outline
	QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]NumberUp:26=$xlUpNum)  // Get Job_Forms records for this Outline
	RELATE MANY SELECTION:C340([Job_Forms_Machine_Tickets:61]JobForm:1)  // Get related Machine Tickets
	QUERY SELECTION WITH ARRAY:C1050([Job_Forms_Machine_Tickets:61]CostCenterID:2; <>aBLANKERS)  // Restrict to ONLY those Machine tickets that are Blankers
	QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=$dDate)  // Restrict to ONLY those Machine tickets entered on or after the Date
	uInit_CostCenterGroups
Else 
	
	
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms:42]OutlineNumber:65=$ttOutline; *)  // Get Job_Forms records for this Outline
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms:42]NumberUp:26=$xlUpNum; *)  // Get Job_Forms records for this Outline
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=$dDate)
	QUERY SELECTION WITH ARRAY:C1050([Job_Forms_Machine_Tickets:61]CostCenterID:2; <>aBLANKERS)  // Restrict to ONLY those Machine tickets that are Blankers
	
End if   // END 4D Professional Services : January 2019 query selection
