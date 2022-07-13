//%attributes = {}
// _______
// Method: EST_PickFGAdvanced   ( ) ->
// By: Mel Bohince @ 02/25/21, 12:28:52
// Description
// use ORDA and remove fg w/o releases, works on arrays
// from the listbox in [Finished_Goods];"PickMultiFG"
// ----------------------------------------------------
// Modified by: Mel Bohince (3/3/21) change THC_State>0 to THC_State>3, that is, things not met by inventory or wip

C_COLLECTION:C1488($candidateFG_c; $fgWithRel_c)
$candidateFG_c:=New collection:C1472
ARRAY TO COLLECTION:C1563($candidateFG_c; aCPN)
C_DATE:C307($earliestDate)
C_LONGINT:C283($hit)

C_OBJECT:C1216($openReleases_es)
$openReleases_es:=ds:C1482.Customers_ReleaseSchedules.query("OpenQty>:1 and THC_State>3 and Sched_Date#:3 and ProductCode in :4"; 0; 0; !00-00-00!; $candidateFG_c)
$fgWithRel_c:=$openReleases_es.distinct("ProductCode")

C_LONGINT:C283($outerBar; $outerLoop; $out)  //progress indicator
$outerBar:=Progress New  //new progress bar
Progress SET BUTTON ENABLED($outerBar; True:C214)  // stop button
Progress SET TITLE($outerBar; "Looking for Releases and Board...")
$outerLoop:=$fgWithRel_c.length
$out:=0

For each ($cpn; $fgWithRel_c)
	$out:=$out+1
	Progress SET PROGRESS($outerBar; $out/$outerLoop)
	Progress SET MESSAGE($outerBar; $cpn+"  "+String:C10($out)+" of "+String:C10($outerLoop)+" @ "+String:C10(100*$out/$outerLoop; "###%"))
	
	$earliestDate:=$openReleases_es.query("ProductCode = :1"; $cpn).min("Sched_Date")
	$hit:=Find in array:C230(aCPN; $cpn)
	
	If ($hit>-1)
		aNextRelease{$hit}:=$earliestDate
		aWeek{$hit}:=util_weekNumber($earliestDate)
		aStock{$hit}:=FG_getStock($cpn)
	End if   //$hit
	
End for each 

Progress QUIT($outerBar)

//now remove elements which didn't get a week number
SORT ARRAY:C229(aWeek; ListBox1; aSelected; aLi; aCPN; aDesc; aOutline; aPSpec; aStock; aNextRelease; <)
$hit:=Find in array:C230(aWeek; 0)
$hit:=$hit-1

ARRAY BOOLEAN:C223(ListBox1; $hit)
ARRAY TEXT:C222(aSelected; $hit)
ARRAY LONGINT:C221(aLi; $hit)
ARRAY TEXT:C222(aCPN; $hit)
ARRAY TEXT:C222(aDesc; $hit)
ARRAY TEXT:C222(aOutline; $hit)
ARRAY TEXT:C222(aPSpec; $hit)
ARRAY INTEGER:C220(aWeek; $hit)
ARRAY TEXT:C222(aStock; $hit)
ARRAY DATE:C224(aNextRelease; $hit)

SORT ARRAY:C229(aWeek; ListBox1; aSelected; aLi; aCPN; aDesc; aOutline; aPSpec; aStock; aNextRelease; >)
