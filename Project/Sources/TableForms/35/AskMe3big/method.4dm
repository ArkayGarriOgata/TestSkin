// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 05/16/13, 13:24:46
// ----------------------------------------------------
// Form Method: [Finished_Goods_Locations].AskMe3big
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground(230; 230; 255; 255; 255; 255)
		If ([Finished_Goods_Locations:35]KillStatus:30=1)
			Core_ObjectSetColor("*"; "Field@"; -(Red:K11:4+(256*Black:K11:16)); True:C214)
		Else 
			Core_ObjectSetColor("*"; "Field@"; -(Black:K11:16+(256*White:K11:1)); True:C214)
		End if 
		
		If ([Finished_Goods_Locations:35]Certified:41#!00-00-00!)
			SetObjectProperties(""; ->[Finished_Goods_Locations:35]Certified:41; True:C214)
			Core_ObjectSetColor(->[Finished_Goods_Locations:35]Certified:41; -(Red:K11:4))
		Else 
			SetObjectProperties(""; ->[Finished_Goods_Locations:35]Certified:41; False:C215)
		End if 
		
		If ([Finished_Goods_Locations:35]BOL_Pending:31>0)
			Core_ObjectSetColor("*"; "Field@"; -(Blue:K11:7+(256*White:K11:1)); True:C214)
		End if 
End case 

app_SelectIncludedRecords(->[Finished_Goods_Locations:35]ProductCode:1; 0; "Finished_Goods_Locations")