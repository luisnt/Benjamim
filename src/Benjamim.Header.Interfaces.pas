unit Benjamim.Header.Interfaces;

interface

uses
  {$IF DEFINED(FPC)}
  fpjson,
  {$ELSE}
  System.JSON,
  {$ENDIF}
  Benjamim.Utils;

Type
  iHeader = interface
    ['{A14B0231-CAB9-40BF-A0D1-91552D33FEA6}']
    function Algorithm: string; overload;
    function Algorithm(const aAlgorithm: TJwtAlgorithm): iHeader; overload;
    function AsJson(const AsBase64: boolean = false): string;
    function AsJsonObject: TJSONObject;
  end;

implementation

end.
