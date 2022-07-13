//%attributes = {"publishedWeb":true}
//(P) uPageChange: Page processing
//4/28/95 chip removed incorect useage of self
//• 7/10/98 cs JMI selection gets lost on transfer page

C_LONGINT:C283($1)  //pop-up element selected
C_BOOLEAN:C305($0)  //valid change

If ($1=0)  //dragged off pop-up
	$0:=False:C215
	// Self»:=Layout page`4/28/95 sanityCheck detected error
	$1:=FORM Get current page:C276
Else 
	FORM GOTO PAGE:C247($1)
	$0:=True:C214
End if 