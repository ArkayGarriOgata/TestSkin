//%attributes = {}
// Method: txt_ToCSV_attribute   ( object;"propertyName") -> text version, quoted if necessary
// By: Mel Bohince @ 11/07/20, 16:24:49
// ----------------------------------------------------
// Description
// prepare an objection property to be included in a CSV document.
// based on txt_ToCSV
// ----------------------------------------------------
// Modified by: Mel Bohince (4/23/21) only quote text containing a comma

C_OBJECT:C1216($1)
C_TEXT:C284($2; $0)
$type:=OB Get type:C1230($1; $2)

Case of 
	: ($type=Is text:K8:3)
		$data:=Replace string:C233($1[$2]; Char:C90(13); "•")
		If (Position:C15(","; $data)=0)  // Modified by: Mel Bohince (4/23/21) only quote text containing a comma
			$0:=$data
		Else 
			$0:=txt_quote($data)
		End if 
		
	: ($type=Is boolean:K8:9)
		$0:=String:C10(Num:C11($1[$2]); "True;;False")  // Modified by: Mel Bohince (4/23/21) only quote text containing a comma
		
	: ($type=Is date:K8:7)  //date, no quotes
		//$0:=String($1[$2];Internal date short special)
		//$0:=String($1[$2];ISO date)
		$0:=Substring:C12(String:C10($1[$2]; ISO date:K1:8); 1; 10)  //should be good for sql db
		
	Else   //number, no quotes
		$0:=String:C10($1[$2])
		
End case 

If (False:C215)  //TESTING
	//C_OBJECT($pjtEntity)
	//$pjtEntity:=New object
	//$pjtEntity.txt:="maple,Lane"
	//$pjtEntity.lng:=1234//$long
	//$pjtEntity.real:=1234.12//$real
	//$pjtEntity.date:=!2020-01-31!//$date
	//$pjtEntity.bool:=True
	//$rtn_t:=txt_ToCSV_attribute ($pjtEntity;"txt")
	//$rtn_t:=txt_ToCSV_attribute ($pjtEntity;"lng")
	//$rtn_t:=txt_ToCSV_attribute ($pjtEntity;"real")
	//$rtn_t:=txt_ToCSV_attribute ($pjtEntity;"date")
	//$rtn_t:=txt_ToCSV_attribute ($pjtEntity;"bool")
	//$pjtEntity.bool:=False
	//$rtn_t:=txt_ToCSV_attribute ($pjtEntity;"bool")
	
	
	//$pjtEntity:=ds.Customers_Projects.query("id = :1";"02708").first()
	//$rtn_t:=txt_ToCSV_attribute ($pjtEntity;"DateOpened")
	//$rtn_t:=txt_ToCSV_attribute($pjtEntity;"CustomerName")
End if 
