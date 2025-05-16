// report 50055 "Mass Balancing"
// {
//     ApplicationArea = All;
//     Caption = 'Mass Balancing';
//     UsageCategory = ReportsAndAnalysis;
//     ProcessingOnly = true;
//     dataset
//     {
//         dataitem(ValueEntry; "Value Entry")
//         {
//             RequestFilterFields = "Posting Date";
//             trigger OnAfterGetRecord()
//             var
//             begin
//                 // Clear(Testcat);
//                 CreateValueEntryExcel();
//                 if not ILEntryNo.ContainsKey(ValueEntry."Item Ledger Entry No.") then
//                     ILEntryNo.Add(ValueEntry."Item Ledger Entry No.", true);
//             end;

//             trigger OnPreDataItem()
//             var
//                 RecValueEntry: Record "Value Entry";
//                 Position: Integer;
//                 subDate: Text[10];

//             begin
//                 RecExcel.reset();
//                 RecExcel.DELETEALL;
//                 MakeVEDataHeader();

//                 DateFilter := ValueEntry.GetFilter("Posting Date");

//                 if DateFilter <> '' then begin
//                     subDate := '..';
//                     Position := StrPos(DateFilter, subDate);
//                     if Position <> 0 then begin
//                         Evaluate(StartDate, CopyStr(DateFilter, 1, Position - 1));
//                         Evaluate(EndDate, CopyStr(DateFilter, Position + 2));
//                     end;
//                 end;

//                 RecValueEntry.Reset();
//                 RecValueEntry.SetFilter("Item Ledger Entry Type", '=%1', RecValueEntry."Item Ledger Entry Type"::Purchase);
//                 if RecValueEntry.FindSet() then begin
//                     repeat
//                         RecPurchInvHead.Reset();
//                         RecPurchInvHead.SetRange("No.", RecValueEntry."Document No.");
//                         if RecPurchInvHead.FindFirst() then begin
//                             if RecPurchInvHead."TC Required" = RecPurchInvHead."TC Required"::Yes then begin
//                                 DocNo += RecPurchInvHead."No." + '|';
//                             end;
//                         end;
//                     until RecValueEntry.Next() = 0;
//                 end;
//                 DocNo := DocNo.TrimEnd('|');

//                 ValueEntry.SetFilter("Document No.", DocNo);
//                 //Acx Nikhil Kumar
//                 if ValueEntry.IsEmpty() then
//                   Error('No data found for the selected posting date.');
//                 //Acx Nikhil Kumar  
//             end;
//         }
//     }
//     requestpage
//     {
//         layout
//         {
//             area(content)
//             {
//                 group(GroupName)
//                 {
//                 }
//             }
//         }
//         actions
//         {
//             area(processing)
//             {
//             }
//         }
//     }

//     trigger OnPostReport()
//     var
//         myInt: Integer;
//     begin
//         MakeILEDataHeader();
//         CreateILEExcel();

//         RecExcel.CreateNewBook('Mass Balancing Report');
//         RecExcel.WriteSheet('Mass Balancing Report', COMPANYNAME, USERID);
//         RecExcel.CloseBook();
//         RecExcel.SetFriendlyFilename('Mass Balancing Report');
//         RecExcel.OpenExcel();
//     end;

//     var
//         StartDate: Date;
//         EndDate: Date;
//         Testcat: Dictionary of [Text, Boolean];
//         Testcat1: Dictionary of [Text, Boolean];
//         DateFilter: Text;
//         RecCostomer: Record customer;
//         RecILE2: Record "Item Ledger Entry";
//         DocNo: Text;
//         RecPurchInvHead: Record "Purch. Inv. Header";
//         RecExcel: Record "Excel Buffer" temporary;
//         RecPIH: Record "Purch. Inv. Header";
//         RecILE: Record "Item Ledger Entry";
//         RecPurchRecpHead: Record "Purch. Rcpt. Header";
//         RecItem1: Record item;
//         ILEntryNo: Dictionary of [Integer, Boolean];
//         VEDocumentNo: Code[20];
//         VEVendorNo: Code[20];
//         VEVendorName: Text[100];
//         VEILECategory: Code[20];
//         VEILELot: Code[50];
//         VEPRHOrderNo: Code[20];
//         VEConsumption: Decimal;
//         VEOutput: Decimal;
//         VESales: Decimal;
//         VESalesabs: Decimal;
//         VEPHOrderDate: Date;
//         VEColor: Text;
//         VEShade: Text;
//         VEILEQuantity: Decimal;
//         VETCRequired: Boolean;
//         qw: Query "Value Entries";
//         ILEItemDescription: Text;
//         ILEItemCategory: Text;

