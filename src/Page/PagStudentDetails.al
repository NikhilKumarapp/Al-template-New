page 50121 "Student Subject Details"
{
    PageType = ListPart;
    SourceTable = "Student Subject Details";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = All;
                    Caption = 'Document No';
                    Editable = false;
                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = All;
                    Caption = 'Line No';
                }
                field("Subject Name"; Rec."Subject Name")
                {
                    ApplicationArea = All;
                    Caption = 'Subject Name';
                }
                field("Total Marks"; Rec."Total Marks")
                {
                    ApplicationArea = All;
                    Caption = 'Total Marks';
                }
                field("Obtained Marks"; Rec."Obtained Marks")
                {
                    ApplicationArea = All;
                    Caption = 'Obtained Marks';
                }
                field("Percentage"; Rec."Percentage")
                {
                    ApplicationArea = All;
                    Caption = 'Percentage';
                }
            }

        }
    }
}