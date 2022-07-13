//%attributes = {"publishedWeb":true}
//(P) mReport: Accesses 4D Adhoc Reporting

If (fAdHocLocal)  //on output list
	gReport
Else   //selected from splash screen
	uSpawnProcess("gReportProcess"; 32000; "REPORTING"; True:C214; True:C214)
	If (False:C215)  //list called procedures for 4D Insider
		gReportProcess
	End if 
End if 
SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)