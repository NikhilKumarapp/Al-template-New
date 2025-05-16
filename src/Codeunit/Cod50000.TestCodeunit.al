codeunit 50000 "Test Codeunit"
{
    trigger OnRun()
    begin
        
    end;

    procedure UpdateCustomerNickName(CustomerNo: Code[30])
    begin
        Clear(recCustomer);
        if recCustomer.Get(CustomerNo) then begin
            recCustomer.Validate("Customer NickName", 'NickName-'+recCustomer.Name);
            recCustomer.Modify();
        end;
    end;
    
    var
        recCustomer: Record Customer;
}