unit Benjamim;

interface

uses
  System.Classes, System.StrUtils
    , Benjamim.Utils
    , Benjamim.Header.Interfaces
    , Benjamim.Payload.Interfaces
    , Benjamim.Signature.Interfaces
    , Benjamim.Interfaces
    ;

type
  TJwtAlgorithm = Benjamim.Utils.TJwtAlgorithm;

type
  TJWT = class(TInterfacedObject, iJWT)
    class function New(const aSingleton: boolean = true): iJWT;
    constructor Create;
    destructor Destroy; override;

  strict private
    FToken          : string;
    FPassword       : string;
    FPasswordEncoded: boolean;
    FHeader         : iHeader;
    FPayload        : iPayload;
    FSignature      : iSignature;

  private
    class var FInstance: iJWT;
  public
    function Token(aValue: string): iJWT; overload;
    function Password(aValue: string; const aEncoded: boolean = false): iJWT; overload;
    function PasswordEncoded: boolean;

    function Token: string; overload;
    function Password: string; overload;
    function Header: iHeader;
    function Payload: iPayload;
    function Signature: iSignature;
  end;

function JWT(const aSingleton: boolean = true): iJWT;

implementation

uses
  System.SysUtils
    , Benjamim.Header
    , Benjamim.Payload
    , Benjamim.Signature
    ;

function JWT(const aSingleton: boolean = true): iJWT;
begin
  Result := TJWT.New(aSingleton);
end;

{ TJWT }

class function TJWT.New(const aSingleton: boolean = true): iJWT;
begin
  if not aSingleton then
    Exit(TJWT.Create);

  if not Assigned(TJWT.FInstance) then
    TJWT.FInstance := TJWT.Create;

  Result := TJWT.FInstance;
end;

constructor TJWT.Create;
begin
  FHeader          := THeader.New;
  FPayload         := TPayload.New;
  FSignature       := TSignature.New(Self);
  FPasswordEncoded := false;
end;

destructor TJWT.Destroy;
begin
  FHeader    := nil;
  FPayload   := nil;
  FSignature := nil;
  inherited Destroy;
end;

function TJWT.Password(aValue: string; const aEncoded: boolean = false): iJWT;
begin
  FPassword        := aValue;
  FPasswordEncoded := aEncoded;
  Result           := Self;
end;

function TJWT.Token(aValue: string): iJWT;
begin
  FToken := aValue;
  Result := Self;
end;

function TJWT.Header: iHeader;
begin
  Result := FHeader;
end;

function TJWT.Payload: iPayload;
begin
  Result := FPayload;
end;

function TJWT.Signature: iSignature;
begin
  Result := FSignature;
end;

function TJWT.Token: string;
begin
  Result := FToken;
end;

function TJWT.Password: string;
begin
  Result := FPassword;
end;

function TJWT.PasswordEncoded: boolean;
begin
  Result := FPasswordEncoded;
end;

var
  LPass: string;

initialization

begin
  LPass := GetEnvironmentVariable('JWT_PRIVATE_PASSWORD');
  JWT.Password(IFThen(SameStr(LPass, EmptyStr), DEFAULT_PASSWORD, LPass));
end;

finalization

JWT._Release;

end.
