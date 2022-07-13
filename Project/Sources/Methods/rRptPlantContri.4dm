//%attributes = {"publishedWeb":true}
//Procedure: rRptPlantContri()  120197  MLB UPR 239
//called by rRptMthEndSuite 
//report of Sales Value and PV by mfg plant each month.
//this will be based on the submitted machine tickets
//also, add the billings for the same period and allocate
//them back to the plants
//•011298  MLB  UPR 1914 scale billing's costs to the level billed in period
//• 5/1/98 cs Mel forgot to open a document to write to
//•052098  MLB Second attempt. This time, only base on what billed
//•051999  mlb  eliminate DIV/0
//in the time period. Apply the actual OOP & budget Matl against
//the job in proportion to what shipped Method used: 
//1) Get all the billings for the specified period, summed by jobform 
//2) Get the total revenue potential for each jobform at latest order price 
//3) Calculate percent of jobform sold (item1/item2) in this period 
//4) Get the"planned" material cost for each of those jobforms 
//5) Get actual labor and burden costs reported against each job, summed by 
//    jobform, but segregated by Plant, then calculate percent for allocation 
//6) Allocate the periods revenue to each plant ( item1 x item5 )
//7) Proportion costs (items 4 & 5) by amount of job sold (item3)in period
//8) Calculate contributions per plant as (Rev-Matl-Labor-Burden)
//9) Calculate margins as contribution / revenue, by plant 

MESSAGES OFF:C175
NewWindow(245; 80; 3; -722; "Plant Contribution")
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Cost_Centers:27])
READ ONLY:C145([Finished_Goods_Transactions:33])
C_TEXT:C284(<>ROANOKE_WC; <>ROANOKE_CCs)  //" 402 403 411 412 443 468 476 477 478 492 493 "
<>ROANOKE_CCs:=<>ROANOKE_WC
C_DATE:C307($today)
$today:=4D_Current_date
C_TIME:C306($now; $docRef)
$now:=4d_Current_time

$title:=fYYMMDD($today)+String:C10($now; HH MM SS:K7:1)
$title:=Replace string:C233($title; "/"; "")
$title:=Replace string:C233($title; ":"; "")
//*   Establish date boundaries
If (Count parameters:C259=2)
	$dateFrom:=$1
	$dateTo:=$2
Else   //default to current month
	$dateFrom:=Date:C102(String:C10(Month of:C24($today))+"/1/"+String:C10(Year of:C25($today)))
	$dateTo:=Date:C102(String:C10(Month of:C24($today)+1)+"/1/"+String:C10(Year of:C25($today)))-1
End if 
C_TEXT:C284($cr; $t)
$cr:=Char:C90(13)
$t:=Char:C90(9)

$docRef:=?00:00:00?
If (fSave)
	docName:="PlantContribution-"+$title
	$docRef:=util_putFileName(->docName)
	If ($docRef=?00:00:00?)
		BEEP:C151
		MESSAGE:C88(" Plant Contribution Report could not open a disk file."+$cr)
	Else 
		MESSAGE:C88(" Filename:PlantContribution-"+$title+$cr)
	End if 
End if 
READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
util_PAGE_SETUP(->[zz_control:1]; "PrintTextLandsc")
FORM SET OUTPUT:C54([zz_control:1]; "PrintTextLandsc")
PDF_setUp(<>pdfFileName)
//*Load Costcenter collection
CostCtrCurrent("init"; "00/00/00")

MESSAGE:C88(" Calculating from "+String:C10($dateFrom; <>MIDDATE)+" to "+String:C10($dateTo; <>MIDDATE)+$cr)

C_LONGINT:C283($i; $numJobs)

//*Calculate Billings in period (build Jobform collection)
MESSAGE:C88(" Analyzing the Billings data"+$cr)
$numJobs:=CalcPlantBillin($dateFrom; $dateTo)

USE SET:C118("allJobs")  //created in proc above
CLEAR SET:C117("allJobs")
MachineTick("init")  //*Load the related Machine Tickets into a collection

MachineTick("apply")  //*Move costs into the jobforms
MachineTick("kill")  //*clear the MT's
//CostCtrCurrent ("kill")  //*clear the CC's

MESSAGE:C88(" Printing the report"+$cr)
//*Print the report
C_TEXT:C284($Header; xTitle; xText)
$Header:="     P L A N T   C O N T R I B U T I O N S   "+$cr
$Header:=$Header+"      for the period from "+String:C10($dateFrom; <>MIDDATE)+" to "+String:C10($dateTo; <>MIDDATE)+$cr
$Header:=$Header+"      calculated at "+String:C10($now; <>HHMM)+" on "+String:C10($today; <>MIDDATE)+$cr+$cr

