//%attributes = {"publishedWeb":true}
//PM: User_ResolveInitials(initials) -> username
//@author mlb - 8/22/02  14:03
C_TEXT:C284($1; $0)
READ ONLY:C145([Users:5])
QUERY:C277([Users:5]; [Users:5]Initials:1=$1)
$0:=[Users:5]UserName:11
REDUCE SELECTION:C351([Users:5]; 0)