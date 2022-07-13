//FM: ReportAll() -> 
//@author mlb - 1/23/03  16:19

Case of 
		
	: (Form event code:C388=On Printing Detail:K2:18)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Finished_Goods_Specifications:98]FG_Key:1)
		If ([Finished_Goods:26]Preflight:66)
			xText:=[Finished_Goods:26]PreflightBy:67
			If (Length:C16(xText)=0)
				xText:="X"
			End if 
		Else 
			xText:=""
		End if 
		
		QUERY:C277([Customers:16]; [Customers:16]ID:1=(Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5)))
		
		
		$red:=-(Red:K11:4+(256*Red:K11:4))
		$green:=-(White:K11:1+(256*Green:K11:9))
		$black:=-(White:K11:1+(256*Black:K11:16))
		$yellow:=-(Yellow:K11:2+(256*Black:K11:16))
		If ([Finished_Goods_Specifications:98]PreApproved:67)
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]Approved:10; $green)
		Else 
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]Approved:10; $red)
		End if 
		
		If ([Finished_Goods_Specifications:98]Status:68="0n Hold")
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; $yellow)
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $yellow)
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DatePrepDone:6; $yellow)
		Else 
			If ([Finished_Goods_Specifications:98]Status:68="7 Filed")
				Core_ObjectSetColor("*"; "c@"; $green)
			Else 
				If ([Finished_Goods_Specifications:98]Status:68="6 Rejected")
					Core_ObjectSetColor("*"; "c@"; $black)
					
				Else 
					Core_ObjectSetColor("*"; "c@"; $red)
					
					If ([Finished_Goods_Specifications:98]Status:68="5 Customer")
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSentToCustomer:8; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateProofRead:7; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DatePrepDone:6; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $green)
					End if 
					If ([Finished_Goods_Specifications:98]Status:68="4 Mail Room")
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateProofRead:7; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DatePrepDone:6; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $green)
					End if 
					If ([Finished_Goods_Specifications:98]Status:68="3 Quality")
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DatePrepDone:6; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $green)
					End if 
					If ([Finished_Goods_Specifications:98]Status:68="2 Imaging")
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $green)
					End if 
					If ([Finished_Goods_Specifications:98]Status:68="1 Planning")
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $green)
					End if 
				End if 
			End if 
		End if 
		
End case 