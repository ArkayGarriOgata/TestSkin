//%attributes = {}

// Method: uInit_CostCenterGroups ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/29/14, 07:53:53
// ----------------------------------------------------
// Description
// moved from uInitInterP to here so could be called by on server startup w/o baggage
//
// ----------------------------------------------------

// Modified by: Mel Bohince (1/28/19) swithc to QWA
//set up the arrays from the datafile's [Cost_Centers]cc_Group
// Modified by: Mel Bohince (1/30/19) qry for <>aBLANKERS didn't close the query
// Modified by: Mel Bohince (11/19/19) add the 421 Primefire
// Modified by: Mel Bohince (7/6/21) typo in new data "based" method


//#################
//WHEN ADDING A COST CENTER, IN ADDITION TO THE <>IP'S BELOW AND CREATING THE NEWBIE IN THE COST_CENTERS TABLE:
// see also PS_SetReadyColors  , Schedule menu, make a PS_ShowXXX, PS_EventOnOutsideCall,  PS_setHeaderPictures, PS_PressSchedule
// If you add code here, add it to PS_qryPrintingOnly, uInitInterPrsVar, MainEventCase, CostCenterEquivalent, and Object Method: [zz_control].MainEvent.Schedule1.
// and RM_AQ_Coating_Usage
//#################
//#################
If (False:C215)  //old way
	//READ ONLY([Cost_Centers])
	
	//<>GLUERS:=" 476 477 478 479 480 481 482 483 484 485 487 491 493 503 505 "  //change gluers in CostCenterEquivalent also
	//ARRAY TEXT(<>aGLUERS;0)
	//QUERY([Cost_Centers];[Cost_Centers]cc_Group="80.FINISHING")
	//SELECTION TO ARRAY([Cost_Centers]ID;<>aGLUERS)
	
	//<>STAMPERS:=" 451 452 454 455  "  //453 461 462
	//ARRAY TEXT(<>aSTAMPERS;0)
	//QUERY([Cost_Centers];[Cost_Centers]cc_Group="50.STAMPING")
	//SELECTION TO ARRAY([Cost_Centers]ID;<>aSTAMPERS)
	
	//<>PRESSES:=" 417 418 419 420 421 "  //  (10/23/13) Added 418.. see also RM_AQ_Coating_Usage 412, 415 416
	//  // Modified by: Mel Bohince (6/20/18) added 420
	//ARRAY TEXT(<>aPRESSES;0)
	//QUERY([Cost_Centers];[Cost_Centers]cc_Group="20.PRINTING";*)
	//QUERY([Cost_Centers]; & [Cost_Centers]ProdCC=True)
	//SELECTION TO ARRAY([Cost_Centers]ID;<>aPRESSES)
	
	//<>BLANKERS:=" 467 468 469 470 471 490 492 "  // (7/31/13) Added 466`   (12/5/13) rename 466 to 470
	//ARRAY TEXT(<>aBLANKERS;0)
	//QUERY([Cost_Centers];[Cost_Centers]cc_Group="55.BLANKING";*)
	//QUERY([Cost_Centers]; | ;[Cost_Centers]cc_Group="90.STRIPPING")  // Modified by: Mel Bohince (1/30/19) removed asteric
	//SELECTION TO ARRAY([Cost_Centers]ID;<>aBLANKERS)
	
	//<>SHEETERS:=" 428 429 "  //426 427
	//<>COATERS:=""  //" 471 472 "  //
	
	//<>PLATEMAKING:=" 402 403 "  //• mlb - 11/21/02  11:48 `401 
	//<>LAMINATERS:="473 474 475 "  // • mel (4/8/05, 15:30:34)
	//<>EMBOSSERS:=" 552 554 555 561 568 569 562 565 "  //553 562 563
	//<>WINDOWERS:=" 486 472 "  // Modified by: Mel Bohince (10/10/17) 
	
	//REDUCE SELECTION([Cost_Centers];0)
	
	
