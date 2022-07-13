//%attributes = {"publishedWeb":true}
//(p) FgArtDefaults
//no parameters called during before of Fg record
//and if customer os changed on FG record
//will set art fields so that they either default based on preference in customer
//records
//created 2/17/97 cs upr 1848
If ([Customers:16]ID:1#[Finished_Goods:26]CustID:2)  //if for some reason customer does not match finished good
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods:26]CustID:2)
End if 

//If (Is new record([Finished_Goods]))
//[Finished_Goods]HaveDisk:=Not([CUSTOMER]extra2)
//[Finished_Goods]HaveBnW:=Not([CUSTOMER]extra1)
//[Finished_Goods]HaveSpecSht:=Not([CUSTOMER]NeedSpecSheet)
If (Not:C34([Customers:16]NeedArtApproval:60))
	[Finished_Goods:26]DateArtApproved:46:=!2001-01-01!
End if 
If (Not:C34([Customers:16]NeedSizeAndStyle:58))
	[Finished_Goods:26]DateSnS_Approved:83:=!2001-01-01!
End if 
If (Not:C34([Customers:16]NeedColorApproval:59))
	[Finished_Goods:26]DateColorApproved:86:=!2001-01-01!
End if 
If (Not:C34([Customers:16]NeedSpecSheet:51))
	[Finished_Goods:26]DateSpecApproved:89:=!2001-01-01!
End if 
//End if 
//if the customer field is true, mark fin good field as entereable 
//SET ENTERABLE([Finished_Goods]HaveDisk;[CUSTOMER]extra2)
//$Color:=(-14*Num(Not([CUSTOMER]extra2)))  `-14 etc = grey if item is disabled
//$Color:=$Color+(-15*Num([CUSTOMER]extra2))  ` 15 etc = black if item is enabled
//SET COLOR([Finished_Goods]HaveDisk;$Color)
//SET ENTERABLE([Finished_Goods]HaveBnW;[CUSTOMER]extra1)
//$Color:=(-14*Num(Not([CUSTOMER]extra1)))  `-14 etc = grey if item is disabled
//$Color:=$Color+(-15*Num([CUSTOMER]extra1))  ` 15 etc = black if item is enabled
//SET COLOR([Finished_Goods]HaveBnW;$Color)
//SET ENTERABLE([Finished_Goods]HaveSpecSht;[CUSTOMER]NeedSpecSheet)
//$Color:=(-14*Num(Not([CUSTOMER]NeedSpecSheet)))  `-14 etc = grey if item is disabled
//$Color:=$Color+(-15*Num([CUSTOMER]NeedSpecSheet))  ` 15 etc = black if item is enabled
//SET COLOR([Finished_Goods]HaveSpecSht;$Color)
//