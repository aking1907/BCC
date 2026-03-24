tableextension 59100 "BCC G/L Entry" extends "G/L Entry" //17
{
    fields
    {
        field(59100; "BCC Account Category"; Enum "G/L Account Category")
        {
            Caption = 'Account Category';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account"."Account Category" where("No." = field("G/L Account No.")));
        }
    }
}
