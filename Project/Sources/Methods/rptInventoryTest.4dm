//%attributes = {"publishedWeb":true}
//Method: rptInventoryTest(dDateBegin;dDateEnd)  022699  MLB
//print a report showing period inventory balance
//•051899  mlb try to validate the dates choozen on monthendsuite
//•072099  mlb  UPR 2056 add by cost option
//•3/03/00  mlb chg'g dDateBegin &/| dDateEnd is nasty on monthend suite
//CPN   BB  +IN  -OUT  -EB  ERR

C_DATE:C307($1; $2)
C_LONGINT:C283($3; iBB; iIN; iOUT; iEB; iERR; iADJ)
C_LONGINT:C283(rb1; rb2; rb3; rb4; rb6; rb5)

If (Count parameters:C259>=2)
	dDateBegin:=$1
	dDateEnd:=$2
	ALL RECORDS:C47([Finished_Goods_Inv_Summaries:64])
	DISTINCT VALUES:C339([Finished_Goods_Inv_Summaries:64]DateFrozen:8; $aDates)
	SORT ARRAY:C229($aDates; >)
	
	$begin:=Find in array:C230($aDates; dDateBegin)
	If ($begin=-1)
		If (Size of array:C274($aDates)>1)
			dDateBegin:=$aDates{Size of array:C274($aDates)-1}
		End if 
	End if 
	
	$end:=Find in array:C230($aDates; dDateEnd)
	If ($end=-1) | (dDateEnd<=dDateBegin)
		If (Size of array:C274($aDates)>1)
			dDateEnd:=$aDates{Size of array:C274($aDates)}
		End if 
	End if 
End if 

If (Count parameters:C259=1)  //!00/00/00
	ALL RECORDS:C47([Finished_Goods_Inv_Summaries:64])
	ORDER BY:C49([Finished_Goods_Inv_Summaries:64]; [Finished_Goods_Inv_Summaries:64]DateFrozen:8; >)
	dDateBegin:=[Finished_Goods_Inv_Summaries:64]DateFrozen:8
	LAST RECORD:C200([Finished_Goods_Inv_Summaries:64])
	dDateEnd:=[Finished_Goods_Inv_Summaries:64]DateFrozen:8
End if 

//*get the BB
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	CREATE EMPTY SET:C140([Finished_Goods_Inv_Summaries:64]; "BBset")
	SET QUERY DESTINATION:C396(Into set:K19:2; "BBset")
	QUERY:C277([Finished_Goods_Inv_Summaries:64]; [Finished_Goods_Inv_Summaries:64]DateFrozen:8=dDateBegin; *)
	QUERY:C277([Finished_Goods_Inv_Summaries:64];  & ; [Finished_Goods_Inv_Summaries:64]z_Group:10="_~BAL")
	
	//*get the ending period records
	CREATE EMPTY SET:C140([Finished_Goods_Inv_Summaries:64]; "EBset")
	SET QUERY DESTINATION:C396(Into set:K19:2; "EBset")
	QUERY:C277([Finished_Goods_Inv_Summaries:64]; [Finished_Goods_Inv_Summaries:64]DateFrozen:8=dDateEnd)
	
	//*get the in between transactions if any
	CREATE EMPTY SET:C140([Finished_Goods_Inv_Summaries:64]; "MIDset")
	SET QUERY DESTINATION:C396(Into set:K19:2; "MIDset")
	QUERY:C277([Finished_Goods_Inv_Summaries:64]; [Finished_Goods_Inv_Summaries:64]DateFrozen:8>dDateBegin; *)
	QUERY:C277([Finished_Goods_Inv_Summaries:64];  & ; [Finished_Goods_Inv_Summaries:64]DateFrozen:8<dDateEnd; *)
	QUERY:C277([Finished_Goods_Inv_Summaries:64];  & ; [Finished_Goods_Inv_Summaries:64]z_Group:10#"_~BAL")
	
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	//*merge the selections
	CREATE EMPTY SET:C140([Finished_Goods_Inv_Summaries:64]; "ResultSet")
	UNION:C120("BBset"; "EBset"; "ResultSet")
	UNION:C120("MIDset"; "ResultSet"; "ResultSet")
	USE SET:C118("ResultSet")
	
	CLEAR SET:C117("BBset")
	CLEAR SET:C117("EBset")
	CLEAR SET:C117("MIDset")
	CLEAR SET:C117("ResultSet")
	
Else 
	
	QUERY BY FORMULA:C48([Finished_Goods_Inv_Summaries:64]; \
		(\
		([Finished_Goods_Inv_Summaries:64]DateFrozen:8=dDateBegin)\
		 & ([Finished_Goods_Inv_Summaries:64]z_Group:10="_~BAL")\
		)\
		 | \
		([Finished_Goods_Inv_Summaries:64]DateFrozen:8=dDateEnd)\
		 | \
		(\
		([Finished_Goods_Inv_Summaries:64]DateFrozen:8>dDateBegin)\
		 & ([Finished_Goods_Inv_Summaries:64]DateFrozen:8<dDateEnd)\
		 & ([Finished_Goods_Inv_Summaries:64]z_Group:10#"_~BAL")\
		)\
		)
	
End if   // END 4D Professional Services : January 2019 

rb1:=0
rb2:=0
rb3:=0
rb4:=0
rb5:=0
rb6:=0

If (Count parameters:C259=3)  //•072099  mlb  UPR 2056
	FORM SET OUTPUT:C54([Finished_Goods_Inv_Summaries:64]; "INV_Equation2")
	util_PAGE_SETUP(->[Finished_Goods_Inv_Summaries:64]; "INV_Equation2")
	ORDER BY:C49([Finished_Goods_Inv_Summaries:64]; [Finished_Goods_Inv_Summaries:64]ProductCode:11; >)
Else 
	FORM SET OUTPUT:C54([Finished_Goods_Inv_Summaries:64]; "INV_Equation")
	util_PAGE_SETUP(->[Finished_Goods_Inv_Summaries:64]; "INV_Equation")
	ORDER BY:C49([Finished_Goods_Inv_Summaries:64]; [Finished_Goods_Inv_Summaries:64]ProductCode:11; >)
End if 

BREAK LEVEL:C302(1)
ACCUMULATE:C303(iBB; iIN; iOUT; iEB; iERR; iADJ)
PDF_setUp(<>pdfFileName)
PRINT SELECTION:C60([Finished_Goods_Inv_Summaries:64]; *)
FORM SET OUTPUT:C54([Finished_Goods_Inv_Summaries:64]; "List")

If (Count parameters:C259>=2)  //•3/03/00  mlb  reset to prior falue
	dDateBegin:=$1
	dDateEnd:=$2
End if 