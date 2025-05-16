query 50000 "Test Query"
{
    Caption = 'Test Query';
    QueryType = Normal;
    
    elements
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No."){ }
            dataitem(Sales_Invoice_Line;"Sales Invoice Line"){
                DataItemLink = "Sell-to Customer No." = Customer."No.";
                SqlJoinType = RightOuterJoin;
                DataItemTableFilter = Type= filter(Item), Quantity= filter(<> 0);

                column(Posting_Date;"Posting Date"){ }
                column(Quantity;Quantity){
                    Method = Sum;
                }
            }
        }
    }
    
    var
        myInt: Integer;
    
    trigger OnBeforeOpen()
    begin
        
    end;
}