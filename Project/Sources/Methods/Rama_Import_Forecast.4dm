//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/11/12, 10:48:29
// ----------------------------------------------------
// Method: Rama_Import_Forecast
// Description
// OBSOLETE
// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($line)
C_DATE:C307($today)
C_TEXT:C284(COMPARE_CUSTID; $plant)
C_TIME:C306($docRef)
C_TEXT:C284($errorMsg)
C_BOOLEAN:C305($continue; $quit)
C_TEXT:C284($t; $r)
C_LONGINT:C283($countOfColumns; $col; <>pid_RamaIF)

If (Count parameters:C259=0)
	If (<>pid_RamaIF=0)
		<>pid_RamaIF:=New process:C317("Rama_Import_Forecast"; <>lMidMemPart; "Process's Name"; "init")
		
	Else 
		SHOW PROCESS:C325(<>pid_RamaIF)
		BRING TO FRONT:C326(<>pid_RamaIF)
	End if 
	
Else 
	Case of 
		: ($1="init")
			$errorMsg:=""
			$today:=4D_Current_date
			COMPARE_CUSTID:="00199"
			$plant:="02563"  //"01666"
			
			$t:=","  //Char(9)
			$r:=Char:C90(13)
			$quit:=True:C214
			$continue:=True:C214
			$countOfColumns:=10
			$version:=fYYMMDD($today)
			zwStatusMsg("IMPORT"; "Find a Cayey Forecast 'CSV' document.")
			$docRef:=Open document:C264("")
			$continue:=($docRef#?00:00:00?)
			If ($continue)  //opened document
				zwStatusMsg("IMPORT"; "Reading "+document)
				
				//delete prior forecasts
				uConfirm("Delete prior forecasts to '"+$plant+"'"; "OK"; "Abort")
				If (ok=1)
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="<FDS>@"; *)  //only the forecasts
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=COMPARE_CUSTID; *)  //for liz arden
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10=$plant)  //at this shipto
					util_DeleteSelection(->[Customers_ReleaseSchedules:46])
					
				Else 
					$continue:=False:C215
				End if 
				
				//import new forecasts
				If ($continue)
					RECEIVE PACKET:C104($docRef; $line; $r)  //get the begin date and period dates
					util_TextParser($countOfColumns; $line; 44; 13)
					ARRAY DATE:C224($aWeek; $countOfColumns)
					
					For ($col; 2; $countOfColumns)  //get date titles
						$aWeek{$col}:=Date:C102(util_TextParser($col))
					End for 
					
					RECEIVE PACKET:C104($docRef; $line; $r)
					While (Length:C16($line)>8)
						util_TextParser($countOfColumns; $line; 44; 13)
						
						$currentCPN:=txt_Trim(Substring:C12(util_TextParser(1); 1; 13))
						QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=(COMPARE_CUSTID+":"+$currentCPN))
						
						For ($col; 2; $countOfColumns)
							$consumption:=Num:C11(util_TextParser($col))
							If ($consumption>0)
								CREATE RECORD:C68([Customers_ReleaseSchedules:46])
								[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
								[Customers_ReleaseSchedules:46]Shipto:10:=$plant
								[Customers_ReleaseSchedules:46]Billto:22:="N/A"
								[Customers_ReleaseSchedules:46]ProductCode:11:=$currentCPN
								[Customers_ReleaseSchedules:46]CustomerLine:28:=[Finished_Goods:26]Line_Brand:15
								[Customers_ReleaseSchedules:46]Sched_Date:5:=$aWeek{$col}
								[Customers_ReleaseSchedules:46]Sched_Qty:6:=$consumption
								[Customers_ReleaseSchedules:46]CustomerRefer:3:="<FDS>"+$version
								[Customers_ReleaseSchedules:46]EDI_Disposition:36:=$version
								[Customers_ReleaseSchedules:46]OpenQty:16:=$consumption
								[Customers_ReleaseSchedules:46]CustID:12:=COMPARE_CUSTID
								[Customers_ReleaseSchedules:46]Entered_Date:34:=$today
								[Customers_ReleaseSchedules:46]ModDate:18:=$today
								[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
								[Customers_ReleaseSchedules:46]CreatedBy:46:="RAMA"
								[Customers_ReleaseSchedules:46]THC_State:39:=9
								[Customers_ReleaseSchedules:46]PayU:31:=1
								[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Finished_Goods:26]ProjectNumber:82
								SAVE RECORD:C53([Customers_ReleaseSchedules:46])
							End if 
						End for 
						
						RECEIVE PACKET:C104($docRef; $line; $r)
					End while 
					
					BEEP:C151
					zwStatusMsg("IMPORT"; "Closing "+document)
					CLOSE DOCUMENT:C267($docRef)
					
				End if   //continue - deleted priors
			End if   //opened doc
	End case 
	
	<>pid_RamaIF:=0
End if 