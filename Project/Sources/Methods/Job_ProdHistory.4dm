//%attributes = {"publishedWeb":true}
//PM: Job_ProdHistory() -> 
//@author mlb - 10/25/02  16:22
//see also JBN_PrintHeader
// Modified by: Mel Bohince (5/1/19) 
C_TEXT:C284($1; $msg; $2; sProcessSpecKey; sCostCenter; $3)
C_TEXT:C284(sBrand; $5; $text)
C_POINTER:C301($6)
C_TEXT:C284(sCustomerName; $4)
C_LONGINT:C283($0; $i)

$msg:=$1

Case of 
	: ($msg="New")
		sProcessSpecKey:=$2
		sCostCenter:=$3
		sCustomerName:=$4
		sBrand:=$5
		ADD RECORD:C56([Job_Forms_Production_Histories:121]; *)
		If (OK=1)
			$0:=Record number:C243([Job_Forms_Production_Histories:121])
		Else 
			$0:=0
		End if 
		
	: ($msg="find")
		sProcessSpecKey:=$2
		If ($3="Specs") | ($3="JobBag")
			$dept:="@"
		Else 
			$dept:=$3
		End if 
		READ WRITE:C146([Job_Forms_Production_Histories:121])  // Modified by: Mel Bohince (5/1/19) 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Job_Forms_Production_Histories:121]; [Job_Forms_Production_Histories:121]ProcessSpecKey:1=sProcessSpecKey; *)
			QUERY:C277([Job_Forms_Production_Histories:121];  & ; [Job_Forms_Production_Histories:121]Department:7=$dept)
			If ($3="JobBag")
				QUERY SELECTION:C341([Job_Forms_Production_Histories:121]; [Job_Forms_Production_Histories:121]ShowOnJobBag:11=True:C214)
			End if 
			
			
		Else 
			
			If ($3="JobBag")
				QUERY:C277([Job_Forms_Production_Histories:121]; [Job_Forms_Production_Histories:121]ShowOnJobBag:11=True:C214; *)
			End if 
			QUERY:C277([Job_Forms_Production_Histories:121]; [Job_Forms_Production_Histories:121]ProcessSpecKey:1=sProcessSpecKey; *)
			QUERY:C277([Job_Forms_Production_Histories:121]; [Job_Forms_Production_Histories:121]Department:7=$dept)
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		ORDER BY:C49([Job_Forms_Production_Histories:121]; [Job_Forms_Production_Histories:121]Created:2; <)
		$0:=Records in selection:C76([Job_Forms_Production_Histories:121])
		
	: ($msg="gather")
		$text:=" ::HISTORY:: "
		$0:=Records in selection:C76([Job_Forms_Production_Histories:121])
		If ($0>0)
			$paren:="/"+String:C10($0)+") "
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				FIRST RECORD:C50([Job_Forms_Production_Histories:121])
				For ($i; 1; $0)
					$text:=$text+" ("+String:C10($i)+$paren+[Job_Forms_Production_Histories:121]Note:5
					NEXT RECORD:C51([Job_Forms_Production_Histories:121])
				End for 
				FIRST RECORD:C50([Job_Forms_Production_Histories:121])
				
			Else 
				
				C_LONGINT:C283($size)
				ARRAY TEXT:C222($_Note; 0)
				SELECTION TO ARRAY:C260([Job_Forms_Production_Histories:121]Note:5; $_Note)
				$size:=Size of array:C274($_Note)
				
				For ($i; 1; $size)
					$text:=$text+" ("+String:C10($i)+$paren+$_Note{$i}
				End for 
				
				FIRST RECORD:C50([Job_Forms_Production_Histories:121])
				
			End if   // END 4D Professional Services : January 2019 query selection
			
		Else 
			$text:=$text+" <none> "
		End if 
		$6->:=$6->+$text
		
	: ($msg="finished")
		REDUCE SELECTION:C351([Job_Forms_Production_Histories:121]; 0)
End case 