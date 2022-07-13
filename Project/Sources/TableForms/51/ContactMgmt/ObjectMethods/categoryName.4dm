//Case of 
//: (Form event=On After Edit)
//C_OBJECT($category_o)
//C_LONGINT($bw;$bh;$bw1;$bh1)
//C_LONGINT($l;$t;$r;$b)
//C_LONGINT($numRecords_l)
//C_TEXT($enteredText_t)
//$enteredText_t:=Get edited text

//If ($enteredText_t#"")
//Form.autofill_preview:=ds.Category.query("Name = :1";$enteredText_t+"@")
//$numRecords_l:=Form.autofill_preview.length

//  // Limit autofill listbox to 10 categories
//If ($numRecords_l>0)
//If ($numRecords_l>10)
//Form.autofill_preview:=Form.autofill_preview.slice(0;10)
//End if 

//For each ($category_o;Form.autofill_preview)
//Form.textPreview:=$category_o.Name
//OBJECT GET BEST SIZE(*;"textPreview";$bw1;$bh1)

//  // Get largest text width out of all the category names
//If ($bw1>$bw)
//$bw:=$bw1+10
//End if 
//End for each 

//$bh:=LISTBOX Get rows height(*;"autofill_preview_lb";lk pixels)*$numRecords_l+4

//OBJECT GET COORDINATES(*;"categoryName";$l;$t;$r;$b)
//OBJECT SET COORDINATES(*;"autofill_preview_lb";$l;$t+20;$l+$bw;$b+$bh)

//OBJECT SET VISIBLE(*;"autofill_preview_lb";True)
//LISTBOX SET ROWS HEIGHT(*;"autofill_preview_lb";25;lk pixels)
//Else 
//OBJECT SET VISIBLE(*;"autofill_preview_lb";False)
//End if 
//Else 
//OBJECT SET VISIBLE(*;"autofill_preview_lb";False)
//End if 

//End case 