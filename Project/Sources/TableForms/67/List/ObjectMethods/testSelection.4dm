// -------
// Method: [Job_Forms_Master_Schedule].List.testSelection   ( ) ->
// By: Mel Bohince @ 02/20/18, 07:31:19
// Description
// display all jobform that are not complete and in the production schedule
// to stage for export to printflow
// ----------------------------------------------------
//


//$recs:=PS_qryPrintingOnly ("not";"complete")
QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]Completed:23=0)
ARRAY TEXT:C222($aPressJobs; 0)
ARRAY TEXT:C222($aJobs; 0)
SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $aPressJobs)
SORT ARRAY:C229($aPressJobs; >)
C_LONGINT:C283($i; $numElements; $hit)

$numElements:=Size of array:C274($aPressJobs)

uThermoInit($numElements; "Processing Array")
For ($i; 1; $numElements)
	$jf:=Substring:C12($aPressJobs{$i}; 1; 8)
	$hit:=Find in array:C230($aPressJobs; $jf)
	If ($hit=-1)
		APPEND TO ARRAY:C911($aJobs; $jf)
	End if 
	uThermoUpdate($i)
End for 
uThermoClose

// ******* Verified  - 4D PS - January  2019 ********

QUERY WITH ARRAY:C644([Job_Forms_Master_Schedule:67]JobForm:4; $aJobs)
QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)


// ******* Verified  - 4D PS - January 2019 (end) *********
//QUERY SELECTION([Job_Forms_Master_Schedule];[Job_Forms_Master_Schedule]MAD#!00/00/0000!;*)
//QUERY SELECTION([Job_Forms_Master_Schedule]; & ;[Job_Forms_Master_Schedule]Printed=!00/00/0000!)
//QUERY SELECTION([Job_Forms_Master_Schedule]; & ;[Job_Forms_Master_Schedule]TargetDate_PrintFlow>!02/20/2018!;*)
//QUERY SELECTION([Job_Forms_Master_Schedule]; & ;[Job_Forms_Master_Schedule]PressDate>!02/20/2018!;*)
//QUERY SELECTION([Job_Forms_Master_Schedule]; & ;[Job_Forms_Master_Schedule]PressDate<!03/08/2018!)
CREATE SET:C116([Job_Forms_Master_Schedule:67]; "◊LastSelection"+String:C10(fileNum))
CREATE SET:C116([Job_Forms_Master_Schedule:67]; "CurrentSet")
SET WINDOW TITLE:C213(fNameWindow(->[Job_Forms_Master_Schedule:67]))