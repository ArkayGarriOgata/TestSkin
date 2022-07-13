//%attributes = {}
//Method:  Core_NmKy_0000Explain
//Description:  This method will explain how the Name/Key find works
//   This can be used to look up fieldnames and keys and value or values 
//   with those in the database.

//Example 1:  You want to find all references to Product Code
//.  that have a " (double quote) in them.

//  Name Field that use ProductCode are:
//             FG_Key, SKU, ProductCode, CPN
//   Name Value would be @"@

//Example 2:  You want to find all references to Company and Company ID
//.    for 
//  Name Field that use Company are:
//             Name, CustomerName, ShortName, CPN
//   Name Value would be @"@