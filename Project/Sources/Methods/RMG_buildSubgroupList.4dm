//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/10/06, 12:49:30
// ----------------------------------------------------
// Method: RMG_buildSubgroupList
// Description
// build an array of subgroups for a given commodity or all
//
// Parameters commodity code and pointer to array to load
// ----------------------------------------------------

ARRAY TEXT:C222($2->; 0)

READ ONLY:C145([Raw_Materials_Groups:22])

If ($1=0)
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]SubGroup:10#"")
Else 
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=$1; *)
	QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]SubGroup:10#"")  //remove blanks from list
End if 

DISTINCT VALUES:C339([Raw_Materials_Groups:22]SubGroup:10; $2->)
REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)