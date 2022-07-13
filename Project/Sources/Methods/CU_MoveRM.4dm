//%attributes = {"publishedWeb":true}
//(p) x_MoveSubGroup
//temp proc to ahelp in cleaning up RM data
//requests new subgroup and lets user select one or mre existing
//subgroups to move into the primary subgroup

uWinListCleanup
C_TEXT:C284(tSubGroup; xText; xTitle)
ARRAY TEXT:C222(aText; 0)
ARRAY TEXT:C222(aSubgroup; 0)
ARRAY TEXT:C222(axText; 0)
ARRAY TEXT:C222(aBullet; 0)
C_LONGINT:C283(i4)
C_REAL:C285(iComm)
ARRAY TEXT:C222(aCommCode; 0)

LIST TO ARRAY:C288("CommCodes"; aCommCode)

uDialog("MoveRM"; 560; 300; 8)
uWinListCleanup