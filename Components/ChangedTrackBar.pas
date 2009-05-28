unit ChangedTrackBar;

{$R-,T-,H+,X+}

interface

uses
  {$IFDEF LINUX}
  WinUtils,
  {$ENDIF}
  Messages, Windows, SysUtils, CommCtrl, Classes, Controls, Forms, Menus,
  Graphics, StdCtrls, RichEdit, ToolWin, ImgList, ExtCtrls, ListActns,
  ShlObj, ComCtrls;

type
{ TChangedTrackBar1 }

  TChangedTrackBarOrientation = (trHorizontal, trVertical);
  TTickMark = (tmBottomRight, tmTopLeft, tmBoth);
  TTickStyle = (tsNone, tsAuto, tsManual);

  TChangedTrackBar = class(TWinControl)
  private
    FOrientation: TChangedTrackBarOrientation;
    FTickMarks: TTickMark;
    FTickStyle: TTickStyle;
    FLineSize: Integer;
    FPageSize: Integer;
    FThumbLength: Integer;
    FSliderVisible: Boolean;
    FMin: Integer;
    FMax: Integer;
    FFrequency: Integer;
    FPosition: Integer;
    FSelStart: Integer;
    FSelEnd: Integer;
    FOnChange: TNotifyEvent;
    function GetThumbLength: Integer;
    procedure SetOrientation(Value: TChangedTrackBarOrientation);
    procedure SetParams(APosition, AMin, AMax: Integer);
    procedure SetPosition(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetFrequency(Value: Integer);
    procedure SetTickStyle(Value: TTickStyle);
    procedure SetTickMarks(Value: TTickMark);
    procedure SetLineSize(Value: Integer);
    procedure SetPageSize(Value: Integer);
    procedure SetThumbLength(Value: Integer);
    procedure SetSliderVisible(Value: Boolean);
    procedure SetSelStart(Value: Integer);
    procedure SetSelEnd(Value: Integer);
    procedure UpdateSelection;
    procedure CNHScroll(var Message: TWMHScroll); message CN_HSCROLL;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure CNVScroll(var Message: TWMVScroll); message CN_VSCROLL;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Changed; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetTick(Value: Integer);
  published
    property Align;
    property Anchors;
    property BorderWidth;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Constraints;
    property LineSize: Integer read FLineSize write SetLineSize default 1;
    property Max: Integer read FMax write SetMax default 10;
    property Min: Integer read FMin write SetMin default 0;
    property Orientation: TChangedTrackBarOrientation read FOrientation write SetOrientation default trHorizontal;
    property ParentCtl3D;
    property ParentShowHint;
    property PageSize: Integer read FPageSize write SetPageSize default 2;
    property PopupMenu;
    property Frequency: Integer read FFrequency write SetFrequency default 1;
    property Position: Integer read FPosition write SetPosition default 0;
    property SliderVisible: Boolean read FSliderVisible write SetSliderVisible default True;
    property SelEnd: Integer read FSelEnd write SetSelEnd default 0;
    property SelStart: Integer read FSelStart write SetSelStart default 0;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property ThumbLength: Integer read GetThumbLength write SetThumbLength default 20;
    property TickMarks: TTickMark read FTickMarks write SetTickMarks default tmBottomRight;
    property TickStyle: TTickStyle read FTickStyle write SetTickStyle default tsAuto;
    property Visible;
    property OnContextPopup;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

{ TChangedTrackBar }

const
  MaxAutoTicks = 10000;

implementation

uses Printers, Consts, RTLConsts, ComStrs, ActnList, StdActns, ExtActns, Types,
  ActiveX, Themes, UxTheme;

constructor TChangedTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 150;
  Height := 25;
  TabStop := True;
  FMin := -100;
  FMax := 100;
  FPosition := 0;
  FLineSize := 1;
  FPageSize := 2;
  FFrequency := 1;
  FSelStart := 0;
  FSelEnd := 0;
  FThumbLength := 20;
  FTickMarks := tmTopLeft;
  FTickStyle := tsNone;
  FOrientation := trHorizontal;
  ControlStyle := ControlStyle - [csDoubleClicks];
  FSliderVisible := True;
end;

procedure TChangedTrackBar.CreateParams(var Params: TCreateParams);
const
  OrientationStyle: array[TChangedTrackBarOrientation] of DWORD = (TBS_HORZ, TBS_VERT);
  TickStyles: array[Boolean, TTickStyle] of DWORD =
    ((TBS_NOTICKS, TBS_AUTOTICKS, 0), (TBS_NOTICKS, 0, 0));
  ATickMarks: array[TTickMark] of DWORD = (TBS_BOTTOM, TBS_TOP, TBS_BOTH);
begin
  InitCommonControl(ICC_BAR_CLASSES);
  inherited CreateParams(Params);
  CreateSubClass(Params, TRACKBAR_CLASS);
  with Params do
  begin
    Style := Style or OrientationStyle[FOrientation] or
      // Ignore tsAuto if more than MaxAutoTicks in the track bar range.
      // tsAuto is is ignored because the TRACKBAR_CLASS will paint,
      // as many tick marks as you ask for. Too many an it appears
      // the track bar has hung but it just painting very slowly. Since large
      // ranges can be accidentally entered in the object inpsector we just
      // have the control ignore them instead of hanging.
      TickStyles[FMax - FMin > MaxAutoTicks, FTickStyle] or
      ATickMarks[FTickMarks] or TBS_FIXEDLENGTH;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW) or
      CS_DBLCLKS;
    if not FSliderVisible then
      Style := Style or TBS_NOTHUMB;
  end;
