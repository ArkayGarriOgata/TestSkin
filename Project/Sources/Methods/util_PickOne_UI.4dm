//%attributes = {}
// _______
// Method: util_PickOne_UI(entitySelection;desiredDisplayField {;->[table] }) -> object:{success,primaryKey;displayedField}
// By: Mel Bohince @ 05/05/20, 09:36:42
// Description
// given an entity selection, open a window to make a choice 
// rtn and object with success, the pk_id, and the value of the displaced field picked
// if the optional $3 pointer is supplied, it will load the picked record in read only
// ----------------------------------------------------


C_OBJECT:C1216($choiceEntities; $1; $form_o; $0; $thePick)  //need access to choice_o after dialog is closed
C_TEXT:C284($displayedField; $2; vSearch)  //vSearch is embedded in search widget
C_POINTER:C301($tablePtr; $3)

If (Count parameters:C259=0)  //no params for testing for testing
	
	//sample calls:
	
	//###### vanilla
	$thePick:=util_PickOne_UI(ds:C1482.Customers.query("Active = :1"; True:C214); "Name")
	
	//###### a big entity selection
	//$thePick:=util_PickOne_UI (ds.Finished_Goods_DeliveryForcasts.all();"ProductCode")  //1.6 million records offered!
	
	//###### using the rtn'd object
	//C_OBJECT($vend_o;$vend_es)
	//$vend_o:=util_PickOne_UI (ds.Vendors.query("Active = :1";True);"Name")  //this is a shallow obj from a collection
	//If ($vend_o.success)
	// $vend_id:=ds.Vendors.get($vend_o.primaryKey).ID  //get it as an entity or just the ID
	//end if
	
	//###### using 3rd param to load the record picked
	//$thePick:=util_PickOne_UI (ds.Customers.query("Active = :1";True);"Name";->[Customers])  //to load the record as
	//     as if followed by:
	//   if($thePick.success)
	//     READ ONLY([Customers])
	//     USE ENTITY SELECTION(ds.Customers.query("pk_id = :1";$thePick.primaryKey))
	//     LOAD RECORD([Customers])
	//   end if
	
	//###### alternate method using the entities mgmt dialog
	//Vendor_UI (the Copy ID# btn clicked after picking something)
	//[Purchase_Orders]VendorID:=Get text from pasteboard
	
	
	//###### doesn't work with related one record
	//$thePick:=util_PickOne_UI (ds.Customers_Addresses.query("CustID = :1 and AddressType= :2";"00121";"Bill to");"ADDRESS.City")  //doesn't work with related one record
	
	
	//###### collections fail
	//C_COLLECTION($testCollection)
	//$testCollection:=New collection
	//$testCollection.push(New object("__KEY";"1234";"Name";"First Choice"))
	//$testCollection.push(New object("__KEY";"5678";"Name";"Second Choice"))
	//$thePick:=util_PickOne_UI ($testCollection;"Name")
	
	
Else 
	$choiceEntities:=$1
	
	If ($choiceEntities.length>0)
		
		$displayedField:=$2
		$msg:="Pick a "+$displayedField+" from below:"
		
		$form_o:=New object:C1471("message"; $msg; "displayedField"; $displayedField; "data"; $choiceEntities.toCollection($displayedField; dk with primary key:K85:6).orderBy($displayedField))
		
		C_LONGINT:C283($winRef)
		C_OBJECT:C1216($xy)
		$xy:=OpenFormWindowCoordinates("get")
		
		$winRef:=Open form window:C675("PickOne_util"; Plain form window:K39:10; $xy.x; $xy.y)
		DIALOG:C40("PickOne_util"; $form_o)
		CLOSE WINDOW:C154($winRef)
		If (ok=1)
			
			If ($form_o.choice_o#Null:C1517)
				$thePick:=New object:C1471("success"; True:C214; "primaryKey"; $form_o.choice_o.__KEY; "value"; $form_o.choice_o[$displayedField])
				
				If (Count parameters:C259=3)  //load record to support legacy way
					$tablePtr:=$3
					READ ONLY:C145($tablePtr->)
					USE ENTITY SELECTION:C1513(ds:C1482[Table name:C256($tablePtr)].query("pk_id = :1"; $thePick.primaryKey))
					LOAD RECORD:C52($tablePtr->)
				End if 
				
			Else 
				$thePick:=New object:C1471("success"; False:C215; "primaryKey"; ""; "value"; "NothingSelected")
				BEEP:C151
			End if 
			
		Else 
			$thePick:=New object:C1471("success"; False:C215; "primaryKey"; ""; "value"; "PickCancelled")
		End if 
		
	Else 
		$thePick:=New object:C1471("success"; False:C215; "primaryKey"; ""; "value"; "NoRecordsFound")
		BEEP:C151
	End if 
	
	$0:=$thePick
	
End if   //count params
