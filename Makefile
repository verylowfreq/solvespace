# SolveSpace may be built using Microsoft Visual Studio 2003 or newer.
# (MSVC++ 6.0 is not supported.)

DEFINES = /D_WIN32_WINNT=0x500 /DISOLATION_AWARE_ENABLED /D_WIN32_IE=0x500 /DWIN32_LEAN_AND_MEAN /DWIN32
# Use the multi-threaded static libc because libpng and zlib do; not sure if anything bad
# happens if those mix, but don't want to risk it.
CXXFLAGS = /W3 /nologo /MT /D_DEBUG /D_CRT_SECURE_NO_DEPRECATE /D_CRT_SECURE_NO_WARNINGS /I. /Iextlib /Zi /EHs  # /O2

HEADERS = win32\freeze.h ui.h solvespace.h dsc.h sketch.h expr.h polygon.h srf\surface.h

OBJDIR = obj

W32OBJS  = $(OBJDIR)\freeze.obj \
           $(OBJDIR)\w32main.obj \
           $(OBJDIR)\w32util.obj

SSOBJS   = \
           $(OBJDIR)\bsp.obj \
           $(OBJDIR)\clipboard.obj \
           $(OBJDIR)\confscreen.obj \
           $(OBJDIR)\constraint.obj \
           $(OBJDIR)\constrainteq.obj \
           $(OBJDIR)\describescreen.obj \
           $(OBJDIR)\draw.obj \
           $(OBJDIR)\drawconstraint.obj \
           $(OBJDIR)\drawentity.obj \
           $(OBJDIR)\entity.obj \
           $(OBJDIR)\export.obj \
           $(OBJDIR)\exportstep.obj \
           $(OBJDIR)\exportvector.obj \
           $(OBJDIR)\expr.obj \
           $(OBJDIR)\file.obj \
           $(OBJDIR)\generate.obj \
           $(OBJDIR)\glhelper.obj \
           $(OBJDIR)\graphicswin.obj \
           $(OBJDIR)\group.obj \
           $(OBJDIR)\groupmesh.obj \
           $(OBJDIR)\mesh.obj \
           $(OBJDIR)\modify.obj \
           $(OBJDIR)\mouse.obj \
           $(OBJDIR)\polygon.obj \
           $(OBJDIR)\request.obj \
           $(OBJDIR)\solvespace.obj \
           $(OBJDIR)\style.obj \
           $(OBJDIR)\system.obj \
           $(OBJDIR)\textscreens.obj \
           $(OBJDIR)\textwin.obj \
           $(OBJDIR)\toolbar.obj \
           $(OBJDIR)\ttf.obj \
           $(OBJDIR)\undoredo.obj \
           $(OBJDIR)\util.obj \
           $(OBJDIR)\view.obj

SRFOBJS =  $(OBJDIR)\boolean.obj \
           $(OBJDIR)\curve.obj \
           $(OBJDIR)\merge.obj \
           $(OBJDIR)\ratpoly.obj \
           $(OBJDIR)\raycast.obj \
           $(OBJDIR)\surface.obj \
           $(OBJDIR)\surfinter.obj \
           $(OBJDIR)\triangulate.obj

RES = $(OBJDIR)\resource.res

LIBS = user32.lib gdi32.lib comctl32.lib advapi32.lib shell32.lib opengl32.lib glu32.lib \
       extlib\libpng.lib extlib\zlib.lib extlib\si\siapp.lib

PERL = perl

all: $(OBJDIR)\solvespace.exe
	@copy /y $(OBJDIR)\solvespace.exe .
	@echo solvespace.exe

clean:
	del /q obj\*

$(OBJDIR)\solvespace.exe: $(SSOBJS) $(SRFOBJS) $(W32OBJS) $(RES)
	$(CXX) $(DEFINES) $(CXXFLAGS) /Fe$(OBJDIR)\solvespace.exe $(SSOBJS) $(SRFOBJS) $(W32OBJS) $(RES) $(LIBS)
	editbin /nologo /STACK:8388608 $(OBJDIR)\solvespace.exe

{.}.cpp{$(OBJDIR)}.obj::
	$(CXX) $(CXXFLAGS) $(DEFINES) /c /Fo$(OBJDIR)\ $<

{srf}.cpp{$(OBJDIR)}.obj::
	$(CXX) $(CXXFLAGS) $(DEFINES) /c /Fo$(OBJDIR)\ $<

{win32}.cpp{$(OBJDIR)}.obj::
	$(CXX) $(CXXFLAGS) $(DEFINES) /c /Fo$(OBJDIR)\ $<

$(RES): win32\$(@B).rc icon.ico
	$(RC) /fo$@ win32\$(@B).rc

$(OBJDIR)\glhelper.obj: bitmapextra.table bitmapfont.table font.table

$(OBJDIR)\textwin.obj: icons.h

$(OBJDIR)\toolbar.obj: icons.h

icons.h: icons\*.png png2c.pl
	$(PERL) png2c.pl $@ icons-proto.h

bitmapextra.table: icons\*.png pngchar2c.pl
	$(PERL) pngchar2c.pl >tmp.$@
	move /y tmp.$@ $@

