//%attributes = {"publishedWeb":true}
//(p) NewIssuing
//new system for issuing Materials to job
//Records are created in [IssueTicket] table by VF
//this is a patch into the automatic system to fill the interim
//between when the new system is implemented VF and current (11/5/97)
//• 11/5/97 cs created

C_POINTER:C301(zDefFilePtr; FilePtr)
C_TEXT:C284(sFile)
C_LONGINT:C283(FileNum)

READ WRITE:C146([Job_Forms_Issue_Tickets:90])  //set up for new records
NewWindow(383; 287; 2; 0; "Material Issues")
FORM SET INPUT:C55([Job_Forms_Issue_Tickets:90]; "input")
FilePtr:=->[Job_Forms_Issue_Tickets:90]
zDefFilePtr:=filePtr
SET MENU BAR:C67(<>DefaultMenu)  //Apple File Edit Window
sFile:=Table name:C256(filePtr)
fileNum:=Table:C252(filePtr)

Repeat   //add new issue records until user cancels (done)
	ADD RECORD:C56([Job_Forms_Issue_Tickets:90]; *)
Until (OK=0)

//look to see if there are any manually entered material issues
QUERY:C277([Job_Forms_Issue_Tickets:90]; [Job_Forms_Issue_Tickets:90]Posted:4=0; *)
QUERY:C277([Job_Forms_Issue_Tickets:90];  & ; [Job_Forms_Issue_Tickets:90]tsTimeStamp:7=0)  //hand entered, VF enters this value
CLOSE WINDOW:C154

If (Records in selection:C76([Job_Forms_Issue_Tickets:90])>0)  //if ther are process them
	NewWindow(175; 30; 2; -720)
	MESSAGE:C88("Posting Material Issues...")
	Batch_VFIssue("*")  //patch into batch to allow only manual (those just entered)
End if 