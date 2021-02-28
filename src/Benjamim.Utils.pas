unit Benjamim.Utils;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  SysUtils, StrUtils, variants, fpjson, base64, TypInfo;
  {$ELSE}
  System.Variants, System.JSON, System.Hash;
  {$ENDIF}

type
  TJwtAlgorithm = (HS256, HS384, HS512);
  TSHA2Version = (SHA224, SHA256, SHA384, SHA512, SHA512_224, SHA512_256);

const
  DEFAULT_EXPIRE_IN_HOURS = 2;
  DEFAULT_PASSWORD = 'your-256-bit-secret';
  DEFAULT_ALGORITHM = TJwtAlgorithm.HS256;

type
  TJwtAlgorithmHelper = record Helper for TJwtAlgorithm
    function AsAlgorithm: TSHA2Version;
    function AsString: String;
  end;

  TSHA2VersionHelper = record Helper for TSHA2Version
    function AsJwtAlgorithm: TJwtAlgorithm;
    function AsString: String;
  end;

  TStringHelper = record Helper for String
  const
    Empty = '';
    function AsJwtAlgorithm: TJwtAlgorithm;
    function ClearLineBreak: String;
    function AsJSONObject: TJSONObject;
    function AsBase64: String;
    function FixBase64: string;
    function AsBase64url: String;
    function AsString: String;
  end;

  TVariantHelper = record Helper for Variant
    function AsString: String;
  end;

implementation

{$IF NOT DEFINED(FPC)}
uses System.TypInfo, System.SysUtils, System.StrUtils, System.NetEncoding;
{$ENDIF}

{ TJwtAlgorithmHelper }

function TJwtAlgorithmHelper.AsAlgorithm: TSHA2Version;
var
  LValue: string;
begin
  LValue := Self.AsString;
  LValue := 'SHA' + LValue[3] + LValue[4] + LValue[5];
  Result := TSHA2Version(GetEnumValue(TypeInfo(TSHA2Version), LValue));
end;

function TJwtAlgorithmHelper.AsString: String;
begin
  Result := GetEnumName(TypeInfo(TJwtAlgorithm), integer(Self));
end;

{ TSHA2VersionHelper }

function TSHA2VersionHelper.AsJwtAlgorithm: TJwtAlgorithm;
var
  LValue: string;
begin
  LValue := Self.AsString;
  LValue := 'HS' + LValue[4] + LValue[5] + LValue[6];
  Result := TJwtAlgorithm(GetEnumValue(TypeInfo(TJwtAlgorithm), LValue));
end;

function TSHA2VersionHelper.AsString: String;
begin
  Result := GetEnumName(TypeInfo(TSHA2Version), integer(Self));
end;

{ TStringHelper }

function TStringHelper.AsJwtAlgorithm: TJwtAlgorithm;
begin
  Result := TJwtAlgorithm(GetEnumValue(TypeInfo(TJwtAlgorithm), String(Self)));
end;

function TStringHelper.ClearLineBreak: String;
begin
  Self := StringReplace(Self, sLineBreak, '', [rfReplaceAll]);
  Result := Self;
end;

function TStringHelper.AsJSONObject: TJSONObject;
begin
  Result := {$IF DEFINED(FPC)}GetJSON(Self) as TJSONObject{$ELSE}TJSONObject(TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Self), 0)){$ENDIF};
end;

function Fix(aValue: string): string;
const
  STR_TO_CLEAR = '= ';
var
  I: integer;
begin
  Result := aValue;
  for I := 1 to Length(STR_TO_CLEAR) do
    Result := StringReplace(Result, STR_TO_CLEAR[I], '', [rfReplaceAll]);
end;

function TStringHelper.FixBase64: string;
begin
  Result := Self;
  Result := StringReplace(Result, '+', '-', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '=', '', [rfReplaceAll]);
end;

function TStringHelper.AsBase64url: String;
begin
  {$IF DEFINED(FPC)}
  Result := EncodeStringBase64(Self).FixBase64;
  {$ELSE}
  Result := TBase64Encoding.Base64.Encode(Self).FixBase64;
  {$ENDIF}
end;

function TStringHelper.AsBase64: String;
begin
  {$IF DEFINED(FPC)}
  Result := EncodeStringBase64(Self);
  {$ELSE}
  Result := Fix(TBase64Encoding.Base64.Encode(Self));
  {$ENDIF}
end;

function TStringHelper.AsString: String;
begin
  {$IF DEFINED(FPC)}
  Result := DecodeStringBase64(Self);
  {$ELSE}
  Result := TBase64Encoding.Base64.Decode(Self);
  {$ENDIF}
end;

{ TVariantHelper }

function TVariantHelper.AsString: String;
begin
  Result := VarToStrDef(Self, EmptyStr);
end;

end.
