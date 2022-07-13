//%attributes = {"publishedWeb":true}
//uInitPopUpsRpts 10/14/94 try to make uInitPopUps less than 32K
If (False:C215)
	//mod 10/17/94 chip
	//upr 1257, 1261 & 1262 10/29/94
	//upr 1357 12/8/94
	//UPR 1290 Chip 12/15/94
	//1/3/95 Chip, upr 1361
	//1/11/95 upr 1329
	//1/12/95 upr 1330 
	//mod 1/25/95 chip upr 1397
	//1/31/95
	//REPORTS
	//upr 1333 2/13/95 sub fg to xc for fg to ex which can't happen
	//upr 1439 2/22/95
	//upr 1461 chip 03/20/95
	//4/20/95 add WIP Actual VAluation
	//4/25/95 chip upr 1470, new monthend sutie rept
	//•061295  MLB  UPR 1640 add costed bill & hold inventory
	//•071495  MLB  UPR 1672
	//•080195  MLB  UPR 213
	//•082295  MLB Aged Excess
	//•090195  MLB  moved assignments to palette before phases
	//• 2/28/97 cs removed code initializing ◊ PI arrays upt 1858
	//•6/19/97 cs upr 1872 changed requisition reports
End if 

//*Estimates
ARRAY TEXT:C222(<>aEstRptPop; 0)
//*RM
ARRAY TEXT:C222(<>aRMRptPop; 0)

ARRAY TEXT:C222(<>aRMGPRptPop; 2)
<>aRMGPRptPop{1}:="RM Group Report"
<>aRMGPRptPop{2}:="Items Report (By Group)"

//*FG see arrFGreports
ARRAY TEXT:C222(<>aFGRptPop; 0)  //upr 1439 2/22/95 add 2 and reorder see doFGRptRecords

//*Month End Suite
ARRAY TEXT:C222(<>MthEndSuite; 0)  //see arrMthEndSuite
//*Requisitioning
ARRAY TEXT:C222(<>aReqRptPop; 0)
//*Purchasing
ARRAY TEXT:C222(<>aPORptPop; 0)

ARRAY TEXT:C222(<>aCIDRptPop; 2)
<>aCIDRptPop{1}:="PO Clause Summary"
<>aCIDRptPop{2}:="PO Clause Listing"
//*Vendors
ARRAY TEXT:C222(<>aVenRptPop; 0)
//*CC
ARRAY TEXT:C222(<>aCCGPRptPop; 0)

ARRAY TEXT:C222(<>aCCRptPop; 0)

//*Salemen
ARRAY TEXT:C222(<>aSaleRptPop; 0)
//*Customer
ARRAY TEXT:C222(<>aCustRptPop; 0)
//*Bookings
ARRAY TEXT:C222(<>aBkRptPop; 0)

//*API
ARRAY TEXT:C222(<>aAPIRptPop; 0)

//*Contacts
ARRAY TEXT:C222(<>aContRptPop; 0)  //contacts file

//◊aContRptPop{2}:="Labels"
//*Orders
ARRAY TEXT:C222(<>aCORptPop; 0)
//*Jobs and WIP
ARRAY TEXT:C222(<>aJobRptPop; 0)

ARRAY TEXT:C222(<>aQARptPop; 0)
ARRAY TEXT:C222(<>aPopPandP; 0)
ARRAY TEXT:C222(<>aPopPK; 0)
//*End of Procedure
//