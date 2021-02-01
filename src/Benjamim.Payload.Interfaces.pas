unit Benjamim.Payload.Interfaces;

interface

uses
  {$IF DEFINED(FPC)}
  fpjson, Variants;
  {$ELSE}
  System.Variants, System.JSON;
  {$ENDIF}

Type
  iPayload = interface
    ['{A14B0231-CAB9-40BF-A0D1-91552D33FEA6}']

    function Clear: iPayload;

    function Add(const aKey: string; const aValue: string; aFormat: string = '"%s":"%s"'): iPayload; overload;
    function Add(const aKey: string; const aValue: Int64; aFormat: string = '"%s":%s'): iPayload; overload;
    function Add(const aKey: string; const aValue: UInt64; aFormat: string = '"%s":%s'): iPayload; overload;
    function Add(const aKey: string; const aValue: Extended; aFormat: string = '"%s":%s'): iPayload; overload;
    function Add(const aKey: string; const aValue: TDateTime; aFormat: string = '"%s":"%s"'): iPayload; overload;
    function Add(const aKey: string; const aValue: Boolean; aFormat: string = '"%s":%s'): iPayload; overload;
    function Add(const aKey: string; const aValue: TJsonObject; aFormat: string = '"%s":%s'): iPayload; overload;
    function Add(const aKey: string; const aValue: TJsonArray; aFormat: string = '"%s":%s'): iPayload; overload;
    function Add(const aKey: string; const aValue: Variant; aFormat: string = '"%s":"%s"'): iPayload; overload;

    function jti(const aID: UInt64): iPayload;                                  { jti - Jwt ID          - Jwt ID ( ID ) }
    function iss(const aEmissor: String): iPayload;                             { iss - Issuer          - Emissor ( Emissor ) }
    function sub(const aAssunto: String): iPayload;                             { sub - Subject         - Assunto }
    function aud(const aRemoteIP: String): iPayload;                            { aud - Audience        - Audiência ( Remote IP ) }
    function iat(const aEmissionAt: TDateTime): iPayload; overload;             { iat - Issued At       - Emitido em ( Quando o Token foi Emitido / Automático ) }
    function iat(const aEmissionAtUsDateTime: string): iPayload; overload;      { iat - Issued At       - Emitido em ( Quando o Token foi Emitido / Automático ) }
    function nbf(const aValidityStarted: TDateTime): iPayload; overload;        { nbf - Not Before      - Validade Iniciada ( Inicia Em ) }
    function nbf(const aValidityStartedUsDateTime: string): iPayload; overload; { nbf - Not Before      - Validade Iniciada ( Inicia Em ) }
    function exp(const aValidityEnded: TDateTime): iPayload; overload;          { exp - Expiration Time - Validade Terminada ( Expirar Em ) }
    function exp(const aValidityEndedUsDateTime: string): iPayload; overload;   { exp - Expiration Time - Validade Terminada ( Expirar Em ) }

    function AsJson(const aAsBase64: Boolean = false): string;
    function AsJsonObject: TJsonObject;
  end;

implementation

end.
