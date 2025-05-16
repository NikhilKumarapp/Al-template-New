pageextension 50000 CustomerListExt extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name){
            field("Customer NickName"; Rec."Customer NickName"){
                ApplicationArea = all;
            }
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
    var
        myInt: Integer;
}