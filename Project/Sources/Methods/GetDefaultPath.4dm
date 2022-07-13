//%attributes = {"publishedWeb":true}
//PM: GetDefaultPath() -> 
//@author mlb - 9/5/02  13:40
//replace FilePack

If (True:C214)  //mlb 08/18/03
	$0:=util_DocumentPath
	
Else 
	READ ONLY:C145([Users:5])
	QUERY:C277([Users:5]; [Users:5]UserName:11=Current user:C182)
	If (Length:C16([Users:5]FavoriteFolder:25)>0)
		If ([Users:5]FavoriteFolder:25[[Length:C16([Users:5]FavoriteFolder:25)]]#":")
			$0:=[Users:5]FavoriteFolder:25+":"
		Else 
			$0:=[Users:5]FavoriteFolder:25
		End if 
		
	Else 
		$fullPath:=Application file:C491
		$len:=Length:C16(HFSShortName($fullPath))
		$0:=Substring:C12($fullPath; 1; (Length:C16($fullPath)-$len))
	End if 
	REDUCE SELECTION:C351([Users:5]; 0)
End if 