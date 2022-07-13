//%attributes = {"publishedWeb":true}
//Procedure: doQuickQuote()  090695  MLB
//§
//Script: bQuote()  072795  MLB
//•072795  MLB  UPR 216
//•010697  MLB  UPR § Inable Edit menu
//allow direct access to a quote via est #

C_TEXT:C284($est)
C_LONGINT:C283($numEsts)

READ WRITE:C146([Estimates:17])
SET MENU BAR:C67(<>DefaultMenu)  //•010697  MLB  

Repeat 
	$est:=Substring:C12(Request:C163("Enter an Estimate Nº/Diff to quote:"; "0-0000.00AA"); 1; 11)
	$diff:=Substring:C12($est; 10; 2)  //•081495  MLB  
	If ($diff="")
		$diff:="*"
	End if 
	
	$est:=Substring:C12($est; 1; 9)  //•081495  MLB  
	If (OK=1)
		QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$est)
		$numEsts:=Records in selection:C76([Estimates:17])
		Case of 
			: ($numEsts=1)
				rRptCOQuote($diff)
				OK:=1
				
			: ($numEsts>1)
				BEEP:C151
				ALERT:C41(String:C10($numEsts)+" were found, be more specific or cancel.")
				
			Else 
				BEEP:C151
				ALERT:C41($est+" was not found, try again or cancel.")
		End case 
	End if 
Until (OK=0)