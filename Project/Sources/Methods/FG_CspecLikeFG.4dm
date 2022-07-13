//%attributes = {"publishedWeb":true}
//PM:  FG_CspecLikeFG  110999  mlb
//see also FG_Cspec2FG
//formerly  `Procedure: uCspecLikeFG()   MLB
//see also uCspec2FG
//•011696  MLB  to hold glue speed
//• 1/8/97 - cs - modification to insure that the carton spec has the CORRECT Cust
//  this modification allows multiple customers to have products on
//  a sinlge job/estimate
//•031297  mBohince  reduce selection
//• 5/23/97 cs upr 1857 - order type on FG
//• 4/16/98 cs insure an income code is assigned
//•081999  mlb  add contract pricing

C_LONGINT:C283($i; $j; $1)

If (Position:C15("obsolete"; [Finished_Goods:26]Status:14)#0)
	ALERT:C41("Warning: "+[Finished_Goods:26]ProductCode:1+" has been marked as Obsolete!")
End if 
[Estimates_Carton_Specs:19]CustID:6:=[Finished_Goods:26]CustID:2  // • 1/8/97 multiple customers on one job
[Estimates_Carton_Specs:19]ProductCode:5:=[Finished_Goods:26]ProductCode:1
[Estimates_Carton_Specs:19]Description:14:=[Finished_Goods:26]CartonDesc:3
[Estimates_Carton_Specs:19]OutLineNumber:15:=[Finished_Goods:26]OutLine_Num:4
[Estimates_Carton_Specs:19]SquareInches:16:=[Finished_Goods:26]SquareInch:6
[Estimates_Carton_Specs:19]Width:17:=[Finished_Goods:26]Width:7
[Estimates_Carton_Specs:19]Depth:18:=[Finished_Goods:26]Depth:8
[Estimates_Carton_Specs:19]Height:19:=[Finished_Goods:26]Height:9
[Estimates_Carton_Specs:19]Width_Dec:20:=[Finished_Goods:26]Width_Dec:10
[Estimates_Carton_Specs:19]Depth_Dec:21:=[Finished_Goods:26]Depth_Dec:11
[Estimates_Carton_Specs:19]Height_Dec:22:=[Finished_Goods:26]Height_Dec:12
[Estimates_Carton_Specs:19]Style:4:=[Finished_Goods:26]Style:32
[Estimates_Carton_Specs:19]ProcessSpec:3:=[Finished_Goods:26]ProcessSpec:33
[Estimates_Carton_Specs:19]StripHoles:46:=[Finished_Goods:26]StripHoles:38
[Estimates_Carton_Specs:19]WindowMatl:35:=[Finished_Goods:26]WindowMatl:39
[Estimates_Carton_Specs:19]WindowGauge:36:=[Finished_Goods:26]WindowGauge:40
[Estimates_Carton_Specs:19]WindowWth:37:=[Finished_Goods:26]WindowWth:41
[Estimates_Carton_Specs:19]WindowHth:38:=[Finished_Goods:26]WindowHth:42
[Estimates_Carton_Specs:19]GlueType:41:=[Finished_Goods:26]GlueType:34
[Estimates_Carton_Specs:19]GlueInspect:42:=[Finished_Goods:26]GlueInspect:35
[Estimates_Carton_Specs:19]SecurityLabels:43:=[Finished_Goods:26]SecurityLabels:36
[Estimates_Carton_Specs:19]DieCutOptions:49:=[Finished_Goods:26]DieCutOptions:44
[Estimates_Carton_Specs:19]UPC:44:=[Finished_Goods:26]UPC:37  //Not(([Finished_Goods]UPC="") | ([Finished_Goods]UPC="N/A"))
[Estimates_Carton_Specs:19]z_ArtReceived:60:=String:C10([Finished_Goods:26]DateArtApproved:46; System date short:K1:1)
[Estimates_Carton_Specs:19]PackingQty:61:=[Finished_Goods:26]PackingQty:45
[Estimates_Carton_Specs:19]Classification:72:=[Finished_Goods:26]ClassOrType:28
[Estimates_Carton_Specs:19]CartonComment:12:=[Finished_Goods:26]Notes:20  //•011696  MLB  to hold glue speed
[Estimates_Carton_Specs:19]OrderType:8:=[Finished_Goods:26]OrderType:59  //• 5/23/97 cs upr 1857
[Estimates_Carton_Specs:19]OriginalOrRepeat:9:=[Finished_Goods:26]OriginalOrRepeat:71
If ([Finished_Goods:26]RKContractPrice:49#0)  //•081999  mlb  
	[Estimates_Carton_Specs:19]PriceWant_Per_M:28:=[Finished_Goods:26]RKContractPrice:49
	[Estimates_Carton_Specs:19]PriceYield_PerM:30:=[Finished_Goods:26]RKContractPrice:49
End if 

[Estimates_Carton_Specs:19]Leaf_Information:77:=[Finished_Goods:26]Leaf_Information:107


CartSpecOvrUndr  //• 5/23/97 cs upr 1857

If (Count parameters:C259<1)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
		
		UNLOAD RECORD:C212([Finished_Goods:26])
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)  //•031297  mBohince  UPR §
		
		
	Else 
		
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)  //•031297  mBohince  UPR §
		
		
	End if   // END 4D Professional Services : January 2019 
End if 