//%attributes = {"publishedWeb":true}
//(P) uInitPageLists:builds arrays for paging pop-ups
//•090195  MLB  move assignments to before phases

ARRAY TEXT:C222(<>asUserPages; 2)
<>asUserPages{1}:="Name"
<>asUserPages{2}:="Notes"
ARRAY TEXT:C222(<>asVendPages; 0)
ARRAY TEXT:C222(<>asReqPages; 0)
ARRAY TEXT:C222(<>asRItPages; 0)
ARRAY TEXT:C222(<>asPOPages; 0)
ARRAY TEXT:C222(<>asPOIPages; 0)
ARRAY TEXT:C222(<>asRMPages; 0)
ARRAY TEXT:C222(<>asCustPages; 0)
ARRAY TEXT:C222(<>asChgOPages; 2)
<>asChgOPages{1}:="Classification"
<>asChgOPages{2}:="Line Item Changes"
ARRAY TEXT:C222(<>asFGPages; 0)
ARRAY TEXT:C222(<>asRFQPages; 0)
ARRAY TEXT:C222(<>asPspecPage; 2)
<>asPspecPage{1}:="Characteristics"
<>asPspecPage{2}:="<Operations&Mat'ls>"
ARRAY TEXT:C222(<>asCspecPage; 2)
<>asCspecPage{1}:="Specifications"
<>asCspecPage{2}:="Pricing & <Costs>"
ARRAY TEXT:C222(<>asCDPages; 2)
<>asCDPages{1}:="Cover Page"
<>asCDPages{2}:="Carton Spec"
ARRAY TEXT:C222(<>asCOPages; 2)
<>asCOPages{1}:="Header"
<>asCOPages{2}:="Detail"
ARRAY TEXT:C222(<>asContPages; 2)  //Contact File
<>asContPages{1}:="Name & Notes"
<>asContPages{2}:="Contact History"
ARRAY TEXT:C222(<>asFspecPage; 2)
<>asFspecPage{1}:="Layout"
<>asFspecPage{2}:="Operations/Mat'ls"
//◊asFspecPage{3}:="Materials"
ARRAY TEXT:C222(<>asOspecPage; 2)
<>asOspecPage{1}:="Machine"
<>asOspecPage{2}:="Material"
ARRAY TEXT:C222(<>asSalePage; 2)
<>asSalePage{1}:="Salesman Info"
<>asSalePage{2}:="Bookings"
ARRAY TEXT:C222(<>asDiffPages; 2)
<>asDiffPages{1}:="Form Estimates"
<>asDiffPages{2}:="Pricing"
//ARRAY TEXT(◊asJobPages;3)
//◊asJobPages{1}:="Budget"
//◊asJobPages{2}:="Machine & Material"
//◊asJobPages{3}:="Actuals Entered"

ARRAY TEXT:C222(<>asJobAPages; 0)
ARRAY TEXT:C222(<>asBJobPages; 0)
ARRAY TEXT:C222(<>asItemPages; 0)