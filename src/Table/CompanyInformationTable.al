// table 50100 "Company Information"
// {
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "Company Name"; Text[100])
//         {
//             DataClassification = CustomerContent;
//         }
//         field(2; "State Code"; Code[2])
//         {
//             DataClassification = CustomerContent;
//         }
//         field(3; Revenue; Decimal)
//         {
//             DataClassification = CustomerContent;
//         }
//     }

//     keys
//     {
//         key(PK; "Company Name")
//         {
//             Clustered = true;
//         }
//     }
// }