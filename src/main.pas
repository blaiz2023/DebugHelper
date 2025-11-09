unit main;

interface
{$ifdef gui4} {$define gui3} {$define gamecore}{$endif}
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define bmp} {$define ico} {$define gif} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define bmp} {$define ico} {$define gif} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gosswin2, gossroot, {$ifdef gui}gossgui,{$endif} {$ifdef snd}gosssnd,{$endif} gosswin, gossio, gossimg, gossnet;
{$align on}{$O+}{$W-}{$I-}{$U+}{$V+}{$B-}{$X+}{$T-}{$P+}{$H+}{$J-} { set critical compiler conditionals for proper compilation - 10aug2025 }
//## ==========================================================================================================================================================================================================================
//##
//## MIT License
//##
//## Copyright 2025 Blaiz Enterprises ( http://www.blaizenterprises.com )
//##
//## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
//## files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
//## modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
//## is furnished to do so, subject to the following conditions:
//##
//## The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//##
//## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//## CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//##
//## ==========================================================================================================================================================================================================================
//## Library.................. app code (main.pas)
//## Version.................. 1.00.367 (+5)
//## Items.................... 2
//## Last Updated ............ 06nov2025, 24may2025
//## Lines of Code............ 1,200+
//##
//## main.pas ................ app code
//## gossroot.pas ............ console/gui app startup and control
//## gossio.pas .............. file io
//## gossimg.pas ............. image/graphics
//## gossnet.pas ............. network
//## gosswin.pas ............. static Win32 api calls
//## gosswin2.pas ............ dynamic Win32 api calls
//## gosssnd.pas ............. sound/audio/midi/chimes
//## gossgui.pas ............. gui management/controls
//## gossdat.pas ............. app icons (24px and 20px) and help documents (gui only) in txt, bwd or bwp format
//## gosszip.pas ............. zip support
//## gossjpg.pas ............. jpeg support
//## gossgame.pas ............ game support (optional)
//## gamefiles.pas ........... internal files for game (optional)
//##
//## ==========================================================================================================================================================================================================================
//## | Name                   | Hierarchy         | Version   | Date        | Update history / brief description of function
//## |------------------------|-------------------|-----------|-------------|--------------------------------------------------------
//## | tapp                   | tbasicapp         | 1.00.040  | 24may2025   | App
//## | tdhelp                 | tbasiccontrol     | 1.00.322  | 06nov2025   | Debug Helper - 24may2025
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================


var
   itimerbusy:boolean=false;
   iapp:tobject=nil;

const
   ilblack  =0;
   ilwhite  =1;
   ilBW     =2;
   ilcolor  =3;
   ilcolor2 =4;//dual color mode
   ilfont   =5;
   ilfont2  =6;//dual color mode (font/hover mode for TEA)
   ilfont2b =7;//dual color mode (hover/font mode for TEA)
   ilrgba   =8;
   ilmax    =8;
   //file formats
   fPNG     =0;
   fICO     =1;
   fTEA     =2;
   fmax     =2;

type
{tdhelp}
//xxxxxxxxxxxxxxxxxxxx//111111111111111111111111111111
   tdhelp=class(tbasicscroll)
   private
    imaintoolbar:tbasictoolbar;
    iloaded:boolean;
    itimer100,itimer500:comp;
    iimagebase,iprogramentry,ifindref,imapref,ifoundname,ifoundhex8,imapfile,isettingsref,ilastopenfile:string;
    //.map support
    imapnam:tdynamicstring;
    imapnum:tdynamicinteger;
    imapbox:tbasicbwp;
    imappep:longint;
    isearch:tbasicedit;
    procedure xonshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
    function xonshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
    procedure xupdatebuttons;
    procedure __onclick(sender:tobject);
    procedure xcmd(sender:tobject;xcode:longint;xcode2:string);
    function xsettingschanged(xreset:boolean):boolean;
    function xloadmap(xfilename:string):boolean;
    procedure xclear;
    function popopenmap(var xfilename:string):boolean;
    function canfind:boolean;
    function canreload:boolean;
    function xfinderr:boolean;
    function xfinderr2(xsearch:boolean):boolean;
    function getimagebase:string;
    procedure setimagebase(x:string);
    function xfilter(x:string):string;
    function geterr:string;
    procedure seterr(x:string);
   public
    //create
    constructor create2(xparent:tobject;xscroll,xstart:boolean); override;
    destructor destroy; override;
    function _onaccept(sender:tobject;xfolder,xfilename:string;xindex,xcount:longint):boolean;
    procedure _ontimer(sender:tobject); override;

    //information
    property mapfile:string read imapfile write imapfile;
    property imagebase:string read getimagebase write setimagebase;
    property err:string read geterr write seterr;
    property programentry:string read iprogramentry;
    property foundname:string read ifoundname;
    property foundhex8:string read ifoundhex8;
    //command
    function cancmd(x:string):boolean;
    procedure cmd(x:string);
    //can

    //other

   end;

