//%attributes = {}
// -------
// Method: FGL_RecertificationCandidate   ( ) ->
// By: Mel Bohince @ 02/07/19, 08:18:33
// Description
//report on inventory requiring re-certification due to age
// and likelyhood of shipping soon

// rewrite of REL_getRecertificationRequired by adding 
// relation on [Finished_Goods_Locations]jobit to [Job_Forms_Items]jobit
// and relation on [Finished_Goods_Locations]custid to [Customers]id
// ----------------------------------------------------

READ ONLY:C145([Finished_Goods_Locations:35])
C_DATE:C307($certificationFence; $dateReleasedFrom; $dateReleasedTo)
C_TEXT:C284($forecastedRelease)

$certificationFence:=Add to date:C393(Current date:C33; 0; -6; 0)  //arbitray biz rule, quality degrades with time
$dateReleasedFrom:=Add to date:C393(Current date:C33; 0; 0; -7)  //candidates scheduled to ship soon
$dateReleasedTo:=Add to date:C393(Current date:C33; 0; 0; 7)
$forecastedRelease:="<@"  //leading angle bracket is convention for forecasts

$benchmark:=True:C214  //benchmark

If ($benchmark)
	$testComment:=Request:C163("Name of test:"; "related search "; "Go"; "Go anyway")
	$startMillisec:=Milliseconds:C459  //benchmark
End if 
QUERY:C277([Finished_Goods_Locations:35]; [Customers:16]ReCertRequired:38=True:C214; *)
QUERY:C277([Finished_Goods_Locations:35]; [Job_Forms_Items:44]Glued:33<$certificationFence; *)  //date of production over 6 months
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Certified:41<$certificationFence; *)  //not recently certified or never certified
QUERY:C277([Finished_Goods_Locations:35]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //only open releases
QUERY:C277([Finished_Goods_Locations:35]; [Customers_ReleaseSchedules:46]Sched_Date:5>=$dateReleasedFrom; *)  //limit horizon
QUERY:C277([Finished_Goods_Locations:35]; [Customers_ReleaseSchedules:46]Sched_Date:5<=$dateReleasedTo; *)  //limit horizon
QUERY:C277([Finished_Goods_Locations:35]; [Customers_ReleaseSchedules:46]CustomerRefer:3#$forecastedRelease)  //not forecasts

If ($benchmark)
	$durationSec:=(Milliseconds:C459-$startMillisec)/1000  //benchmark
	utl_Logfile("benchmark.log"; Current method name:C684+": "+$testComment+" took "+String:C10($durationSec)+" seconds")
End if 
ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aBin; 0)
ARRAY TEXT:C222($aJobit; 0)
ARRAY LONGINT:C221($aQty; 0)

SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]Location:2; $aBin; [Finished_Goods_Locations:35]Jobit:33; $aJobit; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
MULTI SORT ARRAY:C718($aCPN; >; $aBin; >; $aJobit; $aQty)

C_LONGINT:C283($i; $numElements)
$numElements:=Size of array:C274($aCPN)
C_TEXT:C284($text; $filename)
$text:="ProductCode\tLocation\tJobit\tQty\r"

For ($i; 1; $numElements)
	$text:=$text+$aCPN{$i}+"\t"+$aBin{$i}+"\t"+$aJobit{$i}+"\t"+String:C10($aQty{$i})+"\r"
End for 

If (Count parameters:C259>0)  //email report to QA
	$distributionList:=Batch_GetDistributionList(""; "QA_MOVE")
	EMAIL_Sender("RE-CERT REQUIRED"; ""; $text; $distributionList)
Else   //just open in excel
	$filename:=util_DocumentPath("get")+"RE-CERT_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	TEXT TO DOCUMENT:C1237($filename; $text)
	$err:=util_Launch_External_App($filename)
End if 

