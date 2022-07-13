//%attributes = {"publishedWeb":true}
//(p) UpdateFGTypeLst
//• 10/27/97 cs created
//•042999  MLB  increase list to 30, trim the desc
//update FG Product Class/Type list
MESSAGES OFF:C175
ALL RECORDS:C47([Finished_Goods_Classifications:45])
SELECTION TO ARRAY:C260([Finished_Goods_Classifications:45]Class:1; $Class; [Finished_Goods_Classifications:45]Description:2; $Desc)
ARRAY TEXT:C222($List; Size of array:C274($Class))
uClearSelection(->[Finished_Goods_Classifications:45])

For ($i; 1; Size of array:C274($List))
	$List{$i}:=$Class{$i}+" "+Substring:C12($Desc{$i}; 1; 27)
End for 
SORT ARRAY:C229($List; >)
If (Size of array:C274($List)>0)  // Modified by: Mel Bohince (8/5/15) protect indice out of range
	ARRAY TEXT:C222($List; Size of array:C274($List)-1)  //at end of list is an item We do not want, remove it
End if 
ARRAY TO LIST:C287($List; "ProductClassType")
MESSAGES ON:C181
//