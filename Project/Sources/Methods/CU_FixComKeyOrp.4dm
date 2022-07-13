//%attributes = {"publishedWeb":true}
//(p) cu_FixComkeyOrp (phans)
//allow acces to thiese function from Clean up pallete
//• 6/12/98 cs created

ALL RECORDS:C47([Raw_Materials_Groups:22])

CONFIRM:C162("Save report to disk listing commodity key orphans or make changes to fix them?"; "Fix"; "Report")
$Fix:=(OK=1)
For ($i; 1; 7)  //for each table that needs to have an update done, setup searchs
	
	Case of 
		: ($i=1)
			$File:=->[Raw_Materials_Locations:25]
			$Field:=->[Raw_Materials_Locations:25]Commodity_Key:12
		: ($i=2)
			$File:=->[Raw_Materials:21]
			$Field:=->[Raw_Materials:21]Commodity_Key:2
		: ($i=3)
			$File:=->[Purchase_Orders_Items:12]
			$Field:=->[Purchase_Orders_Items:12]Commodity_Key:26
		: ($i=4)
			$File:=->[Job_Forms_Materials:55]
			$Field:=->[Job_Forms_Materials:55]Commodity_Key:12
		: ($i=5)
			$File:=->[Process_Specs_Materials:56]
			$Field:=->[Process_Specs_Materials:56]Commodity_Key:8
		: ($i=6)
			$File:=->[Estimates_Materials:29]
			$Field:=->[Estimates_Materials:29]Commodity_Key:6
		: ($i=7)
			$File:=->[Raw_Materials_Transactions:23]
			$Field:=->[Raw_Materials_Transactions:23]Commodity_Key:22
	End case 
	
	If (Not:C34(x_LocateOrphans($File; $Field; ->[Raw_Materials_Groups:22]Commodity_Key:3; $Fix)))
		$i:=10
	End if 
	
End for 