xTitle:="P L A N T   C O N T R I B U T I O N S   "+"for period: "+String:C10($dateFrom; <>MIDDATE)+" to "+String:C10($dateTo; <>MIDDATE)+",  calculated at "+String:C10($now; <>HHMM)+" on "+String:C10($today; <>MIDDATE)

$linesOnPage:=48
$pageNum:=0
$diskPage:=""
$colTitles:="Jobform"+$t+"%Billed"+$t+"  %Haup"+$t+"  %Roan"+$t+"   Rev Haup"+$t+"   Rev Roan"+$t+"  Matl Haup"+$t+"   Matl Roan"+$t+" Labor Haup"+$t+" Labor Roan"
$colTitles:=$colTitles+$t+"Burden Haup"+$t+"Burden Roan"+$t+"ContribHaup"+$t+"ContribRoan"+$t+"Margin Haup"+$t+"Margin Roan"+$t+"MachTicks From"+$cr
$prnTitles:="Jobform "+"      %"+"    % Allocation"+"       Revenue "+"       Material    "+"     Labor        "+"   Burden   "+"    Contribution"+"      % Margin    "+$cr
$prnTitles:=$prnTitles+"         Billed"+("    Haup    Roan"*7)+$cr

If ($docRef#?00:00:00?)
	$diskHead:=$Header+$colTitles
	SEND PACKET:C103($docRef; $diskHead)
	$range:=String:C10($numJobs+6)+")"
	$diskLine:="TOTALS:"+$t+""+$t+""+$t+""+$t
	$diskLine:=$diskLine+"=SUM(E7:E"+$range+$t+"=SUM(F7:F"+$range+$t
	$diskLine:=$diskLine+"=SUM(G7:G"+$range+$t+"=SUM(H7:H"+$range+$t
	$diskLine:=$diskLine+"=SUM(I7:I"+$range+$t+"=SUM(J7:J"+$range+$t
	$diskLine:=$diskLine+"=SUM(K7:K"+$range+$t+"=SUM(L7:L"+$range+$t
	$diskLine:=$diskLine+"=SUM(M7:M"+$range+$t+"=SUM(N7:N"+$range+$t
	$diskLine:=$diskLine+"=M6/E6"+$t+"=N6/F6"+$t+$cr
	SEND PACKET:C103($docRef; $diskLine)
End if 
$diskHead:=""
$diskLine:=""

C_REAL:C285($pC; $pH; $pR; $rH; $rR; $mH; $mR; $LH; $LR; $bH; $bR; $ctH; $ctR; $gH; $gR; $rHtot; $rRtot; $ctHtot; $ctRtot)
$rHtot:=0
$rRtot:=0
$ctHtot:=0
$ctRtot:=0
For ($i; 1; $numJobs)
	$linesOnPage:=$linesOnPage+1
	If ($linesOnPage>48)  //start a new print page
		$pageNum:=$pageNum+1
		xText:=xText+(130*" ")+"page: "+String:C10($pageNum)+$cr+$prnTitles
		$linesOnPage:=4
	End if 
	//*Calc data
	If (aSalesValue{$i}#0)
		$pC:=aRevPeriod{$i}/aSalesValue{$i}
	Else 
		$pC:=0
	End if 
	
	If (aTotalCost{$i}#0)
		$pH:=Round:C94(((aHaupLabor{$i}+aHaupBurden{$i})/aTotalCost{$i}); 2)
	Else 
		$pH:=0
	End if 
	$pR:=1-$pH  //Round(((aRoanLabor{$i}+aRoanBurden{$i})/aTotalCost{$i});2)
	
	$rH:=Round:C94(($pH*aRevPeriod{$i}); 0)
	$rR:=Round:C94((aRevPeriod{$i}-$rH); 0)
	
	$mH:=Round:C94(($pH*($pC*aMaterial{$i})); 0)
	$mR:=Round:C94((($pC*aMaterial{$i})-$mH); 0)
	
	$LH:=Round:C94(($pC*aHaupLabor{$i}); 0)
	$LR:=Round:C94(($pC*aRoanLabor{$i}); 0)
	
	$bH:=Round:C94(($pC*aHaupBurden{$i}); 0)
	$bR:=Round:C94(($pC*aRoanBurden{$i}); 0)
	
	$ctH:=$rH-$mH-$LH-$bH
	$ctR:=$rR-$mR-$LR-$bR
	
	$rHtot:=$rHtot+$rH
	$rRtot:=$rRtot+$rR
	$ctHtot:=$ctHtot+$ctH
	$ctRtot:=$ctRtot+$ctR
	
	$gH:=0
	$gR:=0
	
	If ($ctH#0) & ($rH#0)
		$gH:=Round:C94(($ctH/$rH); 2)
	Else 
		$gH:=0
	End if 
	If ($ctR#0) & ($rR#0)
		$gR:=Round:C94(($ctR/$rR); 2)
	Else 
		$gR:=0
	End if 
	
	If ($docRef#?00:00:00?)  //*    DiskLine
		$diskLine:=aJob{$i}+$t+String:C10((Round:C94($pC; 2)); "##0.00")+$t+String:C10($pH; "##0.00")+$t+String:C10($pR; "##0.00")+$t
		$diskLine:=$diskLine+String:C10($rH)+$t+String:C10($rR)+$t
		$diskLine:=$diskLine+String:C10($mH)+$t+String:C10($mR)+$t
		$diskLine:=$diskLine+String:C10($LH)+$t+String:C10($LR)+$t
		$diskLine:=$diskLine+String:C10($bH)+$t+String:C10($bR)+$t
		$diskLine:=$diskLine+String:C10($ctH)+$t+String:C10($ctR)+$t
		$diskLine:=$diskLine+String:C10($gH; "##0.00")+$t+String:C10($gR; "##0.00")+$t
		$diskLine:=$diskLine+aTickFrom{$i}+$cr
		$diskPage:=$diskPage+$diskLine
	End if 
	
	//*    PrintLine
	$t:=" "
	$printLine:=aJob{$i}+String:C10((Round:C94($pC; 2)); "^^^0.00")+$t+String:C10($pH; "^^^0.00")+$t+String:C10($pR; "^^^0.00")+$t
	$printLine:=$printLine+String:C10($rH; "^^^,^^0")+$t+String:C10($rR; "^^^,^^0")+$t
	$printLine:=$printLine+String:C10($mH; "^^^,^^0")+$t+String:C10($mR; "^^^,^^0")+$t
	$printLine:=$printLine+String:C10($LH; "^^^,^^0")+$t+String:C10($LR; "^^^,^^0")+$t
	$printLine:=$printLine+String:C10($bH; "^^^,^^0")+$t+String:C10($bR; "^^^,^^0")+$t
	$printLine:=$printLine+String:C10($ctH; "^^^,^^0")+$t+String:C10($ctR; "^^^,^^0")+$t
	$printLine:=$printLine+String:C10($gH; "^^^0.00")+$t+String:C10($gR; "^^^0.00")+$t
	$printLine:=$printLine+$cr
	$t:=Char:C90(9)
	xText:=xText+$printLine
	
	If (Length:C16(xText)>31000) | (Length:C16($diskPage)>31000)
		FIRST RECORD:C50([zz_control:1])
		PRINT SELECTION:C60([zz_control:1]; *)
		xText:=""
		If ($docRef#?00:00:00?)
			SEND PACKET:C103($docRef; $diskPage)
		End if 
		
		$printPage:=""
		$diskPage:=""
	End if 
	
End for 

//*Totals
$t:=" "

$printLine:="TOTALS: "+String:C10((Round:C94(0; 2)); "^^^^.^^")+$t+String:C10(0; "^^^^.^^")+$t+String:C10(0; "^^^^.^^")+$t
$printLine:=$printLine+String:C10($rHtot; "^^^^^^0")+$t+String:C10($rRtot; "^^^^^^0")+$t
$printLine:=$printLine+String:C10(0; "^^^,^^^")+$t+String:C10(0; "^^^,^^^")+$t
$printLine:=$printLine+String:C10(0; "^^^,^^^")+$t+String:C10(0; "^^^,^^^")+$t
$printLine:=$printLine+String:C10(0; "^^^,^^^")+$t+String:C10(0; "^^^,^^^")+$t
$printLine:=$printLine+String:C10($ctHtot; "^^^,^^0")+$t+String:C10($ctRtot; "^^^,^^0")+$t
If ($rHtot#0)
	$printLine:=$printLine+String:C10(($ctHtot/$rHtot); "^^^0.00")+$t
Else 
	$printLine:=$printLine+String:C10(0; "^^^0.00")+$t
End if 
If ($rRtot#0)
	$printLine:=$printLine+String:C10(($ctRtot/$rRtot); "^^^0.00")+$t
Else 
	$printLine:=$printLine+String:C10(0; "^^^0.00")+$t
End if 
$printLine:=$printLine+$cr
$t:=Char:C90(9)
xText:=xText+$printLine

//*Print the last page
If (Length:C16(xText)>0) | (Length:C16($diskPage)>0)
	FIRST RECORD:C50([zz_control:1])
	PRINT SELECTION:C60([zz_control:1]; *)
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; $diskPage)
		SEND PACKET:C103($docRef; $cr+$cr+$cr+"------ END OF PLANT CONTRIBUTION ------")
	End if 
End if 

//*Clean up
CLOSE WINDOW:C154
Job_Form("init"; "0")  //*   clear the jobs
$diskPage:=""
xText:=""
xTitle:=""
If ($docRef#?00:00:00?)
	CLOSE DOCUMENT:C267($docRef)
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
End if 

FORM SET OUTPUT:C54([zz_control:1]; "List")
REDUCE SELECTION:C351([zz_control:1]; 0)
BEEP:C151