//%attributes = {"publishedWeb":true}
//(s) qryFgByOutline
//used to locate Fg records for updates during data entry
//NOTE: this PUSHES a record
//• 10/8/97 cs created

C_BOOLEAN:C305($Exclude)

$FileNo:=[Finished_Goods:26]OutLine_Num:4
CREATE SET:C116([Finished_Goods:26]; "Hold")
$CPN:=[Finished_Goods:26]ProductCode:1
$Exclude:=(Record number:C243([Finished_Goods:26])#-3)
PUSH RECORD:C176([Finished_Goods:26])

If (Not:C34($Exclude))
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]OutLine_Num:4=$FileNo)
Else 
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]OutLine_Num:4=$FileNo; *)
	QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]ProductCode:1#$CPN)
End if 