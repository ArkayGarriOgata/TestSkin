//%attributes = {"publishedWeb":true}
//PM:  CostCtr_Substitution  111199  mlb
//formserly  `Procedure: luSubstitution
//April 20, 1996 TJF
//•060596  TJF  add the 468
//•060696  MLB  add the 489
//•080696  MLB  add the  476 477
//•112399  mlb  STAMPERS ALL HAVE THEIR OWN STD NOW
//05/30/00 use on standards so we can do production reports
//•071902  mlb  reverted
//function passed [MachineTicket]CostCenterID and returns substitution
//note that you MAY need to fix (P)beforeMachines and sRunEstimate
//04/24/07 no longer substitute, must have cc record

C_TEXT:C284($1; $0; $CostCenter)

$CostCenter:=$1

Case of   //enter substitutions see also gMTaccept & mMachTick`•062695  MLB  UPR 220
	: (True:C214)  //04/24/07`•071902  mlb  reverted
		$0:=$CostCenter
		
	: (Position:C15($CostCenter; " 491 493")#0)  //• Mel - 5/7/03  was in the gluers below
		$0:=$CostCenter
		
	: (Position:C15($CostCenter; <>GLUERS)#0)  //the gluers`•092895  MLB  UPR 1720 add the 488
		$0:=$CostCenter  //"481"
		
	: (Position:C15($CostCenter; <>STAMPERS)#0)
		$0:=$CostCenter  //"451"
		
		//: (Position($CostCenter;"462 465 468") # 0)  `•060596  MLB 
		//$0:="465"`•112399  mlb  STAMPERS ALL HAVE THEIR OWN STD NOW
		
	: ($CostCenter="471") | ($CostCenter="472")
		$0:=$CostCenter  //"471"
		
	Else 
		$0:=$CostCenter
End case   //enter substitutions      