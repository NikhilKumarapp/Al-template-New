report 50014 "Company Details"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'CompanyDetailsReport.rdl';


    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(CompInfo_Address; CompInfo.Address)
            {
            }
            column(CompInfo_Address_2; CompInfo."Address 2")
            {
            }
            column(CompInfo_PostCode; CompInfo."Post Code")
            {
            }
            column(CompInfo_City; CompInfo.City)
            {
            }
            column(Comp_State; Comp_State)
            {
            }
            column(CompInfo_State_code; CompInfo."State Code")
            {
            }
            column(CompInfo_GSTRegistrationNo; CompInfo."GST Registration No.")
            {

            }
            column(CompInfo_PhoneNo; CompInfo."Phone No.")
            {
            }
            
            trigger OnAfterGetRecord()
            begin
                CompInfo.Get();
                IF State.Get(CompInfo."State Code") then
                    Comp_State := State.Description;

            end;
        }
    }



    var
        State: Record "State";
        Comp_State: Text;
        CompInfo: Record "Company Information";
        state_description: text;

}