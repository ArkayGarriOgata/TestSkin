//%attributes = {"publishedWeb":true}
//(p) FgArtReceived
//mark Fg records as having received all art work and is reeady for prodction
//$1 (optional) - Revert to previous state (some/all unreceived artwork)
//New 2/7/97 cs needed as part of upr 1848
C_TEXT:C284($1)
If (Count parameters:C259=0)
	[Finished_Goods:26]HaveArt:51:=True:C214
	[Finished_Goods:26]HaveDisk:52:=True:C214
	[Finished_Goods:26]HaveBnW:53:=True:C214
	[Finished_Goods:26]HaveSpecSht:55:=True:C214
	//if the below dates have not been set previously, do so
	If ([Finished_Goods:26]ArtReceivedDate:56=!00-00-00!)
		[Finished_Goods:26]ArtReceivedDate:56:=4D_Current_date
	End if 
	
	If ([Finished_Goods:26]PrepDoneDate:58=!00-00-00!)
		[Finished_Goods:26]PrepDoneDate:58:=4D_Current_date
	End if 
	
Else 
	[Finished_Goods:26]HaveArt:51:=False:C215
	[Finished_Goods:26]HaveDisk:52:=False:C215
	[Finished_Goods:26]HaveBnW:53:=False:C215
	[Finished_Goods:26]HaveSpecSht:55:=False:C215
	
	If ([Finished_Goods:26]ArtReceivedDate:56=4D_Current_date)  //if these dates were set by above code clear
		[Finished_Goods:26]ArtReceivedDate:56:=!00-00-00!
	End if 
	
	If ([Finished_Goods:26]PrepDoneDate:58=4D_Current_date)
		[Finished_Goods:26]PrepDoneDate:58:=!00-00-00!
	End if 
	
End if 