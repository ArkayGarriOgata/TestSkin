//%attributes = {"publishedWeb":true}
//rRptWip_ActHrs called by doJobRptRecords  4/24/95
//    provide material, labor, & burden of jobs using
//    actual hours at standard rate
C_REAL:C285(r1; r2; r3; r4; r5; r6)
C_TEXT:C284(t2; t2b; t3; t10)
C_BOOLEAN:C305(fSave)
C_DATE:C307(nextPeriod)
C_TEXT:C284($month; $year; $nextYr; $nextMth)
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Raw_Materials_Transactions:23])
READ ONLY:C145([Cost_Centers:27])
util_PAGE_SETUP(->[Job_Forms:42]; "WIPActualValuat")
PRINT SETTINGS:C106
If (ok=1)
	//provide an option to save the report to diskfile.
	fSave:=False:C215
	uConfirm("Would you like to also save this report in Excel format?"; "Save file"; "Don't save")
	If (ok=1)
		vDoc:=Create document:C266("")
		If (ok=1)
			fSave:=True:C214
		End if 
	End if 
	
	//find the period of interest
	$month:=Request:C163("What month"; String:C10((Month of:C24(4D_Current_date)-1); "00"))
	$year:=Request:C163("What year"; Substring:C12(String:C10(Year of:C25(4D_Current_date); "0000"); 3; 2))
	$period:=$year+$month
	SET WINDOW TITLE:C213(fNameWindow(->[Job_Forms:42])+" WIP Actuals Valuation for "+$period)
	Case of 
		: ($month="12")
			$nextYr:=String:C10(Num:C11($year)+1; "00")
			nextPeriod:=Date:C102("01/01/"+$nextYr)
		Else 
			$nextmth:=String:C10(Num:C11($month)+1; "00")
			nextPeriod:=Date:C102($nextmth+"/01/"+$year)
	End case 
	
	t2:="A R K A Y   P A C K A G I N G"
	t2b:="W I P   V A L U A T I O N   A T   A C T U A L   H O U R S"
	t3:="Jobs with Closing Balances in Period "+$period+", Sorted by Job Form Nº"
	dDate:=4D_Current_date
	tTime:=4d_Current_time
	
	If (fSave)
		SEND PACKET:C103(vDoc; String:C10(dDate; 2)+Char:C90(9)+Char:C90(9)+t2+Char:C90(13))
		SEND PACKET:C103(vDoc; String:C10(tTime; 5)+Char:C90(9)+Char:C90(9)+t2b+Char:C90(13))
		SEND PACKET:C103(vDoc; Char:C90(9)+Char:C90(9)+t3+Char:C90(13)+Char:C90(13))
		SEND PACKET:C103(vDoc; "Job Form"+Char:C90(9)+"Customer"+Char:C90(9)+"Material"+Char:C90(9)+"Labor"+Char:C90(9)+"Burden"+Char:C90(9))
		SEND PACKET:C103(vDoc; "Total"+Char:C90(9)+"Cartons"+Char:C90(9)+"Hours"+Char:C90(13)+Char:C90(13))
	End if 
	
	
	
	If (fSave)
		CLOSE DOCUMENT:C267(vDoc)
	End if 
	
	MESSAGES ON:C181
End if   // print settings
FORM SET OUTPUT:C54([Job_Forms:42]; "List")

//