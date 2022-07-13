//%attributes = {"publishedWeb":true}
//PM: wms_compExists() -> 
//@author Mel - 5/9/03  16:32

//comp_Exists(item{,container})
READ WRITE:C146([WMS_Compositions:124])
Case of 
	: (Count parameters:C259=1)
		QUERY:C277([WMS_Compositions:124]; [WMS_Compositions:124]Container:1=$1)
		If (Records in selection:C76([WMS_Compositions:124])>0)
			$0:=True:C214
		Else 
			$0:=False:C215
		End if 
		
	: (Count parameters:C259=2)
		QUERY:C277([WMS_Compositions:124]; [WMS_Compositions:124]CompKey:3=($1+$2))
		If (Records in selection:C76([WMS_Compositions:124])>0)
			$0:=True:C214
		Else 
			$0:=False:C215
		End if 
		
	: (Count parameters:C259=3)
		QUERY:C277([WMS_Compositions:124]; [WMS_Compositions:124]Content:2=$3)
		If (Records in selection:C76([WMS_Compositions:124])>0)
			$0:=True:C214
		Else 
			$0:=False:C215
		End if 
End case 
