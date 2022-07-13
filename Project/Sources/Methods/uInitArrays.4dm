//%attributes = {"publishedWeb":true}
//(P) 0CompileArray
//4/19/95 make terms array larger 35 char
//Upr 0235 general comple tim e fixes  Chip 12/9/96
//•1/30/97 - cs - changed 4 arrays (used in fgBatchInventor) to interprocess

//---------------- Standard Arrays ------------------
ARRAY DATE:C224(adRelTemp; 0)  //Temporary array for RelateSelection
ARRAY INTEGER:C220(aiRelTemp; 0)  //Temporary array for RelateSelection
ARRAY LONGINT:C221(alRelTemp; 0)  //Temporary array for RelateSelection
ARRAY POINTER:C280(aSlctField; 0)  //array used by uSelectSetter
ARRAY TEXT:C222(axRelTemp; 0)  //Temporary array for RelateSelection
ARRAY TEXT:C222(axText; 0)  //temporary text array
//---------------- Non-Standard Arrays ------------------
ARRAY TEXT:C222(<>aAskMeHistory; 0)
ARRAY TEXT:C222(aOL; 0)  //Order Lines
ARRAY TEXT:C222(<>asReordPol; 0)
ARRAY TEXT:C222(<>asReordDesc; 0)
ARRAY TEXT:C222(asReordPolx; 0)
ARRAY TEXT:C222(<>asInkType; 0)
ARRAY TEXT:C222(<>asInkDesc; 0)
ARRAY TEXT:C222(asInkTypex; 0)
ARRAY TEXT:C222(<>asPressType; 0)
ARRAY TEXT:C222(<>asPressDesc; 0)
ARRAY TEXT:C222(asPrsTypex; 0)
ARRAY TEXT:C222(<>asIssueType; 0)
ARRAY TEXT:C222(<>asIssueDesc; 0)
ARRAY TEXT:C222(asIssTypex; 0)
ARRAY TEXT:C222(<>asRecType; 0)
ARRAY TEXT:C222(<>asRecDesc; 0)
ARRAY TEXT:C222(asRecTypex; 0)
ARRAY TEXT:C222(<>asTermsDesc; 0)  //4/19/95
ARRAY TEXT:C222(asTermsDesc; 0)
ARRAY TEXT:C222(aORqty; 0)
ARRAY LONGINT:C221(aORund; 0)
ARRAY LONGINT:C221(aORove; 0)
//UPR 0235 just general fixes
//ARRAY TEXT(◊aCommand;0)  `execute dialog commands defined as text
ARRAY TEXT:C222(<>aFileStruct; Get last table number:C254; 0)  //file names, and field names
ARRAY TEXT:C222(<>puFields; 0)  //pop up array for fields
ARRAY TEXT:C222(<>puOper; 0)  //pop up array for operators (+-etc)

//•1/30/97 cs- add these arrays to batch interprocess group
ARRAY LONGINT:C221(<>aQty_CC; 0)
ARRAY LONGINT:C221(<>aQty_FG; 0)
ARRAY LONGINT:C221(<>aQty_EX; 0)
ARRAY LONGINT:C221(<>aQty_BH; 0)
ARRAY TEXT:C222(<>aPrinterNames; 0)

CAR_Locations("size"; 0)