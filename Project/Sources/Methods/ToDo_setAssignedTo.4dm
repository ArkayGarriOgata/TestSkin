//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 01/25/06, 14:01:40
// ----------------------------------------------------
// Method: ToDo_setAssignedTo
// Description
// hash of responsibilities, see also uInitInterPrsVar
//◊GLUERS:=" 476 477 478 480 481 482 483 484 485 487 488 489 491 493 470 479 " 
//◊PRESSES:=" 411 412 413 414 415 416 417 419 "
//◊BLANKERS:=" 462 468 490 492 469 "
//◊STAMPERS:=" 451 452 453 454 455 461 "
//◊SHEETERS:=" 426 427 428 425 "
//◊COATERS:=" 471 472 "  `
//◊PLATEMAKING:=" 401 402 403 "  `• mlb - 11/21/02  11:48
//◊LAMINATERS:="473 474"  ` • mel (4/8/05, 15:30:34)
//◊EMBOSSERS:=" 552 553 554 555 561 562 563 568 "
// Parameters
//key
// ----------------------------------------------------
Case of 
	: (Position:C15($1; <>SHEETERS)>0)
		$0:="Keith Long"
		
	: (Position:C15($1; <>PRESSES)>0)
		$0:="Ed Griffin"
		
	: (Position:C15($1; <>STAMPERS)>0)
		$0:="Matt Shiels"
		
	: (Position:C15($1; <>EMBOSSERS)>0)
		$0:="Matt Shiels"
		
	: (Position:C15($1; <>COATERS)>0)
		$0:="Ed Griffin"
		
	: (Position:C15($1; <>PLATEMAKING)>0)
		$0:="Eric Simon"
		
	: (Position:C15($1; <>LAMINATERS)>0)
		$0:="Matt Shiels"
		
	: (Position:C15($1; <>BLANKERS)>0)
		$0:="Matt Shiels"
		
	: (Position:C15($1; <>GLUERS)>0)
		$0:="James Burd"
		
	Else   //just reflect it back
		$0:=$1
End case 
