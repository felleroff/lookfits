program LookFitsDem;

uses
  Vcl.Forms,
  ufmDemo in 'ufmDemo.pas' {fmDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmDemo, fmDemo);
  Application.Run;
end.
