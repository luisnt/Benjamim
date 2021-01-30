program BenjamimTest;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils
    , Benjamim
    ;

procedure print(aToken: string; aSign: boolean);
begin
  WriteLn(EmptyStr);
  WriteLn('       Token: ');
  WriteLn(aToken);
  WriteLn('   Algorithm: ', Benjamim.JWT.Header.Algorithm);
  WriteLn('        Sign: ', BoolToStr(aSign, true));
  WriteLn(EmptyStr);
  WriteLn(EmptyStr);
end;

var
  LToken: string;
  LSign : boolean;

begin
  ReportMemoryLeaksOnShutdown := true;

  try
    Benjamim.JWT.Password('secret'); { OPTIONAL }

    Benjamim.JWT.Header.Algorithm(TJwtAlgorithm.HS512); { OPTIONAL - DEFAULT TJwtAlgorithm.HS256 }

    Benjamim.JWT.Payload.jti(1)
      .iss('Luis Nt')
      .sub('Chave de acesso')
      .aud('192.168.0.77')
      .iat('2021-01-31 15:55:21.123')
      .nbf('2021-01-31 18:01:01.001')
      .exp('2021-01-31 22:01:01.001')
      .add('price', 10.5)
      .add('name', 'your fullname')
      .add('phone', 559822223333)
      ;
    LToken := Benjamim.JWT.Signature.Sign;

    LSign :=
      Benjamim.JWT
      .Token(LToken)
      .Signature
      .Verify;

    print(LToken, LSign);

    LToken :=
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ikpva' +
      'G4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

    LSign :=
      Benjamim.JWT
      .Token(LToken)
      .Password('your-256-bit-secret') { usado no site JWT.io }
      .Signature
      .Verify;

    print(LToken, LSign);

    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
