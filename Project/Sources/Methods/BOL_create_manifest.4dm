//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/01/07, 14:19:28
// ----------------------------------------------------
// Method: BOL_create_manifest
// Description:
// Convert the bin information into a list of items for the manifest
// each line item has a common release# and case qty
// ----------------------------------------------------
// Modified by: Garri Ogata (11/29/21) added Nest component description to Remarks1 and Remarks2

C_OBJECT:C1216($oParse)
C_REAL:C285($pricePerM)  // Modified by: Mel Bohince (11/4/19) 

$oParse:=New object:C1471()

bol_manifest_refresh_required:=False:C215
//clear out any prior subrecords so we can start fresh
RELATE MANY:C262([Customers_Bills_of_Lading:49]Manifest:16)
util_DeleteSelection(->[Customers_Bills_of_Lading_Manif:181])


C_LONGINT:C283($i; $numElements)
$numElements:=Size of array:C274(aCPN2)  //these are the input arrays
BOL_ListBox1("sort-by-release")
SET QUERY LIMIT:C395(1)

uThermoInit($numElements; "Creating Manifest")
$itemNumber:=0
RELATE MANY:C262([Customers_Bills_of_Lading:49]Manifest:16)  //this should be empty
ARRAY LONGINT:C221($aManifestRecNo; 0)
ARRAY LONGINT:C221($aRKrel; 0)
ARRAY LONGINT:C221($aCntPerCase; 0)
ARRAY TEXT:C222($aMatch; 0)
SELECTION TO ARRAY:C260([Customers_Bills_of_Lading_Manif:181]; $aManifestRecNo; [Customers_Bills_of_Lading_Manif:181]Arkay_Release:4; $aRKrel; [Customers_Bills_of_Lading_Manif:181]Count_PerCase:8; $aCntPerCase)
For ($existing; 1; Size of array:C274($aManifestRecNo))
	$aMatch{$existing}:=String:C10($aRKrel{$existing}; "000000000000000")+String:C10($aCntPerCase{$existing}; "000000000000000")
End for 
SORT ARRAY:C229($aMatch; $aManifestRecNo; $aRKrel; $aCntPerCase; >)
//CREATE SET([Customers_Bills_of_Lading_Manif];"manifest")
[Customers_Bills_of_Lading:49]DeclaredValue:33:=0  // Modified by: Mel Bohince (11/2/19) 

