//If (True)
piEnter_RM_Tags("init")
//Else   //old way    `(S) [CONTROL]CIDEvent'ibMod
//  //• 3/27/97 cs Mellisa's suggestion, make Adj screens have ONLY 'Phys Inv' reason
//If (User in group(Current user;"Physical Inv"))
//<>fPiActive:=True  //•3/27/97 cs
//uSpawnProcess ("gRMadj";32000;"Adjusting:RAW_MATERIALS";True;False)
//If (False)  //list called procedures for 4D Insider 
//RM_adjustBin 
//End if 
//Else 
//uNotAuthorized 
//End if 
//End if 
//  //EOS