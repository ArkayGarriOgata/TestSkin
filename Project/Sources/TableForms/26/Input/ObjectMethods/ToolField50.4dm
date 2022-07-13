// (s) ArtReceived[finished_goods]InputArt2
//• modified 2/7/97 cs upr 1848
//  moved code into procedure FgArtReceived

If ([Finished_Goods:26]DateArtApproved:46#!00-00-00!)
	FgArtReceived  //mark as received
	//Else 
	FgArtReceived("*")  //mark as un received
End if 
//