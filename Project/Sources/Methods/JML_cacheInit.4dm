//%attributes = {"publishedWeb":true}
//PM: JML_cacheInit() -> 
//@author mlb - 4/24/02  15:10
//• mlb - 7/31/02  10:44 add Rev date and Operations
// • mel (9/15/04, 11:01:15) include glue readies
// Modified by: Mel Bohince (10/31/17) added aRTG for Ready to Glue
//____________
//see also JML_cacheUpdate
//_________________

C_LONGINT:C283($i; $numJML)

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
$numJML:=Records in selection:C76([Job_Forms_Master_Schedule:67])
zwStatusMsg("Please Wait..."; "Caching Job Master Log info. Getting Customer colors")

C_OBJECT:C1216($oNameColor)
$oNameColor:=New object:C1471()
$oNameColor:=Cust_Name_ColorO()

PS_DateArrays(0)
//;[Job_Forms_Master_Schedule]LocationOfMfg;$aPlant;[Job_Forms_Master_Schedule]eBag;◊aeBag;;[Job_Forms_Master_Schedule]MAD;◊aMAD;[Job_Forms_Master_Schedule]FirstReleaseDat;◊a1ST;;[Job_Forms_Master_Schedule]Operations;◊aOperations
zwStatusMsg("Please Wait..."; "Caching Job Master Log info. Loading JobMasterLog Data")
SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; <>aJML; [Job_Forms_Master_Schedule:67]OrigRevDate:20; <>aREV; [Job_Forms_Master_Schedule:67]DateStockRecd:17; <>aStockGot; [Job_Forms_Master_Schedule:67]DateStockSheeted:47; <>aStockShted; [Job_Forms_Master_Schedule:67]DateBagReceived:48; <>aBagGot; [Job_Forms_Master_Schedule:67]DateBagApproved:49; <>aBagOK; [Job_Forms_Master_Schedule:67]Printed:32; <>aPrinted; [Job_Forms_Master_Schedule:67]DateBagReturned:52; <>aBagRtn; [Job_Forms_Master_Schedule:67]DateWIPreceived:53; <>aWIP; [Job_Forms_Master_Schedule:67]GlueReady:28; <>aRTG)

PS_DateArraySort
REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
zwStatusMsg("JML Cache"; "Initialized")