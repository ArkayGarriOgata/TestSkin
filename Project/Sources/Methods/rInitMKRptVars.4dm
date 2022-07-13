//%attributes = {"publishedWeb":true}
//9p) rinitMKRptVars - MK -> Mary Kay
//initialize the report vars (process) that are usd in this report
//$1 - (optional) - string - anything flag reset ONLY subtotals to zero
//10/15/97 cs created

If (Count parameters:C259=0)
	sCPN:=""
	sPoNo:=""
	sDesc:=""
	dDate1:=!00-00-00!
	dDate:=4D_Current_date
	rReal1:=0
	rReal2:=0
	rReal3:=0
	rReal4:=0
	rReal5:=0
	rReal6:=0
	rReal7:=0
	rReal8:=0
	rReal9:=0
	rReal10:=0
	rReal1t:=0
	rReal2t:=0
	rReal3t:=0
	rReal4t:=0
	rReal5t:=0
	rReal6t:=0
	rReal7t:=0
	rReal8t:=0
	rReal9t:=0
	rReal10t:=0
	xText:=""
	iPage:=1
End if 
rReal1a:=0
rReal2a:=0
rReal3a:=0
rReal4a:=0
rReal5a:=0
rReal6a:=0
rReal7a:=0
rReal8a:=0
rReal9a:=0
rReal10a:=0