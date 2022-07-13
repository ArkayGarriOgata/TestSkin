//%attributes = {"publishedWeb":true}
//PM: wms_actionExists() -> 

//@author Mel - 5/9/03  17:03


//action_exists(action)


C_BOOLEAN:C305($0)
$0:=True:C214
Case of 
	: ($1="put")  //wms_actionput
		
	: ($1="take")  //wms_actiontake
		
	: ($1="move")  //wms_actionmove
		
	Else 
		$0:=False:C215
End case 