//     procedure MakeVEDataHeader()
//     begin
//         RecExcel.NewRow;
//         RecExcel.NewRow;
//         RecExcel.AddColumn('Posting Date', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(Format(StartDate), false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(Format(EndDate), false, '', True, False, False, '', RecExcel."Cell Type"::Text);

//         RecExcel.NewRow;
//         RecExcel.AddColumn('Document No.', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Vendor', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Vendor Name', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Item No.', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Item Description', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Category', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Lot', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('OrderNo.', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Order Date', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Invoice No.', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Invoice Date', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Colour', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Shade', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Quantity', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('TC Required', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('TC to be received', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('TC No.', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Consumption', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('FG Output', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Sale', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//     end;

//     local procedure CreateValueEntryExcel()
//     var
//         myInt: Integer;
//         RecValue: Record "Value Entry";
//         RecILE3: Record "Item Ledger Entry";
//         Customr: Record Customer;
//         ItemNo: Code[20];
//         DocNo1: Code[20];
//         LotNo: Code[50];
//         DateFormate: Text;
//         DateFormate1: Text;
//         Doc: Text;
//     begin
//         if RecPIH.Get(ValueEntry."Document No.") then begin
//             VEVendorNo := RecPIH."Buy-from Vendor No.";
//             VEVendorName := RecPIH."Buy-from Vendor Name";
//             VEPHOrderDate := RecPIH."Order Date";
//         end;
//         RecILE.Reset();
//         RecILE.SetRange("Entry No.", ValueEntry."Item Ledger Entry No.");
//         if RecILE.FindFirst() then begin
//             VEILECategory := RecILE."Item Category Code";
//             VEILELot := RecILE."Lot No.";

//             RecPurchRecpHead.Reset();
//             RecPurchRecpHead.SetRange("No.", RecILE."Document No.");
//             if RecPurchRecpHead.FindFirst() then begin
//                 VEPRHOrderNo := RecPurchRecpHead."Order No.";
//             end;
//             VEILEQuantity := RecILE.Quantity;
//             RecItem1.Reset();
//             RecItem1.SetRange("No.", RecILE."Item No.");
//             if RecItem1.FindFirst() then begin
//                 VEColor := RecItem1.Colour;
//                 VEShade := RecItem1."Colour Shade";
//             end;
//         end;
//         RecPurchInvHead.Reset();
//         RecPurchInvHead.SetRange("No.", ValueEntry."Document No.");
//         if RecPurchInvHead.FindFirst() then begin
//             if RecPurchInvHead."TC Required" = RecPurchInvHead."TC Required"::Yes then
//                 VETCRequired := True;
//             if RecPurchInvHead."TC Required" = RecPurchInvHead."TC Required"::No then
//                 VETCRequired := false;
//         end;

//         VEConsumption := 0;
//         RecILE.Reset();
//         RecILE.SetRange("Item No.", ValueEntry."Item No.");
//         RecILE.SetRange("Lot No.", VEILELot);
//         if RecILE.FindSet() then begin
//             repeat
//                 if RecILE."Entry Type" = RecILE."Entry Type"::Consumption then
//                     VEConsumption += RecILE.Quantity;
//             until RecILE.Next() = 0;
//         end;
//         //NS
//         VEOutput := 0;
//         VESales := 0;
//         VESalesabs := 0;
//         DocNo := '';
//         RecILE.Reset();
//         RecILE.SetCurrentKey("Document No.", "Item No.", "Lot No.");
//         RecILE.SetRange("Item No.", ValueEntry."Item No.");
//         RecILE.SetRange("Lot No.", VEILELot);
//         RecILE.SetRange("Entry Type", RecILE."Entry Type"::Consumption);
//         RecILE.SetAscending("Document No.", true);
//         if RecILE.FindSet() then begin
//             repeat
//                 if DocNo <> RecILE."Document No." then begin
//                     RecILE2.Reset();
//                     RecILE2.SetRange("Document No.", RecILE."Document No.");
//                     RecILE2.SetRange("Entry Type", RecILE2."Entry Type"::Output);
//                     if RecILE2.FindSet() then
//                         repeat
//                             DocNo := RecILE2."Document No.";
//                             if (RecILE2."Item Category Code" <> 'WS') and (RecILE2."Item Category Code" <> 'WSOTH') then begin
//                                 VEOutput += RecILE2.Quantity;
//                                 RecILE3.Reset();
//                                 RecILE3.SetCurrentKey("Document No.", "Document Line No.", "Item No.", "Lot No.");
//                                 RecILE3.SetRange("Item No.", RecILE2."Item No.");
//                                 RecILE3.SetRange("Lot No.", RecILE2."Lot No.");
//                                 RecILE3.SetRange("Entry Type", RecILE2."Entry Type"::Sale);
//                                 RecILE3.SetFilter("Posting Date", DateFilter);
//                                 RecILE3.SetAscending("Item No.", true);
//                                 if RecILE3.FindSet() then
//                                     repeat

