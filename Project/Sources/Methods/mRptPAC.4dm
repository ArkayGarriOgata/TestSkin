//%attributes = {"publishedWeb":true}
//(P) mRptPAC: Produces Production Analysis Report (Cumulative)

SET MENU BAR:C67(5)
DEFAULT TABLE:C46([Job_Forms_Machine_Tickets:61])
iPage:=0
aFrom:=""
aTo:=""
aPrevCC:=""
dPrevDate:=!00-00-00!
aPrevMach:=""
gZeroCY
gZeroLY
gZeroCum
uInitMonths
//uCenterWindow (260;130;1;"")
//uCenterWindow (450;260;1;"")
ALL RECORDS:C47([Job_Forms_Machine_Tickets:61])
DIALOG:C40([Job_Forms_Machine_Tickets:61]; "Select4.5B")
CLOSE WINDOW:C154
zDefFilePtr:=->[Job_Forms_Machine_Tickets:61]
MESSAGES OFF:C175

If (OK=1)
	dFrom:=4D_Current_date
	dTo:=4D_Current_date
	If (Month of:C24(4D_Current_date)<4)
		$YY_From:=Substring:C12(String:C10(Year of:C25(4D_Current_date)-1); 3; 2)
		$YY_To:=Substring:C12(String:C10(Year of:C25(4D_Current_date)); 3; 2)
	Else 
		$YY_From:=Substring:C12(String:C10(Year of:C25(4D_Current_date)); 3; 2)
		$YY_To:=Substring:C12(String:C10(Year of:C25(4D_Current_date)); 3; 2)
	End if 
	$MM_From:="04"
	If (Month of:C24(4D_Current_date)<10)
		$MM_To:="0"+String:C10(Month of:C24(4D_Current_date))
	Else 
		$MM_To:=String:C10(Month of:C24(4D_Current_date))
	End if 
	
	$LYY:=String:C10(Num:C11($YY_From)-1; "00")
	gGetDate($LYY; "04")
	dLYFrom:=dFrom
	gGetDate($YY_From; "03")
	dLYTo:=dTo
	
	gGetDate($YY_From; $MM_From)
	$HoldFrom:=dFrom
	gGetDate($YY_To; $MM_To)
	dFrom:=$HoldFrom
	$MM:=Month of:C24(dTo)
	If ($MM>3)
		zzend:=$MM-3
	Else 
		zzend:=$MM+9
	End if 
	aFromP:=$MM_From+"/"+$YY_From
	xText:=$MM_To+"/"+$YY_To
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dLYFrom; *)
	QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dTo)
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0)
		ALERT:C41("No records found!!!")
	Else 
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >)
		
		FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "ProdAnalCum_H")
		SET WINDOW TITLE:C213("PRODUCTION ANALYSIS REPORT (Cumulative)")
		util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "ProdAnalCum_H")
		POST KEY:C465(13)
		PRINT SETTINGS:C106
		//util_PAGE_SETUP(->[MACH_ACT_JOB];"ProdAnalCum_H")
		If (OK=1)
			For ($i; 1; Records in selection:C76([Job_Forms_Machine_Tickets:61]))
				If ([Job_Forms_Machine_Tickets:61]CostCenterID:2#aPrevMach)
					If (aPrevMach#"")
						PAGE BREAK:C6
						gPrintem
					End if 
					aPrevMach:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
					gZeroCum
				End if 
				If ([Job_Forms_Machine_Tickets:61]DateEntered:5<=dLYTo)
					gSumLY
				Else 
					gSumCY
				End if 
				NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
			End for 
			If (aPrevMach#"")
				PAGE BREAK:C6
				gPrintem
				PAGE BREAK:C6
			End if 
		End if 
		FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "List")
		gSetWindTitle
	End if 
End if 

MESSAGES ON:C181