report 50102 "Item Ledger Entries Report"
{
    Caption = 'Item Ledger Entries Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'ItemLedgerEntriesReport.rdl';

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");

            column(ItemNo; "Item No.") { Caption = 'Item No.'; }
            column(LocationCode; "Location Code") { Caption = 'Location Code'; }
            column(PostingDate; "Posting Date") { Caption = 'Posting Date'; }
            column(Quantity; Quantity) { Caption = 'Quantity'; }
            column(RemainingQuantity; "Remaining Quantity") { Caption = 'Remaining Quantity'; }

            trigger OnPreDataItem()
            begin
                // Ensure only records with a valid Location Code are fetched
                ItemLedgerEntry.SetFilter("Location Code", '<>'''''); 

                // Apply user filters
                if LocationFilter <> '' then
                    ItemLedgerEntry.SetRange("Location Code", LocationFilter);
                if ItemNoFilter <> '' then
                    ItemLedgerEntry.SetRange("Item No.", ItemNoFilter);
                
                // Ensure date condition - include all records before the start date
                if StartingDate <> 0D then
                    ItemLedgerEntry.SetRange("Posting Date", 0D, CalcDate('-1D', StartingDate));
                
                if EndingDate <> 0D then
                    ItemLedgerEntry.SetRange("Posting Date", 0D, CalcDate('-1D', EndingDate));

                // Check if data exists, otherwise break report
                if ItemLedgerEntry.IsEmpty() then
                begin
                    Message('No data found for the selected filters.');
                    CurrReport.Break();
                end;
            end;
        }

        dataitem(IntegerLoop; Integer)  
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(SumQuantity; TotalQuantity) { Caption = 'Total Quantity'; }
            column(SumRemainingQuantity; TotalRemainingQuantity) { Caption = 'Total Remaining Quantity'; }

            trigger OnPreDataItem()
            begin
                TotalQuantity := 0;
                TotalRemainingQuantity := 0;

                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetFilter("Location Code", '<>'''''); 
                
                if LocationFilter <> '' then
                    ItemLedgerEntry.SetRange("Location Code", LocationFilter);
                if ItemNoFilter <> '' then
                    ItemLedgerEntry.SetRange("Item No.", ItemNoFilter);
                
                // Apply same date condition
                if StartingDate <> 0D then
                    ItemLedgerEntry.SetRange("Posting Date", 0D, CalcDate('-1D', StartingDate));
                
                if EndingDate <> 0D then
                    ItemLedgerEntry.SetRange("Posting Date", 0D, CalcDate('-1D', EndingDate));

                if ItemLedgerEntry.FindSet() then
                begin
                    repeat
                        TotalQuantity += ItemLedgerEntry.Quantity;
                        TotalRemainingQuantity += ItemLedgerEntry."Remaining Quantity";
                    until ItemLedgerEntry.Next() = 0;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field(LocationFilter; LocationFilter)
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                }
                field(ItemNoFilter; ItemNoFilter)
                {
                    Caption = 'Item No.';
                    ApplicationArea = All;
                }
                field(StartingDate; StartingDate)
                {
                    Caption = 'Starting Date';
                    ApplicationArea = All;
                }
                field(EndingDate; EndingDate)
                {
                    Caption = 'Ending Date';
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        LocationFilter: Code[20];
        ItemNoFilter: Code[20];
        StartingDate: Date;
        EndingDate: Date;
        TotalQuantity: Decimal;
        TotalRemainingQuantity: Decimal;
}
