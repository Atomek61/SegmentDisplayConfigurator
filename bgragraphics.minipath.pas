unit BGRAGraphics.MiniPath;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Generics.Collections;

type
  TCmd = (pcMove, pcLine, pcArc, pcBezier);
  TPixel :single;
  TAngle :single; // Deg
  TPoint = record
    x, y :TPixel;
  end;

  TPathSegment = class
  end;

  specialize TPathSegments = TObjectList<TPathSegment>;

  TPath = class
    Segments :TPathSegments;
    procedure Draw(Canvas :TCanvas);
  end;

  TMove = class(TPathSegment)
    Pt :TPoint;
  end;

  TLine = class(TPathSegment)
    Pt :TPoint;
  end;

  TArc = class(TPathSegment)
    Pt :TPoint;
    a1, a2 :TAngle;
  end;

  TBezier = class(TPathSegment)
    Pt :TPoint;
    c1 :TPoint; // relative
    c2 :TPoint; // relative
  end;

implementation

end.

