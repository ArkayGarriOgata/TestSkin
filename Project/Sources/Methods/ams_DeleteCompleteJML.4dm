//%attributes = {"publishedWeb":true}
//PM: ams_DeleteCompleteJML() -> 
//@author mlb - 7/2/02  17:44
$mth3Ago:=Add to date:C393(Current date:C33; 0; -3; 0)

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15#!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15<$mth3Ago)

util_DeleteSelection(->[Job_Forms_Master_Schedule:67])