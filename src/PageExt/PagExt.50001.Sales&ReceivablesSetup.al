pageextension 50001 SalesandReceivables extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Customer Nos.")
        {
            field("Student No. acx"; rec.StudentID)
            {
                ApplicationArea = all;

            }

            field("StudentNe No. abc"; rec.NewStudentID){
                ApplicationArea = all;
            }

             field("StudentID Series 1"; Rec."StudentID Series 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the No. Series for Student ID Series 1.';
            }
            field("StudentID Series 2"; Rec."StudentID Series 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the No. Series for Student ID Series 2.';
            }
            field("StudentID Series 3"; Rec."StudentID Series 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the No. Series for Student ID Series 3.';
            }

        }
    }

    actions
    {

    }

    var
        myInt: Integer;
}