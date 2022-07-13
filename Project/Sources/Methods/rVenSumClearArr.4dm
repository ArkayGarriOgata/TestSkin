//%attributes = {"publishedWeb":true}
//(p) rVenSumClearArr
//clear arrays for use in Vensum report
//• 7/2/98 cs created

ARRAY DATE:C224(aDate; 0)
ARRAY REAL:C219(aCost; 0)
ARRAY REAL:C219(aPOIQty; 0)
ARRAY INTEGER:C220(aComCode; 0)
ARRAY TEXT:C222(aVend; 0)
ARRAY TEXT:C222(aUOM; 0)
ARRAY TEXT:C222(aKey; 0)
ARRAY REAL:C219(aFlex2; 0)
ARRAY REAL:C219(aFlex3; 0)
ARRAY TEXT:C222(aRMCode; 0)
ARRAY TEXT:C222(aDesc; 0)  //vendor name
ARRAY REAL:C219(ayA2; 0)  //month to date
ARRAY REAL:C219(ayA3; 0)  //quarter to date
ARRAY REAL:C219(ayBx; 0)  //year to date
ARRAY REAL:C219(ayA4; 0)  //last year month to date
ARRAY REAL:C219(ayA5; 0)  //last year quarter to date
ARRAY REAL:C219(ayA6; 0)  //YTD , last year
ARRAY REAL:C219(ayA7; 0)  //last year
//ARRAY DATE(aDate;0)`•092598  MLB  see above
ARRAY TEXT:C222(aPeriod; 0)
ARRAY DATE:C224(aFCDate; 0)