//                                         RecValue.Reset();
//                                         RecValue.SetRange("Item Ledger Entry No.", RecILE3."Entry No.");
//                                         RecValue.SetRange(Adjustment, false);
//                                         if RecValue.FindFirst() then begin

//                                             if (RecILE3."Item Category Code" <> 'WS') and (RecILE3."Item Category Code" <> 'WSOTH') then
//                                                 if RecILE3."Entry Type" = RecILE3."Entry Type"::Sale then begin
//                                                     Customr.Reset();
//                                                     Customr.SetRange("No.", RecILE3."Source No.");
//                                                     if Customr.FindFirst() then
//                                                         if Customr."Gen. Bus. Posting Group" <> 'INTERUNIT' then begin
//                                                             VESalesabs += abs(RecILE3.Quantity);
//                                                             // if not testcat.ContainsKey(RecILE3."Document No." + '|' + format(RecILE3."Document Line No.") + '|' + RecILE3."Item No." + '|' + RecILE3."Lot No." + '|' + RecILE3."Item Category Code") then begin
//                                                             //     Testcat.Add(RecILE3."Document No." + '|' + format(RecILE3."Document Line No.") + '|' + RecILE3."Item No." + '|' + RecILE3."Lot No." + '|' + RecILE3."Item Category Code", True);
//                                                             //     // VESales := VESalesabs * -1;//162,2276,724,5120,640,RM0051
//                                                             VESales += RecILE3.Quantity;
//                                                             LotNo := RecILE3."Lot No.";
//                                                             // end;
//                                                         end;
//                                                 end;
//                                         end;
//                                     until RecILE3.Next() = 0;
//                             end;
//                         until RecILE2.Next() = 0;
//                 end;
//             until RecILE.Next() = 0;
//         end;
//         //NS

//         RecExcel.NewRow;
//         RecExcel.AddColumn(ValueEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEVendorNo, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEVendorName, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(ValueEntry."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(ValueEntry.Description, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEILECategory, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEILELot, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEPRHOrderNo, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEPHOrderDate, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(ValueEntry."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(ValueEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEColor, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEShade, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEILEQuantity, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VETCRequired, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEConsumption, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VEOutput, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn(VESales, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//     end;

//     local procedure MakeILEDataHeader()
//     var
//         ControlVariable: Integer;
//     begin
//         for ControlVariable := 1 to 5 do begin
//             RecExcel.NewRow;
//         end;
//         RecExcel.AddColumn('Source Item', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Source Item Lot', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         // RecExcel.AddColumn('Source Document', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Supplier', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Entry Type', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Customer', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Customer Name', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Item RM', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Item Description', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Category', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Lot', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Document No.', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Sale Invoice No.', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Posting Date', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Colour', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Shade', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('Quantity', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('TC applied on', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('TC approved on', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('TC Sent to customer on', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         RecExcel.AddColumn('TC No.', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         // RecExcel.AddColumn('Source Item', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//         // RecExcel.AddColumn('Source Document', false, '', True, False, False, '', RecExcel."Cell Type"::Text);
//     end;

