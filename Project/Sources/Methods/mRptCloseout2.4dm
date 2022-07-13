//%attributes = {"publishedWeb":true}
//(P) mRptCloseout2: Produces Job Closeout Report
//040196 TJF 
//50596 TJF
//52896 TJF
//replaces procedure mRptCloseout
// adds a batch feature to the previous procedure to batch load jobs
//the Close-out reports are  produced as a group
//• 12/9/97 cs added var to header layout/assigned here so the header can be used 
//  on 2 different reports

READ ONLY:C145([Job_Forms:42])  //042996 TJF
READ ONLY:C145([Jobs:15])  //042996 TJF

DIALOG:C40([Job_Forms:42]; "GroupClose")  //```````````````````
ERASE WINDOW:C160
zDefFilePtr:=->[Job_Forms:42]

MESSAGES OFF:C175

If (OK=1)
	If (aJobNo#"")
		ARRAY TEXT:C222(aRpt; 1)
		ARRAY TEXT:C222(aJFID; 1)
		aRpt{1}:="√"
		aJFID{1}:=aJobNo
	End if 
	util_PAGE_SETUP(->[Job_Forms:42]; "CloseoutRept_H1")  //use the settings saved in design(80%)   
	PRINT SETTINGS:C106
	If (OK=1)
		<>fContinue:=True:C214
		ON EVENT CALL:C190("eCancelPrint")
		For ($i; 1; Size of array:C274(aRpt))
			If (aRpt{$i}="√")  //*for each job, print jobclosout,waste and save jobclosesummary record.
				MESSAGE:C88(aJFID{$i}+Char:C90(13))
				
				QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=aJFID{$i})
				doJobCloseOut
				If (Not:C34(<>fContinue))
					$i:=$i+Size of array:C274(aRpt)
				End if 
			End if 
		End for 
		ON EVENT CALL:C190("")
	End if 
End if 

MESSAGES ON:C181