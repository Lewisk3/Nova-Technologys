{
  [ "/apis/novaio" ] = {
    content = "local str = \"\"\
local active = true\
local inputindex = #str\
local function setStartStr(nstr)\
\009str = nstr\
end\
function read(e,maxlen,mslen,x,y)\
\009term.setCursorBlink(active)\
\009local function drawstr()\
\009\009term.setCursorPos(x,y)\
\009\009write(string.rep(\" \",mslen+1))\
\009\009term.setCursorPos(x,y)\
\009\009if(#str > mslen)then\
\009\009\009local dif = #str - mslen\
\009\009\009if(inputindex <= dif)then\
\009\009\009\009write(str:sub(inputindex,mslen+inputindex))\
\009\009\009else\
\009\009\009\009write(str:sub(dif,mslen+dif))\
\009\009\009end\
\009\009else\
\009\009\009write(str)\
\009\009end\
\009\009if(inputindex > mslen)then\
\009\009\009term.setCursorPos(x+inputindex-(#str-mslen),y)\
\009\009else\
\009\009\009term.setCursorPos(x+inputindex,y)\
\009\009end\
\009end\
\009local function undrawstr()\
\009\009term.setCursorPos(x,y)\
\009\009write(string.rep(\" \",mslen))\
\009end\
\009local function updatestr()\
\009\009inputindex = inputindex + 1\
\009\009drawstr()\
\009end\
\009if(active)then\
\009\009if(e[1] == \"char\" and #str < maxlen)then\
\009        str = str:sub(1,inputindex) .. tostring(e[2]) .. str:sub(inputindex+1,#str)\
        \009updatestr()\
\009\009end\
\009\009if(e[1] == \"key\")then\
\009\009\009local key = e[2]\
\009\009\009 if(key == keys.enter)then\
\009\009\009 \009term.setCursorBlink(false)\
\009\009\009 \009active = false\
\009\009\009 \009return true\
\009\009\009 end\
\009\009\009 if(key == keys.backspace and inputindex > 0)then\
\009\009\009 \009 undrawstr()\
\009\009\009 \009 str =  string.sub( str, 1, inputindex - 1 ) .. string.sub( str, inputindex + 1 )\
\009\009\009 \009 inputindex = inputindex - 1\
\009\009\009 \009 drawstr()\
\009\009\009 end\
\009\009\009 if(key == keys.left and inputindex > 0)then\
\009\009\009 \009 inputindex = inputindex - 1\
\009\009\009 \009 drawstr()\
\009\009\009 end\
\009\009\009 if(key == keys.right and inputindex < #str)then\
\009\009\009 \009 inputindex = inputindex + 1\
\009\009\009 \009 drawstr()\
\009\009\009 end\
\009\009\009 if(key == keys.delete and inputindex < #str)then\
\009\009\009 \009 undrawstr()\
\009\009\009 \009 str = string.sub( str, 1, inputindex ) .. string.sub( str, inputindex + 2 )\
\009\009\009 \009 drawstr()\
\009\009\009 end\
\009\009end\
\009end\
\009if(e[1] == \"mouse_click\" and (e[4] ~= y or e[3] < x or e[3] > x+maxlen) )then\
\009\009active = false\
\009\009term.setCursorBlink(active)\
\009elseif(e[1] == \"mouse_click\" and e[4] == y)then\
\009\009if(not active)then\
\009\009\009active = true\
\009\009\009term.setCursorPos(x+inputindex,y)\
\009\009\009term.setCursorBlink(active)\
\009\009end\
\009\009if(e[3]-x >= 0 and e[3]-x <= #str)then\
\009\009\009inputindex = e[3]-x\
\009\009\009drawstr()\
\009\009end\
\009end\
end\
function getInput()\
\009return str\
end\
function resetInput()\
\009str = \"\"\
\009inputindex = #str\
end\
function setInput(nstr)\
\009str = nstr\
\009inputindex = #str\
end\
function setActive(act)\
\009active = act\
end\
function getActive()\
\009return active\
end",
  },
  [ "/apis/futils" ] = {
    content = "function file_readAll(file,s)\
    local f = fs.open(file,\"r\")\
    local cont = f.readAll()\
    f.close()\
    if(s)then return textutils.unserialize(s) end\
    return cont\
end\
function file_readLine(file,s)\
    local f = fs.open(file,\"r\")\
    local cont = f.readLine()\
    f.close()\
    if(s)then return textutils.unserialize(s) end\
    return cont\
end\
function file_write(file,data,s)\
    local f = fs.open(file,\"w\")\
    if(s)then f.write(textutils.serialize(data)) else\
    f.write(data) end\
    f.close()\
end\
function file_writeline(file,data,s)\
    local f = fs.open(file,\"w\")\
    if(s)then f.writeLine(textutils.serialize(data)) else\
    f.writeLine(data) end\
    f.close()\
end\
 \
local function getcontent(data,wdata,ctbl)\
    -- Returns a table --\
    for k, v in pairs(fs.list(data)) do\
     \
      if(fs.isDir(data..\"/\"..v) )then\
        getcontent(data..v..\"/\",v..\"/\",ctbl)\
      else\
      print(data..v)\
        f = fs.open(data..v,\"r\")\
        ctbl[\"/\" .. wdata..v] = {content=f.readAll()}\
        f.close()\
      end\
    end\
     return textutils.serialize(ctbl)\
end\
function archive(data,export)\
    local content = {}\
    content = getcontent('/' .. data .. \"/\",\"/\",content)\
    file_write(export,content)\
end\
 \
function extract(file,to)\
    local cont = textutils.unserialize(file_readAll(file))\
    for k,v in pairs(cont) do\
         file_write(to .. k,v.content)\
    end\
end",
  },
  [ "/programs/novaexplore" ] = {
    content = "--====================================================\
--]] Nova Explore and all file apis created by\
--]] Lewisk3 CEO of Nova, all rights reservered \
--]] DO NOT REDISTRIBUTE without the permission \
--]] of Nova, Editing and/or \"rebranding\" is prohibited.\
--]] Any copys found outside the permission of Nova\
--]] will be taken and money will be due to the rights\
--]] of Nova Technologys\
-------------------------------------------------------\
--=]      We have the rights to all the above       [=-       \
--=====================================================\
--]] Determine OS and load apis accordingly \
local w, h = term.getSize()\
local sbc = term.setBackgroundColor\
local stc = term.setTextColor\
local scp = term.setCursorPos\
local clr = term.clear\
local clrln = term.clearLine\
local pa = paintutils\
local apis = {'ugapi','fpath','futils','novaio'}\
local function init()\
if(fs.isDir(\"CrossBow/apis\"))then\
\009for i = 1, #apis do\
\009\009\009if(fs.exists(\"CrossBow/apis/\"..apis[i]))then\
\009\009\009\009apis[i] = \"CrossBow/apis/\" ..apis[i]\
\
\009\009\009else\
\009\009\009\009error(\"Program had to Quit: CrossBow install outdated or malformed. \")\
\009\009\009end\
\009\009end \
\009end\
\009for i = 1, #apis do\
\009\009os.loadAPI(apis[i])\
\009end\
end\
init()\
--]] Define variables \
local file_selected = 0\
local files = {}\
-- Path isnt locked\
local path = fpath.newpath(\"rom/apis\")\
novaio.setActive(false)\
novaio.setInput(path:getraw())\
local fileoffs = 0\
local sideoffs = 0\
local sidemax = h-1\
local filemax = h\
local searching = false\
local selectedside = 0\
local search = \"\"\
local clipboard = \"\"\
local inmenu = false\
local inmenutype = {}\
local inmenux, inmenuy = 1, 4\
local filemenu = {\
\009 {n=\"Open    \",func=function(file) end},\
\009 {n=\"Edit    \",func=function(file) end},\
\009 {n=\"Open as \",func=function(file) end},\
\009 {n=\"Rename  \",func=function(file) end},\
\009 {n=\"Extract \",relies=function(file) return file.t == \"zip\" end,\
\009 func=function(file) end},\
\009 {n=\"Archive \",relies=function(file) return file.t ~= \"zip\" end,\
\009 func=function(file) end},\
\009 {n=\"Copy    \",func=function(file) end},\
\009 {n=\"Paste   \",relies=function(file) return clipboard ~= \"\" end,\
\009 func=function(file) end},\
\009 {n=\"Pin item\",func=function(file) end},\
\009 {n=\"Delete  \",func=function(file) end},\
}\
local foldermenu = {\
\009 {n=\"Open    \",func=function(file) end},\
\009 {n=\"Rename  \",func=function(file) end},\
\009 {n=\"Archive \",func=function(file) end},\
\009 {n=\"Copy    \",func=function(file) end},\
\009 {n=\"Paste   \",relies=function(file) return clipboard ~= \"\" end,\
\009 func=function(file) end},\
\009 {n=\"Pin item\",func=function(file) end},\
\009 {n=\"Delete  \",func=function(file) end},\009\
}\
local icons = {\
\009folder = \"&e[=]\",\
\009file = \"&7-~-\",\
\009executable = \"&4-&7=&8]\",\
\009zip = \"&5[&1=&2]\",\
\009paint = \"&2~&4*\",\
\009pin = \"&7<&8 \",\
}\
local sideitems = {\
\009{n='&5* &rQuick Access',t='text'},\
\009{n=' ',t='text'},\
\009{n=icons.folder..' &rPrograms',t='link',href=\"CrossBow/programs\"},\
\009{n=icons.folder..' &rGames',t='link',href=\"CrossBow/games\"},\
\009{n=' ',t='text'},\
\009{n=' ',t='text'},\
\009{n=icons.pin .. \"&rPinned Items\",t='text'},\
\009{n=' ',t='text'},\
\009{n=icons.executable..' &rGameOfLife',t='file',href=\"CrossBow/games/GameOfLife\"},\
\009{n=icons.executable..' &r2048',t='file',href=\"CrossBow/games/2048\"},\
\009{n=icons.folder..' &rPrograms',t='link',href=\"CrossBow/apis/\"},\
}\
local colorencode = {\
    ['&r'] = \"black\",\
    ['&1'] = \"blue\",\
    ['&2'] = \"green\",\
    ['&3'] = \"cyan\",\
    ['&4'] = \"red\",\
    ['&5'] = \"purple\",\
    ['&6'] = \"brown\",\
    ['&7'] = \"lightGray\",\
    ['&8'] = \"gray\",\
    ['&9'] = \"lightBlue\",\
    ['&a'] = \"lime\",\
    ['&b'] = \"orange\",\
    ['&c'] = \"pink\",\
    ['&d'] = \"magenta\",\
    ['&e'] = \"yellow\",\
    ['&f'] = \"white\",\
}\
\
-- Icon drawing\
function drawmenu(menu,sx,sy)\
\009local finalmenu = {}\
\009for i = 1, #menu do\
\009\009if(menu[i].relies == nil)then\
\009\009\009finalmenu[#finalmenu+1] = menu[i]\
\009\009elseif(menu[i].relies(files[file_selected]))then\
\009\009\009finalmenu[#finalmenu+1] = menu[i]\
\009\009end\
\009end\
\009if(sy+#finalmenu > h)then\
\009\009sy = sy - ((sy+#finalmenu)-h)\
\009end\
\009for i = 1, #finalmenu do\
\009\009if(sy+i <= h)then\
\009\009\009scp(sx-1,sy+i)\
\009\009\009sbc(colors.gray)\
\009\009\009stc(colors.white)\
\009\009\009write(string.rep(\" \",#finalmenu[i].n+1))\
\009\009\009scp(sx,sy+i)\
\009\009\009write(finalmenu[i].n)\
\009\009end\
\009end\
\009return finalmenu, sy\
end\
function drawMenuClick(mop)\
\009local dnx, dny = term.getCursorPos()\
\009sbc(colors.black)\
\009stc(colors.gray)\
\009write(mop.n)\
\009sleep(0.2)\
\009scp(dnx,dny)\
\009sbc(colors.gray)\
\009stc(colors.white)\
\009write(mop.n)\
end\
function updatemenu(e,menu,sx,sy)\
\009if(e[1] == \"mouse_click\")then\
\009\009local x, y = e[3], e[4]\
\009\009local mlen = #menu[1].n-1\
\009\009if(x >= sx and x <= sx+mlen and y >= sy+1 and y <= sy+#menu)then\
\009\009\009 local clicked = menu[(y-sy)]\
\009\009\009 scp(sx,y)\
\009\009\009 drawMenuClick(clicked)\
\009\009\009 return clicked.func(files[file_selected])\
\009\009else\
\009\009\009undrawFiles()\
\009\009\009drawFiles()\
\009\009\009inmenu = false\
\009\009end\
\009end\
end\
function fullwrite(str,smax,x,y,special)\
\009scp(x,y)\
\009if(special)then sbc(colors.lightBlue) end\
    for a = 1, #str do\
        if(string.sub(str,a,a) == \"&\")then\
            if(colorencode[string.sub(str,a,a+1)] ~= nil)then\
                stc(colors[colorencode[string.sub(str,a,a+1)]])\
            end\
            str = string.sub(str,1,a-1) .. string.sub(str,a+1,#str)\
        else\
            write(string.sub(str,a,a))\
        end\
    end  \
    sbc(colors.white)\
end\
--]] Get files in directory\
function getfiles()\
\009files = {}\
\009for k , v in pairs(fs.list(path:getraw())) do\
\009\009if(fs.isDir(path:getraw() .. v))then\
\009\009\009files[#files+1] = {n=v,t='folder'}\
\009\009else\
\009\009\009local nt = 'file'\
\009\009\009if(v:sub(#v-3,#v) == '.zip')then nt = 'zip' end\
\009\009\009if(v:sub(#v-3,#v) == '.exe')then nt = 'exe' end\
\009\009\009files[#files+1] = {n=v,t=nt}\
\009\009end\
\009end\
end\
--]] Draw program layout\
function drawSideBar()\
\009term.current().setVisible(false)\
\009sbc(colors.white)\
\009pa.drawFilledBox(0,4,17,h,colors.white)\
\009sbc(1,1)\
\009for i = 1+sideoffs, #sideitems do\
\009\009if(i-sideoffs < sidemax)then\
\009\009\009scp(1,(i-sideoffs)+4)\
\009\009\009write(string.rep(\" \",16))\
\009\009\009if(selectedside == i)then\
\009\009\009\009sbc(colors.lightGray)\
\009\009\009else\
\009\009\009\009sbc(colors.white)\
\009\009\009end\
\009\009\009fullwrite(sideitems[i].n,12,1,(i-sideoffs)+4)\
\009\009end\
\009end\
\009pa.drawBox(17,4,17,h,colors.gray)\
\009pa.drawBox(1,h,17,h,colors.gray)\
\009pa.drawBox(16,4,16,h-1,colors.lightGray)\
\009stc(colors.gray)\
\009ugapi.writexy(\"^\",16,4)\
\009ugapi.writexy(\"v\",16,h-1)\
\009term.current().setVisible(true)\
end\
-- Deprecidated\
function drawFile(ind)\
\009 -- Draw selected files\
\009term.current().setVisible(false)\
\009sbc(colors.white)\
\009stc(colors.black)\
\009drawFilePath()\
\009  if(ind <= filemax)then\
\009 \009    scp(19,ind+fileoffs)\
\009\009\009write(string.rep(\" \",30))\
\009\009\009fullwrite(icons[files[ind].t] .. \" &r\" .. files[ind].n ,12,19,ind,file_selected == ind)\
\009\009\009scp(40,ind+fileoffs)\
\009\009 if(not fs.isDir(path:getraw() .. files[ind].n))then\
\009\009     \009write(tostring(fs.getSize(path:getraw() .. files[ind].n) / 1000):sub(1,4) .. \"KB\")\
\009\009 end\
\009  end\
\009  term.current().setVisible(true)\
end\
function undrawFiles()\
\009pa.drawFilledBox(19,4,w-1,h,colors.white)\
end\
function drawFilePath()\
\009sbc(colors.white)\
\009ugapi.writexy(string.rep(\" \",w-24),12,2)\
\009sbc(colors.white)\
\009stc(colors.black)\
\009scp(13,2)\
\009if(#path:getraw() > 25)then\
\009\009local dif = #path:getraw() - 25\
\009\009write(path:getraw():sub(dif,#path:getraw()))\
\009else\
\009\009write(path:getraw())\
\009end\
end\
function drawFiles()\
\009term.current().setVisible(false)\
\009sbc(colors.white)\
\009stc(colors.black)\
\009drawFilePath()\
\009 scp(23,4)\
\009 stc(colors.lightGray)\
\009 write(\"Name\")\
\009 scp(40,4)\
\009 write(\"Size\")\
\009if(#files == 0)then\
\009\009scp(25,5)\
\009\009stc(colors.lightGray)\
\009\009if(search ~= \"\")then\
\009\009\009scp(20,5)\
\009\009\009write(\"No items matched your search. \")\
\009\009else\
\009\009\009write(\"This folder is empty. \")\
\009\009end\
\009end\
\009 for i = 1+fileoffs, #files do\
\009 \009  if(i-fileoffs <= filemax)then\
\009 \009  \009 scp(19,(i-fileoffs)+4)\
\009\009\009 write(string.rep(\" \",30))\
\009\009\009 fullwrite(icons[files[i].t] .. \" &r\" .. files[i].n ,12,19,(i-fileoffs)+4,file_selected == i)\
\009\009\009 scp(40,(i-fileoffs)+4)\
\009\009\009 if(not fs.isDir(path:getraw() .. files[i].n))then\
\009\009\009 \009write(tostring(fs.getSize(path:getraw() .. files[i].n) / 1000):sub(1,4) .. \"KB\")\
\009\009\009 end\
\009 \009  end\
\009 end \
\009 term.current().setVisible(true)\
end\
function runFile(fpath)\
\009local odir = shell.dir()\
\009sbc(colors.black)\
\009stc(colors.white)\
\009clr()\
\009scp(1,1)\
\009shell.setDir(\"\")\
\009shell.run(fpath)\
\009sbc(colors.white)\
\009clr()\
\009stc(colors.gray)\
\009ugapi.writecy(\"Click anywhere to return to NovaBrowse. \",9)\
\009os.pullEvent(\"mouse_click\")\
\009shell.setDir(odir)\
\009drawMain()\
\009getfiles()\
\009drawFiles()\
end\
function setDir(name)\
\009if(fs.isDir(name))then\
\009\009clearSearch()\
\009\009file_selected = 0\
\009\009if(name:sub(#name,#name) ~= \"/\")then name = name .. \"/\" end\
\009\009fileoffs = 0\
\009\009path:set(name)\
\009\009getfiles()\
\009\009undrawFiles()\
\009\009drawFiles()\
\009\009return true\
\009else\
\009\009drawFilePath()\
\009\009return false\
\009end\
end\
function addDir(name)\
\009selectedside = 0\
\009drawSideBar() \
\009clearSearch()\
\009file_selected = 0\
\009fileoffs = 0\
\009path:add(name)\
\009getfiles()\
\009undrawFiles()\
\009drawFiles()\
end\
function clearSearch()\
\009search = \"\"\
\009scp(40,2)\
\009sbc(colors.lightGray)\
\009write(string.rep(\" \",11))\
end\
function searchDir(val)\
\009file_selected = 0\
\009fileoffs = 0\
\009local nfiles = {}\
\009undrawFiles()\
\009if(val == \"\" or val == \" \")then\
\009\009getfiles()\
\009else\
\009\009for i = 1, #files do\
\009\009\009if(files[i].n:find(val))then\
\009\009\009\009nfiles[#nfiles+1] = files[i]\
\009\009\009end\
\009\009end\
\009\009files = nfiles\
\009end\
\009drawFiles()\
end\
function openHref(href)\
 if(fs.isDir(href))then\
 \009setDir(href)\
 elseif(fs.exists(href))then\
 \009return runFile(href)\
 end\
end\
function prevDir(ind) \
\009selectedside = 0 \
\009drawSideBar()\
\009scp(2,2)\
\009sbc(colors.gray)\
\009stc(colors.black)\
\009write(\"<-\")\
\009sleep(0.1)\
\009scp(2,2)\
\009sbc(colors.lightGray)\
\009stc(colors.gray)\
\009write(\"<-\")\
\009clearSearch()\
\009file_selected = 0\
\009fileoffs = 0\
\009path:goback(ind)\
\009getfiles()\
\009undrawFiles()\
\009drawFiles()\009\
end\
function refreshDir()\
\009scp(6,2)\
\009sbc(colors.gray)\
\009stc(colors.black)\
\009write(\"<>\")\
\009sleep(0.1)\
\009scp(6,2)\
\009sbc(colors.lightGray)\
\009stc(colors.gray)\
\009write(\"<>\")\
\009clearSearch()\
\009file_selected = 0\
\009fileoffs = 0\
\009getfiles()\
\009undrawFiles()\
\009drawFiles()\009\
end\
function update(e)\
\009if(inmenu)then\
\009\009updatemenu(e,inmenutype,inmenux,inmenuy)\
\009end\
\009if(e[1] == \"mouse_click\")then\
\009\009 local x,y = e[3], e[4]    \
\009\009 -- Left clicked\
\009\009if(e[2] == 1)then\
\009\009 \009if(x >= 38 and x <= 51 and y == 2)then\
\009\009 \009\009novaio.setInput(search)\
\009\009 \009\009searching = true\
\009\009 \009elseif(searching)then\
\009\009 \009\009search = novaio.getInput()\
\009\009 \009\009searching = false\
\009\009 \009end\
\009\009 \009if(x >= 2 and x <= 4 and y == 2)then\
\009\009 \009\009if(inmenu)then inmenu = false end\
\009\009 \009\009prevDir(1)\
\009\009 \009end\
\009\009 \009if(x >= 6 and x <= 8 and y == 2)then\
\009\009 \009\009refreshDir()\
\009\009 \009end\
\009\009end \
\009\009-- Left or right clicked\
\009\009 \009local yind = (y+fileoffs)-4\
\009\009 \009local syind = (y+sideoffs)-4\
\009\009 \009if(x < 18 and syind <= #sideitems and syind > 0)then\
\009\009\009 \009 if(y > 4 and x >= 1 and x <= #(sideitems[syind].n:sub(1,14)) )then\
\009\009\009 \009   if(e[2] == 1)then\
\009\009\009\009 \009 \009if(sideitems[syind].t == \"link\")then\
\009\009\009\009 \009 \009    selectedside = syind\
\009\009\009\009 \009 \009  \009openHref(sideitems[syind].href)\
\009\009\009\009 \009 \009  \009drawSideBar()\
\009\009\009\009 \009 \009elseif(sideitems[syind].t == \"file\")then\
\009\009\009\009 \009 \009  \009if(selectedside == syind)then\
\009\009\009\009 \009 \009  \009 \009openHref(sideitems[syind].href)\
\009\009\009\009 \009 \009  \009else\
\009\009\009\009 \009 \009  \009    selectedside = syind\
\009\009\009\009 \009 \009  \009 \009drawSideBar()\
\009\009\009\009 \009 \009  \009end\
\009\009\009\009 \009 \009end\
\009\009\009 \009   end\
\009\009\009 \009 end\
\009\009\009 elseif(yind <= #files and yind > 0)then\
\009\009 \009 \009if(y > 4 and x >= 18 and x <= 22+#files[yind].n)then\
\009\009 \009 \009   if(e[2] == 1 and not inmenu)then\
\009\009\009 \009 \009  if(file_selected == yind)then\
\009\009\009 \009 \009  \009if(files[file_selected].t == \"folder\")then\
\009\009\009 \009 \009  \009\009if(inmenu)then inmenu = false end\
\009\009\009 \009 \009  \009 \009addDir(files[yind].n)\
\009\009\009 \009 \009  \009end\
\009\009\009 \009 \009  else\
\009\009\009 \009 \009  \009 file_selected = yind\
\009\009\009 \009 \009  \009 drawFiles()\
\009\009\009 \009 \009  end\
\009\009\009 \009   elseif(e[2] == 2)then\
\009\009\009 \009   \009   if(file_selected == yind)then\
\009\009\009\009\009\009 \009if(inmenu)then\
\009\009\009\009\009\009 \009   undrawFiles()\
\009\009\009\009\009\009 \009   drawFiles()\
\009\009\009\009\009\009 \009   inmenu = false\
\009\009\009\009\009\009 \009else\
\009\009\009\009\009\009 \009  local mtodraw = filemenu\
\009\009\009\009\009\009 \009  if(fs.isDir(path:getraw() .. files[file_selected].n))then\
\009\009\009\009\009\009 \009  \009  mtodraw = foldermenu\
\009\009\009\009\009\009 \009  end\
\009\009\009\009\009\009 \009   inmenutype,inmenuy = drawmenu(mtodraw,22+#files[yind].n,y)\
\009\009\009\009\009\009 \009   inmenux = 22+#files[yind].n\
\009\009\009\009\009\009 \009   inmenu = true\
\009\009\009\009\009\009 \009end\
\009\009\009\009\009\009 end\
\009\009 \009 \009   end\
\009\009 \009 \009end\
\009\009 end \
\009end\
\009if(e[1] == \"mouse_scroll\")then\
\009\009local dir = e[2]\
\009\009local x,y = e[3], e[4]\
\009\009if(dir == -1)then\
\009\009\009if(x > 16 and fileoffs > 0 and #files > filemax-5)then\
\009\009\009\009fileoffs = fileoffs - 1\
\009\009\009\009drawFiles()\
\009\009\009elseif(x <= 16 and sideoffs > 0 and #sideitems > sidemax-5)then\
\009\009\009\009sideoffs = sideoffs - 1\
\009\009\009\009drawSideBar()\
\009\009\009end\
\009\009elseif(dir == 1)then\
\009\009\009if(x > 16 and fileoffs < #files-(filemax-4))then\
\009\009\009\009fileoffs = fileoffs + 1\
\009\009\009\009drawFiles()\
\009\009\009elseif(x <= 16 and sideoffs < #sideitems-(sidemax-4))then\
\009\009\009\009sideoffs = sideoffs + 1\
\009\009\009\009drawSideBar()\
\009\009\009end\
\009\009end\
\009end\
\009if(novaio.getActive() == false and not searching)then\
\009\009if(novaio.getInput() ~= path:getraw())then\
\009\009\009novaio.setInput(path:getraw())\
\009\009end\
\009end\
\
\009if(not searching)then\
\009\009stc(colors.black)\
\009\009sbc(colors.white)\
\009\009local doneinp = novaio.read(e,1000,25,13,2)\
\009\009if(doneinp)then\
\009    \009novaio.setActive(false)\
\009\009\009if( setDir(novaio.getInput()) )then\
\009\009\009\009selectedside = 0\
\009\009\009\009drawSideBar()\
\009\009\009end\
\009\009\009novaio.setInput(\"\")\
\009\009end\
\009else\
\009\009stc(colors.black)\
\009\009sbc(colors.lightGray)\
\009\009local doneinp = novaio.read(e,1000,10,40,2)\
\009\009if(doneinp)then\
\009\009\009searching = false\
\009    \009novaio.setActive(false)\
\009    \009search = novaio.getInput()\
\009\009\009searchDir(novaio.getInput()) \
\009\009\009novaio.setInput(\"\")\
\009\009end\
\009end\
end\
function drawMain()\
\009sbc(colors.white)\
\009clr()\
\009scp(1,2)\
\009sbc(colors.lightGray)\
\009clrln()\
\009pa.drawBox(w-12,1,w,3,colors.gray)\
\009sbc(colors.white)\
\009ugapi.writexy(string.rep(\" \",w-12),1,2)\
\009pa.drawBox(10,1,w-12,3,colors.gray)\
\009drawSideBar()\
\009pa.drawFilledBox(1,1,9,3,colors.lightGray)\
\009scp(2,2)\
\009stc(colors.gray)\
\009write(\"<-  <>\")\
\009--pa.drawBox(15,h,w,h,colors.lightGray)\
\009pa.drawBox(w,4,w,h,colors.lightGray)\
\009stc(colors.gray)\
\009ugapi.writexy(\"^\",w,4)\
\009ugapi.writexy(\"v\",w,h)\
end\
drawMain()\
getfiles()\
drawFiles()\
\
while true do \
\009local e = {os.pullEvent()}\
\009update(e)\
end",
  },
  [ "/games/2048" ] = {
    content = "local running = true\
local cx,cy = 0, 0\
local drawx = 11\
local drawy = -2\
local xscale = 5\
local yscale = 4\
local cubexsize = 6\
local cubeysize = 4\
local score = 2\
local function calcdragpos(sx,sy,ex,ey,dx,dy)\
\009if(ex < sx-dx)then return -1,0\
\009elseif(ex > sx+dx)then return 1,0\
\009elseif(ey < sy-dy)then return 0,-1\
\009elseif(ey > sy+dy)then return 0,1 end\
end\
\
local map = {\
\009{2,0,0,0},\
\009{0,0,0,0},\
\009{0,0,0,0},\
\009{0,0,0,0},\
}\
local numcols = {\
\009['2'] = \"white\",\
\009['4'] = \"lightGray\",\
\009['8'] = \"brown\",\
\009['16'] = \"orange\",\
\009['32'] = \"pink\",\
\009['64'] = \"red\",\
\009['128'] = \"yellow\",\
\009['256'] = \"yellow\",\
\009['512'] = \"yellow\",\
\009['1024'] = \"yellow\",\
\009['2048'] = \"yellow\",\
\009['4096'] = \"magenta\",\
\009['8192'] = \"purple\",\
}\
local function drawtile(x,y)\
\009   \009local sx = (drawx)+(x)*xscale\
   \009   \009local sy = (drawy)+(y)*yscale\
   \009   \009local ex = (drawx+x*xscale)+cubexsize\
   \009   \009local ey = (drawy+y*yscale)+cubeysize\
   \009   \009if(map[y][x] ~= 0)then\
   \009   \009\009-- drawing code form empty\
   \009   \009\009bcol = numcols[tostring(map[y][x])]\
   \009   \009\009if(bcol == nil)then col = colors.lightBlue end\
   \009   \009\009paintutils.drawFilledBox(sx+1,sy+1,ex-(cubexsize/2)+1,ey-(cubeysize/2)+1,colors[bcol])\
   \009   \009\009term.setTextColor(colors.black)\
   \009   \009\009term.setCursorPos((sx+3) - #tostring(map[y][x])/2 ,sy+2)\
   \009   \009\009write(map[y][x])\
   \009    else\
   \009   \009\009paintutils.drawFilledBox(sx+1,sy+1,ex-(cubexsize/2)+1,ey-(cubeysize/2)+1,colors.black)\
   \009   \009end\
end\
local function drawtiles()\
\009term.current().setVisible(false)\
\009--paintutils.drawBox(drawx,drawy,drawx+(#map[1]*xscale),drawy+(#map*yscale),colors.gray)\
\009for y = 1, #map do\
   \009   for x = 1, #map[y] do \
   \009   \009\009local tile = map[y][x]\
   \009   \009\009   \009local sx = (drawx)+(x)*xscale\
   \009   \009\009\009local sy = (drawy)+(y)*yscale\
   \009   \009\009\009local ex = (drawx+x*xscale)+cubexsize\
   \009   \009\009\009local ey = (drawy+y*yscale)+cubeysize\
   \009   \009\009\009paintutils.drawBox(sx,sy,ex-1,ey,colors.gray)\
   \009   \009\009\009drawtile(x,y)\
   \009   end\
   \009end\
   \009term.current().setVisible(true)\
end\
local function setTile(x,y,n)\
\009if(map[y][x] ~= 0 and n ~= 0)then \
\009\009score = score + (n-map[y][x]) \
\009elseif(map[y][x] ~= 0 and n == 0)then\
\009\009score = score - map[y][x]\
\009else\
\009\009score = score + n\
\009end\
\009map[y][x] = n\
\009drawtile(x,y)\
end\
\
local function getRandTile()\
\009local rx = math.ceil(math.random(1,#map[1]))\
\009local ry = math.ceil(math.random(1,#map))\
\009local rn = math.ceil(math.random(1,10))\
\009if(rn == 10)then\
\009\009rn = 4\
\009else \
\009\009rn = 2\
\009end\
\009return rx,ry,rn\
end\
\
local function slidetiles(xd,yd)\
\009-- 1, UP: 2, DOWN, 3: LEFT, 4: RIGHT\
\009local rna = math.ceil(math.random(1,2))\
\009local moved=false\
\009local cancombine = true\
\009for li = 1, #map[1] do\
\009   for y = 1, #map do\
\009   \009  for x = 1, #map[y] do\
\009   \009    \009local to = nil\
\009   \009    \009if(y+yd < 0 or x+xd < 0)then break end\
\009   \009\009    if(map[y+yd] ~= nil)then\
\009   \009\009    \009if(map[y+yd][x+xd] ~= nil)then\
\009   \009\009\009\009\009to = map[y+yd][x+xd]\
\009   \009\009\009\009end\
\009   \009\009\009end\
\
\009   \009\009    if(to == 0)then\
\009\009\009\009\009setTile(x+xd,y+yd,map[y][x])\
\009   \009\009\009\009setTile(x,y,0)\
\009   \009\009\009\009moved = true\
\009   \009\009\009elseif(to == map[y][x] and cancombine and to ~= 8192)then\
\009\009\009\009\009setTile(x+xd,y+yd,map[y+yd][x+xd]+map[y][x])\
\009   \009\009\009\009setTile(x,y,0)\
\009   \009\009\009\009cancombine = false\
\009   \009\009\009end\
\009   \009   end\
\009   end\
\009end\
\009local rx,ry,rn = getRandTile()\
\009if(map[ry][rx] == 0 and moved)then\
\009\009setTile(rx,ry,rn)\
\009end\
\009term.setCursorPos(1,1)\
\009term.setBackgroundColor(colors.white)\
\009term.setTextColor(colors.black)\
\009term.clearLine()\
\009print(score)\
end\
term.clear()\
drawtiles()\
while running do\
\
\009local e = {os.pullEvent()}\009\
\009if(e[1] == \"mouse_click\")then \
\009\009cx = e[3]\
\009\009cy = e[4]\
\009end\
\009if(e[1] == \"mouse_drag\" and cx ~= 0 and cy ~= 0)then\
\009\009local xdir,ydir = calcdragpos(cx,cy,e[3],e[4],2,1)\
       if(type(xdir) == \"number\" and type(ydir) == \"number\")then\
       \009  slidetiles(tonumber(xdir),tonumber(ydir))\
       \009  cx = 0\
       \009  cy = 0\
       end\
\009end\
end",
  },
  [ "/programs/RedLevel" ] = {
    content = "--]] Block Table [--\
term.redirect(term.native())\
local w, h = term.getSize()\
local sMenuIndex = 1\
local inSave = false\
local inGame = true\
local sPlay = false\
local bOff = 2\
local selBlock = bOff\
\
 local map = {}\
 local blocks = {\
    [0]={name=\"Air\",color=\"black\",bcolor=\"black\",graphic=\" \",solid=false},\
    {name=\"Player\",color=\"blue\",bcolor=\"black\",graphic=\"@\",solid=true},\
    {name=\"Dirt\",color=\"yellow\",bcolor=\"brown\",graphic=\" \",solid=true}, -- 1\
    {name=\"Stone\",color=\"lightGray\",bcolor=\"gray\",graphic=\"@\",solid=true}, -- 2\
    {name=\"Sand\",color=\"white\",bcolor=\"yellow\",graphic=\"+\",solid=true}, -- 3\
    {name=\"Scifi\",color=\"purple\",bcolor=\"blue\",graphic=\"0\",solid=true}, -- 4\
    {name=\"Grass\",color=\"green\",bcolor=\"brown\",graphic=\"*\",solid=true}, -- 5\
    {name=\"Iron\",color=\"white\",bcolor=\"lightGray\",graphic=\"/\",solid=true}, -- 6\
    {name=\"Gravel\",color=\"white\",bcolor=\"brown\",graphic=\"G\",solid=true}, -- 7\
    {name=\"Quartz\",color=\"lightGray\",bcolor=\"white\",graphic=\"X\",solid=true}, -- 8\
}\
 \
 \
 \
local sMenu = {\
  {name=\"Save\",run=function()\
\
       term.setCursorPos(1,h)\
      term.clearLine()\
      write(\"Export BlockMap To File : \")\
      tf = read()\
      f = fs.open(tf,\"w\")\
      f.write(textutils.serialize(blocks))\
      f.close()\
      term.setCursorPos(1,h)\
      term.clearLine()\
      write(\"Exported To File  - \"..tf)  \
      os.pullEvent(\"key\") \
\
    term.setCursorPos(1,h)\
    term.clearLine() \
    write(\"Save Map As: \")\
    sa=read()\
    f = fs.open(sa,\"w\")\
    --for i = 1, #map do\
    --   f.writeLine(table.concat(map[i]))\
    -- end\
    f.write(textutils.serialize(map):gsub(\"\\n%s*\",\"\"))\
    f.close()\
    term.setCursorPos(1,h)\
    term.clearLine() write(\"Saved As  \"..sa)\
    drawMap()\
    inSave=false\
  end};\
  {name=\"Load\",run=function()\
        term.setCursorPos(1,h)\
      term.clearLine()\
      write(\"Blocks Map File : \")\
      tf = read()\
      f = fs.open(tf,\"r\")\
      blocks = textutils.unserialize(f.readAll())\
      f.close()\
      term.setCursorPos(1,h)\
      term.clearLine()\
      write(\"Imported From File  - \"..tf)  \
      os.pullEvent(\"key\")\
      term.setCursorPos(1,h)\
      term.clearLine()\
      write(\"Load Map: \")\
      sa=read()\
\
    if(fs.exists(sa) and sa ~= \"\" and  sa ~= \" \")then\
      f = fs.open(sa,\"r\")\
      smap = textutils.unserialize(f.readAll())\
      f.close()\
      if(type(smap) ~= \"table\")then\
        term.setCursorPos(1,h)\
        term.clearLine()\
        write(\"Not a valid save file!\")\
        os.pullEvent(\"key\")\
      else\
        term.setCursorPos(1,h)\
        term.clearLine()\
        map=smap\
        write(\"Save loaded \"..sa)\
        os.pullEvent(\"key\")  \
      end\
      -- for line in f.readLine do\
      --    map[#map+1] = {}\
      --  for i = 1, #line do\
      --    local l = line:sub(i,i)\
      --    map[#map][i] = tonumber(l) or tostring(l)\
      --    end\
      -- end\
    else\
      term.setCursorPos(1,h)\
      term.clearLine()\
      write(\"File Not Found - \"..sa)  \
      os.pullEvent(\"key\")    \
    end\
    inSave=false\
    drawMap()\
    end};\
    -- {name=\"Play\",run=function()\
    --        sPlay=true\
    --        inSave=false\
    -- end};\
\
      {name=\"AddBlock\",run=function()\
        term.setCursorPos(1,h)\
        term.clearLine()\
        local nb = {}\
        write(\"Name: \")\
        nbName = read()\
        write(\"TextColor: \")\
        nbTCol= read()\
        write(\"BackColor: \")\
        nbBCol = read()\
        write(\"Graphic: \")\
        nbGraph = read()\
        write(\"Solid?: \")\
        sol = read()\
\009  \
\009if(sol == \"true\")then\
\009  issol = true;\
\009else\
\009  issol = false;\
\009end\
\
        nb = {name=nbName,color=nbTCol,bcolor=nbBCol,graphic=nbGraph,solid=issol}\
\
        table.insert(blocks,nb)\
        term.setCursorPos(1,h)\
        term.clearLine()\
        write(\"Block Created - \"..nbName)  \
        os.pullEvent(\"key\") \
         inSave=false\
         drawMap()\
     end};\
\
\
      {name=\"RemoveBlock\",run=function()\
        term.setCursorPos(1,h)\
        term.clearLine()\
        write(\"Name: \")\
        nbName = read()\
       for i = 1, #blocks do\
            if(blocks[i].name == nbName)then\
              table.remove(blocks,i)\
            end\
       end\
\
        term.setCursorPos(1,h)\
        term.clearLine()\
        write(\"Block(s) Removed - \"..nbName)  \
        os.pullEvent(\"key\") \
        drawMenu()\
         inSave=false\
         drawMap()\
     end};\
\
     {name=\"Exit\",run=function() inGame = false\
         term.setBackgroundColor(colors.black)\
          term.setTextColor(colors.white)\
          term.clear()\
          term.setCursorPos(1,1)\
      end};\
}\
 \
function drawMenu()\
    term.setCursorPos(1,h)\
   term.setTextColor(colors.white)\
   term.setBackgroundColor(colors.gray)\
   if(not inSave)then\
    if(selBlock < 8)then mCalc = bOff else mCalc = (selBlock-(8+(bOff-1)))+bOff end\
    for i = mCalc, (mCalc-1)+8 do\
      if(blocks[i]==nil)then \
          selBlock = 1\
      else\
        if(i ~= selBlock)then\
            write(\"[\")\
            term.setTextColor(colors[blocks[i].color])\
            term.setBackgroundColor(colors[blocks[i].bcolor])\
            write(blocks[i].graphic)\
            term.setTextColor(colors.white)\
            term.setBackgroundColor(colors.gray)\
            write(\"] \")\
       else\
            write(\">\")\
            term.setTextColor(colors[blocks[i].color])\
            term.setBackgroundColor(colors[blocks[i].bcolor])\
            write(blocks[i].graphic)\
            term.setTextColor(colors.white)\
            term.setBackgroundColor(colors.gray)\
            write(\"< \")\
       end    \
      end\
    end\
     term.setTextColor(colors.yellow)\
    write(\"Press Ctrl For Menu\")\
end\
 \
     if(inSave)then\
         term.setCursorPos(1,h)\
             term.clearLine()\
             term.setTextColor(colors.white)\
         for i = 1, #sMenu do\
              if(i == sMenuIndex)then\
                    term.setTextColor(colors.yellow)\
                    write(\"[\")\
                    term.setTextColor(colors.white)\
                    write(sMenu[i].name)\
                    term.setTextColor(colors.yellow)\
                    write(\"]\")\
              else\
                    term.setTextColor(colors.yellow)\
                    write(\" \")\
                    term.setTextColor(colors.white)\
                    write(sMenu[i].name)\
                    term.setTextColor(colors.yellow)\
                    write(\" \")    \
              end    \
              term.setTextColor(colors.white)\
         end\
     end\
end\
 \
function buildMap(w,h)\
         for i = 1, h do\
        map[i] = {}\
       for c = 1, w do\
            map[i][c] = 0\
       end    \
    end\
end\
 \
function drawMap()\
    term.setBackgroundColor(colors.black)\
    term.clear()\
    term.setCursorPos(1,1)\
    for i = 1, #map do\
        for c = 1, #map[i] do\
            if(blocks[map[i][c]] == nil)then map[i][c] = 0 end\
            term.setTextColor(colors[blocks[map[i][c]].color])\
            term.setBackgroundColor(colors[blocks[map[i][c]].bcolor])\
            write(blocks[map[i][c]].graphic)    \
        end\
        write(\"\\n\")\
    end    \
end\
 \
function isPlayer()\
    local is = false\
    for i = 1, #map do\
        for c = 1, #map[i] do\
            if(map[i][c] == tonumber(4))then\
                 is=true\
            end\
        end\
    end\
        return is\
end\
 \
function getPlayerX()\
    local fx = 1\
    for i = 1, #map do\
        for c = 1, #map[i] do\
            if(map[i][c] == tonumber(4))then\
                fx=i\
            end\
        end\
    end\
            return fx\
end\
 \
function getPlayerY()\
    local fy = 1\
    for i = 1, #map do\
        for c = 1, #map[i] do\
            if(map[i][c] == tonumber(4))then\
                fy=c\
            end\
        end\
    end\
            return fy\
end\
 \
function drawMapBlock(x,y)\
  if(blocks[map[x][y]] == nil)then map[x][y] = 0 end\
    term.setCursorPos(tonumber(y),tonumber(x))\
     term.setTextColor(colors[blocks[map[x][y]].color])\
     term.setBackgroundColor(colors[blocks[map[x][y]].bcolor])\
    print(blocks[map[x][y]].graphic)    \
end\
 \
function placeBlock(id,x,y)\
    for i = 1, #blocks do\
 \
        if(i == id)then\
            map[x][y] = id  \
        end\
    end\
end\
 \
function breakBlock(x,y)\
            map[x][y] = 0\
end\
 \
buildMap(w,h-1)\
drawMap()\
 \
 \
 \
 \
function update()\
    drawMenu()\
   \
    a = {os.pullEvent()}\
    term.setCursorPos(1,1)\
    --if(a[1]==\"timer\" and not sPlay)then gTimer=os.startTimer(fps) end\
 \
    if( (a[1] == \"mouse_click\" and a[4] < h) or (a[1] == \"mouse_drag\" and a[4] < h) and not inSave)then\
        if(a[2] == 1)then\
            placeBlock(selBlock,a[4],a[3])  \
            drawMapBlock(a[4],a[3])  \
        elseif(a[2] == 2)then\
                    breakBlock(a[4],a[3])  \
                    drawMapBlock(a[4],a[3])  \
        end\
     elseif(a[1] == \"mouse_scroll\" and not inSave )then  \
        if(a[2] == 1 and selBlock < #blocks)then\
            selBlock = selBlock + 1\
        elseif(a[2] == -1 and selBlock > bOff) then\
            selBlock = selBlock - 1\
        end\
    elseif(a[1] == \"key\")then\
                if(a[2] == keys.enter and inSave)then sMenu[sMenuIndex].run() end\
              if(a[2] == 29)then inSave = not inSave end\
                if(a[2] == keys.left and sMenuIndex > 1  and inSave)then\
                     sMenuIndex = sMenuIndex - 1\
               elseif(a[2] == keys.right and sMenuIndex < #sMenu  and inSave)then\
                     sMenuIndex = sMenuIndex + 1    \
                end\
    end\
end\
 \
while inGame do\
    update()    \
end",
  },
  [ "/apis/Redgame" ] = {
    content = "--]] RedGame API By: Redxone[[--\
\
function init()\
\009w,h = term.getSize()\
\009pmap = {}\
\009 for i = 1, h do\
        pmap[i] = {}\
       for c = 1, w do\
            pmap[i][c] = 0\
       end    \
    end\
\
    gmap = {}\
\009emp={}\
\009gplayer={}\
\009gblocks={}\
\009doors={}\
\009maps={}\
\009mapName = \"\"\
\
end\
\
function getGMAP()\
\009return gmap\
end\
\
function getPMAP()\
\009return pmap\
end\
\
function getGBLOCKS()\
\009return gblocks\
end\
\
function setPMAP(x,y,id)\
\009pmap[y][x] = id\
end\
\
function setGMAP(x,y,id)\
\009gmap[y][x] = id\
end\
\
function openTextbox()\
\009paintutils.drawBox(1,h-5,w,h,colors.gray)\
\009paintutils.drawFilledBox(2,h-4,w-1,h-1,colors.blue)\
end\
\
clearTextbox = openTextbox\
\
function drawTextbox(text,ln,speed)\
\009term.setCursorPos(6,h- ( 4 - ( ln-1 ) ) )\
\009term.setTextColor(colors.white)\
\009textutils.slowPrint(text,speed)\
end\
\
function createYesNo(YText,NText,ln)\
\009local sel = 1\
\009local waiting = true\
\009local opt = {\
\009\009{name=YText};\
\009\009{name=NText};\
\009}\
\
\009function waitResult()\
\009\009while waiting do\
\009\009\009for i = 1, #opt do\
\009\009\009\009term.setCursorPos((w/2) - #opt[i].name/2,h- ( 4 - ( (ln+i)-1 ) ) )\
\009\009\009\009if(sel == i )then\
\009\009\009\009\009write(\"[\"..opt[i].name..\"]\")\
\009\009\009\009else\
\009\009\009\009\009write(\" \"..opt[i].name..\" \")\
\009\009\009\009end\
\009\009\009end\
\
\009\009\009a = {os.pullEvent(\"key\")}\
\
\009\009\009if(a[2] == keys.w and sel > 1)then\
\009\009\009\009sel = sel - 1\
\009\009\009end\
\009\009\009if(a[2] == keys.s and sel < #opt)then\
\009\009\009\009sel = sel + 1\
\009\009\009end\
\009\009\009if(a[2] == keys.space)then\
\009\009\009\009if(sel == 1)then waiting = false  return \"ok\" end\
\009\009\009\009if(sel == 2)then  waiting = false return \"no\" end\
\009\009\009end\
\009\009end\
\009end\
\009return waitResult()\
end\
\
\
function addDoor(fromx,fromy,tox,toy,fromMap,toMap)\
\009doors[#doors+1] = {fx=fromx,fy=fromy,tx=tox,ty=toy,fMap=fromMap,tMap=toMap}\
end\
\
function draw()\
\
\009for i = 1, #gmap do\
\009\009for c = 1, #gmap[i] do\
\009\009\009term.setCursorPos(c,i)\
\009\009\009term.setTextColor(colors[ gblocks[ gmap[i][c] ].color ])\
\009\009\009term.setBackgroundColor(colors[ gblocks[ gmap[i][c] ].bcolor ])\
\009\009\009write(gblocks[ gmap[i][c] ].graphic)\
\009\009end\
\009end\
\
\009for i = 1, #pmap do\
\009\009for c = 1, #pmap[i] do\
\009\009\009if(pmap[i][c] ~= 0)then\
\009\009\009\009term.setCursorPos(c,i)\
\009\009\009\009term.setTextColor(colors[ gblocks[ pmap[i][c] ].color ])\
\009\009\009\009term.setBackgroundColor(colors[ gblocks[ pmap[i][c] ].bcolor ])\
\009\009\009\009write(gblocks[ pmap[i][c] ].graphic)\
\009\009\009end\
\009\009end\
\009end\
\
end\
\
\
function closeTextbox()\
\009os.pullEvent(\"key\")\
\009draw()\
\009term.setCursorPos(1,h)\
\009term.setBackgroundColor(colors[gblocks[0].bcolor])\
\009term.clearLine()\
end\
\
function closeTextboxRaw()\
\009draw()\
\009term.setCursorPos(1,h)\
\009term.setBackgroundColor(colors[gblocks[0].bcolor])\
\009term.clearLine()\
end\
\
\
function drawMapPixel(x,y)\
\009term.setCursorPos(y,x)\
\009term.setTextColor(colors[ gblocks[ gmap[x][y] ].color ])\
\009term.setBackgroundColor(colors[ gblocks[ gmap[x][y] ].bcolor ])\
\009write(gblocks[ gmap[x][y] ].graphic)\
\009if(pmap[x][y] ~= 0)then\
\009\009term.setCursorPos(y,x)\
\009\009term.setTextColor(colors[ gblocks[ pmap[x][y] ].color ])\
\009\009term.setBackgroundColor(colors[ gblocks[ pmap[x][y] ].bcolor ])\
\009\009write(gblocks[ pmap[x][y] ].graphic)\
\009end\
end\
\
function lookupBlock(id)\
\009for i = 1, #gmap do\
\009\009for c = 1, #gmap[i] do\
\009\009\009if(gmap[i][c] == id)then return true end\
\009\009end\
\009end\
\009return false\
end\
\
function findBlockAt(id)\
\009inf = {}\
\009for i = 1, #gmap do\
\009\009for c = 1, #gmap[i] do\
\009\009\009if(gmap[i][c] == tonumber(id))then \
\009\009\009\009 return i,c \
\009\009\009end\
\009\009end\
\009end\
\009return nil\
end\
\
function getBlockAt(x,y)\
\009return gmap[y][x]\
end\
\
function setBlockAt(id,x,y)\
\009gmap[y][x] = id\
\009drawMapPixel(y,x)\
end\
\
function breakBlockAt(x,y)\
\009gmap[y][x] = 0\
\009drawMapPixel(y,x)\
end\
\
function editBlock(id,color,bcolor,graphic,solid)\
\009gblocks[id].color = color\
\009gblocks[id].bcolor = bcolor\
\009gblocks[id].graphic = graphic\
\009gblocks[id].solid = solid\
\009draw()\
end\
function getCurrentMap()\
\009return mapName\
end\
\
\
function addMap(name,levmap,blocks)\
\009if(maps[name] ~= nil)then error(\"[Redgame] - > AddMap - > Map already added!\") end\
\009maps[name] = {level=levmap,blockmap=blocks}\
end\
\
function setSolid(id,solid)\
\009gblocks[id].solid = solid\
end\
\
function getResource(file)\
\009f = fs.open(file,\"r\")\
\009res = textutils.unserialize(f.readAll())\
\009f.close()\
\009if(type(res) ~= \"table\")then error(\"[RedGame]: getResource -> file [\"..file..\"] must contain only a table!\") end\
\009return res\
end\
\
function setMap(map)\
\009if(maps[map] == nil)then\
\009\009error(\"[RedGame] -> setMap -> No such map.\")\
\009end\
\009gmap=maps[map].level\
\009mapName = map\
\009gblocks = maps[map].blockmap\
\009draw()\
end\
\
function getMap()\
\009return gmap\
end\
\
\
\
\
function createPlayer(block,startX,startY)\
\
\009local player = {\
\
\009\009x=startX,\
\009\009y=startY,\
\009\009tickrate=tonumber(0.1),\
\009\009physicsTick = os.startTimer(0.1),\
\009\009jump_height=2,\
\009\009hspd = 0,\
\009\009vspd = 0,\
\009\009blockid = block,\
\009\009multidir = false,\
\009\009physic_control= {\
\009\009\009[\"direction_up\"] = keys.w,\
\009\009\009[\"direction_down\"] = keys.s,\
\009\009\009[\"direction_left\"] = keys.a,\
\009\009\009[\"direction_right\"] = keys.d,\
\009\009},\
\009\009lastMove = \"player_up\",\
\009\009events = {},\
\009\009interactions ={},\
\
\009\009addInteraction = function(self,mydmap,x,y,func)\
\009\009\009self.interactions[#self.interactions+1] = {onmap=mydmap,x=x,y=y,active=true,event=func}\
\009\009end,\
\
\009\009removeInteraction = function(self,mydmap,x,y)\
\009\009\009for i = 1, #self.interactions do\
\009\009\009\009if(self.interactions[i].x == x and self.interactions[i].y == y and self.interactions[i].onmap == mydmap)then\
\009\009\009\009\009self.interactions[i].active=false;\
\009\009\009\009end\
\009\009\009end \
\009\009end,\
\
\009\009setPhysicsTick = function(self,time)\
\009\009\009self.tickrate = tonumber(time)\
\009\009\009self.physicsTick = os.startTimer(time)\
\009\009end,\
\
\009\009addEvent = function(self,check,evfunc)\
\009\009\009table.insert(self.events,{type=check,run=evfunc})\
\009\009end,\
\
\009\009getBlockUnder = function(self)\
\009\009\009\009if(gmap[self.y][self.x] ~= 0)then\
\009\009\009\009\009return gmap[self.y][self.x]\
\009\009\009\009end\
\009\009\009\009return 0\
\009\009end,\
\
\
\009\009checkCollision = function(self,x,y)\
\009\009\009hasColl = false\
\009\009\009if( gblocks[gmap[y][x]].solid or pmap[y][x] ~= 0)then hasColl = true end\
\009\009\009if( gmap[y][x] == 0 and pmap[y][x] == 0)then hasColl = false end\
\009\009\009return hasColl\
\009\009end,\
\
\009\009jump = function(self,ammount)\
\009\009\009if(self:checkCollision(self.x,self.y+1))then\
\009\009\009\009for i = 1, ammount do\
\009\009\009\009\009if(not self:checkCollision(self.x,self.y-1))then\
\009\009\009\009\009\009pmap[self.y][self.x] = 0\
\009\009\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009\009\009\009self.y = self.y - 1\
\009\009\009\009\009\009pmap[self.y][self.x] = self.blockid\
\009\009\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009\009\009end\
\009\009\009\009end\
\009\009\009end\
\009\009end,\
\
\009\009moveUp=function(self,ammount)\
\009\009\009if(not self:checkCollision(self.x,self.y-1) and not self:checkPhysics(\"gravity\"))then\
\009\009\009\009pmap[self.y][self.x] = 0\
\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009\009self.y = self.y - ammount\
\009\009\009\009pmap[self.y][self.x] = self.blockid\
\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009end\
\
\009\009\009if(not self:checkCollision(self.x,self.y-1) and self:checkPhysics(\"gravity\"))then\
\009\009\009\009self:jump(self.jump_height)\
\009\009\009end\
\009\009end,\
\
\009\009moveDown=function(self,ammount)\
\009\009\009if(not self:checkCollision(self.x,self.y+1))then\
\009\009\009\009pmap[self.y][self.x] = 0\
\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009\009self.y = self.y + ammount\
\009\009\009\009pmap[self.y][self.x] = self.blockid\
\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009end\009\
\009\009\
\009\009end,\
\
\009\009moveLeft=function(self,ammount)\
\009\009\009--pmap[self.y][self.x-1] == 0\
\009\009\009if(not self:checkCollision(self.x-1,self.y))then\
\009\009\009\009pmap[self.y][self.x] = 0\
\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009\009self.x = self.x - ammount\
\009\009\009\009pmap[self.y][self.x] = self.blockid\
\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009end\009\009\
\
\
\009\009end,\
\
\009\009moveRight=function(self,ammount)\
\009\009\009if(not self:checkCollision(self.x+1,self.y))then\
\009\009\009\009pmap[self.y][self.x] = 0\
\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009\009self.x = self.x + ammount\
\009\009\009\009pmap[self.y][self.x] = self.blockid\
\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009end\009\009\
\009\009end,\
\
\
\009\009physics = {\
\
\009\009\009[\"gravity\"] = {has=false,func=function(self) \
\009\009\009\009if(not self:checkCollision(self.x,self.y+1))then\
\009\009\009\009\009\009self:moveDown(1)\
\009\009\009\009\009\009sleep(0.01)\
\009\009\009\009end\
\009\009\009end};\
\
\009\009\009[\"smooth_experimental\"] = {has=false,func=function(self) \
\009\009\009\009\009self.multidir = true\
\009\009\009\009\009self.physics[\"smooth_experimental\"].has = false\
\009\009\009end};\
\
\009\009},\
\
\
\009\009checkPhysics = function(self,element)\
\009\009\009for k, v in pairs(self.physics) do\
\009\009\009\009if(k == element and v.has)then\
\009\009\009\009\009return true\
\009\009\009\009end\
\009\009\009end\
\
\009\009\009return false\
\009\009end,\
\
\009\009checkInteract = function(self)\
\009\009\009for i = 1, #self.interactions do\
\009\009\009\009if(    ((self.y == self.interactions[i].y-1) \
\009\009\009\009\009and (self.x == self.interactions[i].x)) \
\009\009\009\009\009or ((self.y == self.interactions[i].y+1)\
\009\009\009\009    and (self.x == self.interactions[i].x))\
\009\009\009\009\009or ((self.y == self.interactions[i].y)\
\009\009\009\009    and (self.x == self.interactions[i].x+1))\
\009\009\009\009\009or ((self.y == self.interactions[i].y)\
\009\009\009\009    and (self.x == self.interactions[i].x-1))\
\009\009\009\009    )then\
\009\009\009\009\009if(self.interactions[i].onmap == getCurrentMap() and self.interactions[i].active)then\
\009\009\009\009\009\009self.interactions[i].event()\
\009\009\009\009\009end\
\009\009\009\009end\
\009\009\009end\
\009\009end,\
\
\009\009controls = {\
\009\009\009{name = \"player_interact\",event=\"key\",key=keys.space,func=function(self) self:checkInteract() end};\
\009\009\009{name=\"player_up\",event=\"key\",key=keys.w,func=function(self) self.lastMove = \"player_up\" self:moveUp(1)  end};\
\009\009\009{name=\"player_down\",event=\"key\",key=keys.s,func=function(self) self.lastMove = \"player_down\" self:moveDown(1) end};\
\009\009\009{name=\"player_left\",event=\"key\",key=keys.a,func=function(self) self.lastMove = \"player_left\" self:moveLeft(1) end};\
\009\009\009{name=\"player_right\",event=\"key\",key=keys.d,func=function(self)self.lastMove = \"player_right\" self:moveRight(1) end};\
\009\009},\
\
\009\009--]] movement functions\
\
\009\009put = function(self)\
\009\009\009pmap[self.y][self.x] = self.blockid \
\009\009end,\
\
\009\009unput = function(self)\
\009\009\009pmap[self.y][self.x] = 0; \
\009\009\009drawMapPixel(self.y,self.x)\
\009\009end,\
\
\009\009applyPhysics = function(self,element)\
\009\009\009if(self.physics[element] ~= nil)then\
\009\009\009\009if(self.physics[element].has == false)then\
\009\009\009\009\009self.physics[element].has = true\
\009\009\009\009end\
\009\009\009else\
\009\009\009\009error(\"[RedGame]: player -> addPhysicsElement -> no such element!\")\
\009\009\009end\
\009\009end,\
\
\009\009setJumpHeight = function(self,h)\
\009\009\009self.jump_height = h\
\009\009end,\
\
\009\009createPhysics = function(self,element,physic)\
\009\009\009\009if(self.physics[element] ~= nil)then error(\"[RedGame]: player - > createPhysicsElement -> element already exists!\") end\
\009\009\009\009if(type(physic) ~= \"table\")then error(\"[RedGame]: player -> createPhysicsElement -> must be in table format eg {func=function(self) physics stuff end};\") end\
\009\009\009\009 metaindex = {has=false,func=function(self) end};\
\009\009\009\009physic = setmetatable(physic, {__index = metaindex})\
\009\009\009\009self.physics[element] = physic\
\009\009end,\
\
\009\009remapPhysicsControl = function(self,name,to)\
\009\009\009\009if(self.physic_control[name])then\
\009\009\009\009\009self.physic_control[name] = to\
\009\009\009\009else\
\009\009\009\009\009error(\"[RedGame]: player -> remapPhysicsControl invalid control!\")\
\009\009\009\009end\
\009\009end,\
\
\009\009remapControl = function(self,name,to)\
\009\009\009for i = 1, #self.controls do\
\009\009\009\009if(self.controls[i].name == name)then\
\009\009\009\009\009self.controls[i].key = to\
\009\009\009\009end\
\009\009\009end\
\009\009end,\
\
\009\009addControl=function(self,controltable)\
\009\009\009if(type(controltable) ~= \"table\")then\
\009\009\009\009error(\"[RedGame]:addControl -> control must be a table in this format: {name=<control name>,event=<event>,key=<key in string format>,func=function() <actions> end}\")\
\009\009\009else\
\009\009\009\009table.insert(self.controls,controltable)\
\009\009\009end\
\009\009end,\
\
\009\009importControls=function(self,controltable)\
\009\009\009if(type(controltable) ~= \"table\")then\
\009\009\009\009error(\"[RedGame]:importControls -> control must be a table in this format: controls = { {name=<control name>,event=<event>,key=<key in string format>,func=function() <actions> end}, ect... }\")\
\009\009\009else\
\009\009\009\009self.controls = controltable\
\009\009\009end\
\009\009end,\
\
\
\009\009setPos = function(self,x,y)\
\009\009\009pmap[self.y][self.x] = 0\
\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009self.x = x\
\009\009\009self.y = y\
\009\009\009self:checkCollision(self.x,self.y)\
\009\009\009pmap[self.y][self.x] = self.blockid\
\009\009\009drawMapPixel(self.y,self.x)\
\009\009end,\
\
\009\009update=function(self)\
\
\009\009\009for i = 1, #doors do\
\009\009\009\009if(getCurrentMap() == doors[i].fMap and self.x == doors[i].fx and self.y == doors[i].fy)then\
\009\009\009\009\009setMap(doors[i].tMap)\
\009\009\009\009\009self:setPos(doors[i].tx,doors[i].ty)\
\009\009\009\009end\
\009\009\009end\
\
\009\009\009if(self.multidir)then\
\009\009\009\009pmap[self.y][self.x] = 0\
\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009\009if(not self:checkCollision(self.x+self.hspd,self.y))then\
\009\009\009\009\009self.x = self.x + self.hspd\
\009\009\009\009end\
\009\009\009\009if(not self:checkCollision(self.x,self.y+self.vspd))then\
\009\009\009\009\009self.y = self.y + self.vspd\
\009\009\009\009end\
\009\009\009\009pmap[self.y][self.x] = self.blockid\
\009\009\009\009drawMapPixel(self.y,self.x)\
\009\009\009end\
\
\009\009\009a = {os.pullEvent()}\
\
\009\009\009for k, v in pairs(self.events) do\
\009\009\009\009if(v.type == a[1])then\
\009\009\009\009\009v.run(a)\
\009\009\009\009end\
\009\009\009end\
\
\009\009\009if(a[1]==\"timer\")then\
\009\009\009\009self.physicsTick=os.startTimer(self.tickrate)\
\009\009\009\009for k, v in pairs(self.physics) do\
\009\009\009\009\009if(v.has)then v.func(self) end\
\009\009\009\009end\
\009\009\009end\
\
\009\009\009if(not self.multidir)then\
\009\009\009\009for i = 1, #self.controls do\
\009\009\009\009\009if(a[1] == self.controls[i].event and a[2] == self.controls[i].key)then\
\009\009\009\009\009\009self.controls[i].func(self)\
\009\009\009\009\009end\
\009\009\009\009end \
\009\009\009end\
\
\009\009\009if(self.multidir)then\
\009\009\009\009\009\009if(a[2] ~= self.physic_control[\"direction_up\"] and a[2] ~= self.physic_control[\"direction_down\"])then\
\009\009\009\009\009\009\009self.vspd = 0\
\009\009\009\009\009\009end\
\009\009\009\009\009\009if(a[2] ~= self.physic_control[\"direction_left\"] and a[2] ~= self.physic_control[\"direction_right\"])then\
\009\009\009\009\009\009\009self.hspd = 0\
\009\009\009\009\009\009end\
\009\009\009\009\009\009if(a[2] == self.physic_control[\"direction_up\"])then\
\009\009\009\009\009\009\009if(self:checkPhysics(\"gravity\"))then\
\009\009\009\009\009\009\009\009if(self:checkCollision(self.x,self.y+1))then\
\009\009\009\009\009\009\009\009\009self.vspd = -self.jump_height\
\009\009\009\009\009\009\009\009end\
\009\009\009\009\009\009\009else\
\009\009\009\009\009\009\009\009self.vspd = -self.jump_height\
\009\009\009\009\009\009\009end\
\009\009\009\009\009\009end\
\009\009\009\009\009\009if(a[2] == self.physic_control[\"direction_down\"])then\
\009\009\009\009\009\009\009self.vspd = 1\
\009\009\009\009\009\009end\
\009\009\009\009\009\009if(a[2] == self.physic_control[\"direction_left\"])then\
\009\009\009\009\009\009\009self.hspd = -1\
\009\009\009\009\009\009end\
\009\009\009\009\009\009if(a[2] == self.physic_control[\"direction_right\"])then\
\009\009\009\009\009\009\009self.hspd = 1\
\009\009\009\009\009\009end\
\009\009\009end\
\009\009end,\
\
\009}\
\
\009return player\
end",
  },
  [ "/apis/ugapi" ] = {
    content = "--]] Language assigning [[--\
 \
pos = term.setCursorPos\
bcolor = term.setBackgroundColor\
tcolor = term.setTextColor\
blink = term.setCursorBlink\
buffer = term.current().setVisible\
getpos = term.getCursorPos\
getbcolor = term.getBackgroundColor\
gettcolor = term.getTextColor\
printslow = textutils.slowPrint\
clr = term.clear\
clrln = term.clearLine\
clrlny = function(y)\
  local x,_ = getpos()\
  pos(x,y)\
  clrln()\
end\
clrlnycolor = function(col,y) bcolor(col) clrlny(y) end\
box = paintutils.drawFilledBox\
hbox = paintutils.drawBox\
drawimage = function(img,x,y) paintutils.drawImage(paintutils.loadImage(img),x,y) end\
 \
 \
-- ]] Write functions [[--\
function writexy(text,x,y)\
  term.setCursorPos(x,y)\
  term.write(text)\
end\
 \
function writec(text)\
  local w, h = term.getSize()\
  term.setCursorPos(w/2 - #text/2, (h/2)- 1)\
  term.write(text)\
end\
 \
function writecy(text,y)\
    local w,_ = term.getSize()\
    term.setCursorPos(w/2 - #text/2, y)\
    term.write(text)\
end\
 \
 \
 \
-- ]] Print functions [[--\
function printc(text)\
  local w,h = term.getSize()\
  term.setCursorPos( (w/2) - #text/2,(h/2) - 1)\
  print(text)\
end\
 \
function printcy(text,y)\
  local w,_ = term.getSize()\
  term.setCursorPos(w/2 - #text/2, y)\
  print(text)\
end\
 \
function println(text)\
   local xx, yy = term.getCursorPos()\
   term.setCursorPos(xx,yy+1)\
   print(text)\
end\
 \
function printxy(text,x,y)\
  term.setCursorPos(x,y)\
  print(text)\
end\
 \
--]] Transitions [[--\
function fadeIn(time)\
   \
   local ctbl = {\
     'black',\
     'gray',\
     'lightGray',\
     'white',\
   }\
 \
   for i = 1, #ctbl do\
      term.setBackgroundColor(colors[ ctbl[i] ])\
      term.clear()\
      sleep(time)  \
   end\
end\
 \
function fadeOut(time)\
   \
   local ctbl = {\
     'white',\
     'lightGray',\
     'gray',\
     'black',\
   }\
   \
   for i = 1, #ctbl do\
      term.setBackgroundColor(colors[ ctbl[i] ])\
      term.clear()\
      sleep(time)  \
   end\
end\
 \
 \
function fadecolors(time,ctbl)\
  for i = 1, #ctbl do\
    term.setBackgroundColor(colors[ctbl[i]])\
    term.clear()\
    sleep(time)\
  end\
end\
\
function transitionIn(pixeltime, linetime,smoothness)\
\009local w, h = term.getSize()\
\009local left = true\
\009for hh = 1, h/2+1 do\
\009\009for ww = 1, w do\
\009\009\009bcolor(colors.white)\
\009\009\009if(left)then writexy(string.rep(\" \",smoothness),w-(ww-1),hh) else writexy(\" \",ww,hh) end\
\009\009\009bcolor(colors.white)\
\009\009\009if(left)then writexy(string.rep(\" \",smoothness),ww,h-(hh-1) ) else writexy(\" \",w-(ww-1),h-(hh-1)) end\
\009\009\009if(pixeltime > 0) then sleep(pixeltime) end\
\009\009end\
\009\009if(left)then left = false else left = true end\
\009\009if(linetime > 0)then sleep(linetime) end\
\009end\
\
end\
\
function transitionOut(pixeltime, linetime,smoothness)\
\009local w, h = term.getSize()\
\009local left = true\
\009for hh = 1, h/2+1 do\
\009\009for ww = 1, w do\
\009\009\009bcolor(colors.black)\
\009\009\009if(left)then writexy(string.rep(\" \",smoothness),w-(ww-1),hh) else writexy(\" \",ww,hh) end\
\009\009\009bcolor(colors.black)\
\009\009\009if(left)then writexy(string.rep(\" \",smoothness),ww,h-(hh-1) ) else writexy(\" \",w-(ww-1),h-(hh-1)) end\
\009\009\009if(pixeltime > 0) then sleep(pixeltime) end\
\009\009end\
\009\009if(left)then left = false else left = true end\
\009\009if(linetime > 0)then sleep(linetime) end\
\009end\
\
end\
\
--]] Button API [[ -- \
\
function newButton(name,x,y,width,height,namecolor,color,activecolor)\
\009local button = {\
\009\009name = name,\
\009\009x = x,\
\009\009y = y,\
\009\009w = width-1,\
\009\009h = height-1,\
\009\009tcol = namecolor,\
\009\009col = color,\
\009\009acol = activecolor,\
\009\009active = false,\
\009\009rfun = function() end,\
\009\009fun = function() end,\
\
\009\009draw = function(self)\
\009\009\009local dbcol\
\009\009\009if(self.active)then dbcol = self.acol \
\009\009\009else dbcol = self.col end\
\009\009\009box(self.x,self.y,self.x+self.w,self.y+self.h,dbcol)\
\009\009\009-- Center text on button --\
\009\009\009tcolor(self.tcol)\
\009\009\009writexy(self.name,\
\009\009\009\009( (self.x+self.w/2) - (#self.name/2) ),\
\009\009\009\009( (self.y+self.h) - (self.h/2) )\
\009\009\009)\
\009\009end,\
\
\009\009update = function(self,ev)\
\009\009\009if(ev[1] == \"mouse_click\")then\
\009\009\009\009-- Display active for a bit then switch off\
\009\009\009\009if(ev[3] >= self.x and ev[3] <= self.x + self.w and ev[4] >= self.y and ev[4] <= self.y + self.h)then\
\009\009\009\009\009self:setActive(true)\
\009\009\009\009\009sleep(0.2)\
\009\009\009\009\009self:setActive(false)\
\
\009\009\009\009\009if(ev[2] == 1)then self.fun() end\
\009\009\009\009\009if(ev[2] == 2)then self.rfun() end\
\
\009\009\009\009end\
\009\009\009end\
\009\009end,\
\
\009\009onPress = function(self,func)\
\009\009\009self.fun = func\
\009\009end,\
\
\009\009setName = function(self,nname)\
\009\009\009self.name = nname\
\009\009end,\
\
\009\009getName = function(self,nname)\
\009\009\009return self.name\
\009\009end,\
\
\009\009setPos = function(self,x,y)\
\009\009\009self.x = x\
\009\009\009self.y = y\
\009\009\009self:draw()\
\009\009end,\
\
\009\009getPos = function(self)\
\009\009\009return self.x, self.y\
\009\009end,\
\
\009\009onRightPress = function(self,func)\
\009\009\009self.rfun = func\
\009\009end,\
\
\009\009setActive = function(self,act)\
\009\009\009self.active = act\
\009\009\009self:draw()\
\009\009end,\
\
\009\009getActive = function(self)\
\009\009\009return self.active\
\009\009end,\
\
\009}\
\
\009return button\
end\
\
-- Menu API --\
function newMenu(x,y,width,height,bcolor)\
\
\009local menu = {\
\009\009x = x,\
\009\009y = y,\
\009\009w = width,\
\009\009h = height,\
\009\009bcol = bcolor,\
\009\009options={},\
\009\009presets={},\
\
\009\009draw = function(self)\
\009\009\009box(self.x,self.y,self.x+self.w-1,self.y+self.h-1,self.bcol)\
\009\009\009for i = 1, #self.options do\
\009\009\009\009if(self.options[i].name ~= nil)then\
\009\009\009\009\009local bcol = self.presets[self.options[i].pset].bc\
\009\009\009\009\009local tcol = self.presets[self.options[i].pset].tc\
\
\009\009\009\009\009if(self.options[i].active)then\
\009\009\009\009\009\009bcol = self.presets[self.options[i].pset].ab\
\009\009\009\009\009\009tcol = self.presets[self.options[i].pset].at\
\009\009\009\009\009end\
\
\009\009\009\009\009term.setBackgroundColor(bcol)\
\009\009\009\009\009term.setTextColor(tcol)\
\
\009\009\009\009\009pos( self.x, self.y+(i-1) )\
\
\009\009\009\009\009write(self.options[i].name)\
\009\009\009\009end\
\009\009\009end\
\009\009end,\
\
\009\009update = function(self, ev)\
\009\009\009if(ev[1] == \"mouse_click\")then\
\
\009\009\009\009for i = 1, #self.options do\
\009\009\009\009\009if(self.options[i].name ~= nil)then\
\009\009\009\009\009\009if(ev[3] >= self.x and ev[3] <= #self.options[i].name + self.x\
\009\009\009\009\009\009  and ev[4] == self.y + (i-1))then\
\009\009\009\009\009\009\009self:setActiveOption(self.options[i].name,true)\
\009\009\009\009\009\009\009sleep(0.2)\
\009\009\009\009\009\009\009self:setActiveOption(self.options[i].name,false)\
\
\009\009\009\009\009\009\009self.options[i].act()\
\009\009\009\009\009\009end\
\009\009\009\009\009end\
\009\009\009\009end\
\
\009\009\009end\
\009\009end,\
\
\009\009addOption = function(self,name,preset,action)\
\009\009\009if(self.presets[preset].tc ~= nil)then\
\009\009\009\009self.options[#self.options+1] = {name=name,pset=preset,act=action,active=false}\
\009\009\009else\
\009\009\009\009error(\"UGAPI: ->menu->addOption: No such preset.\")\
\009\009\009end\
\009\009end,\
\
\009\009setPreset = function(self,name,tcolor,bcolor,atcolor,abcolor,action)\
\009\009\009self.presets[name] = {tc=tcolor,bc=bcolor,at=atcolor,ab=abcolor}\
\009\009end,\
\
\009\009addWhiteSpace = function(self)\
\009\009\009self.options[#self.options+1] = {name=nil}\
\009\009end,\
\
\009\009setActiveOption = function(self,nname,isact)\
\009\009\009for i = 1, #self.options do\
\009\009\009\009if(self.options[i].name == nname and nname ~= nil)then\
\009\009\009\009\009self.options[i].active = isact\
\009\009\009\009end\
\009\009\009end\
\
\009\009\009self:draw()\
\009\009end,\
\
\009}\
\
\009return menu \
end",
  },
  [ "/games/GameOfLife" ] = {
    content = "--]] Game of life, by Redxone(Lewisk3), Special thanks to: MultMine [[--\
-- Rules:\
-- if less than 2, die\
-- if more then 3, die\
-- if has 2 or 3, live\
-- if more then 3, die\
-- if has exactly 3 and is dead, live\
os.loadAPI(\"CrossBow/apis/grid\")\
------------------------------------\
term.setBackgroundColor(colors.black)\
term.clear()\
term.setCursorPos(1,1)\
term.setBackgroundColor(colors.gray)\
term.setTextColor(colors.white)\
term.clearLine()\
local w, h = term.getSize()\
-- check for updates -- \
term.setBackgroundColor(colors.gray)\
term.setTextColor(colors.white)\
term.clear()\
term.setCursorPos((w/2) - 11, 4)\
write(\"Checking for updates...\")\
if(http)then\
\009\009term.setCursorPos((w/2) - 1, (h/2) - 1)\
\009\009for i = 1, 5 do\
\009\009\009term.setCursorPos((w/2) - 1, (h/2) - 1)\
\009\009\009write(\":\")\
\009\009\009sleep(0.2)\
\009\009\009term.setCursorPos((w/2) - 1, (h/2) - 1)\
\009\009\009write(\"/\")\
\009\009\009sleep(0.2)\
\009\009\009term.setCursorPos((w/2) - 1, (h/2) - 1)\
\009\009\009write(\"-\")\
\009\009\009sleep(0.2)\
\009\009\009term.setCursorPos((w/2) - 1, (h/2) - 1)\
\009\009\009write(\"\\\\\")\009\
\009\009end\
\009local gameupdate = http.get(\"http://pastebin.com/raw/R3HfhA4x\")\
\009sleep(0.2)\
\009if(gameupdate == nil)then\
        gameupdate = gameupdate.readAll()\
\009\009f = fs.open(shell.getRunningProgram() ,\"r\")\
\009\009_contents = f.readAll()\
\009\009f.close()\
\009\009if(_contents ~= gameupdate)then\
\009\009\009term.setCursorPos((w/2) - 11, 4)\
\009\009\009write(\"Update found, updating...\")\
\009\009\009f = fs.open(shell.resolve(shell.getRunningProgram()),\"w\")\
\009\009\009f.write(gameupdate)\
\009\009\009f.close()\
\009\009\009sleep(0.5)\
\009\009\009term.setCursorPos((w/2) - 11, 4)\
\009\009\009term.clearLine()\
\009\009\009write(\" Restarting game...\")\
\009\009\009sleep(0.5)\
\009\009\009return shell.run(shell.getRunningProgram())\
\009\009end\
\009else\
\009\009term.setCursorPos((w/2) - 11, 4)\
\009\009write(\"Updating disable for CrossBow. launching game...\")\
\009\009sleep(0.2)\
\009end\
end\
term.clear()\
term.setCursorPos((w/2) - 12, (h/2) - 1)\
print(\"Creating cell universe...\")\
local verse = grid.create(82,50)\
local ngen = grid.create(82,50)\
sleep(0.2)\
local isPaused = false\
local running = true\
local generation = 0\
local speed = 0.01\
local xoff, yoff = 0, 0\
local genTimer = os.startTimer(speed)\
function newCell(alive)\
    local cell = {isAlive=true}\
    if(not alive)then cell.isAlive = false end\
    return cell\
end\
--- Fill universe with dead cells ---\
--verse:fill(newCell(false))\
--ngen:fill(newCell(false))\
--------------------------------------\
function drawCell(x,y)\
    if(x <= w and y <= 50 and y >= 2)then\
        term.setCursorPos(x,y)\
        if(verse:get(x+xoff,y+yoff).isAlive==true)then\
            if(isPaused)then term.setBackgroundColor(colors.yellow) else term.setBackgroundColor(colors.green) end\
            term.setTextColor(colors.black)\
            write(' ')\
        else\
             if(isPaused)then term.setBackgroundColor(colors.gray) else term.setBackgroundColor(colors.black) end\
             term.setTextColor(colors.lightGray)\
             if(isPaused)then write('L') else write (' ') end\
        end\
    end\
end\
function updateview()\
    for x = 1, verse:getHeight() do\
        for y = 1, verse:getWidth() do\
            drawCell(y,x)\
        end\
    end\
end\
function life()\
    for x = 1, verse:getHeight() do\
        for y = 1, verse:getWidth() do\
            local friends = 0\
            drawCell(y,x)\
\009\009    for _y = -1, 1 do\
\009\009     for _x = -1, 1 do\
\009\009      if _y ~= 0 or _x ~= 0 then\
\009\009       if(verse:get(y+_y,x+_x).isAlive == true) then friends = friends + 1 end\
\009\009      end\
\009\009     end\
\009\009    end\
             -- Die conditions\
            if(verse:get(y,x).isAlive and friends < 2)then\
                ngen:set(y,x,newCell(false))\
            elseif(friends > 3 and verse:get(y,x).isAlive)then\
                ngen:set(y,x,newCell(false))\
            end\
                -- Live conditions\
            if(verse:get(y,x).isAlive and (friends == 2 or friends == 3))then\
                ngen:set(y,x,newCell(true))\
            end\
            if(verse:get(y,x).isAlive ~= true and (friends == 3))then\
                ngen:set(y,x,newCell(true))\
            end\
        end\
    end\
  verse:replace(ngen:getRaw())\
  ngen = grid.create(82,50)\
end\
function infoBar()\
    term.setCursorPos(1,1)\
    term.setBackgroundColor(colors.gray)\
    term.setTextColor(colors.white)\
    term.clearLine()\
    local printgeneration = generation\
    if generation > 999 then printgeneration = 999 end\
    write(\" Editing:\" .. tostring(isPaused) .. \" Generation: \" .. printgeneration .. \",\" .. speed .. \" X:\" .. xoff .. \",Y:\" .. yoff)\
    term.setCursorPos(w,1)\
    term.setBackgroundColor(colors.red)\
    write('X')\
    term.setCursorPos(w-1,1)\
    term.setBackgroundColor(colors.lightGray)\
    write('C')\
end\
function endscr()\
\009term.setBackgroundColor(colors.black)\
    term.clear()\
    term.setCursorPos(1,1)\
    term.setBackgroundColor(colors.gray)\
    term.setTextColor(colors.white)\
    term.clearLine()\
    write(\"Thank you for playing Lewisk3's Game Of Life! Credits: John Conway, Multmine\")\
    term.setCursorPos(w,1)\
    term.setBackgroundColor(colors.brown)\
    write('X')\
\009term.setBackgroundColor(colors.black)\
    term.setCursorPos(1,3)\
\
end\
\
verse:loop(drawCell)\
while running do\
    term.current().setVisible(false)\
    infoBar()\
    ev = {os.pullEvent()}\
    if(ev[1] == 'key')then\
        if(ev[2] == keys.space)then isPaused = not isPaused end\
        if(ev[2] == keys.w and yoff > 0)then yoff = yoff - 1 end\
        if(ev[2] == keys.a and xoff > 0)then xoff = xoff - 1 end\
        if(ev[2] == keys.s and yoff < verse:getHeight()-h)then yoff = yoff + 1 end\
        if(ev[2] == keys.d and xoff < verse:getWidth()-w)then xoff = xoff + 1 end\
        if(ev[2] == keys.up and speed > 0.01)then speed = speed - 0.01 end  \
        if(ev[2] == keys.down)then speed = speed + 0.01 end\
        updateview()\
    end\
    if(ev[1] == 'timer' and ev[2] == genTimer)then\
        if(not isPaused)then life() generation = generation + 1 end\
        genTimer = os.startTimer(speed)\
    elseif(ev[1] == \"mouse_click\" or ev[1] == \"mouse_drag\")then\
        \009if(ev[3] == w and ev[4] == 1)then running = false endscr() end\
        \009if(ev[3] == w-1 and ev[4] == 1)then verse = grid.create(verse:getWidth(),verse:getHeight()) verse:fill({}) ngen = grid.create(ngen:getWidth(),ngen:getHeight()) updateview() end\
        if(isPaused)then   \
            if(ev[2] == 1)then verse:set(ev[3]+xoff,ev[4]+yoff,newCell(true)) end\
            if(ev[2] == 2)then verse:set(ev[3]+xoff,ev[4]+yoff,{}) end\
            drawCell(ev[3],ev[4])\
        end\
    end\
    term.current().setVisible(true)\
end",
  },
  [ "/apis/grid" ] = {
    content = "\
-- ] Created by: Redxone(Lewisk3) [ -- \
-- ] \009(c)Lewisk3 Corpz 2016\009  [ -- \
\
-- DOCUMENTATION (Sorta...) -- \
--] grid.create(width,height)\
--] grid:set(x,y,thing)\
--] grid:find(obj) - returns the found objects x and y location\
--] grid:findByAttrib(attrib,compare)\
--] grid:get(x,y) - returns the object in the x any y of the grid\
--] grid:getByAttrib(attrib,compare)\
--] grid:getWidth() - returns width of grid\
--] grid:getHeight() - returns grid height\
--] grid:unset(x,y) - set grid spot to {}\
--] grid:getRaw() - returns entire grid unserialized\
--] grid:getSerial() - returns entire grid serialized\
--] grid:replace(newgrid) - replaces grid with another grid\
--] grid:draw()\
--] grid:drawAttrib(attrib)\
--] grid:fill(with) - fills grid with something\
--] grid:setRegion(startx,starty,endx,endy,with) - fills grid from start x and start y to ends with something\
--] grid:drawRegion(startx,starty,endx,endy)\
\
function create(w, h)\
\009local gridtable = {\
\009\009maxw = w,\
\009\009maxh = h,\
\009\009grid = {},\
\
\009\009set = function(self,x,y,obj)\
\009\009\009if(x <= self.maxw and y <= self.maxh)then\
\009\009\009\009self.grid[y][x] = obj\
\009\009\009else\
\009\009\009\009error(\"grid:set -> Invaild X and/or Y param(s).\")\
\009\009\009end\
\009\009end,\
\
\009\009find = function(self,obj)\
\009\009\009for y = 0, self.maxh do\
\009\009\009 \009for x = 0, self.maxw do\
\009\009\009 \009\009if(textutils.serialize(self.grid[y][x]) == textutils.serialize(obj))then\
\009\009\009 \009\009\009return x, y\
\009\009\009 \009\009end\
\009\009\009 \009end\
\009\009\009 end\
\009\009end,\
\
\009\009get = function(self,x,y)\
\009\009\009local tbl = {}\
\009\009\009if(x <= self.maxw and y <= self.maxh )then\
\009\009\009\009return self.grid[y][x]\
\009\009\009else\
\009\009\009\009return tbl\
\009\009\009end\
\009\009end,\
\
\009\009getByAttribEqual = function(self,a,c)\
\009\009\009local gx, gy = 0, 0\
\009\009\009for y = 0, self.maxh do\
\009\009\009 \009for x = 0, self.maxw do\
\009\009\009 \009\009if(self.grid[y][x][a] == c)then\
\009\009\009 \009\009\009gx = x\
\009\009\009 \009\009\009gy = y\
\009\009\009 \009\009end\
\009\009\009 \009end\
\009\009\009 end\
\009\009\009return self:get(gx,gy)\
\009\009end,\
\
\009\009checkAttribEqual = function(self,x,y,a,e)\
\009\009\009 if(self.grid[y][x][a] == c)then\
\009\009\009 \009return true\
\009\009\009 else\
\009\009\009 \009return false\
\009\009\009 end\
\009\009end,\
\
\009\009getByAttrib = function(self,a)\
\009\009\009local xx, yy = 0, 0\
\009\009\009for y = 0, self.maxh do\
\009\009\009 \009for x = 0, self.maxw do\
\009\009\009 \009\009if(self.grid[y][x][a] ~= nil)then\
\009\009\009 \009\009\009 xx = x\
\009\009\009 \009\009\009 yy = y\
\009\009\009 \009\009end\
\009\009\009 \009end\
\009\009\009 end\
\
\009\009\009 if(xx ~= 0 and yy ~= 0)then\
\009\009\009\009return self:get(xx,yy)[a]\
\009\009\009 else\
\009\009\009\009return {}\
\009\009\009 end\
\009\009end,\
\
\009\009setByAttrib = function(self,a,n)\
\009\009\009for y = 0, self.maxh do\
\009\009\009 \009for x = 0, self.maxw do\
\009\009\009 \009\009if(self.grid[y][x][a] ~= nil)then\
\009\009\009 \009\009\009 local bset = self.grid[y][x]\
\009\009\009 \009\009\009 bset[a] = n\
\009\009\009 \009\009\009 self:set(x,y,bset)\
\009\009\009 \009\009end\
\009\009\009 \009end\
\009\009\009 end\
\009\009end,\
\
\009\009getWidth = function(self)\
\009\009\009return self.maxw\
\009\009end,\
\
\009\009getHeight = function(self)\
\009\009\009return self.maxh\
\009\009end,\
\
\009\009unset = function(self,x,y)\
\009\009\009if(x <= self.maxw and y <= self.maxh)then\
\009\009\009\009self.grid[y][x] = {}\
\009\009\009else\
\009\009\009\009error(\"grid:unset -> Invaild X and/or Y param(s).\")\
\009\009\009end\
\009\009end,\
\
\009\009getRaw = function(self)\
\009\009\009return self.grid\
\009\009end,\
\
\009\009getSerial = function(self)\
\009\009\009return textutils.serialize(self.grid):gsub(\"\\n%s*\",\"\")\
\009\009end,\
\
\009\009replace = function(self,grid)\
\009\009\009if(type(grid) ~= \"table\")then error(\"grid:replace -> Invalid grid type. \") end\
\009\009\009 -- calculating grid size... --\
\009\009\009 self.maxh = 0\
\009\009\009 self.maxw = 0\
\
\009\009\009 for iy = 1, #grid do\
\009\009\009 \009self.maxh = self.maxh + 1\
\009\009\009 end\
\
\009\009\009 for ix = 1, #grid[0] do\
\009\009\009\009self.maxw = self.maxw + 1\
\009\009     end\
\
\009\009     self.grid = grid\
\
\009\009\009 if(self.maxh <= 0 or self.maxw <= 0)then error(\"grid:replace -> Grid is malformed.\") end\
\
\009\009end,\
\
\009\009draw = function(self)\
\009\009\009for y = 0, self.maxh do\
\009\009\009 \009for x = 0, self.maxw do\
\009\009\009 \009\009term.setCursorPos(x,y)\
\009\009\009 \009\009if(self.grid[y][x] ~= {})then\
\009\009\009\009\009\009term.write(self.grid[y][x])\
\009\009\009\009\009end\
\009\009\009 \009end\
\009\009\009 end\
\009\009end,\
\
\009\009swap = function(self,fromx,fromy,tox,toy)\
\009\009\009local prevo = self.grid[fromy][fromx] \
\009\009\009local too = self.grid[toy][tox]\
\009\009\009self.grid[fromy][fromx] = too\
\009\009\009self.grid[toy][tox] = prevo\
\009\009end,\
\
\009\009moveInto = function(self,obj,x,y,uap,flags)\
\009\009\009local prloc = self:get(x,y)\
\009\009\009local ox, oy = self:find(obj)\
\009\009\009-- only take place if flags on other block are met --\
\009\009\009if(type(flags) == \"table\")then\
\009\009\009\009for k, v in pairs(flags) do\
\009\009\009\009\009if(not self:checkAttribEqual(x,y,k,v))then\
\009\009\009\009\009\009return false\
\009\009\009\009\009end\
\009\009\009\009end\
\009\009\009end\
\009\009\009-- if passes flags -- \
\009\009\009if(type(uap) == \"table\")then\
\009\009\009\009for k, v in pairs(uap) do\
\009\009\009\009\009obj[k] = v\
\009\009\009\009end\009\009\009\009\
\009\009\009end\
\009\009\009self:set(ox,oy,prloc)\
\009\009\009self:set(x,y,obj)\
\009\009end,\
\
\009\009renderSwap = function(self, charattrib, tcolattrib, bcolattrib, fromx,fromy,tox,toy)\
\009\009\009self:swap(fromx,fromy,tox,toy)\009\009\
\009\009\009self:renderRegion(charattrib, tcolattrib, bcolattrib,tox,toy,tox,toy)\
\009\009\009self:renderRegion(charattrib, tcolattrib, bcolattrib,fromx,fromy,fromx,fromy)\
\009\009end,\
\
\009\009render = function(self,charattrib,tcolattrib,bcolattrib)\
\009\009\009local ta = colors.white\
\009\009\009local ba = colors.black\
\009\009\009for y = 0, self.maxh do\
\009\009\009 \009for x = 0, self.maxw do\
\009\009\009 \009\009term.setCursorPos(x,y)\
\009\009\009 \009\009term.setTextColor(self.grid[y][x][tcolattrib])\
\009\009\009 \009\009term.setBackgroundColor(self.grid[y][x][bcolattrib])\
\009\009\009\009\009 \009ta = colors.white\
\009\009\009\009\009 \009ba = colors.black\
\009\009\009\009\009 \009if(type(tcolattrib) == \"number\")then ta = tcolattrib end\
\009\009\009\009\009 \009if(type(bcolattrib) == \"number\")then ba = bcolattrib end\
\009\009\009\009\009 \009if(self.grid[y][x][charattrib] ~= nil)then\
\009\009\009\009\009 \009\009if(self.grid[y][x][tcolattrib] ~= nil)then\
\009\009\009\009\009 \009\009\009ta = self.grid[y][x][tcolattrib]\
\009\009\009\009\009 \009\009end\
\009\009\009\009\009 \009\009if(self.grid[y][x][bcolattrib] ~= nil)then\
\009\009\009\009\009 \009\009\009ba = self.grid[y][x][bcolattrib]\
\009\009\009\009\009 \009\009end\
\009\009\009\009\009\009 \009term.setTextColor(ta)\
\009\009\009\009 \009\009\009term.setBackgroundColor(ba)\
\009\009\009\009\009 \009\009term.write(self.grid[y][x][charattrib])\
\009\009\009\009\009 \009end\
\009\009\009\009end\
\009\009\009 end\
\009\009end,\
\
\009\009drawAttrib = function(self,a)\
\009\009\009for y = 0, self.maxh do\
\009\009\009 \009for x = 0, self.maxw do\
\009\009\009 \009\009term.setCursorPos(x,y)\
\009\009\009 \009\009if(self.grid[y][x][a] ~= nil)then\
\009\009\009 \009\009\009term.write(self.grid[y][x][a])\
\009\009\009 \009\009end\
\009\009\009 \009end\
\009\009\009 end\
\009\009end,\
\
\009\009fill = function(self,obj)\
\009\009\009for y = 0, self.maxh do\
\009\009\009 \009for x = 0, self.maxw do\
\009\009\009 \009\009self.grid[y][x] = obj\
\009\009\009 \009end\
\009\009\009 end\
\009\009end,\
\
\009\009setCursorPos = function(self,x,y)\
\009\009\009term.setCursorPos(y,x)\
\009\009end,\
\
\009\009loop = function(self,f,startx,starty,endx,endy)\
\009\009\009if(startx == nil)then startx = 0 end\
\009\009\009if(starty == nil)then starty = 0 end\
\009\009\009if(endx == nil and startx ~= nil)then endx = startx end\
\009\009\009if(endy == nil and starty ~= nil)then endy = starty end\
\009\009\009if(endx == nil)then endx = self.maxw end\
\009\009\009if(endy == nil)then endy = self.maxh end\
\009\009\009for y = tonumber(starty), tonumber(endy) do\
\009\009\009\009for x = tonumber(startx), tonumber(endx) do\
\009\009\009\009\009f(x,y)\
\009\009\009\009end\
\009\009\009end\
\009\009end,\
\
\009\009setRegion = function(self, sx, sy, ex, ey, obj)\
\009\009\009if(sx <= self.maxw and sy <= self.maxh and ex <= self.maxw and ey <= self.maxh)then\
\009\009\009\009for y = tonumber(sy), tonumber(ey) do\
\009\009\009\009 \009for x = tonumber(sx), tonumber(ex) do\
\009\009\009\009 \009\009self.grid[y][x] = obj\
\009\009\009\009 \009end\
\009\009\009\009 end\
\009\009\009else\
\009\009\009\009error(\"grid:setRegion -> Invaild X and/or Y param(s).\")\
\009\009\009end\
\009\009end,\
\
\009\009drawRegion = function(self, sx, sy, ex, ey)\
\009\009\009if(sx <= self.maxw and sy <= self.maxh and ex <= self.maxw and ey <= self.maxh)then\
\009\009\009\009for y = tonumber(sy), tonumber(ey) do\
\009\009\009\009 \009for x = tonumber(sx), tonumber(ex) do\
\009\009\009\009\009 \009term.setCursorPos(x,y)\
\009\009\009\009 \009\009if(self.grid[y][x] ~= {})then\
\009\009\009\009\009\009\009term.write(self.grid[y][x])\
\009\009\009\009\009\009end\
\009\009\009\009 \009end\
\009\009\009\009 end\
\009\009\009else\
\009\009\009\009error(\"grid:drawRegion -> Invaild X and/or Y param(s).\")\
\009\009\009end\
\009\009end,\
\
\009\009renderRegion = function(self, charattrib, tcolattrib, bcolattrib, sx, sy, ex, ey)\
\009\009\009if(sx <= self.maxw and sy <= self.maxh and ex <= self.maxw and ey <= self.maxh)then\
\009\009\009\009local ta = colors.white\
\009\009\009 \009local ba = colors.black\
\009\009\009\009for y = tonumber(sy), tonumber(ey) do\
\009\009\009\009 \009for x = tonumber(sx), tonumber(ex) do\
\009\009\009\009\009 \009term.setCursorPos(x,y)\
\009\009\009\009\009 \009ta = colors.white\
\009\009\009\009\009 \009ba = colors.black\
\009\009\009\009\009 \009if(self.grid[y][x][charattrib] ~= nil)then\
\009\009\009\009\009 \009\009if(self.grid[y][x][tcolattrib] ~= nil)then\
\009\009\009\009\009 \009\009\009ta = self.grid[y][x][tcolattrib]\
\009\009\009\009\009 \009\009end\
\009\009\009\009\009 \009\009if(self.grid[y][x][bcolattrib] ~= nil)then\
\009\009\009\009\009 \009\009\009ba = self.grid[y][x][bcolattrib]\
\009\009\009\009\009 \009\009end\
\009\009\009\009\009\009 \009term.setTextColor(ta)\
\009\009\009\009 \009\009\009term.setBackgroundColor(ba)\
\009\009\009\009\009 \009\009term.write(self.grid[y][x][charattrib])\
\009\009\009\009\009 \009end\
\009\009\009\009 \009end\
\009\009\009\009 end\
\009\009\009else\
\009\009\009\009error(\"grid:renderRegion -> Invaild X and/or Y param(s).\")\
\009\009\009end\
\009\009end,\
\
\009}\
\
\
\009-- generate grid locally --\
\009for y = 0, h do\
\009\009gridtable.grid[y] = {}\
\009\009for x = 0, w do\
\009\009\009gridtable.grid[y][x] = {}\
\009\009end\
\009end\
\
\009-- return grid to user --\
\009return gridtable\
end",
  },
  [ "/apis/fpath" ] = {
    content = "local function path_goback(path,amm)\
    pathtbl={}\
    s=\"\"\
    pathsize=0\
    -- Divide string and count the number of \
    -- divisions.\
     for str in string.gmatch(path, \"([^/]+)\") do\
         pathtbl[#pathtbl+1] = str  \
     end\
     for k, v in pairs(pathtbl) do\
         pathsize=k\
     end\
     pathsize = pathsize - amm\
    -- Split string into words based on seperator.\
    pathtbl={}\
    for str in string.gmatch(path, \"([^/]+)\") do\
        pathtbl[#pathtbl+1] = str  \
    end\
    -- Based on how large the user wants the string to be \
    -- add only the string bits that led up to the user defined\
    -- size.\
    for k, v in pairs(pathtbl) do\
        if(k <= pathsize)then s = s..pathtbl[k]..\"/\" end\
    end\
    return \"/\" .. s\
end\
local function path_getsize(path)\
    pathtbl={}\
    pathsize=0\
    -- Divide string and count the number of \
    -- divisions.\
     for str in string.gmatch(path, \"([^/]+)\") do\
         pathtbl[#pathtbl+1] = str  \
     end\
     for k, v in pairs(pathtbl) do\
         pathsize=k\
     end\
     return pathsize\
end\
\
function newpath(name,stuckindex)\
    if(name == nil or type(name) ~= \"string\")then error(\"PathAPI: Name must be provided for new paths. \") end\
    if(string.sub(name,#name,#name) ~= \"/\")then\
        name = name .. \"/\"\
    end\
    if(type(stuckindex) ~= \"number\")then stuckindex = 0 end\
    local pathobj = {\
        path = name,\
        stuckind = stuckindex,\
        getsize = function(self)\
           return path_getsize(self.path)\
        end,\
        goback = function(self,amm)\
            if(self:getsize() - amm >= self.stuckind)then\
               self.path = path_goback(self.path,amm)\
               return self.path\
            else\
                return false\
            end\
        end,\
        getraw = function(self)\
            return self.path\
        end,\
        add = function(self,new)\
            self.path = self.path .. new .. \"/\"\
            return self.path\
        end,\
        set = function(self,npath)\
            self.path = npath\
            return self.path\
        end,\
        lockpath = function(self)\
            self.stuckind = self:getsize()\
        end,\
        unlockpath = function(self)\
            self.stuckind = 0\
        end,\
    }\
    return pathobj\
end",
  },
}
