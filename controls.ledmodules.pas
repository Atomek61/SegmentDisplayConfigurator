unit Controls.LedModules;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Generics.Collections;

type
  TPixel = single;

  TModule = class
  public
    procedure Draw(Canvas :TCanvas);
    property Width :TPixel;
    property Height :TPixel;
    property Left :TPixel;
    property Top :TPixel;
    property Segments :TSegments;
    property Renderer :TRenderer;
  end;

  T7SegmentModule = class(TModule)
  end;

  T8SegmentModule = class(7SegmentModule)
  end;

  TDotModule = class(TModule)
  end;

  TDoubleDotModule = class(TModule)
  end;

  TSegment = class
  public
    property Name :string;
    property Active :boolean;
    property Width :TPixel;
    property Height :TPixel;
    property Left :TPixel;
    property Top :TPixel;
  end;

  specialize TSegements = TObjectList<TSegement>;

  TRenderer = class
  end;

implementation

end.

