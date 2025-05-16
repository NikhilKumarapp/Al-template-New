page 50101 StudentList
{
    PageType = List;
    SourceTable = Student;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    CardPageID = StudentCard;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(StudentID; Rec.StudentID) { ApplicationArea = All; Editable = IsEditable; }
                field(StudentName; Rec.StudentName) { ApplicationArea = All; Editable = IsEditable; }
                field(StudentOldID; Rec.StudentOldID){ ApplicationArea = All; Editable = IsEditable;}
                field(FatherName; Rec.FatherName) { ApplicationArea = All; Editable = IsEditable; }
                field(MotherName; Rec.MotherName) { ApplicationArea = All; Editable = IsEditable; }
                field(Address; Rec.Address) { ApplicationArea = All; Editable = IsEditable; }
                field(City; Rec.City) { ApplicationArea = All; Editable = IsEditable; }
                field(PostCode; Rec.PostCode)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;

                }
                field(Class; Rec.Class) { ApplicationArea = All; Editable = IsEditable; }
                field(Section; Rec.Section) { ApplicationArea = All; Editable = IsEditable; }
                field(TotalFee; Rec.TotalFee) { ApplicationArea = All; Editable = IsEditable; }
                field(Released; Rec.Released) { ApplicationArea = All; Editable = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Release)
            {
                Caption = 'Release';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to release student %1?', false, Rec."StudentName") then
                    begin
                        Rec."Released" := true;
                        Rec.Modify(false);
                        IsEditable := false; // Disable all fields
                        Message('Student %1 has been released.', Rec."StudentName");
                    end;
                end;
            }

            action(Reopen)
            {
                Caption = 'Reopen';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to reopen student %1?', false, Rec."StudentName") then
                    begin
                        Rec."Released" := false;
                        Rec.Modify(false);
                        IsEditable := true; // Enable all fields
                        Message('Student %1 has been reopened.', Rec."StudentName");
                    end;
                end;
            }
        }
    }
    var
        [InDataSet]
        IsEditable: Boolean; // Variable to control field editability

    trigger OnAfterGetRecord()
    begin
        // Set the initial state of IsEditable based on the Released field
        IsEditable := not Rec."Released";
    end;
}
