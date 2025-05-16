// page 50000 "Test Page"
// {
//     PageType = List;
//     ApplicationArea = All;
//     UsageCategory = Administration;
//     SourceTable = "Test Table";
    
//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("Entry No."; Rec."Entry No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Name;Rec.Name){
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }
    
//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {
                
//                 trigger OnAction()
//                 begin
                    
//                 end;
//             }
//         }
//     }
    
//     var
//         myInt: Integer;
// }