end;

procedure TChangedTrackBar.CreateWnd;
begin
  inherited CreateWnd;
  if HandleAllocated then
  begin
    SendMessage(Handle, TBM_SETTHUMBLENGTH, FThumbLength, 0);
    SendMessage(Handle, TBM_SETLINESIZE, 0, FLineSize);
    SendMessage(Handle, TBM_SETPAGESIZE, 0, FPageSize);
    SendMessage(Handle, TBM_SETRANGEMIN, 0, FMin);
    SendMessage(Handle, TBM_SETRANGEMAX, 0, FMax);
    UpdateSelection;
    SendMessage(Handle, TBM_SETPOS, 1, FPosition);
    SendMessage(Handle, TBM_SETTICFREQ, FFrequency, 1);
  end;
end;

procedure TChangedTrackBar.DestroyWnd;
begin
  inherited DestroyWnd;
end;

procedure TChangedTrackBar.CNHScroll(var Message: TWMHScroll);
begin
  inherited;
  FPosition := SendMessage(Handle, TBM_GETPOS, 0, 0);
  Changed;
  Message.Result := 0;
end;

procedure TChangedTrackBar.CNVScroll(var Message: TWMVScroll);
begin
  inherited;
  FPosition := SendMessage(Handle, TBM_GETPOS, 0, 0);
  Changed;
  Message.Result := 0;
end;

function TChangedTrackBar.GetThumbLength: Integer;
begin
  if HandleAllocated then
    Result := SendMessage(Handle, TBM_GETTHUMBLENGTH, 0, 0)
  else
    Result := FThumbLength;
end;

procedure TChangedTrackBar.SetOrientation(Value: TChangedTrackBarOrientation);
begin
  if Value <> FOrientation then
  begin
    FOrientation := Value;
    if ComponentState * [csLoading, csUpdating] = [] then
      SetBounds(Left, Top, Height, Width);
    RecreateWnd;
  end;
end;

procedure TChangedTrackBar.SetParams(APosition, AMin, AMax: Integer);
begin
  if AMax < AMin then
    raise EInvalidOperation.CreateFmt(SPropertyOutOfRange, [Self.Classname]);
  if APosition < AMin then APosition := AMin;
  if APosition > AMax then APosition := AMax;
  if (AMax - AMin > MaxAutoTicks) <> (FMax - FMin > MaxAutoTicks) then
  begin
    FMin := AMin;
    FMax := AMax;
    RecreateWnd;
  end;
  if (FMin <> AMin) then
  begin
    FMin := AMin;
    if HandleAllocated then
      SendMessage(Handle, TBM_SETRANGEMIN, 1, AMin);
  end;
  if (FMax <> AMax) then
  begin
    FMax := AMax;
    if HandleAllocated then
      SendMessage(Handle, TBM_SETRANGEMAX, 1, AMax);
  end;
  if FPosition <> APosition then
  begin
    FPosition := APosition;
    if HandleAllocated then
      SendMessage(Handle, TBM_SETPOS, 1, APosition);
    Changed;
  end;
end;

procedure TChangedTrackBar.SetPosition(Value: Integer);
begin
  SetParams(Value, FMin, FMax);
end;

procedure TChangedTrackBar.SetMin(Value: Integer);
begin
  if Value <= FMax then
    SetParams(FPosition, Value, FMax);
end;

procedure TChangedTrackBar.SetMax(Value: Integer);
begin
  if Value >= FMin then
    SetParams(FPosition, FMin, Value);
end;

procedure TChangedTrackBar.SetFrequency(Value: Integer);
begin
  if Value <> FFrequency then
  begin
    FFrequency := Value;
    if HandleAllocated then
      SendMessage(Handle, TBM_SETTICFREQ, FFrequency, 1);
  end;
end;

procedure TChangedTrackBar.SetTick(Value: Integer);
begin
  if HandleAllocated then
    SendMessage(Handle, TBM_SETTIC, 0, Value);
end;

procedure TChangedTrackBar.SetTickStyle(Value: TTickStyle);
begin
  if Value <> FTickStyle then
  begin
    FTickStyle := Value;
    RecreateWnd;
  end;