{tapp}
   tapp=class(tbasicapp)
   private
    icore:tdhelp;
    itimer500:comp;
    icouldcapture,iloaded,ibuildingcontrol:boolean;
    isettingsref:string;
    procedure xcmd(sender:tobject;xcode:longint;xcode2:string);
    procedure __onclick(sender:tobject);
    procedure __ontimer(sender:tobject); override;
    function xshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
    procedure xloadsettings;
    procedure xsavesettings;
    procedure xautosavesettings;
    procedure xsync;
   public
    //create
    constructor create; virtual;
    destructor destroy; override;
   end;

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function info__app(xname:string):string;//information specific to this unit of code - 20jul2024: program defaults added, 23jun2024


//app procs --------------------------------------------------------------------
//.create / destroy
procedure app__remove;//does not fire "app__create" or "app__destroy"
procedure app__create;
procedure app__destroy;

//.event handlers
function app__onmessage(m,w,l:longint):longint;
procedure app__onpaintOFF;//called when screen was live and visible but is now not live, and output is back to line by line
procedure app__onpaint(sw,sh:longint);
procedure app__ontimer;

//.support procs
function app__netmore:tnetmore;//optional - return a custom "tnetmore" object for a custom helper object for each network record -> once assigned to a network record, the object remains active and ".clear()" proc is used to reduce memory/clear state info when record is reset/reused
function app__findcustomtep(xindex:longint;var xdata:tlistptr):boolean;
function app__syncandsavesettings:boolean;


implementation

{$ifdef gui}
uses
    gossdat;
{$endif}


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
begin
result:=info__rootfind(xname);
end;

function info__app(xname:string):string;//information specific to this unit of code - 20jul2024: program defaults added, 23jun2024
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//get
if      (xname='slogan')              then result:=info__app('name')+' by Blaiz Enterprises'
else if (xname='width')               then result:='1100'
else if (xname='height')              then result:='700'
else if (xname='language')            then result:='english-australia'//for Clyde - 14sep2025
else if (xname='codepage')            then result:='1252'//for Clyde
else if (xname='ver')                 then result:='1.00.367'
else if (xname='date')                then result:='06nov2025'
else if (xname='name')                then result:='Debug Helper'
else if (xname='web.name')            then result:='dhelp'//used for website name
else if (xname='des')                 then result:='Map an exception to a procedure / function for a Borland Dehlpi 3 app'
else if (xname='infoline')            then result:=info__app('name')+#32+info__app('des')+' v'+app__info('ver')+' (c) 1997-'+low__yearstr(2025)+' Blaiz Enterprises'
else if (xname='size')                then result:=low__b(io__filesize64(io__exename),true)
else if (xname='diskname')            then result:=io__extractfilename(io__exename)
else if (xname='service.name')        then result:=info__app('name')
else if (xname='service.displayname') then result:=info__app('service.name')
else if (xname='service.description') then result:=info__app('des')
else if (xname='new.instance')        then result:='1'//1=allow new instance, else=only one instance of app permitted
else if (xname='screensizelimit%')    then result:='95'//95% of screen area
else if (xname='realtimehelp')        then result:='0'//1=show realtime help, 0=don't
else if (xname='hint')                then result:='1'//1=show hints, 0=don't

