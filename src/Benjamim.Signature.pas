unit Benjamim.Signature;

interface

uses
  System.Classes, System.TypInfo, System.NetEncoding, System.Hash, System.SysUtils
    , Benjamim.Utils
    , Benjamim.Signature.Interfaces
    , Benjamim.Interfaces

    ;

type
  TSignature = class(TInterfacedObject, iSignature)
    class function New(const aJWT: iJWT): iSignature;
    constructor Create(const aJWT: iJWT);
    destructor Destroy; override;
  strict private
    FJWT: iJWT;

    procedure loadAlgorithm(const aHeader: string);
    function Sign(const aData: string): string; overload;
  private

  public
    function Sign: string; overload;
    function Verify: boolean;
  end;

implementation

{ TSignature }

class function TSignature.New(const aJWT: iJWT): iSignature;
begin
  Result := Self.Create(aJWT);
end;

constructor TSignature.Create(const aJWT: iJWT);
begin
  FJWT := aJWT;
end;

destructor TSignature.Destroy;
begin
  FJWT := nil;
  inherited;
end;

function TSignature.Sign(const aData: string): string;
begin
  if FJWT.PasswordEncoded then
    Exit((TNetEncoding.Base64.EncodeBytesToString(THashSHA2.GetHMACAsBytes(
      TEncoding.UTF8.GetBytes(aData),
      TNetEncoding.Base64.DecodeStringToBytes(FJWT.Password),
      FJWT.Header.Algorithm.AsJwtAlgorithm.AsAlgorithm
      ))).ClearLineBreak.FixBase64);

  Result := (TNetEncoding.Base64.EncodeBytesToString(THashSHA2.GetHMACAsBytes(
    TEncoding.UTF8.GetBytes(aData),
    FJWT.Password,
    FJWT.Header.Algorithm.AsJwtAlgorithm.AsAlgorithm)
    )).ClearLineBreak.FixBase64;
end;

procedure TSignature.loadAlgorithm(const aHeader: string);
begin
  if SameStr(aHeader, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9') then
  begin
    FJWT.Header.Algorithm(TJwtAlgorithm.HS256);
    Exit;
  end;

  if SameStr(aHeader, 'eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9') then
  begin
    FJWT.Header.Algorithm(TJwtAlgorithm.HS384);
    Exit;
  end;

  if SameStr(aHeader, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9') then
  begin
    FJWT.Header.Algorithm(TJwtAlgorithm.HS512);
    Exit;
  end;

  FJWT.Header.Algorithm(TJwtAlgorithm.HS256);
end;

{ Signature - Verify }
function TSignature.Verify: boolean;
const
  INDEX_HEADER    = 0;
  INDEX_PAYLOAD   = 1;
  INDEX_SIGNATURE = 2;
begin
  try
    with TStringList.Create do
      try
        Clear;
        Delimiter       := DotSep[1];
        StrictDelimiter := true;
        DelimitedText   := FJWT.Token;
        loadAlgorithm(Strings[INDEX_HEADER]);
        Exit(SameStr(Strings[INDEX_SIGNATURE], Sign(Strings[INDEX_HEADER] + DotSep + Strings[INDEX_PAYLOAD])));
      finally
        Free;
      end;
  except
    on E: Exception do
  end;
  Result := false;
end;

{ Signature - Sign }
function TSignature.Sign: string;
begin
  Result := FJWT.Header.AsJson(true) + DotSep + FJWT.Payload.AsJson(true);
  Result := Result + DotSep + Sign(Result);
end;

end.