end;

procedure TChangedTrackBar.SetTickMarks(Value: TTickMark);
begin
  if Value <> FTickMarks then
  begin
    FTickMarks := Value;
    RecreateWnd;
  end;
end;

procedure TChangedTrackBar.SetLineSize(Value: Integer);
begin
  if Value <> FLineSize then
  begin
    FLineSize := Value;
    if HandleAllocated then
      SendMessage(Handle, TBM_SETLINESIZE, 0, FLineSize);
  end;
end;

procedure TChangedTrackBar.SetPageSize(Value: Integer);
begin
  if Value <> FPageSize then
  begin
    FPageSize := Value;
    if HandleAllocated then
      SendMessage(Handle, TBM_SETPAGESIZE, 0, FPageSize);
  end;
end;

procedure TChangedTrackBar.SetThumbLength(Value: Integer);
begin
  if Value <> FThumbLength then
  begin
    FThumbLength := Value;
    if HandleAllocated then
      SendMessage(Handle, TBM_SETTHUMBLENGTH, Value, 0);
  end;
end;

procedure TChangedTrackBar.SetSliderVisible(Value: Boolean);
begin
  if FSliderVisible <> Value then
  begin
    FSliderVisible := Value;
    RecreateWnd;
  end;
end;

procedure TChangedTrackBar.UpdateSelection;
begin
  if HandleAllocated then
  begin
    if (FSelStart = 0) and (FSelEnd = 0) then
      SendMessage(Handle, TBM_CLEARSEL, 1, 0)
    else
      SendMessage(Handle, TBM_SETSEL, Integer(True), MakeLong(FSelStart, FSelEnd));
  end;
end;

procedure TChangedTrackBar.SetSelStart(Value: Integer);
begin
  if Value <> FSelStart then
  begin
    FSelStart := Value;
    UpdateSelection;
  end;
end;

procedure TChangedTrackBar.SetSelEnd(Value: Integer);
begin
  if Value <> FSelEnd then
  begin
    FSelEnd := Value;
    UpdateSelection;
  end;
end;

procedure TChangedTrackBar.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TChangedTrackBar.CNNotify(var Message: TWMNotify);
var
  Info: PNMCustomDraw;
  R: TRect;
  Rgn: HRGN;
  Details: TThemedElementDetails;
  Offset: Integer;
begin
  if ThemeServices.ThemesEnabled then
  begin
    with Message do
      if NMHdr.code = NM_CUSTOMDRAW then
      begin
        Info := Pointer(NMHdr);
        case Info.dwDrawStage of
          CDDS_PREPAINT:
            Result := CDRF_NOTIFYITEMDRAW;
          CDDS_ITEMPREPAINT:
            begin
              case Info.dwItemSpec of
                TBCD_TICS:
                  begin
                    R := ClientRect;
                    if Focused and ((Perform(WM_QUERYUISTATE, 0, 0) and UISF_HIDEFOCUS) = 0) then
                      InflateRect(R, -1, -1);
                    ThemeServices.DrawParentBackground(Handle, Info.hDC, nil, False, @R)
                  end;
                TBCD_CHANNEL:
                  begin
                    SendMessage(Handle, TBM_GETTHUMBRECT, 0, Integer(@R));
                    Offset := 0;
                    if Focused then
                      Inc(Offset);
                    if Orientation = trHorizontal then
                    begin
                      R.Left := ClientRect.Left + Offset;
                      R.Right := ClientRect.Right - Offset;
                    end
                    else
                    begin
                      R.Top := ClientRect.Top + Offset;
                      R.Bottom := ClientRect.Bottom - Offset;
                    end;
                    with R do
                      Rgn := CreateRectRgn(Left, Top, Right, Bottom);
                    SelectClipRgn(Info.hDC, Rgn);
                    Details := ThemeServices.GetElementDetails(ttbThumbTics);
                    ThemeServices.DrawParentBackground(Handle, Info.hDC, @Details, False);
                    DeleteObject(Rgn);
                    SelectClipRgn(Info.hDC, 0);
                  end;
              end;
              Result := CDRF_DODEFAULT;
            end;
        else
          Result := CDRF_DODEFAULT;
        end;
      end;
  end
  else
    inherited;
end;

procedure TChangedTrackBar.WMEraseBkGnd(var Message: TWMEraseBkGnd);
var
  R: TRect;
begin
  if ThemeServices.ThemesEnabled then
  begin
    R := ClientRect;
    if Focused and ((Perform(WM_QUERYUISTATE, 0, 0) and UISF_HIDEFOCUS) = 0) then
      InflateRect(R, -1, -1);
    ThemeServices.DrawParentBackground(Handle, Message.DC, nil, False, @R);
    Message.Result := 1;
  end
  else
    inherited;
end;

procedure Register;
begin
  RegisterComponents('Win32', [TChangedTrackBar]);
end;

end.
