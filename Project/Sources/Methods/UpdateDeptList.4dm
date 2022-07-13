//%attributes = {"publishedWeb":true}
//(p) UpdateDeptList
//• 10/27/97 cs created
//update both Department list and Approval list
//• 11/13/97 cs update interprocess list

MESSAGES OFF:C175
ALL RECORDS:C47([y_accounting_departments:4])
SELECTION TO ARRAY:C260([y_accounting_departments:4]DepartmentID:1; $Depts; [y_accounting_departments:4]Description:4; $Desc)
SORT ARRAY:C229($Desc; $Depts; >)
ARRAY TEXT:C222($List; Records in selection:C76([y_accounting_departments:4]))
uClearSelection(->[y_accounting_departments:4])

For ($i; 1; Size of array:C274($List))
	$List{$i}:=$Depts{$i}+" - "+$Desc{$i}
End for 
//SORT ARRAY($List;>)
ARRAY TO LIST:C287($List; "Departments")
ARRAY TEXT:C222(<>aDepartment; Size of array:C274($List))
COPY ARRAY:C226($List; <>aDepartment)

QUERY:C277([y_accounting_departments:4]; [y_accounting_departments:4]UseForApprvDept:2=True:C214)
SELECTION TO ARRAY:C260([y_accounting_departments:4]DepartmentID:1; $Depts; [y_accounting_departments:4]Description:4; $Desc)
SORT ARRAY:C229($Desc; $Depts; >)
ARRAY TEXT:C222($List; Records in selection:C76([y_accounting_departments:4]))
uClearSelection(->[y_accounting_departments:4])

For ($i; 1; Size of array:C274($List))
	$List{$i}:=$Depts{$i}+" - "+$Desc{$i}
End for 
//SORT ARRAY($List;>)
ON ERR CALL:C155("eArray2List")  //• 11/13/97 cs start
ARRAY TO LIST:C287($List; "GeneralDeptCodes")  //place into structure list

If (<>fContinue)  //if this worked OK
	ARRAY TEXT:C222(<>aGenDepts; Size of array:C274($List))
	COPY ARRAY:C226($List; <>aGenDepts)  //• 11/13/97 cs update interprocess list
Else 
	ALERT:C41("Update to internal 'General Department Code' lists could not be performed."+Char:C90(13)+"Please inform System Administrator.")
End if 
ON ERR CALL:C155("")  //clear error call
//• 11/13/97 cs  end
MESSAGES ON:C181