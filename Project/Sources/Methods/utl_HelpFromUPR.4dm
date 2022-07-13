//%attributes = {"publishedWeb":true}
//PM:  utl_HelpFromUPR  3/01/00  mlb
//present content of a UPR
C_LONGINT:C283($1)  //the upr
utl_LogIt("init")
READ ONLY:C145([Usage_Problem_Reports:84])
QUERY:C277([Usage_Problem_Reports:84]; [Usage_Problem_Reports:84]Id:1=$1)
If (Records in selection:C76([Usage_Problem_Reports:84])>0)
	utl_LogIt("UPR Nº "+String:C10([Usage_Problem_Reports:84]Id:1)+":  "+[Usage_Problem_Reports:84]Subject:12+" --Released in version: "+[Usage_Problem_Reports:84]VersionRelease:24; 0)
	
	utl_LogIt(Char:C90(13)+"DESCRIPTION:"; 0)
	utl_LogIt([Usage_Problem_Reports:84]Description:13; 0)
	
	utl_LogIt(Char:C90(13)+"EXAMPLE:"; 0)
	utl_LogIt([Usage_Problem_Reports:84]Example:14; 0)
	
	utl_LogIt(Char:C90(13)+"NEW DESIGN:"; 0)
	utl_LogIt([Usage_Problem_Reports:84]NewDesign:15; 0)
	
	utl_LogIt(Char:C90(13)+"*** USAGE INFO: ***"; 0)
	utl_LogIt([Usage_Problem_Reports:84]UsageInfo:16; 0)
	REDUCE SELECTION:C351([Usage_Problem_Reports:84]; 0)
Else 
	BEEP:C151
End if 
//