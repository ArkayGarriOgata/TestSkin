//%attributes = {"publishedWeb":true}
//PM:  Est_OKToQuotestimate#) ->bool 3/21/00  mlb
//return true if use may quote this estimate
//•4/05/00  mlb  add Accepted

C_TEXT:C284($1; $estimate)
C_BOOLEAN:C305($0; $okToQuote)

$estimate:=$1
$okToQuote:=False:C215

If (User in group:C338(Current user:C182; "AccountManager"))
	$okToQuote:=True:C214
	
Else 
	If ([Estimates:17]EstimateNo:1#$estimate)
		QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$estimate)
	End if 
	
	Case of 
		: (Position:C15("Priced"; [Estimates:17]Status:30)#0)
			$okToQuote:=True:C214
			
		: ([Estimates:17]Status:30="Quoted")
			$okToQuote:=True:C214
			
		: (Position:C15("Accept"; [Estimates:17]Status:30)#0)
			$okToQuote:=True:C214
			
		Else 
			uConfirm("You may not quote until the estimate has been priced."; "OK"; "Help")
			
	End case 
End if 

$0:=$okToQuote