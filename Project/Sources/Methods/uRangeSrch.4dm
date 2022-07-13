//%attributes = {"publishedWeb":true}
//(P) uRangeSrch: select dialog range search

Case of 
	: (sSlctType="I") | (sSlctType="L") | (sSlctType="R")  //Number
		uRangeNum
	: (sSlctType="A")  //Alphanumeric
		uRangeAlpha
	: (sSlctType="D")  //Date
		uRangeDate
End case 