//%attributes = {}
// Method: eBag_releaseRecords () -> 
// ----------------------------------------------------
// by: mel: 03/11/04, 11:42:05
// ----------------------------------------------------
// Description:
//try again to resolve a locking problem

sCriterion1:=""
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sCriterion1)
sCriterion2:=""
sCriterion3:=""
sCriterion4:=""
sCriterion5:=""
sCriterion6:=""
tTitle:=""
tMessage1:=""
sLocation:=""
t7:=""
t8:=""
t9:=""
tText:=""
xComment:=""
sBin:=""
ARRAY LONGINT:C221(aSubForm; 0)
ARRAY LONGINT:C221(aSubFormQty; 0)
ARRAY REAL:C219(aRatio; 0)
ARRAY TEXT:C222(aOutlineNum; 0)

eBag_MakeTabs(sCriterion1)