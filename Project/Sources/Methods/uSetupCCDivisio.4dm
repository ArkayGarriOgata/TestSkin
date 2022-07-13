//%attributes = {"publishedWeb":true}
//(p) uSetupCCDivisio(n)
//creates 2 interprocess sets of unique CCs (and current effectivity date)
//for each company/division
//Also create an interprocess list (text) of unique CCs for each division
//• 3/26/98 cs created
//• 5/27/98 cs added creation of text list of CCs

C_TEXT:C284(<>Roanoke_CCs; <>Ny_CCs)

MESSAGES OFF:C175

QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]CompanyID:6="1"; *)  //get Hauppauge CCs
QUERY:C277([Cost_Centers:27];  & ; [Cost_Centers:27]ProdCC:39=True:C214)
CREATE SET:C116([Cost_Centers:27]; "◊CCHauppauge")
ARRAY TEXT:C222($CC; 0)
SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $CC)
SORT ARRAY:C229($CC; >)

For ($i; 1; Size of array:C274($CC))
	<>Ny_CCs:=<>Ny_CCs+$CC{$i}+";"
End for 

QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]CompanyID:6="2"; *)  //get those CC for Roanoke
QUERY:C277([Cost_Centers:27];  & ; [Cost_Centers:27]ProdCC:39=True:C214)

CREATE SET:C116([Cost_Centers:27]; "◊CCRoanoke")
ARRAY TEXT:C222($CC; 0)
SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $CC)
SORT ARRAY:C229($CC; >)
For ($i; 1; Size of array:C274($CC))
	<>Roanoke_CCs:=<>Roanoke_CCs+$CC{$i}+";"
End for 

<>Ny_CCs:=<>Ny_CCs+" 888"
<>Roanoke_CCs:=<>Roanoke_CCs+" 888"