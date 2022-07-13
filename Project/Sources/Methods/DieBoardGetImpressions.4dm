//%attributes = {"executedOnServer":true}
// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/28/18, 13:50:25
// ----------------------------------------------------
// Method: DieBoardGetImpressions
// Description
// 
//
// Parameters
// ----------------------------------------------------
//$1=-># of Impressions variable
//$0= # of impressions remainning


// This method is set to "EXECUTE ON SERVER"

C_TEXT:C284($ttOutline)
C_DATE:C307($dDate)
C_TEXT:C284($ttCenters; $ttMachineID)
C_POINTER:C301($1)
C_LONGINT:C283($xlMax; $0)
$1->:=0
$0:=0

$ttOutline:=[Job_DieBoard_Inv:168]OutlineNumber:4
$dDate:=[Job_DieBoard_Inv:168]DateEntered:6
If ($dDate=!00-00-00!)
	$dDate:=Add to date:C393(Current date:C33; -1; 0; 0)
End if 
$xlMax:=[Job_DieBoard_Inv:168]MaxImpressions:11
$xlUpNum:=[Job_DieBoard_Inv:168]UpNumber:5

If ($dDate#!00-00-00!)  // safe guard just in case date isn't entered
	//ARRAY TEXT($sttCenters;0) use <>aBLANKERS
	//$ttCenters:=<>blankers
	//Repeat 
	//$ttMachineID:=GetNextField (->$ttCenters;" ")
	//If (Length($ttMachineID)>0)
	//APPEND TO ARRAY($sttCenters;$ttMachineID)
	//End if 
	//Until (Length($ttCenters)=0)
	
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		//QUERY([Job_Forms];[Job_Forms]OutlineNumber=$ttOutline;*)  // Get Job_Forms records for this Outline
		//QUERY([Job_Forms]; & ;[Job_Forms]NumberUp=$xlUpNum)  // Get Job_Forms records for this Outline
		//RELATE MANY SELECTION([Job_Forms_Machine_Tickets]JobForm)  // Get related Machine Tickets
		//QUERY SELECTION WITH ARRAY([Job_Forms_Machine_Tickets]CostCenterID;$sttCenters)  // Restrict to ONLY those Machine tickets that are Blankers
		//QUERY SELECTION([Job_Forms_Machine_Tickets];[Job_Forms_Machine_Tickets]DateEntered>=$dDate)  // Restrict to ONLY those Machine tickets entered on or after the Date
		
	Else 
		
		
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms:42]OutlineNumber:65=$ttOutline; *)  // Get Job_Forms records for this Outline
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms:42]NumberUp:26=$xlUpNum; *)  // Get Job_Forms records for this Outline
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=$dDate)
		QUERY SELECTION WITH ARRAY:C1050([Job_Forms_Machine_Tickets:61]CostCenterID:2; <>aBLANKERS)  // Restrict to ONLY those Machine tickets that are Blankers
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	// Sum command does not work inside a print selection, we need this method,so we have to revise the Sum logic
	
	//$1->:=Sum([Job_Forms_Machine_Tickets]Good_Units)+Sum([Job_Forms_Machine_Tickets]Waste_Units)
	$1->:=0
	ARRAY LONGINT:C221($sxlGood; 0)
	ARRAY LONGINT:C221($sxlWaste; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Good_Units:8; $sxlGood; [Job_Forms_Machine_Tickets:61]Waste_Units:9; $sxlWaste)
	For ($i; 1; Size of array:C274($sxlGood))
		$1->:=$1->+$sxlGood{$i}+$sxlWaste{$i}
	End for 
	
	$0:=$xlMax-$1->
	
End if 