unit Benjamim.Signature.Interfaces;

interface

Type
  iSignature = interface
    ['{9576A323-797D-414D-AFFB-0F3CCC567AFB}']
    function Sign: string;
    function Verify: boolean;
  end;

implementation

end.
