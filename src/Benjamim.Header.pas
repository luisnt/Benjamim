unit Benjamim.Header;

interface

uses
  System.JSON, System.Classes, System.SysUtils

    , Benjamim.Utils
    , Benjamim.Header.Interfaces

    ;

type
  THeader = class(TInterfacedObject, iHeader)
    class function New: iHeader;
    constructor Create;
    destructor Destroy; override;
  strict private
    FHeader: TJwtAlgorithm;
  public
    function Algorithm: string; overload;
    function Algorithm(const aAlgorithm: TJwtAlgorithm): iHeader; overload;
    function AsJson(const AsBase64: boolean = false): string;
    function AsJsonObject: TJSONObject;
  end;

implementation

{ THeader }

class function THeader.New: iHeader;
begin
  Result := Self.Create;
end;

constructor THeader.Create;
begin
  FHeader := TJwtAlgorithm.HS256;
end;

destructor THeader.Destroy;
begin
  inherited;
end;

function THeader.Algorithm(const aAlgorithm: TJwtAlgorithm): iHeader;
begin
  FHeader := aAlgorithm;
  Result  := Self;
end;

function THeader.AsJson(const AsBase64: boolean = false): string;
begin
  Result := Format('{"alg":"%s","typ":"JWT"}', [FHeader.AsString]);
  if AsBase64 then
    Result := Result.AsBase64url.ClearLineBreak;
end;

function THeader.AsJsonObject: TJSONObject;
begin
  Result := AsJson(false).ClearLineBreak.AsJsonObject;
end;

function THeader.Algorithm: string;
begin
   Result := FHeader.AsString;
end;

end.
