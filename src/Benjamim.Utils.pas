unit Benjamim.Utils;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  fpjson, base64;
  {$ELSE}
  System.Variants, System.JSON, System.Hash;
  {$ENDIF}

type
  TJwtAlgorithm = (HS256, HS384, HS512);
  {$IF DEFINED(FPC)}
  { TODO -oAll -cLazarus : Implementar para lazarus }
  {$ELSE}
  TSHA2Version = THashSHA2.TSHA2Version;
  {$ENDIF}

const
  DEFAULT_EXPIRE_IN_HOURS = 2;
  DEFAULT_PASSWORD = 'your-256-bit-secret';
  DEFAULT_ALGORITHM = TJwtAlgorithm.HS256;

type
  TJwtAlgorithmHelper = record Helper for TJwtAlgorithm
    {$IF DEFINED(FPC)}
    { TODO -oAll -cLazarus : Implementar para lazarus }
    {$ELSE}
    function AsAlgorithm: TSHA2Version;
    {$ENDIF}
    function AsString: String;
  end;

  {$IF DEFINED(FPC)}
  { TODO -oAll -cLazarus : Implementar para lazarus }
  {$ELSE}
  TSHA2VersionHelper = record Helper for TSHA2Version
    function AsJwtAlgorithm: TJwtAlgorithm;
    function AsString: String;
  end;
  {$ENDIF}

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

uses
  {$IF DEFINED(FPC)}
  SysUtils, StrUtils, variants;
  {$ELSE}
  System.TypInfo, System.SysUtils, System.StrUtils, System.NetEncoding;
  {$ENDIF}

{ TJwtAlgorithmHelper }

{$IF DEFINED(FPC)}
{ TODO -oAll -cLazarus : Implementar para lazarus }
{$ELSE}
function TJwtAlgorithmHelper.AsAlgorithm: TSHA2Version;
var
  LValue: string;
begin
  LValue := Self.AsString;
  LValue := 'SHA' + LValue[3] + LValue[4] + LValue[5];
  Result := TSHA2Version(GetEnumValue(TypeInfo(TSHA2Version), LValue));
end;
{$ENDIF}

function TJwtAlgorithmHelper.AsString: String;
begin
  {$IF DEFINED(FPC)}
  { TODO -oAll -cLazarus : Implementar para lazarus }
  {$ELSE}
  Result := GetEnumName(TypeInfo(TJwtAlgorithm), integer(Self));
  {$ENDIF}
end;

{ TSHA2VersionHelper }

{$IF DEFINED(FPC)}
{ TODO -oAll -cLazarus : Implementar para lazarus }
{$ELSE}
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
{$ENDIF}

{ TStringHelper }

function TStringHelper.AsJwtAlgorithm: TJwtAlgorithm;
begin
  {$IF DEFINED(FPC)}
  { TODO -oAll -cLazarus : Implementar para lazarus }
  {$ELSE}
  Result := TJwtAlgorithm(GetEnumValue(TypeInfo(TJwtAlgorithm), String(Self)));
  {$ENDIF}
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
  { TODO -oAll -cLazarus : Implementar para lazarus }
  {$ELSE}
  Result := TBase64Encoding.Base64.Encode(Self).FixBase64;
  {$ENDIF}
end;

function TStringHelper.AsBase64: String;
begin
  {$IF DEFINED(FPC)}
  { TODO -oAll -cLazarus : Implementar para lazarus }
  {$ELSE}
  Result := Fix(TBase64Encoding.Base64.Encode(Self));
  {$ENDIF}
end;

function TStringHelper.AsString: String;
begin
  {$IF DEFINED(FPC)}
  { TODO -oAll -cLazarus : Implementar para lazarus }
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
