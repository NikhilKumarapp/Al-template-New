/// <summary>
/// Report Sale-Invoice (ID 50007) with Document No. Filter.
/// </summary>
report 50007 "Sale-Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'SaleHeaderInvoice.rdl';
    caption = 'Sales Tax Invoice Jewellery';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No."; // Adding filter for Document No.
            DataItemTableView = where("Document Type" = filter(invoice));
            column(Document_No; "No.") { }
            column(State; State) { }
            column(StateCode; Statecode) { }
            column(Address; Address) { }
            column(GSTIN; "Customer GST Reg. No.") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_PostCode; "Ship-to Post Code") { }
            column(Ship_to_City; "Ship-to City") { }

            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_Address_2; "Bill-to Address 2") { }
            column(Bill_to_PostCode; "Bill-to Post Code") { }
            column(Bill_to_City; "Bill-to City") { }

            column(CustomerId; CustomerId) { }
            column(CustName; CustName) { }
            column(CustomerAddress; CustomerAddress) { }
            column(CustomerStateCode; CustomerStateCode) { }
            column(CustomerGSTNo; CustomerGSTNo) { }
            column(CustomerStateName; CustomerStateName) { }
            column(CustomerPhoneNo; CustomerPhoneNo) { }
            // column(AmountWords; AmountWords) { }
            column(CompInfo_Name; CompInfo.Name) { }
            column(CompInfo_Address; CompInfo.Address) { }
            column(CompInfo_Address_2; CompInfo."Address 2") { }
            column(CompInfo_PostCode; CompInfo."Post Code") { }
            column(CompInfo_City; CompInfo.City) { }
            column(Comp_State; Comp_State) { }
            column(CompInfo_State_code; CompInfo."State Code") { }
            column(CompInfo_GSTRegistrationNo; CompInfo."GST Registration No.") { }
            column(CompInfo_PhoneNo; CompInfo."Phone No.") { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = FIELD("no.");
                DataItemTableView = where("Document Type" = filter(invoice));
                column(SNO; S_No) { }
                column(Item_No; "No.") { }
                column(Item_Description; "Description") { }
                column(HSNSAC; "HSN/SAC Code") { }
                column(Quantity; "Quantity") { }
                column(UOM; "Unit of Measure") { }
                column(Gross_Weight; "Gross Weight") { }
                column(Net_Weight; "Net Weight") { }
                column(Discount; "Line Discount %") { }
                column(TotalAmt; "Line Amount") { }

                trigger OnAfterGetRecord()
                begin
                    S_No += 1;  // Ensure proper numbering for sales line item
                end;   

            }

            trigger OnAfterGetRecord()
            var
                RecCust: Record Customer;
            begin
                if RecCust.Get("Sell-to Customer No.") then begin
                    CustomerId := RecCust."No.";
                    CustName := RecCust.Name;
                    CustomerAddress := RecCust.Address;
                    CustomerStateCode := RecCust."State Code";
                    CustomerStateName := RecCust."City";
                    CustomerGSTNo := RecCust."GST Registration No.";
                    CustomerPhoneNo := RecCust."Phone No.";
                end;
            end;

            trigger OnPreDataItem()
            begin
                CompInfo.Get();
                IF recState.Get(CompInfo."State Code") then
                    Comp_State := recState.Description;
            end;
        }
    }

    trigger OnInitReport()
    begin
        S_No := 0;  // Reset serial number at the start of the report
    end;

    var
        S_No: Integer;
        CompInfo: Record "Company Information";
        recState: Record State;
        Comp_State: Text;
        Address: text[100];
        Statecode: text[100];
        StateName: text;
        GSTNO: Code[30];
        HSNSAC: code[15];
        UOM: code[10];
        TotalAmt: Decimal;
        TotalTaxableAmount: Decimal;
        CustName: Text;
        CustomerId: Code[10];
        CustomerAddress: Text;
        CustomerStateCode: Text;
        CustomerGSTNo: Code[30];
        CustomerStateName: Text;
        CustomerPhoneNo: Code[30];
        AmountWords: Text;
        Customer: Record Customer;
}
