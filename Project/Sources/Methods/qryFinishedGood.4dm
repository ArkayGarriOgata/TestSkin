//%attributes = {"publishedWeb":true}
//qryFinishedGood(custid | switch;cpn;{"SplBill"})  3/15/95
//upr 1489 5/8/95 jparameter 3 added for special billing style record
//•960618 mlb
//•120597  MLB  UPR 1908 define some other searches

C_TEXT:C284($1)
C_TEXT:C284($2)  //;$3)
C_LONGINT:C283($3)  //optional param to prevent spl billing search
C_LONGINT:C283($0)  //rtn number of records

Case of   //•120597  MLB  UPR 1908
	: ($1#"#@")  //original code
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=($1+":"+$2))
		
		If (Records in selection:C76([Finished_Goods:26])=0)
			If (Count parameters:C259#3)  //•960618 mlb
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=$2)  //in case this is special billing 
			End if 
		End if 
		
	: ($1="#FILE")  //file or outline number search
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]OutLine_Num:4=$2)
		
	: ($1="#PACK")  //file or outline number search
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]PackingSpecification:103=$2)
		
	: ($1="#LINE")  //file or outline number search
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Line_Brand:15=$2)
		
	: ($1="#CUST")  //file or outline number search
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]CustID:2=$2)
		
	: ($1="#PREP")  //special billing
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=$2; *)  //in case this is special billing 
		QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]SpecialBilling:23=True:C214)  //•052599  mlb 
		
	: ($1="#KEY")
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=$2)  //in case this is special billing 
		
	: ($1="#CPN")  //file or outline number search
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$2)  //customer-free search
		
	: ($1="#SIZE")  //file or outline number search
		REDUCE SELECTION:C351([Finished_Goods:26]; Num:C11($2))
		
	Else 
		BEEP:C151
		ALERT:C41($1+" not supported in qryFinishedGood")
End case 

$0:=Records in selection:C76([Finished_Goods:26])