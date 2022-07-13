//%attributes = {}


ttVer:=""
xlVer:=0
//ttVer:=GetDBVers   //v3.9.7-PJK (8/6/14)
$ttVers:=Request:C163("Enter New Version"; ttVer)
If (OK=1)
	//SetDBVers ($ttVers)  //v3.9.7-PJK (8/6/14)
End if 