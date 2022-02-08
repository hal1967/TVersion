{----------------------------------------------------------------------------}
{                                                                            }
{ File:       VersionUnit.pas                                                }
{ Function:   TVersion implementation, record than drives Version exe file   }
{             information. Bring 2 additional functions in order to          }
{             get version info from exe file or resources                    }
{                                                                            }
{ Español     TVersion: registro para manejar la informacion de version de   }
{             los archivos ejecutables. Además un par de funciones para      }
{             obtener esta infromacion via archivo de recuros y por          }
{             llamada al api de windows.                                     }
{                                                                            }
{ Language:   Delphi version XE2 or later                                    }
{ Author:     Alirio Gavidia                                                 }
{                                                                            }
{ Credits:                                                                   }
{          StackOverflow:                                                    }
{             Stijn Sanders                                                  }
{             Get version form resources                                     }
{             How to determine Delphi Application Version                    }
{             https://stackoverflow.com/users/87971/stijn-sanders            }
{                                                                            }
{             - https://stackoverflow.com/questions/1717844/                 }
{                      how-to-determine-delphi-application-version/1720501   }
{                                                                            }
{                                                                            }
{ -------------------------------------------------------------------------- }
{                                                                            }
{ License:    GNU General Public License v3.0  GPL-3.0-or-later              }
{                                                                            }
{                                                                            }
{ Disclaimer: THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS "AS IS"     }
{             AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      }
{             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND      }
{             FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO         }
{             EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE      }
{             FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,      }
{             OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,       }
{             PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,      }
{             DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED     }
{             AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT    }
{             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)         }
{             ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF    }
{             ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                     }
{                                                                            }
{----------------------------------------------------------------------------}

{----------------------------------------------------------------------------}
{ Changes:                                                                   }
{                                                                            }
{   2020-04-12: Update for aditional operators. >=  and <=                   }
{               empty string-> 0.0.0.0                                       }
{               partial version string filled with 0                         }
{                                                                            }
{----------------------------------------------------------------------------}
{   Checkit in                                                               }
{   https://www.gavidia.org                                                  }
{----------------------------------------------------------------------------}

unit VersionUnit;

interface

type

TVersion = packed record
public
  class operator LessThan ( a, b: TVersion): Boolean;
  class operator LessThanOrEqual( a, b: TVersion): Boolean;
  function LessThan(avMayor, avMinor, aRelease, aBuild: word): boolean;

  class operator GreaterThan ( b, a: TVersion): Boolean;
  class operator GreaterThanOrEqual ( b, a: TVersion): Boolean;
  function GreaterThan(avMayor, avMinor, aRelease, aBuild: word): boolean;

  class operator Equal ( a, b: TVersion): Boolean;
  class operator NotEqual ( a, b: TVersion): Boolean;

  class operator Implicit (a: TVersion): string;
  class operator Implicit (OrigVer: string): TVersion;

  constructor Create(avMayor, avMinor, aRelease, aBuild: word);

  case Boolean of
    true: (Build, Release, vMinor, vMayor : word);
    false:(ver64 : UInt64);
end;

function GetLocalAppVersion : TVersion;
Function GetFileVersion(fn: string): TVersion; overload;

implementation

uses
  Windows,Classes,SysUtils, VCL.Forms,
  System.Variants;

class operator TVersion.LessThan(a, b: TVersion): Boolean;
begin
  result := a.ver64 < b.ver64;
end;

class operator TVersion.Implicit(a: TVersion): string;
begin
   result := inttostr(a.vMayor) + '.' + inttostr(a.vMinor) + '.' +
             inttostr(a.Release) + '.' + inttostr(a.Build);
end;

constructor TVersion.Create(avMayor, avMinor, aRelease, aBuild: word);
begin
   self.vMayor := avMayor;
   self.vMinor := avMinor;
   self.Build  := aBuild;
   self.Release := aRelease;
end;

class operator TVersion.Equal(a, b: TVersion): Boolean;
begin
//  result := a= b;  This must be recursive
  result := a.ver64 = b.ver64;
end;

function TVersion.GreaterThan(avMayor, avMinor, aRelease,
  aBuild: word): boolean;
begin
  result := self.ver64  > TVersion.Create(avMayor, avMinor, aRelease, aBuild).ver64
end;

class operator TVersion.GreaterThanOrEqual(b, a: TVersion): Boolean;
begin
  result := b.ver64 >= a.ver64;
end;

class operator TVersion.GreaterThan(b, a: TVersion): Boolean;
begin
  result := b.ver64 > a.ver64;
end;

// String helper   -> split
class operator TVersion.Implicit(OrigVer: string): TVersion;
Var
  i, l : integer;
  Splitted: TArray<String>;
begin
  Splitted := OrigVer.Split(['.'],4);
  l := Length(Splitted);
  if l> 0 then
    result.vMayor  :=  StrToInt(Splitted[0])
  else
    result.vMayor  :=  0;

  if l> 1 then
    result.vMinor  :=  StrToInt(Splitted[1])
  else
    result.vMinor  :=  0;

  if l> 2 then
    result.Release :=  StrToInt(Splitted[2])
  else
    result.Release := 0;

  if l> 3 then
    result.Build   :=  StrToInt(Splitted[3])
  else
    result.Build   := 0
end;


function TVersion.LessThan(avMayor, avMinor, aRelease, aBuild: word): boolean;
begin
  result := self.ver64  < TVersion.Create(avMayor, avMinor, aRelease, aBuild).ver64
end;

class operator TVersion.LessThanOrEqual(a, b: TVersion): Boolean;
begin
  result := a.ver64 <= b.ver64;
end;

class operator TVersion.NotEqual(a, b: TVersion): Boolean;
begin
  result := a.ver64 <> b.ver64
end;

Function GetFileVersion(fn: string;
                      var aver: string;
                      var vMayor, vMinor, Release, Build: word): boolean; overload;

var
  newsize : integer;
  buffer : pointer;
  pointertopointer : pointer;
  Filename : Array[0..127] of Char;
  len : Cardinal;
  tozero : Cardinal;
  v1,v2,v3,v4 : word;

begin
  result := false;
  StrPCopy(FileName, fn);
  newsize := GetFileVersionInfoSize(Filename,tozero);
  aver := '';
  if newsize>0 then
   begin
    GetMem(buffer, newsize);
    try
      GetFileVersionInfo(Filename, 0, newsize, buffer);

      VerQueryValue(buffer,'\', pointertopointer, len);

      v1 := TVSFixedFileInfo(pointertopointer^).dwFileVersionMS div $ffff;
      v2 := TVSFixedFileInfo(pointertopointer^).dwFileVersionMS and $FFFF;

      v3 := TVSFixedFileInfo(pointertopointer^).dwFileVersionLS div $ffff;
      v4 := TVSFixedFileInfo(pointertopointer^).dwFileVersionLS and $FFFF;

      aver := Format('%d.%d (B %d.%d)',[v1,v2,v3,v4]);
      vMayor := v1; vMinor:= v2; Release:= v3; Build:=v4;
      result := true;
    finally
      FreeMem(buffer);
    end
   end;
end;


Function GetFileVersion(fn: string): TVersion; overload;
Var
  vMayor, vMinor, Release, Build: word;
  aver : string;
begin
  if GetFileVersion(fn, aver,
                      vMayor, vMinor, Release, Build) then
    begin
      result.vMayor := vMayor;
      result.vMinor := vMinor;
      result.Release := Release;
      result.Build := Build;
    end
  else
    result := '';
end;


// Taken from  - Tomado de
//     https://stackoverflow.com/questions/1717844/how-to-determine-delphi-application-version/1720501
//     Check credits at begin

function GetLocalAppVersion: TVersion;
var
  verblock:PVSFIXEDFILEINFO;
  versionMS,versionLS:cardinal;
  verlen:cardinal;
  rs:TResourceStream;
  m:TMemoryStream;
begin
  m:=TMemoryStream.Create;
  try
    rs:=TResourceStream.CreateFromID(HInstance,1,RT_VERSION);
    try
      m.CopyFrom(rs,rs.Size);
    finally
      rs.Free;
    end;
    m.Position:=0;
    if VerQueryValue(m.Memory,'\',pointer(verblock),verlen) then
      begin
        VersionMS:=verblock.dwFileVersionMS;
        VersionLS:=verblock.dwFileVersionLS;
        result.vMayor  := versionMS shr 16;
        result.vMinor  := versionMS and $FFFF;
        result.Release := VersionLS shr 16;
        result.Build   := VersionLS and $FFFF;
      end;
  finally
    m.Free;
  end;
end;



end.
