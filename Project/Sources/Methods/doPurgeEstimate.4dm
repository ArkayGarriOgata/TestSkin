//%attributes = {"publishedWeb":true}
//(p) doPurgeEstimate
//this code moved from DoPurge to simplify that procedure
//• 11/6/97 cs created
//• 12/18/97 cs modifed so that estimating archive ACTULLY archives and
//not just deltes (has been a problem since purging first started
//• 3/30/98 cs clear sets
//•061499  mlb arrest deletion of header in the "*" conditions
//•092999  mlb  UPR 1987  don't consider Closed Jobs and Orders and other chgs

C_LONGINT:C283($i; $Error)
C_TEXT:C284(xTitle; xText; $Defaultpath; $Destination)
C_TEXT:C284($OverFlow)
ARRAY TEXT:C222(aEstimate; r56)

$OverFlow:=""

doPurgeEstimateRptCounts(1)
uPurgeEstUnify  //*Unify sets created in dialog 
doPurgeEstimateRptCounts(2)
uPurgeEstUnify(1)
MESSAGES OFF:C175

uThermoInit(r56; "Purging "+String:C10(r56; "###,##0")+" Estimates, press Esc to stop.")
$Error:=0
$Destination:=<>purgeFolderPath+"Estimatesƒ"

If (Test path name:C476($Destination)=0)  //if folder doesnot exist create it
	$Error:=NewFolder($Destination)
End if 

If ($Error=0)  //folder created
	$Destination:=$Destination+":"  //add directory marker  
	USE SET:C118("DeleteThese")
	FIRST RECORD:C50([Estimates:17])
	
	For ($i; 1; r56)
		If (<>fContinue)
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]EstimateNo:3=[Estimates:17]EstimateNo:1; *)
			QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]Status:10#"Closed")  //•092999  mlb  don't keep them around so long
			If (Records in selection:C76([Customers_Orders:40])=0)
				
				QUERY:C277([Jobs:15]; [Jobs:15]EstimateNo:6=[Estimates:17]EstimateNo:1; *)  //•070595 MLB
				QUERY:C277([Jobs:15];  & ; [Jobs:15]Status:4#"Closed")
				If (Records in selection:C76([Jobs:15])=0)  //*.   Free to delete, not on job or order                
					If (fLockNLoad(->[Estimates:17]))
						aEstimate{$i}:=[Estimates:17]EstimateNo:1
						QryPurgeEstprts
						uPurgeEstCount
						doPurgeEstBits  //• 12/18/97 cs 
					End if   //not locked
					
				Else   // on a job
					aEstimate{$i}:=doPurgeEstimateRetention([Jobs:15]CaseScenario:7; "j")
				End if 
				
			Else   //on an order
				aEstimate{$i}:=doPurgeEstimateRetention([Customers_Orders:40]CaseScenario:4; "o")
			End if   //no orders
			
		Else   //break
			$i:=$i+r56  //not continue
		End if 
		uThermoUpdate($i)
		NEXT RECORD:C51([Estimates:17])
	End for 
	
	uThermoClose
	MESSAGE:C88(Char:C90(13)+" doing Est archives/deletions...")
	
	USE SET:C118("DeleteThese")  //•061499  mlb  
	CREATE SET:C116([Estimates:17]; Table name:C256(->[Estimates:17]))  //•061499  mlb
	doPurgeEstBits($Destination)  //• 12/18/97 cs flag says Killem
	FLUSH CACHE:C297
	
	SORT ARRAY:C229(aEstimate; >)
	For ($i; 1; r56)
		If (Length:C16(xText)<30000)
			xText:=xText+aEstimate{$i}+"   "
		Else 
			xText:=xText+Char:C90(13)+"_____________ SEE CONTINUED RPT______________"+String:C10(4d_Current_time; <>HMMAM)
			rPrintText("ESTIMATE_PURGE"+$OverFlow+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; ""))
			$OverFlow:=$OverFlow+"*"
			xText:="Continued..."+Char:C90(13)
		End if 
	End for 
	
	doPurgeEstimateRptCounts(3)
	
	If ($OverFlow#"")
		xTitle:=xTitle+" (Continued)"
	End if 
	rPrintText("ESTIMATE_PURGE"+$OverFlow+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; ""))
	
	xTitle:=""
	xText:=""
	
Else 
	xText:="Folder for Estimating archives could not be created/opened."+Char:C90(13)+"Folder name was: "+$Destination
	rPrintText("EST_PURGE_ERR"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; ""))
End if   //folder created

CLEAR SET:C117("DeleteThese")
REDUCE SELECTION:C351([Jobs:15]; 0)
REDUCE SELECTION:C351([Estimates_Carton_Specs:19]; 0)
REDUCE SELECTION:C351([Estimates:17]; 0)