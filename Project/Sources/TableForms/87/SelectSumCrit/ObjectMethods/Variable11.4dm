
$FstMthYear:=vFstMthYr
//*determine month of report, prior months and YTD months
$CDate:=4D_Current_date
vDTo:=$CDate-Day of:C23($CDate)
vDFrom:=vDTo-(Day of:C23(vDTo))+1
$LMonth:=Month of:C24(vDTo)
If ($LMonth>=$FstMthYear)
	$LYear:=Year of:C25(vDTo)
Else 
	$LYear:=Year of:C25(vDTo)-1
End if 
aTimes{1}{1}:=vDFrom
aTimes{1}{2}:=vDTo
aTimes{2}{1}:=Date:C102(String:C10($FstMthYear)+"/1/"+String:C10($LYear))
aTimes{2}{2}:=vDTo-(Day of:C23(vDTo))
aTimes{3}{1}:=aTimes{2}{1}
aTimes{3}{2}:=vDTo

If ($LMonth=$FstMthYear)
	OBJECT SET ENABLED:C1123(drb2; False:C215)  //if your looking at the first month of the year,there are no priors
	OBJECT SET ENABLED:C1123(drb3; False:C215)
	OBJECT SET ENABLED:C1123(cbAllTotals; False:C215)
	cbAllTotals:=0
Else 
	OBJECT SET ENABLED:C1123(drb2; True:C214)  //if your looking at the first month of the year,there are no priors
	OBJECT SET ENABLED:C1123(drb3; True:C214)
	OBJECT SET ENABLED:C1123(cbAllTotals; True:C214)
	cbAllTotals:=1
End if 