//     local procedure CreateILEExcel()
//     var
//         RecILE1: Record "Item Ledger Entry";
//         RecILE2: Record "Item Ledger Entry";
//         RecILE3: Record "Item Ledger Entry";
//         RecItem: Record Item;
//         RecVE: Record "Value Entry";
//         RecVE1: Record "Value Entry";
//         RecVEDocNo: Code[20];
//         RecVEPostingDate: date;
//         ItemCOlor: Text;
//         ItemShade: Text;
//         ILEntryNo1: Text;
//         Entry: Integer;
//         ILEDocNo: Dictionary of [Text, Integer];
//         ILEDocNo1: Text;
//         Doc: Text;
//         SaleEntryDic: Dictionary of [Integer, Boolean];
//         EntryDic: Dictionary of [Integer, Boolean];
//         EntryDic1: Integer;
//         SalesDoc: Text;
//         LotNo: Code[50];
//         RecILE1EntryNo: Integer;

//     begin

//         foreach Entry in ILEntryNo.Keys do begin
//             ILEntryNo1 += Format(Entry) + '|';
//         end;
//         ILEntryNo1 := ILEntryNo1.TrimEnd('|');

//         RecILE1.Reset();
//         RecILE1.SetFilter("Entry No.", ILEntryNo1);
//         if RecILE1.FindSet() then begin
//             repeat
//                 RecILE2.Reset();
//                 RecILE2.SetRange("Item No.", RecILE1."Item No.");
//                 RecILE2.SetRange("Lot No.", RecILE1."Lot No.");
//                 RecILE2.SetFilter("Entry Type", '%1|%2', RecILE2."Entry Type"::Consumption, RecILE2."Entry Type"::Output);
//                 if RecILE2.FindSet() then begin
//                     repeat
//                         // if not ContainsKey(RecILE2."Document No.") then begin
//                         //     ILEDocNo.Add(RecILE2."Document No.", RecILE1."Entry No.");
//                         // end;
//                     until RecILE2.Next() = 0;
//                 end;
//             until RecILE1.Next() = 0;
//         end;

//         foreach Doc in ILEDocNo.Keys do begin
//             ILEDocNo1 += Doc + '|';
//         end;
//         ILEDocNo1 := ILEDocNo1.TrimEnd('|');

//         Clear(EntryDic);

//         RecILE3.Reset();
//         RecILE3.SetFilter("Entry Type", '%1|%2', RecILE2."Entry Type"::Consumption, RecILE2."Entry Type"::Output);
//         RecILE3.SetFilter("Document No.", ILEDocNo1);
//         if RecILE3.FindSet() then begin
//             repeat
//                 RecVE.Reset();
//                 RecVE.SetRange("Item Ledger Entry No.", RecILE3."Entry No.");
//                 RecVE.SetRange(Adjustment, false);
//                 if RecVE.FindFirst() then begin
//                     if RecILE3."Entry Type" = RecILE3."Entry Type"::Output then
//                         if not EntryDic.ContainsKey(RecILE3."Entry No.") then begin
//                             EntryDic.Add(RecILE3."Entry No.", True);
//                         end;
//                     if RecItem.Get(RecILE3."Item No.") then begin
//                         ILEItemDescription := RecItem.Description;
//                         ILEItemCategory := RecItem."Item Category Code";
//                     end;
//                     RecILE1.Reset();
//                     if ILEDocNo.ContainsKey(RecILE3."Document No.") then begin

//                         RecILE1EntryNo := ILEDocNo.Get(RecILE3."Document No.");
//                         // if RecILE1EntryNo <> 0 then
//                         RecILE1.SetRange("Entry No.", RecILE1EntryNo);
//                         if RecILE1.FindFirst() then;

//                         RecVE1.Reset();
//                         RecVE1.SetRange("Item Ledger Entry No.", RecILE1."Entry No.");
//                         if RecVE1.FindFirst() then;

//                         if (RecItem."Item Category Code" <> 'WS') and (RecItem."Item Category Code" <> 'WSOTH') then begin
//                             RecExcel.NewRow;
//                             RecExcel.AddColumn(RecILE1."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn(RecILE1."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             // RecExcel.AddColumn(RecVE1."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn(RecVE1."Source No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn(RecILE3."Entry Type", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn(RecILE3."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn(ILEItemDescription, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn(ILEItemCategory, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn(RecILE3."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn(RecILE3."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                             RecExcel.AddColumn(RecILE3.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Number);
//                         end;
//                     end;
//                 end;
//             until RecILE3.Next() = 0;
//         end;

