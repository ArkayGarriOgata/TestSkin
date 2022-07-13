//%attributes = {}
// Method: qryLaunch () -> 
// ----------------------------------------------------
// by: mel: 05/06/04, 12:57:39
// ----------------------------------------------------
// Modified by: Mel Bohince (9/13/16) ignore the submitted field

C_LONGINT:C283($0)
C_TEXT:C284($1)

Case of 
	: (Count parameters:C259=0)  //is launch
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]DateLaunchReceived:84#!00-00-00!; *)
		QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]OriginalOrRepeat:71="Original")
		
	: (Count parameters:C259=1)
		Case of 
			: ($1="NotSubmitted")
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]DateLaunchReceived:84#!00-00-00!; *)
				QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]OriginalOrRepeat:71="Original"; *)
				QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]DateLaunchSubmitted:93=!00-00-00!)
				
			: ($1="NotApproved")  // Modified by: Mel Bohince (9/13/16) ignore the submitted field
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]DateLaunchReceived:84#!00-00-00!; *)
				QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]OriginalOrRepeat:71="Original"; *)
				//QUERY([Finished_Goods]; & ;[Finished_Goods]DateLaunchSubmitted#!00/00/0000!;*)
				QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]DateLaunchApproved:85=!00-00-00!)
		End case 
		
End case 

$0:=Records in selection:C76([Finished_Goods:26])


