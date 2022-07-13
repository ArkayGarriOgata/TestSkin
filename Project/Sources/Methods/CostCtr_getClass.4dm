//%attributes = {}
// -------
// Method: CostCtr_getClass   ( c/c ) -> class(aka group)
// By: Mel Bohince @ 10/19/16, 10:02:13
// Description
// determine what group a cc belongs too
// see also uInit_CostCenterGroups
// ----------------------------------------------------

C_TEXT:C284($1; $cc; $0)
$cc:=$1

Case of 
	: (Length:C16($cc)<3)  //no cheating
		$0:="unknown"
		
	: (Position:C15($cc; <>SHEETERS)>0)
		$0:="sheeter"
		
	: (Position:C15($cc; <>PRESSES)>0)
		$0:="printer"
		
	: (Position:C15($cc; <>STAMPERS)>0)
		$0:="stamper"
		
	: (Position:C15($cc; <>LAMINATERS)>0)
		$0:="laminater"
		
	: (Position:C15($cc; <>BLANKERS)>0)
		$0:="blanker"
		
	: (Position:C15($cc; <>GLUERS)>0)
		$0:="gluer"
		
		//unlikely:
	: (Position:C15($cc; <>COATERS)>0)
		$0:="coater"
		
	: (Position:C15($cc; <>PLATEMAKING)>0)
		$0:="plater"
		
	: (Position:C15($cc; <>EMBOSSERS)>0)
		$0:="embosser"
		
	Else 
		$0:="unknown"
End case 