//         foreach EntryDic1 in EntryDic.Keys do begin
//             SalesDoc += Format(EntryDic1) + '|';
//         end;
//         SalesDoc := SalesDoc.TrimEnd('|');

//         Clear(SaleEntryDic);
//         RecILE1.Reset();
//         RecILE1.SetFilter("Entry No.", SalesDoc);
//         if RecILE1.FindSet() then begin
//             repeat
//                 RecILE2.Reset();
//                 RecILE2.SetCurrentKey("Document No.", "Document Line No.", "Item No.", "Lot No.");
//                 RecILE2.SetRange("Item No.", RecILE1."Item No.");
//                 RecILE2.SetRange("Lot No.", RecILE1."Lot No.");
//                 RecILE2.SetFilter("Entry Type", '=%1', RecILE1."Entry Type"::Sale);
//                 if RecILE2.FindSet() then begin
//                     if LotNo <> RecILE2."Lot No." then
//                         repeat
//                             RecVE.Reset();
//                             RecVE.SetRange("Item Ledger Entry No.", RecILE3."Entry No.");
//                             RecVE.SetRange(Adjustment, false);
//                             if RecVE.FindFirst() then begin
//                                 if not SaleEntryDic.ContainsKey(RecILE2."Entry No.") then begin
//                                     SaleEntryDic.Add(RecILE2."Entry No.", True);
//                                     if RecItem.Get(RecILE2."Item No.") then begin
//                                         ILEItemDescription := RecItem.Description;
//                                         ILEItemCategory := RecItem."Item Category Code";
//                                     end;
//                                     RecVE.Reset();
//                                     RecVE.SetRange("Item Ledger Entry No.", RecILE2."Entry No.");
//                                     if RecVE.FindFirst() then begin
//                                         RecVEDocNo := RecVE."Document No.";
//                                         RecVEPostingDate := RecVE."Posting Date";
//                                     end;
//                                     RecItem.Reset();
//                                     RecItem.SetRange("No.", RecILE2."Item No.");
//                                     if RecItem.FindFirst() then begin
//                                         ItemCOlor := RecItem.Colour;
//                                         ItemShade := RecItem."Colour Shade";
//                                     end;
//                                     RecILE3.Reset();
//                                     RecILE3.SetRange("Entry No.", ILEDocNo.Get(RecILE1."Document No."));
//                                     if RecILE3.FindFirst() then;

//                                     RecVE1.Reset();
//                                     RecVE1.SetRange("Item Ledger Entry No.", RecILE3."Entry No.");
//                                     if RecVE1.FindFirst() then;

//                                     LotNo := RecILE2."Lot No.";

//                                     RecCostomer.Reset();
//                                     RecCostomer.SetRange("No.", RecILE2."Source No.");
//                                     if RecCostomer.FindFirst() then
//                                         if RecCostomer."Gen. Bus. Posting Group" <> 'INTERUNIT' then
//                                             if (RecItem."Item Category Code" <> 'WS') and (RecItem."Item Category Code" <> 'WSOTH') then begin
//                                                 if CopyStr(RecILE2."Item No.", 1, 3) = 'BLK' then
//                                                     // if not testcat1.ContainsKey(RecILE2."Document No." + '|' + format(RecILE2."Document Line No.") + '|' + RecILE2."Item No." + '|' + RecILE2."Lot No." + '|' + RecILE2."Item Category Code") then
//                                                     //     Testcat1.Add(RecILE2."Document No." + '|' + format(RecILE2."Document Line No.") + '|' + RecILE2."Item No." + '|' + RecILE2."Lot No." + '|' + RecILE2."Item Category Code", True);
//                                                 RecExcel.NewRow;
//                                                 RecExcel.AddColumn(RecILE3."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(RecILE3."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 // RecExcel.AddColumn(RecVE1."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(RecVE1."Source No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(RecILE2."Entry Type", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(RecILE2."Source No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(RecCostomer.Name, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(RecILE2."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(ILEItemDescription, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(ILEItemCategory, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(RecILE2."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(RecVEDocNo, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(RecVEPostingDate, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(ItemCOlor, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(ItemShade, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Text);
//                                                 RecExcel.AddColumn(RecILE2.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', RecExcel."Cell Type"::Number);
//                                             end;
//                                 end;
//                             end;
//                         until RecILE2.Next() = 0;
//                 end;

//             until RecILE1.Next() = 0;
//         end;
//     end;

// }
