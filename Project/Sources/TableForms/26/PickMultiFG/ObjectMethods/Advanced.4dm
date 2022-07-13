// -------
// Method: [Finished_Goods].PickMultiFG.Advanced   ( ) ->
// By: Mel Bohince @ 04/21/18, 09:57:43
// Description
// add the release date (week) and the stock to make combo's easier to configure
// ----------------------------------------------------

// Modified by: Mel Bohince (4/18/18)
// Modified by: Mel Bohince (2/25/21) add progress bar and use ORDA, wow!

EST_PickFGAdvanced(->aCPN)  // Modified by: Mel Bohince (2/25/21) add progress bar and use ORDA, wow!

//READ ONLY([Customers_ReleaseSchedules])
// see also JML_get1stRelease, JMI_get1stRelease, REL_getNextRelease



//C_LONGINT($outerBar;$outerLoop;$out)  // Added by: Mel Bohince (6/26/20) progress indicator
//$outerBar:=Progress New   //new progress bar
//Progress SET BUTTON ENABLED ($outerBar;True)  // stop button
//Progress SET TITLE ($outerBar;"Looking for Releases and Board...")
//$outerLoop:=Size of array(aCPN)
//$out:=0
//For ($i;1;Size of array(aCPN))
//$out:=$out+1
//Progress SET PROGRESS ($outerBar;$out/$outerLoop)
//Progress SET MESSAGE ($outerBar;aCPN{$i}+"  "+String($out)+" of "+String($outerLoop)+" @ "+String(100*$out/$outerLoop;"###%"))
//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]ProductCode=aCPN{$i};*)
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]OpenQty>0;*)
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]THC_State>0;*)
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]Sched_Date#!00-00-00!)

//If (Records in selection([Customers_ReleaseSchedules])>0)
//If (Not(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET

//ARRAY DATE($aDate;0)
//SELECTION TO ARRAY([Customers_ReleaseSchedules]Sched_Date;$aDate)
//REDUCE SELECTION([Customers_ReleaseSchedules];0)
//SORT ARRAY($aDate;>)

//aNextRelease{$i}:=$aDate{1}
//Else 
//  //Fixe after Mel bug
//C_DATE($_date_min)
//$_date_min:=Min([Customers_ReleaseSchedules]Sched_Date)

//aNextRelease{$i}:=$_date_min

//End if   // END 4D Professional Services : January 2019 

//aWeek{$i}:=util_weekNumber (aNextRelease{$i})
//Else 
//aNextRelease{$i}:=<>magic_date
//aWeek{$i}:=99
//End if 

//aStock{$i}:=FG_getStock (aCPN{$i})
//End for 

//Progress QUIT ($outerBar)
//  // end Modified by: Mel Bohince (4/18/18) 

//If (Not(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET

//Else 
//REDUCE SELECTION([Customers_ReleaseSchedules];0)

//End if   // END 4D Professional Services : January 2019 
