//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceSetView() -> 
//@author mlb - 4/27/01  09:55
//called by tab control on output list

zwStatusMsg("Searching"; "Please Wait...")
C_LONGINT:C283($1; $tabNumber; $itemRef)
C_TEXT:C284($itemText)

C_POINTER:C301($2; $orderBy)
CUT NAMED SELECTION:C334([Finished_Goods_Specifications:98]; "hold")
If (Count parameters:C259=2)
	$tabNumber:=$1
	$orderBy:=$2
Else 
	$tabNumber:=Selected list items:C379(iJMLTabs)
	Case of 
		: ($itemText="Planning")
			$orderBy:=->[Finished_Goods_Specifications:98]DateArtReceived:63
		: (b1=1)
			$orderBy:=->[Finished_Goods_Specifications:98]DateArtReceived:63
		: (b2=1)
			$orderBy:=->[Finished_Goods_Specifications:98]ControlNumber:2
		: (b3=1)
			$orderBy:=->[Finished_Goods_Specifications:98]FG_Key:1
		: (b4=1)
			$orderBy:=->[Finished_Goods:26]PressDate:64
		: (b5=1)
			$orderBy:=->[Finished_Goods_Specifications:98]Priority:50
		: (b6=1)
			$orderBy:=->[Finished_Goods_Specifications:98]DateArtReceived:63
	End case 
End if 



If (Count parameters:C259=0)  //*The Search
	GET LIST ITEM:C378(iJMLTabs; $tabNumber; $itemRef; $itemText)
	
	Case of 
		: ($itemText="Search...")
			FG_PrepServicesQueries("0")
			
		: ($itemText="Planning")
			FG_PrepServicesQueries("1 Planning")
			
		: ($itemText="Imaging")
			FG_PrepServicesQueries("2 Imaging")
			
		: ($itemText="Quality")
			FG_PrepServicesQueries("3")  // Quality")
			
		: ($itemText="Mail Room")
			FG_PrepServicesQueries("4 Mail Room")
			
		: ($itemText="Customer")
			FG_PrepServicesQueries("5 Customer")
			
		: ($itemText="Order")
			FG_PrepServicesQueries("5")
			
		: ($itemText="Invoice")
			FG_PrepServicesQueries("6")
			
		: ($itemText="Add'l Reqs")
			FG_PrepServicesQueries("8")
			
		: ($itemText="On Hold")
			FG_PrepServicesQueries("7")
			
		: ($itemText="Not Done")
			FG_PrepServicesQueries("9")
			
		: ($itemText="Preflight")
			FG_PrepServicesQueries("10")
			
		: ($itemText="")
			USE SET:C118("anyPressDate")
			
		Else 
			USE SET:C118("anyPressDate")
			QUERY SELECTION:C341([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ServiceRequested:54=$itemText)
	End case 
	
	Case of 
		: (cb1=1)
			SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
			QUERY SELECTION:C341([Finished_Goods_Specifications:98]; [Finished_Goods:26]PressDate:64<=(4D_Current_date+5); *)
			QUERY SELECTION:C341([Finished_Goods_Specifications:98];  & ; [Finished_Goods:26]PressDate:64#!00-00-00!)
			SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
		: (cb2=1)
			//  leave selection alone
	End case 
	
	If (Li1=1)  //press date has been set
		SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
		QUERY SELECTION:C341([Finished_Goods_Specifications:98]; [Finished_Goods:26]PressDate:64#!00-00-00!)
		SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
	End if 
	
	If (i3=1)  // Modified by: Mel Bohince (4/16/21) fixed the <>4D query and removed the old
		zwStatusMsg("Searching"; " for your records")
		$numCust:=User_AllowedRecords(Table name:C256(->[Customers:16]))
		
		DISTINCT VALUES:C339([Customers:16]ID:1; $aCustId)  //the allowed customers
		
		SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]FG_Key:1; $_FG_Key)  //currently displayed fg specs
		
		ARRAY TEXT:C222($_Allowed; 0)
		
		For ($Iter; 1; Size of array:C274($_FG_Key))
			$custid:=Substring:C12($_FG_Key{$Iter}; 1; 5)
			$hit:=Find in array:C230($aCustId; $custid)
			If ($hit>-1)
				APPEND TO ARRAY:C911($_Allowed; $_FG_Key{$Iter})
			End if 
			
		End for 
		
		QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Specifications:98]FG_Key:1; $_Allowed)
		
	End if 
	
Else 
	USE NAMED SELECTION:C332("hold")
End if 

//*The sort
If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
	SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
	ORDER BY:C49([Finished_Goods_Specifications:98]; $orderBy->; >)
	SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
Else 
	BEEP:C151
End if 

zwStatusMsg("Done"; "")

CREATE SET:C116([Finished_Goods_Specifications:98]; "◊LastSelection"+String:C10(fileNum))
CREATE SET:C116([Finished_Goods_Specifications:98]; "CurrentSet")
winTitle:=$itemText+" "+fNameWindow(->[Finished_Goods_Specifications:98])
SET WINDOW TITLE:C213(winTitle)
//