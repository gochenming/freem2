program Test;

uses
  Forms,
  Main in 'Main.pas' {FormTest},
  grobal2 in '..\..\..\�ҵ����\��½��\��½��\GameLogin\Grobal2.pas',
  EDcode in '..\..\ESelGate\EDCode.pas',
  HUtil32 in '..\..\ESelGate\HUtil32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormTest, FormTest);
  Application.Run;
end.
