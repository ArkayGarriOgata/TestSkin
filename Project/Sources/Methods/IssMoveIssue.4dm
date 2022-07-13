//%attributes = {"publishedWeb":true}
//(p) IssMoveIssue
//allow user to move an existing issue from one (incorrect jobform)
//to another
//• 8/5/98 cs created
READ WRITE:C146([Raw_Materials_Transactions:23])
READ ONLY:C145([Job_Forms:42])
uDialog("MoveIssues"; 360; 300; 4; "")
//