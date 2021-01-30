unit Benjamim.Payload.Interfaces;

interface

uses
  System.Variants, System.JSON

    ;

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

    function jti(const aID: UInt64): iPayload;                 { jti - Jwt ID          - Jwt ID ( ID ) }
    function iss(const aEmissor: String): iPayload;            { iss - Issuer          - Emissor ( Emissor ) }
    function sub(const aAssunto: String): iPayload;            { sub - Subject         - Assunto }
    function aud(const aRemoteIP: String): iPayload;           { aud - Audience        - Audiência ( Remote IP ) }
    function iat(const aEmissionAt: TDateTime): iPayload;      { iat - Issued At       - Emitido em ( Quando o Token foi Emitido / Automático ) }
    function nbf(const aValidityStarted: TDateTime): iPayload; { nbf - Not Before      - Validade Iniciada ( Inicia Em ) }
    function exp(const aValidityEnded: TDateTime): iPayload;   { exp - Expiration Time - Validade Terminada ( Expirar Em ) }

    function AsJson(const aAsBase64: Boolean = false): string;
    function AsJsonObject: TJsonObject;
  end;

implementation

end.