For ($i; 1; $numElements)
	If ($i<=Size of array:C274(aPricePerM))  //for compatibility with old records
		[Customers_Bills_of_Lading:49]DeclaredValue:33:=[Customers_Bills_of_Lading:49]DeclaredValue:33+(aTotalPicked2{$i}/1000*aPricePerM{$i})
		
	Else   //;backward compatibility
		$pricePerM:=ds:C1482.Customers_ReleaseSchedules.query("ReleaseNumber = :1"; aReleases{$i}).first().ORDER_LINE.Price_Per_M  //sorry, didn't check for null, which in this context is hard to imagine
		[Customers_Bills_of_Lading:49]DeclaredValue:33:=[Customers_Bills_of_Lading:49]DeclaredValue:33+(aTotalPicked2{$i}/1000*$pricePerM)
	End if 
	$new_record:=False:C215
	$target:=String:C10(aReleases{$i}; "000000000000000")+String:C10(aPackQty2{$i}; "000000000000000")
	$hit:=Find in array:C230($aMatch; $target)
	If ($hit=-1)  //not found
		$new_record:=True:C214  //will update arrays after we get a rec num
		$itemNumber:=$itemNumber+1
		CREATE RECORD:C68([Customers_Bills_of_Lading_Manif:181])
		[Customers_Bills_of_Lading_Manif:181]id_added_by_converter:16:=[Customers_Bills_of_Lading:49]Manifest:16
		[Customers_Bills_of_Lading_Manif:181]ShippersNo:17:=[Customers_Bills_of_Lading:49]ShippersNo:1
		[Customers_Bills_of_Lading_Manif:181]Item:1:=$itemNumber
		
		[Customers_Bills_of_Lading_Manif:181]Arkay_Release:4:=aReleases{$i}
		[Customers_Bills_of_Lading_Manif:181]CPN:5:=aCPN2{$i}
		[Customers_Bills_of_Lading_Manif:181]NumCases:6:=aNumCases2{$i}
		[Customers_Bills_of_Lading_Manif:181]Wt_PerCase:7:=aWgt2{$i}/aNumCases2{$i}
		[Customers_Bills_of_Lading_Manif:181]Count_PerCase:8:=aPackQty2{$i}
		[Customers_Bills_of_Lading_Manif:181]Total_Amt:9:=aTotalPicked2{$i}
		[Customers_Bills_of_Lading_Manif:181]Total_Wt:11:=aWgt2{$i}
		
		[Customers_Bills_of_Lading_Manif:181]jobit:15:=aJobit2{$i}
		
		xMemo:=arValues{$i}
		[Customers_Bills_of_Lading_Manif:181]Total_Rel:12:=Num:C11(util_TaggedText("get"; "sch-qty"; ""; ->xMemo))
		[Customers_Bills_of_Lading_Manif:181]Cust_Release:3:=util_TaggedText("get"; "cust-refer"; ""; ->xMemo)
		[Customers_Bills_of_Lading_Manif:181]Remarks1:10:=util_TaggedText("get"; "remark1"; ""; ->xMemo)
		[Customers_Bills_of_Lading_Manif:181]Remarks2:14:=util_TaggedText("get"; "remark2"; ""; ->xMemo)
		[Customers_Bills_of_Lading_Manif:181]Cust_PO:2:=util_TaggedText("get"; "cust-po"; ""; ->xMemo)
		
		Case of 
			: ([Customers_Bills_of_Lading:49]CustID:2="00765")  //loreal needs SAP item number also
				$numFG:=qryFinishedGood("#key"; "00765:"+aCPN2{$i})
				[Customers_Bills_of_Lading_Manif:181]Remarks1:10:=Substring:C12([Finished_Goods:26]AliasCPN:106; 1; 15)
				[Customers_Bills_of_Lading_Manif:181]Remarks2:14:=Substring:C12("LOT"+aJobit2{$i}; 1; 15)
				//[Customers_Bills_of_Lading]Manifest'Cust_Release:=""
				
			: ([Customers_Bills_of_Lading:49]CustID:2="01469")  //zirh
				$numFG:=qryFinishedGood("#key"; "01469:"+aCPN2{$i})
				[Customers_Bills_of_Lading_Manif:181]Remarks1:10:=Substring:C12([Finished_Goods:26]AliasCPN:106; 1; 15)
				[Customers_Bills_of_Lading_Manif:181]Remarks2:14:=Substring:C12("LOT"+aJobit2{$i}; 1; 15)
				//[Customers_Bills_of_Lading]Manifest'Cust_Release:=""
				
			: ([Customers_Bills_of_Lading:49]CustID:2="91859")  //Nest component descriptions GNO-11/29/21
				$numFG:=qryFinishedGood("#key"; "91859:"+aCPN2{$i})
				
				$oParse.tValue:=[Finished_Goods:26]CartonDesc:3
				$oParse.tFontName:="Courier"
				$oParse.nFontSize:=12
				$oParse.nWidthInPixels:=105
				$oParse.nMaxLines:=2
				$oParse.tLine1:=CorektBlank
				$oParse.tLine2:=CorektBlank
				
				Case of   //Description
						
					: (([Customers_Bills_of_Lading_Manif:181]Remarks1:10=CorektBlank) & ([Customers_Bills_of_Lading_Manif:181]Remarks2:14=CorektBlank))
						
						Core_Parse_Text($oParse)
						
						[Customers_Bills_of_Lading_Manif:181]Remarks1:10:=$oParse.tLine1
						[Customers_Bills_of_Lading_Manif:181]Remarks2:14:=$oParse.tLine2
						
					: (([Customers_Bills_of_Lading_Manif:181]Remarks1:10#CorektBlank) & ([Customers_Bills_of_Lading_Manif:181]Remarks2:14#CorektBlank))
						
					: ([Customers_Bills_of_Lading_Manif:181]Remarks1:10#CorektBlank)
						
						[Customers_Bills_of_Lading_Manif:181]Remarks2:14:=[Customers_Bills_of_Lading_Manif:181]Remarks1:10
						
						$oParse.nMaxLines:=1
						Core_Parse_Text($oParse)
						
						[Customers_Bills_of_Lading_Manif:181]Remarks1:10:=$oParse.tLine1
						
					: ([Customers_Bills_of_Lading_Manif:181]Remarks2:14#CorektBlank)
						
						$oParse.nMaxLines:=1
						Core_Parse_Text($oParse)
						
						[Customers_Bills_of_Lading_Manif:181]Remarks1:10:=$oParse.tLine1
						
				End case   //Done description
				
		End case 
		
		[Customers_Bills_of_Lading_Manif:181]InvoiceNumber:13:=No current record:K29:2
		
	Else   //add to exisiting item     
		GOTO RECORD:C242([Customers_Bills_of_Lading_Manif:181]; $aManifestRecNo{$hit})
		[Customers_Bills_of_Lading_Manif:181]NumCases:6:=[Customers_Bills_of_Lading_Manif:181]NumCases:6+aNumCases2{$i}
		[Customers_Bills_of_Lading_Manif:181]Total_Amt:9:=[Customers_Bills_of_Lading_Manif:181]Total_Amt:9+aTotalPicked2{$i}
		[Customers_Bills_of_Lading_Manif:181]Total_Wt:11:=[Customers_Bills_of_Lading_Manif:181]Total_Wt:11+aWgt2{$i}
		//[Customers_Bills_of_Lading]Manifest'Total_Rel:=[Customers_ReleaseSchedules]Sched_Qty
	End if 
	
	SAVE RECORD:C53([Customers_Bills_of_Lading_Manif:181])
	If ($new_record)
		APPEND TO ARRAY:C911($aManifestRecNo; Record number:C243([Customers_Bills_of_Lading_Manif:181]))
		APPEND TO ARRAY:C911($aRKrel; aReleases{$i})
		APPEND TO ARRAY:C911($aCntPerCase; aPackQty2{$i})
		APPEND TO ARRAY:C911($aMatch; String:C10(aReleases{$i}; "000000000000000")+String:C10(aPackQty2{$i}; "000000000000000"))
		SORT ARRAY:C229($aMatch; $aManifestRecNo; $aRKrel; $aCntPerCase; >)
	End if 
	uThermoUpdate($i)
End for 
uThermoClose

[Customers_Bills_of_Lading:49]DeclaredValue:33:=Round:C94([Customers_Bills_of_Lading:49]DeclaredValue:33; 0)

SET QUERY LIMIT:C395(0)
ORDER BY:C49([Customers_Bills_of_Lading_Manif:181]; [Customers_Bills_of_Lading_Manif:181]Item:1; >)
