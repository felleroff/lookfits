program LookFitsApp;

uses
  Vcl.Forms,
  ufmMain in '..\forms\ufmMain.pas' {fmMain},
  uUtils in '..\units\uUtils.pas',
  uProfile in '..\units\uProfile.pas',
  ufmWinProgress in '..\forms\ufmWinProgress.pas' {fmWinProgress},
  ufrBase in '..\forms\ufrBase.pas' {frBase: TFrame},
  ufrHeader in '..\forms\ufrHeader.pas' {frHeader: TFrame},
  ufrData in '..\forms\ufrData.pas' {frData: TFrame},
  ufrImage in '..\forms\ufrImage.pas' {frImage: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