//.links and values
else if (xname='linkname')            then result:=info__app('name')+' by Blaiz Enterprises.lnk'
else if (xname='linkname.vintage')    then result:=info__app('name')+' (Vintage) by Blaiz Enterprises.lnk'
//.author
else if (xname='author.shortname')    then result:='Blaiz'
else if (xname='author.name')         then result:='Blaiz Enterprises'
else if (xname='portal.name')         then result:='Blaiz Enterprises - Portal'
else if (xname='portal.tep')          then result:=intstr32(tepBE20)
//.software
else if (xname='url.software')        then result:='https://www.blaizenterprises.com/'+info__app('web.name')+'.html'
else if (xname='url.software.zip')    then result:='https://www.blaizenterprises.com/'+info__app('web.name')+'.zip'
//.urls
else if (xname='url.portal')          then result:='https://www.blaizenterprises.com'
else if (xname='url.contact')         then result:='https://www.blaizenterprises.com/contact.html'
else if (xname='url.facebook')        then result:='https://web.facebook.com/blaizenterprises'
else if (xname='url.mastodon')        then result:='https://mastodon.social/@BlaizEnterprises'
else if (xname='url.twitter')         then result:='https://twitter.com/blaizenterprise'
else if (xname='url.x')               then result:=info__app('url.twitter')
else if (xname='url.instagram')       then result:='https://www.instagram.com/blaizenterprises'
else if (xname='url.sourceforge')     then result:='https://sourceforge.net/u/blaiz2023/profile/'
else if (xname='url.github')          then result:='https://github.com/blaiz2023'
//.program/splash
else if (xname='license')             then result:='MIT License'
else if (xname='copyright')           then result:='© 1997-'+low__yearstr(2025)+' Blaiz Enterprises'
else if (xname='splash.web')          then result:='Web Portal: '+app__info('url.portal')

else
   begin
   //nil
   end;

except;end;
end;


//app procs --------------------------------------------------------------------
procedure app__create;
begin
{$ifdef gui}
iapp:=tapp.create;
{$else}

//.starting...
app__writeln('');
//app__writeln('Starting server...');

//.visible - true=live stats, false=standard console output
scn__setvisible(false);


{$endif}
end;

procedure app__remove;
begin
try

except;end;
end;

procedure app__destroy;
begin
try
//save
//.save app settings
app__syncandsavesettings;

//free the app
freeobj(@iapp);
except;end;
end;

function app__findcustomtep(xindex:longint;var xdata:tlistptr):boolean;

  procedure m(const x:array of byte);//map array to pointer record
  begin
  {$ifdef gui}
  xdata:=low__maplist(x);
  {$else}
  xdata.count:=0;
  xdata.bytes:=nil;
  {$endif}
  end;
begin//Provide the program with a set of optional custom "tep" images, supports images in the TEA format (binary text image)
//defaults
result:=false;

//sample custom image support

//m(tep_none);
{
case xindex of
5000:m(tep_write32);
5001:m(tep_search32);
end;
}

//successful
//result:=(xdata.count>=1);
end;