Else   //new way
	
	
	//for each costcenter group, set up an IP text varible that is used in legacy code as a switch in a case stmt and an id array used in 'IN' queries
	C_OBJECT:C1216($cc_es)  //Costcenter entity selections
	C_COLLECTION:C1488($ccID_c)  //Costcenter ID collections
	
	//set up to loop thru each group using legacy IP variables
	ARRAY TEXT:C222(<>aGLUERS; 0)  // IP arrays used in QUERY SELECTION WITH ARRAY
	ARRAY TEXT:C222(<>aSTAMPERS; 0)
	ARRAY TEXT:C222(<>aPRESSES; 0)
	ARRAY TEXT:C222(<>aBLANKERS; 0)
	ARRAY TEXT:C222(<>aLAMINATERS; 0)
	ARRAY TEXT:C222(<>aWINDOWERS; 0)
	ARRAY TEXT:C222(<>aSHEETERS; 0)
	
	C_TEXT:C284(<>GLUERS; <>STAMPERS; <>PRESSES; <>BLANKERS; <>LAMINATERS; <>WINDOWERS; <>SHEETERS)  // these are for case stmts like :(postion(cc;<>GLUERS)>0)
	
	ARRAY POINTER:C280($ccStringPtr; 7)
	ARRAY POINTER:C280($ccArrayPtr; 7)
	ARRAY TEXT:C222($ccGroups; 7)
	
	$ccGroups{1}:="80.FINISHING"
	$ccStringPtr{1}:=-><>GLUERS
	$ccArrayPtr{1}:=-><>aGLUERS
	
	$ccGroups{2}:="50.STAMPING"
	$ccStringPtr{2}:=-><>STAMPERS
	$ccArrayPtr{2}:=-><>aSTAMPERS
	
	$ccGroups{3}:="20.PRINTING"
	$ccStringPtr{3}:=-><>PRESSES
	$ccArrayPtr{3}:=-><>aPRESSES
	
	$ccGroups{4}:="55.BLANKING"  // Modified by: Mel Bohince (7/6/21) typo
	$ccStringPtr{4}:=-><>BLANKERS
	$ccArrayPtr{4}:=-><>aBLANKERS
	
	$ccGroups{5}:="70.ACETATE LAMINATOR"  // Modified by: Mel Bohince (7/6/21) 
	$ccStringPtr{5}:=-><>LAMINATERS
	$ccArrayPtr{5}:=-><>aLAMINATERS
	
	$ccGroups{6}:="75.WINDOWING"  // Modified by: Mel Bohince (7/6/21) 
	$ccStringPtr{6}:=-><>WINDOWERS
	$ccArrayPtr{6}:=-><>aWINDOWERS
	
	$ccGroups{7}:="30.SHEETING"  // Modified by: Mel Bohince (7/6/21) 
	$ccStringPtr{7}:=-><>SHEETERS
	$ccArrayPtr{7}:=-><>aSHEETERS
	
	For ($ccGroup; 1; Size of array:C274($ccGroups))
		//see PROTOTYPE below before refactoring
		$cc_es:=ds:C1482.Cost_Centers.query("cc_Group = :1"; $ccGroups{$ccGroup})
		If ($cc_es.length>0)
			
			$ccID_c:=$cc_es.toCollection("ID").orderBy("ID")
			COLLECTION TO ARRAY:C1562($ccID_c; $ccArrayPtr{$ccGroup}->; "ID")  // IP array used in queries,  
			ARRAY TO COLLECTION:C1563($ccID_c; $ccArrayPtr{$ccGroup}->)  //strip of the property name to set up for join
			$ccStringPtr{$ccGroup}->:=$ccID_c.join(" ")  //change gluers in CostCenterEquivalent also
		End if 
		
	End for 
	
	//PROTOTYPE:
	//$cc_es:=ds.Cost_Centers.query("cc_Group = :1";"80.FINISHING")
	//If ($cc_es.length>0)
	
	//$ccID_c:=$cc_es.toCollection("ID").orderBy("ID")
	//COLLECTION TO ARRAY($ccID_c;<>aGLUERS;"ID")   // IP array used in queries,  
	//ARRAY TO COLLECTION($ccID_c;<>aGLUERS)//strip of the property name to set up for join
	//$gluers->:=$ccID_c.join(" ")
	//  //this could be different, so no loopie
	//<>GLUERS:=" 476 477 478 479 480 481 482 483 484 485 487 491 493 503 505 "  //change gluers in CostCenterEquivalent also
	//End if 
	
	//TODO
	//<>SHEETERS:=" 428 429 "  //426 427
	<>COATERS:=""  //" 471 472 "  //
	
	<>PLATEMAKING:=" 402 403 "  //• mlb - 11/21/02  11:48 `401 
	//<>LAMINATERS:="473 474 475 "  // • mel (4/8/05, 15:30:34)
	<>EMBOSSERS:=" 552 554 555 561 568 569 562 565 "  //553 562 563
	//<>WINDOWERS:=" 486 472 "  // Modified by: Mel Bohince (10/10/17)
	
End if   //new way

