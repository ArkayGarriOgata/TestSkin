//%attributes = {"publishedWeb":true}
//PM: JML_cacheUpdate() -> 
//@author mlb - 4/24/02  15:06
//• mlb - 7/31/02  10:44 add Rev date and Operations
// • mel (9/15/04, 11:01:15) include glue readies
// Modified by: Mel Bohince (10/31/17) added aRTG for Ready to Glue

C_LONGINT:C283($i; $numJML)
ARRAY DATE:C224($aMAD; 0)
ARRAY DATE:C224($aRev; 0)
ARRAY TEXT:C222($aPlant; 0)

zwStatusMsg("Please Wait..."; "Caching Job Master Log info. Loading JobMasterLog Data")

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]LastUpdate:51>=<>cacheJMLts)
//QUERY([JobMasterLog]; & ;[JobMasterLog]GlueReady=!00/00/00!)` • mel (9/15/04, 11:01:15) include glue readies

$numJML:=Records in selection:C76([Job_Forms_Master_Schedule:67])
If ($numJML>0)  //get the updates
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJML; [Job_Forms_Master_Schedule:67]OrigRevDate:20; $aRev; [Job_Forms_Master_Schedule:67]DateStockRecd:17; $aStockGot; [Job_Forms_Master_Schedule:67]DateStockSheeted:47; $aStockShted; [Job_Forms_Master_Schedule:67]DateBagReceived:48; $aBagGot; [Job_Forms_Master_Schedule:67]DateBagApproved:49; $aBagOK; [Job_Forms_Master_Schedule:67]Printed:32; $aPrinted; [Job_Forms_Master_Schedule:67]DateBagReturned:52; $aBagRtn; [Job_Forms_Master_Schedule:67]DateWIPreceived:53; $aWIP; [Job_Forms_Master_Schedule:67]GlueReady:28; $aRTG)  //[JobMasterLog]Date1stItemMAD
	//SELECTION TO ARRAY()
	//SELECTION TO ARRAY([Job_Forms_Master_Schedule]Launch;$aLaunch;[Job_Forms_Master_Schedule]caliper;$aCal;[Job_Forms_Master_Schedule]MAD;$aMAD;[Job_Forms_Master_Schedule]LocationOfMfg;$aPlant;[Job_Forms_Master_Schedule]FirstReleaseDat;$a1ST;[Job_Forms_Master_Schedule]eBag;$aeBag;[Job_Forms_Master_Schedule]Operations;$aOperations)
	uThermoInit($numJML; "Checking updated jobs that are not complete and not glue"+" ready")
	For ($i; 1; $numJML)
		$hit:=Find in array:C230(<>aJML; $aJML{$i})
		If ($hit=-1)
			PS_DateArrays(1; 1)
			$hit:=1
		End if 
		<>aJML{$hit}:=$aJML{$i}
		<>aREV{$hit}:=$aRev{$i}
		<>aBagGot{$hit}:=$aBagGot{$i}
		<>aBagOK{$hit}:=$aBagOK{$i}
		<>aStockGot{$hit}:=$aStockGot{$i}
		<>aStockShted{$hit}:=$aStockShted{$i}
		<>aPrinted{$hit}:=$aPrinted{$i}
		<>aBagRtn{$hit}:=$aBagRtn{$i}
		<>aWIP{$hit}:=$aWIP{$i}
		<>aRTG{$hit}:=$aRTG{$i}
		uThermoUpdate($i)
	End for 
	uThermoClose
	PS_DateArraySort
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
End if 
zwStatusMsg("JML Cache"; "Initialized")