function app__syncandsavesettings:boolean;
begin
//defaults
result:=false;
try
//.settings
{
app__ivalset('powerlevel',ipowerlevel);
app__ivalset('ramlimit',iramlimit);
{}


//.save
app__savesettings;

//successful
result:=true;
except;end;
end;

function app__netmore:tnetmore;//optional - return a custom "tnetmore" object for a custom helper object for each network record -> once assigned to a network record, the object remains active and ".clear()" proc is used to reduce memory/clear state info when record is reset/reused
begin
result:=tnetbasic.create;
end;

function app__onmessage(m,w,l:longint):longint;
begin
//defaults
result:=0;
end;

procedure app__onpaintOFF;//called when screen was live and visible but is now not live, and output is back to line by line
begin
//nil
end;

procedure app__onpaint(sw,sh:longint);
begin
//console app only
end;

procedure app__ontimer;
begin
try
//check
if itimerbusy then exit else itimerbusy:=true;//prevent sync errors

//last timer - once only
if app__lasttimer then
   begin

   end;

//check
if not app__running then exit;


//first timer - once only
if app__firsttimer then
   begin

   end;



except;end;
try
itimerbusy:=false;
except;end;
end;


//## tmicon ####################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//1111111111111111111111111
constructor tdhelp.create2(xparent:tobject;xscroll,xstart:boolean);

   function xhelpval(const n:string):string;
   begin

   if      (n='find')    then result:='Find|Search an exception address to find the closest procedure / function responsible for raising the exception.  Search is approximate, usually within one to two procedure / function calls.'
   else                       result:='';

   end;

begin
//self
xscroll:=false;
inherited create2(xparent,xscroll,false);

//var
iloaded          :=false;
bordersize       :=0;
oautoheight      :=true;
itimer500        :=0;
itimer100        :=0;
ilastopenfile    :='';
imapfile         :='';
isettingsref     :='';
ifindref         :='';
imapref          :='';
ifoundname       :='';
ifoundhex8       :='';

//controls
imapnam:=tdynamicstring.create;
imapnum:=tdynamicinteger.create;
xclear;


//.toolbar
//gui.rootwin.xhead.add('Test',tepEdit20,0,'dhelp.test','');//???????????
gui.rootwin.xhead.add('Find',tepEdit20,0,'dhelp.find', xhelpval('find') );
gui.rootwin.xhead.add('Paste',tepPaste20,0,'dhelp.paste','Paste Exception Address|Paste an exception address from Clipboard and search');
gui.rootwin.xhead.add('Reload',tepRefresh20,0,'dhelp.reload','Reload|Reload map file (*.map) and search again');
gui.rootwin.xhead.add('Open Map',tepOpen20,0,'dhelp.open','Open|Open a Borland Delphi 3 map file for debugging (*.map)');
gui.rootwin.xhead.add('Image Base',tepPaste20,0,'dhelp.imagebase','Image Base|Set size of app image base in hex8 format.  Value is applied to each procedure and function address to generate a final runtime address.');

with client do
begin
mlabelplain('Find app procedure / function by hex8 address','');
isearch:=nedit('< type a hex8 exception address to search for closest app procedure / function >','');
isearch.help:=xhelpval('find');


with isearch.oinputcolorise do
begin

minlen     :=8;
backTRUE   :=cllime;
backFALSE  :=clred;
code       :=icMinLen;
use        :=true;

end;

mlabelplain('List of app procedures and fuctions by ascending hex8 address','Address Information|Procedures and functions are re-addressed from the app''s Image Base upwards');

imapbox              :=nbwp('',nil);
imapbox.oautoheight  :=true;
imapbox.oreadonly    :=true;
imapbox.maketxt2;
imapbox.oshowcursor  :=false;
imapbox.help         :='List|A list of your app''s procedures and functions and their hex8 addresses with the image base value applied in ascending order';

end;

//events
ocanshowmenu:=true;
showmenuFill1:=xonshowmenuFill1;
showmenuClick1:=xonshowmenuClick1;
//imaintoolbar.onclick:=__onclick;

//imaintoolbar.onnotify:=_onnotify;
gui.rootwin.xhead.onnotify:=_onnotify;

//defaults
iloaded:=true;
xloadmap('');

//start
if xstart then start;
end;

destructor tdhelp.destroy;
begin
try
//controls
freeobj(@imapnam);
freeobj(@imapnum);

//self
inherited destroy;
except;end;
end;

function tdhelp.getimagebase:string;
begin
if (iimagebase='') then iimagebase:='00400000';
result:=int4__hex8RL(hex8__int4RL(stripwhitespace_lt(iimagebase)));
end;

procedure tdhelp.setimagebase(x:string);
begin
if (x='') then x:='00400000';
iimagebase:=int4__hex8RL(hex8__int4RL(stripwhitespace_lt(x)));
end;

function tdhelp.xfilter(x:string):string;
begin
//filter
if (x<>'') then
   begin
   x:=stripwhitespace_lt(x);
   if (strcopy1(x,1,1)='$') then x:=stripwhitespace_lt(strcopy1(x,2,low__len(x)));
   end;

//get
if (x<>'') then result:=int4__hex8RL(hex8__int4RL(x)) else result:='';
end;

function tdhelp.geterr:string;
begin
if (isearch<>nil) then result:=xfilter(isearch.value) else result:='';
end;

procedure tdhelp.seterr(x:string);
begin
if (isearch<>nil) then isearch.value:=xfilter(x);
end;

function tdhelp.xfinderr:boolean;
begin
result:=xfinderr2(false);
end;

function tdhelp.xfinderr2(xsearch:boolean):boolean;
label
   skipend;
var
   str1,str2,str3:string;
   vpos,vpos2,p,vproc,vnum,verr,vbase:longint;
begin
//defaults
result:=true;//pass-thru

try
//init
verr :=hex8__int4RL(isearch.value);
vbase:=hex8__int4RL(imagebase);
if not xsearch then goto skipend;

//find
vproc:=-1;
vnum :=verr-vbase-imapnum.value[0];
for p:=0 to (imapnum.count-1) do if (vnum>=imapnum.value[p]) then vproc:=p else break;

//check
if (vproc>=0) and (vproc<imapnum.count) and (vnum>=(imapnum.value[vproc]+100000)) then vproc:=-1;//out of range

//get
if (vproc>=0) then
   begin
   str1:=imapnam.value[vproc];
   low__splitstr(str1,ssSpace,str2,str3);
   ifoundname:=stripwhitespace_lt(str3);
   ifoundhex8:=stripwhitespace_lt(str2);
   end
else
   begin
   ifoundname:='';
   ifoundhex8:='';
   end;

//scroll list
vpos :=low__wordcore_str2(imapbox.core^,'line>pos',intstr32(0+vproc));//convert line number (0..N) into a text position "xpos", e.g. character at location -> "x.data[xpos]"
vpos2:=low__wordcore_str2(imapbox.core^,'line>pos',intstr32(1+vproc));//convert line number (0..N) into a text position "xpos", e.g. character at location -> "x.data[xpos]"

//.scroll down 2 lines past actual proc for previous/next view - 19may2025
imapbox.scrollto(-1,frcmin32(vproc-2,0),-1,vpos,vpos2,true);

skipend:
except;end;
end;

function tdhelp.xloadmap(xfilename:string):boolean;
label
   skipend;
var
   a:tstr8;
   lm:tdynamicstring;
   e:string;
   vbase:longint;

   function m(const s,d:string):boolean;
   begin
   result:=strmatch(s, strcopy1(d,1,low__len(s)) );
   end;

   function xfindPEP(var xout:longint):boolean;//program entry point
   var
      p:longint;
      n,v:string;
   begin
   //defaults
   result:=false;
   xout  :=0;

   //find
   for p:=0 to (lm.count-1) do if m('Program entry point at',lm.value[p]) then
      begin
      result:=true;
      low__splitstr(lm.value[p],ssColon,n,v);
      xout:=hex8__int4RL(stripwhitespace_lt(v));
      break;
      end;
   end;

   function xfindPAS:boolean;//proc addresses
   var
      nlongest,sp,p,i:longint;
      xpadstr,str1,dn,dv,v:string;
      xwithin:boolean;
      dnam:tdynamicstring;
      dnum:tdynamicinteger;

      function xpad(const s:string):string;
      var
         p:longint;
      begin
      result:=xpadstr;
      for p:=1 to smallest32(low__len(s),low__len(xpadstr)) do result[p-1+stroffset]:=s[p-1+stroffset];
      end;
   begin
   //defaults
   result  :=false;
   xwithin :=false;
   dnam    :=nil;
   dnum    :=nil;
   nlongest:=0;

   try
   //init
   dnam:=tdynamicstring.create;
   dnum:=tdynamicinteger.create;

   //find
   for p:=0 to (lm.count-1) do
   begin
   v:=lm.value[p];

   //within
   if xwithin and m(' 0001:',v) then
      begin
      str1:=strcopy1(v,7,low__len(v));
      low__splitstr(str1,ssSpace,dn,dv);
      dn:=stripwhitespace_lt(dn);
      dv:=stripwhitespace_lt(dv);
      if (dn<>'') and (dv<>'') and (dnam.find(0,dv,false)<0) then//skip over duplicates
         begin
         i:=dnam.count;
         dnum.value[i]:=hex8__int4RL(dn);
         dnam.value[i]:=dv;
         if (low__len(dv)>nlongest) then nlongest:=low__len(dv);
         end;
      end;

   //start
   if (not xwithin) and m('  Address',v) then xwithin:=true;
   end;//p

   //sort
   dnum.sort(true);
   xpadstr:=makestrb(nlongest,ssSpace);

   //set
   for p:=0 to (dnum.count-1) do
   begin
   sp:=dnum.sindex(p);
   imapnam.value[p]:=int4__hex8RL(vbase+dnum.value[sp])+#32#32+xpad(dnam.value[sp]);
   imapnum.value[p]:=dnum.value[sp];
   end;//p

   except;end;
   //free
   freeobj(@dnam);
   freeobj(@dnum);
   end;
begin
//defaults
result  :=false;
a       :=nil;
lm      :=nil;

try
//init
a     :=str__new8;
lm    :=tdynamicstring.create;
vbase :=hex8__int4RL(imagebase);

//clear
xclear;

//get
imapfile:=xfilename;
io__fromfile(xfilename,@a,e);

//find program entry point
lm.text:=a.text;
if not xfindPEP(imappep) then imappep:=0;

//find proc addresses
xfindPAS;

case (imapnum.count>=1) of
true:iprogramentry:=int4__hex8RL(vbase+imappep+imapnum.value[0]);
else iprogramentry:=int4__hex8RL(vbase+imappep);
end;

//successful
result:=true;
skipend:

//sync
if (imapnam.count<=1) then a.text:='No content found.  Select a MAP file (*.map) for your app''s EXE.' else a.text:=imapnam.text;
imapbox.iosettxt(a);

except;end;
//free
str__free(@a);
freeobj(@lm);
end;

procedure tdhelp.xclear;
begin
imapnam.clear;
imapnum.clear;
imapPEP:=0;
end;

procedure tdhelp.__onclick(sender:tobject);
begin
xcmd(sender,0,'');
end;

procedure tdhelp.xcmd(sender:tobject;xcode:longint;xcode2:string);
begin
//init
if zzok(sender,7455) and (sender is tbasictoolbar) then
   begin
   //ours next
   //xcode:=(sender as tbasictoolbar).ocode;
   xcode2:=strlow((sender as tbasictoolbar).ocode2);
   cmd(xcode2);
   end;
end;

procedure tdhelp.xupdatebuttons;
var
   p:longint;
   bol1:boolean;
begin
try

with imaintoolbar do
begin
{
bol1:=cansolid;
benabled2['micon.make.trans']:=bol1;
benabled2['micon.make.sold'] :=bol1;

bol1:=cansave;
benabled2['micon.save.png']  :=bol1;
benabled2['micon.save.ico']  :=bol1;
benabled2['micon.save.tea']  :=bol1;

benabled2['micon.paste']     :=canpaste;
benabled2['micon.resample']  :=canresample;
benabled2['micon.clear']     :=canclear;

bflash2['micon.capture']     :=capturing;
bpert2['micon.capture']      :=capturepert;
}
end;


with gui.rootwin.xhead do
begin
benabled2['dhelp.find']:=canfind;
benabled2['dhelp.reload']:=canreload;
end;

except;end;
end;

function tdhelp.xsettingschanged(xreset:boolean):boolean;
var
   x:string;
begin
x:='|'+imapfile;//bolstr(idark)+bolstr(imirror)+bolstr(iflip)+'|'+insstr( intstr32(icliparea.left)+'_'+intstr32(icliparea.top)+'_'+intstr32(icliparea.right)+'_'+intstr32(icliparea.bottom), iclipactive<=0)+'|'+intstr32(irotate)+'|'+intstr32(icolor0.color)+'|'+intstr32(icolor1.color)+'|'+intstr32(icolor2.color)+'|'+intstr32(lcolor2(mode,true))+'|'+intstr32(lcolor(mode,true))+'|'+intstr32(iqual.val)+'|'+intstr32(itolCol.val)+'|'+intstr32(itol.val)+'|'+intstr32(ifeat.val)+'|'+intstr32(iopac.val)+'|'+intstr32(iquality)+'|'+intstr32(imode)+'|'+intstr32(ipadw.val)+'|'+intstr32(ipadh.val)+'|'+intstr32(iminw.val)+'|'+intstr32(iminh.val);
result:=(x<>isettingsref);
if result and xreset then isettingsref:=x;
end;


procedure tdhelp._ontimer(sender:tobject);
var
   xmustpaint:boolean;
begin
try
//defaults
xmustpaint:=false;

//check
if not iloaded then exit;


//timer500
if (ms64>=itimer500) then
   begin
   //update buttons
   xupdatebuttons;

   //reset
   itimer500:=ms64+500;
   end;

//timer100
if (ms64>=itimer100) or xmustpaint then
   begin

   //sync
   if gui.paintfirst then
      begin
      //reload
      if low__setstr(imapref,iimagebase+'|'+imapfile) then xloadmap(imapfile);

      //research
      if low__setstr(ifindref,isearch.value+'|'+iimagebase+'|'+imapfile) then xfinderr2(true);
      end;

   //detect changes
   if xsettingschanged(true) then
      begin
      //buttons
      xupdatebuttons;

      //paint
      xmustpaint:=true;
      end;

   //reset
   itimer100:=add64(ms64,100);
   end;

//paint
if xmustpaint then paintnow;
except;end;
end;

procedure tdhelp.xonshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
begin
//nil
end;

function tdhelp.xonshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
begin
result:=true;
cmd(xcode2);
end;

function tdhelp.cancmd(x:string):boolean;
begin
result:=strmatch(strcopy1(x,1,6),'dhelp.');
end;

procedure tdhelp.cmd(x:string);
var
   int1,v32:longint;
   str1,v:string;
   xmustpaint:boolean;

   function m(s:string):boolean;
   begin
   result:=strmatch(s,x);
   end;

   function mv(s:string):boolean;
   begin
   result:=strmatch(s,strcopy1(x,1,low__len(s)));
   if result then
      begin
      v:=strcopy1(x,low__len(s)+1,low__len(x));
      v32:=strint32(v);
      end;
   end;

begin
try
//defaults
xmustpaint:=false;
v         :='';
v32       :=0;

//check -> "dhelp."
if cancmd(x) then x:=strcopy1(x,7,low__len(x)) else exit;

//get
if m('paste') then
   begin
   //refind
   ifindref:='';

   //paste
   clip__pastetext(str1);
   err:=str1;
   end
else if m('test') then
   begin

   tstr8(nil).clear;//debug purposes only

   end
else if m('find') then
   begin
   ifindref:='';//refind
   end
else if m('reload') then
   begin
   imapref:='';//reload
   ifindref:='';//refind
   end
else if m('open') then
   begin
   if popopenmap(ilastopenfile) then
      begin
      xloadmap(ilastopenfile);
      ifindref:='';//refind
      end;
   end
else if m('imagebase') then
   begin
   str1:=imagebase;
   if gui.popedit(str1,'Enter size of app Image Base in hex8 format','Default Size|Leave empty for default image base of 00400000') then
      begin
      imapref:='';//reload
      ifindref:='';//refind
      imagebase:=str1;
      end;
   end;

//paint
if xmustpaint then paintnow;
except;end;
end;

function tdhelp.canfind:boolean;
begin
result:=(isearch<>nil) and (isearch.value<>'');
end;

function tdhelp.canreload:boolean;
begin
result:=(imapfile<>'');
end;

function tdhelp.popopenmap(var xfilename:string):boolean;
var
   daction,xfilterlist:string;
   xfilterindex:longint;
begin
result:=false;
daction:='';

try
//filterlist
xfilterlist:='map'+fesep;
xfilterindex:=0;

//get
result:=gui.xpopnav3(xfilename,xfilterindex,xfilterlist,'','open','','Open Map',daction,true);
except;end;
end;


function tdhelp._onaccept(sender:tobject;xfolder,xfilename:string;xindex,xcount:longint):boolean;
begin
result:=true;

try
if io__fileexists(xfilename) then
   begin
   //xxxxxxxxxxxxxxxxxxxxx
   end;
except;end;
end;


//## tapp ######################################################################
constructor tapp.create;
begin
if system_debug then dbstatus(38,'Debug 010 - 21may2021_528am');//yyyy

//check source code for know problems ------------------------------------------
//io__sourecode_checkall(['']);


//self
inherited create(strint32(app__info('width')),strint32(app__info('height')),true);
ibuildingcontrol:=true;
iloaded:=false;
isettingsref:='';

//need checkers
need_jpeg;
need_gif;
need_ico;

//init
itimer500 :=ms64;

//vars
iloaded:=false;


//controls
with rootwin do
begin
static:=true;
xhead;
xgrad;
xgrad2;
xstatus2.cellwidth[0]:=250;
xstatus2.cellwidth[1]:=200;
xstatus2.cellwidth[2]:=500;

icore:=tdhelp.create(client);
end;//rootwin


with rootwin do
begin
xhead.xaddoptions;
xhead.xaddhelp;
end;


//default page to show
rootwin.xhead.parentpage:='overview';

//events
rootwin.xhead.onclick:=__onclick;
rootwin.xhead.showmenuClick1:=xshowmenuClick1;
rootwin.xhead.ocanshowmenu:=true;//use toolbar for special menu display - 18dec2021
rootwin.onaccept:=icore._onaccept;//drag and drop support

//start timer event
ibuildingcontrol:=false;
xloadsettings;

//finish
createfinish;
end;

destructor tapp.destroy;
begin
try
//settings
xautosavesettings;

//self
inherited destroy;
except;end;
end;

procedure tapp.xcmd(sender:tobject;xcode:longint;xcode2:string);
begin//use for testing purposes only - 15mar2020
try

//init
if zzok(sender,7455) and (sender is tbasictoolbar) then
   begin
   //ours next
   //xcode:=(sender as tbasictoolbar).ocode;
   xcode2:=strlow((sender as tbasictoolbar).ocode2);
   end;

//get
if icore.cancmd(xcode2) then icore.cmd(xcode2);
except;end;
end;

function tapp.xshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
begin
result:=true;
xcmd(nil,0,xcode2);
end;

procedure tapp.xloadsettings;
var
   a:tvars8;
begin
try
//defaults
a:=nil;
//check
if zznil(prgsettings,5001) then exit;

//init
a:=vnew2(950);
//filter
a.s['mapfile']          :=prgsettings.sdef('mapfile','');
a.s['imagebase']        :=prgsettings.sdef('imagebase','00400000');
a.s['err']              :=prgsettings.sdef('err','');

//sync
prgsettings.data:=a.data;

//set
icore.mapfile           :=io__readportablefilename(a.s['mapfile']);
icore.imagebase         :=a.s['imagebase'];
icore.err               :=a.s['err'];

except;end;
//free
freeobj(@a);
iloaded:=true;
end;

procedure tapp.xsavesettings;
var
   a:tvars8;
begin
try
//check
if not iloaded then exit;

//defaults
a:=nil;
a:=vnew2(951);

//get
a.s['mapfile']   :=io__makeportablefilename(icore.mapfile);
a.s['imagebase'] :=icore.imagebase;
a.s['err']       :=icore.err;

//set
prgsettings.data:=a.data;
siSaveprgsettings;
except;end;
//free
freeobj(@a);
end;

procedure tapp.xautosavesettings;
begin
if iloaded and low__setstr(isettingsref,icore.err+'|'+icore.imagebase+'|'+icore.mapfile) then xsavesettings;
end;

procedure tapp.__onclick(sender:tobject);
begin
xcmd(sender,0,'');
end;

procedure tapp.__ontimer(sender:tobject);//._ontimer
begin
try
//check
if not iloaded then exit;


//timer500
if (ms64>=itimer500) then
   begin
   //savesettings
   xautosavesettings;

   //sync info
   xsync;

   //reset
   itimer500:=ms64+500;
   end;

//debug tests
//if system_debug then debug_tests;
except;end;
end;

procedure tapp.xsync;
begin
try
with rootwin.xstatus2 do
begin

celltext[0]:='Program Entry Point: '+icore.programentry;
celltext[1]:='Image Base: '+icore.imagebase;

case (icore.foundname<>'') of
true:begin
   celltext[2]:='  Found Proc: "'+icore.foundname+'" at '+icore.foundhex8;
   cellmark[2]:=true;
   cellflash[2]:=true;
   end;
else
   begin

   case (icore.err<>'') of
   true:celltext[2]:='  No procedure or function found for address: '+icore.err;
   else celltext[2]:='  No address entered';
   end;//case

   cellmark[2]:=false;
   cellflash[2]:=false;
   end;
end;//case


cellalign[2]:=0;
//celltext[1]:='Program Entry: '+icore.programentry;

end;

except;end;
end;

end.
