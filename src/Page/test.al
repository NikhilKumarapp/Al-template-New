page 50501 "Test Page"{
    SourceTable = test;
    PageType = card;
    ApplicationArea = all;
    UsageCategory = Lists;
    Caption = 'Test Page';
    layout{
        area(Content){
            group(Group1){
                field("test"; Rec."test"){
                    ApplicationArea = all;
                }
                field("Nikhil"; Rec."Nikhil"){
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnOpenPage() begin 
        Message('Hi Nikhil!');
        Message('This is a test page for testing purposes.');
    end;
    trigger OnClosePage() begin
        Message('Goodbye Nikhil!');
        Message('This is a test page for testing purposes.');
    end;        // Message('This is a test page for testing purposes.');

}