<>purgeFolderPath:=Select folder:C670("Select Purge Folder")
If (<>purgeFolderPath[[Length:C16(<>purgeFolderPath)]]#":")
	<>purgeFolderPath:=<>purgeFolderPath+":"
End if 
<>purgeFolderPath:=<>purgeFolderPath+fYYMMDD(4D_Current_date)+"Purgeƒ:"

If (Test path name:C476(<>purgeFolderPath)<0)
	$Error:=NewFolder(<>purgeFolderPath)
End if 
$Error:=SetDefaultPath(<>purgeFolderPath)