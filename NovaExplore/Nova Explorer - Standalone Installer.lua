content = {
  [ "//novaio" ] = {
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
  [ "//fpath" ] = {
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
    return s\
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
  [ "//futils" ] = {
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
  [ "//novaexplore" ] = {
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
local pinnednames = {}\
local innova = true\
local iscrossbow = false\
local function init()\
if(fs.isDir(\"CrossBow/apis\"))then\
\009iscrossbow = true\
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
\009\009if(iscrossbow)then\
\009\009\009os.loadAPI((apis[i]))\
\009\009else\
\009\009\009os.loadAPI(shell.resolveProgram((apis[i])))\
\009\009end\
\009end\
end\
init()\
--]] Define variables \
local file_selected = 0\
local files = {}\
-- Path isnt locked\
local path = fpath.newpath(\"/\")\
novaio.setActive(false)\
novaio.setInput(path:getraw())\
local fileoffs = 0\
local sideoffs = 0\
local sidemax = h-1\
local filemax = h\
local searching = false\
local selectedside = 0\
local search = \"\"\
local clipboard = {}\
local inmenu = false\
local inmenutype = {}\
local drawingmenu = {}\
local inmenux, inmenuy = 1, 4\
local sideitems = {}\
local icons = {\
\009folder = \"&e[=]\",\
\009file = \"&7-~-\",\
\009executable = \"&8:&7=&8:\",\
\009game = \"&4-&7=&8]\",\
\009zip = \"&5[&1=&2]\",\
\009paint = \"&2~&4* \",\
\009pin = \"&7<&8 \",\
\009disk= \"&8:&4^&8:\"\
}\
filemenu = {\
\009 {n=\"Open    \",func=function(file) openHref(path:getraw() .. file.n) end},\
\009 {n=\"Edit    \",func=function(file) \
\009 \009editfile(path:getraw() .. file.n)\
\009 end},\
\009 {n=\"Open as \",func=function(file) \
\009 \009local ans = openYesNo(\"Open File As. \",\"Select open option.*\",\"With\", \"Args\")\
\009 \009if(ans == 1)then -- open with file\
\009 \009\009local openfile = openReadDialog(\"Open with another file. \")\
\009 \009\009if(file ~= \"\")then\
\009 \009\009\009runFile(openfile,path:getraw() .. file.n,true)\
\009 \009\009end\
\009 \009elseif(ans == 2)then -- open with arguments\
\009 \009\009local args = openReadDialog(\"Open with arguments. \")\
\009 \009\009runFile(path:getraw() .. file.n,args,true)\
\009 \009end\
\009 end},\
\009 {n=\"Rename  \",relies=function(file) \
\009 \009return file.t ~= \"disk\"\
\009 end,\
\009 func=function(file)\
\009 \009\009local sid = getSelectedFile()\
\009 \009\009scp(23,(sid-fileoffs)+4)\
\009 \009\009write(string.rep(\" \",17))\
\009 \009\009scp(23,(sid-fileoffs)+4)\
\009 \009\009local newname = readEx(17,false,file.n)\
\009 \009\009renameFile(path:getraw(),file.n,newname)\
\009 end},\
\009 {n=\"Extract \",relies=function(file) return file.t == \"zip\" end,\
\009 func=function(file) end},\
\009 {n=\"Archive \",relies=function(file) return file.t ~= \"zip\" end,\
\009 func=function(file) end},\
\009 {n=\"Cut     \",relies=function(file) \
\009\009return not fs.isReadOnly(path:getraw() .. file.n)\
\009 end,func=function(file) \
\009 \009setClipboard(path:getraw() .. file.n, file.n, \"cut\")\
\009 end},\
\009 {n=\"Copy    \",func=function(file) \
\009 \009setClipboard(path:getraw() .. file.n, file.n, \"copy\")\
\009 end},\
\009 {n=\"Paste   \",relies=function(file) \
\009 \009return clipboard.name ~= nil and \
\009 \009\009not fs.isReadOnly(path:getraw() .. file.n)\
\009 end,\
\009 func=function(file) \
\009 \009pasteFile(path:getraw()) \
\009 end},\
\009 {n=\"Pin item\",relies=function(file) \
\009 \009return not getnamedpins()[path:getraw() .. file.n] end,\
\009 func=function(file)\
\009 \009 addPinnedFile(\
\009 \009 \009icons[file.t] .. \" &r\" .. file.n,file.t,path:getraw() .. file.n\
\009 \009 )\
\009 end},\
\009 {n=\"Unpin   \",relies=function(file) \
\009 \009return getnamedpins()[path:getraw() .. file.n] end,\
\009 func=function(file) \
\009 \009 removePinnedFile(path:getraw() .. file.n)\
\009 end},\
\009 {n=\"Delete  \",relies=function(file) \
\009 \009 return not fs.isReadOnly(path:getraw() .. file.n) and \
\009 \009 \009not (file.t == \"disk\" and peripheral.find(\"drive\"))\
\009 end,func=function(file) \
\009 \009\009local ans = openYesNo(\"File deletion. \",\"Confirm &4deletion&r of *\" .. file.n)\
\009 \009\009if(ans == 1)then\
\009 \009\009\009deleteFile(path:getraw() .. file.n)\
\009 \009\009end\
\009 end},\
}\
sidemenu = {\
\009 {n=\"Open   \",func=function() openHref(getSelectedSideItem().href) end},\
\009 {n=\"Rename \",\
\009 func=function(file)\
\009 \009\009local sid = getSelectedSide()\
\009 \009\009scp(5,(sid-sideoffs)+4)\
\009 \009\009sbc(colors.lightGray)\
\009 \009\009write(string.rep(\" \",11))\
\009 \009\009scp(5,(sid-sideoffs)+4)\
\009 \009\009local newname = readEx(9,false)\
\009 \009\009renameSideItem(getSelectedSide(),newname)\
\009 end},\
\009 {n=\"Unpin  \",relies=function() return getSelectedSide() >= 8 end,\
\009 func=function(file) \
\009 \009removePinnedFile(getSelectedSideItem().href)\
\009 end},\
\009 {n=\"Up     \",relies=function() \
\009 \009\009return getSideItem(getSelectedSide()-1).t ~= nil and  \
\009 \009\009\009   getSideItem(getSelectedSide()-1).t ~= \"text\" \
\009 \009\009end,\
\009 func=function(file) \
\009 \009\009moveSideItem(getSelectedSide(),-1)\
\009 end},\
\009 {n=\"Down   \",relies=function() \
\009 \009return (getSelectedSide() < getSideAmmount()) and \
\009 \009\009   (getSideItem(getSelectedSide()+1).n ~= nil) and\
\009 \009\009   (getSideItem(getSelectedSide()+1).n ~= \"text\")\
\009 end,\
\009 func=function(file) \
\009 \009moveSideItem(getSelectedSide(),1)\
\009 end},\
}\
emptymenu = {\
\009{n=\"New Folder \",func=function() \
\009\009local file = openReadDialog(\"New Folder\")\
\009\009newFileFolder(\"folder\",path:getraw(),file) \
\009end},\
\009{n=\"New File   \",func=function() \
\009\009local file = openReadDialog(\"New File\")\
\009\009newFileFolder(\"file\",path:getraw(),file) \
\009end},\
\009 {n=\"Paste      \",relies=function() \
\009 \009return clipboard.name ~= nil and \
\009 \009\009not fs.isReadOnly(path:getraw())\
\009 end,\
\009 func=function() \
\009 \009pasteFile(path:getraw()) \
\009 end},\
\009 {n=\"Test Crash \",func=function() error(\"Lol get rekt!\") end},\
}\
foldermenu = {\
\009 filemenu[1],\
\009 filemenu[4],\
\009 {n=\"Archive \",func=function(file) end},\
\009 filemenu[7],\
\009 filemenu[8],\
\009 filemenu[9],\
\009 {n=\"Pin item\",relies=function(file,pins) \
\009 \009return not pins[path:getraw() .. file.n] end,\
\009 func=function(file) \
\009 \009 addPinnedFile(\
\009 \009 \009icons[file.t] .. \" &r\" .. file.n,file.t,path:getraw() .. file.n\
\009 \009 )\
\009 end},\
\009 filemenu[12],\
}\
if(iscrossbow)then\
\009sideitems = {\
\009\009{n='&5* &rQuick Access',t='text'},\
\009\009{n=' ',t='text'},\
\009\009{n=icons.folder..' &rPrograms',t='folder',href=\"CrossBow/programs\"},\
\009\009{n=icons.folder..' &rGames',t='folder',href=\"CrossBow/games\"},\
\009\009{n=' ',t='text'},\
\009\009{n=' ',t='text'},\
\009\009{n=icons.pin .. \"&rPinned Items\",t='text'},\
\009\009{n=' ',t='text'},\
\009\009{n=icons.game..' &rGameOfLife',t='game',href=\"CrossBow/games/GameOfLife\"},\
\009\009{n=icons.game..' &r2048',t='game',href=\"CrossBow/games/2048\"},\
\009\009{n=icons.folder..' &5Apis',t='folder',href=\"CrossBow/apis/\"},\
\009}\
else\
\009sideitems = {\
\009\009{n='&5* &rQuick Access',t='text'},\
\009\009{n=' ',t='text'},\
\009\009{n=icons.folder..' &rPrograms',t='folder',href=\"rom/programs\"},\
\009\009{n=icons.folder..' &rGames',t='folder',href=\"rom/programs/fun\"},\
\009\009{n=' ',t='text'},\
\009\009{n=' ',t='text'},\
\009\009{n=icons.pin .. \"&rPinned Items\",t='text'},\
\009\009{n=' ',t='text'},\
\009\009{n=icons.game..' &2Worm',t='game',href=\"rom/programs/fun/worm\"},\
\009\009{n=icons.game..' &8Redirection',t='game',href=\"rom/programs/fun/advanced/redirection\"},\
\009}\
end\
local pinnednames = {}\
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
\009\009elseif(menu[i].relies(files[file_selected],pinnednames))then\
\009\009\009finalmenu[#finalmenu+1] = menu[i]\
\009\009end\
\009end\
\009if(sy+#finalmenu > h)then\
\009\009sy = sy - ((sy+#finalmenu)-h)\
\009end\
\009if(sx+#finalmenu[1].n >= w-1)then\
\009\009sx = sx - ((sx+#finalmenu[1].n)-(w-1))\
\009end\
\009pa.drawBox(sx,sy+2,sx+#finalmenu[1].n,sy+#finalmenu+1,colors.black)\
\009for i = 1, #finalmenu do\
\009\009if(sy+i <= h)then\
\009\009\009scp(sx-1,sy+i)\
\009\009\009sbc(colors.lightGray)\
\009\009\009stc(colors.white)\
\009\009\009write(string.rep(\" \",#finalmenu[i].n+1))\
\009\009\009scp(sx,sy+i)\
\009\009\009write(finalmenu[i].n)\
\009\009end\
\009end\
\009return finalmenu, sx, sy\
end\
function openReadDialog(title,startread)\
\009local bw, bh = 30,0\
\009local sx, sy = w/2-math.ceil(bw/2), (h/2)-math.ceil(bh/2)-1\
\009local ex, ey = w/2+math.ceil(bw/2), (h/2)+math.floor(bh/2)-1\
\009paintutils.drawFilledBox(sx+1,sy,ex+2,ey+2,colors.black)\
\009paintutils.drawFilledBox(sx,sy,ex,ey,colors.lightGray)\
\009paintutils.drawBox(sx-1,sy-1,ex+1,ey+1,colors.gray)\
\009scp(sx,sy-1)\
\009stc(colors.white)\
\009write(title)\
\009scp(sx,sy)\
\009sbc(colors.lightGray)\
\009local inp = readEx(30,true,startread)\
\009drawMain()\
\009getfiles()\
\009drawFiles()\
\009return inp\
end\
function notify(title,txt)\
\009local bw, bh = 30,5\
\009local sx, sy = w/2-math.ceil(bw/2), (h/2)-math.ceil(bh/2)+2\
\009local ex, ey = w/2+math.ceil(bw/2), (h/2)+math.floor(bh/2)+1\
\009paintutils.drawLine(sx,sy-1,ex,sy-1,colors.gray)\
\009paintutils.drawFilledBox(sx+1,sy+1,ex+1,ey+1,colors.black)\
\009paintutils.drawFilledBox(sx,sy,ex,ey,colors.lightGray)\
\009scp(sx,sy-1)\
\009stc(colors.white)\
\009sbc(colors.gray)\
\009write(title)\
\009sbc(colors.lightGray)\
\009local msg = {}\
     for str in string.gmatch(txt, \"([^*]+)\") do\
         msg[#msg+1] = str  \
     end\
     for i = 1, #msg do\
     \009sbc(colors.lightGray)\
     \009fullwrite(\" \" .. msg[i],45,sx,sy+i)\
     end\
     fullwrite(\"&4Click&r to close. \",45,sx+8,sy+#msg+2)\
\009os.pullEvent(\"mouse_click\")\
\009drawMain()\
\009getfiles()\
\009drawFiles()\
end\
function openYesNo(title,txt,y,n)\
\009if(y == nil or n == nil)then \
\009\009 y = \"Yes\"\
\009\009 n = \"No\"\
\009end\
\009local ynm = {y, n}\
\009local inynm = true\
\009local bw, bh = 30,5\
\009local opinc = 9\
\009local sx, sy = w/2-math.ceil(bw/2), (h/2)-math.ceil(bh/2)+2\
\009local ex, ey = w/2+math.ceil(bw/2), (h/2)+math.floor(bh/2)+1\
\009paintutils.drawLine(sx,sy-1,ex,sy-1,colors.gray)\
\009paintutils.drawFilledBox(sx+1,sy+1,ex+1,ey+1,colors.black)\
\009paintutils.drawFilledBox(sx,sy,ex,ey,colors.lightGray)\
\009scp(sx,sy-1)\
\009stc(colors.white)\
\009sbc(colors.gray)\
\009write(title)\
\009sbc(colors.lightGray)\
\009 local msg = {}\
     for str in string.gmatch(txt, \"([^*]+)\") do\
         msg[#msg+1] = str  \
     end\
     for i = 1, #msg do\
     \009sbc(colors.lightGray)\
     \009fullwrite(\" \" .. msg[i],45,sx,sy+i)\
     end\
\009stc(colors.white)\
\009local function drawm()\
\009\009  for i = 1, #ynm do\
\009\009  \009\009sbc(colors.red)\
\009\009  \009\009if(i==1)then\
\009\009  \009\009\009sbc(colors.green)\
\009\009  \009\009end\
\009\009  \009\009scp(sx+(i*opinc),ey-1)\
\009\009  \009\009write(ynm[i])\
\009\009  end\
\009end\
\009local function drawmopt(id,clk)\
\009\009 sbc(colors.red)\
\009\009 if(i==1)then\
\009\009    sbc(colors.green)\
\009\009 end\
\009\009 if(clk)then sbc(colors.gray) end\
\009\009 scp(sx+(id*opinc),ey-1)\
\009\009 write(ynm[id])\
\009\009 sleep(0.2)\
\009end\
\009local function mupdate()\
\009\009while inynm do\
\009\009\009local ev = {os.pullEvent()}\
\009\009\009if(ev[1] == \"mouse_click\")then\
\009\009\009\009local x, y = ev[3], ev[4]\
\009\009\009\009for i = 1, #ynm do\
\009\009\009\009\009if( x >= sx+(i*opinc)-1 and x <= sx+(i*opinc)+#ynm[i] and y == math.floor(ey-1) )then\
\009\009\009\009\009\009inynm = false\
\009\009\009\009\009\009drawmopt(i,true)\
\009\009\009\009\009\009return i\
\009\009\009\009\009end\
\009\009\009\009end\
\009\009\009end\
\009\009end\
\009end\
\009drawm()\
\009local res = mupdate()\
\009getfiles()\
\009drawMain()\
\009drawFiles()\
\009return res\
end\
function readEx(mlen,scroll,startw)\
\009novaio.setActive(false)\
\009if(startw == nil)then startw = \"\" end\
\009novaio.setInput(startw)\
\009local x, y = term.getCursorPos()\
\009local readxoff = x\
\009if(startw ~= \"\")then\
\009\009scp(readxoff,y)\
\009\009write(novaio.getInput())\
\009end\
\009local oinp = novaio.getInput()\
\009local ininp = true\
\009if(scroll)then\
\009\009mslen = 1000\
\009end\
\009term.setCursorBlink(true)\
\009while ininp do\
\009\009local e = {os.pullEvent()}\
\009\009local inp = novaio.read(e,mslen,mlen-1,readxoff,y)\
\009\009novaio.setActive(true)\
\009\009if(inp)then \
\009\009\009ininp = false\
\009\009\009novaio.setActive(false)\
\009\009\009local inp = novaio.getInput()\
\009\009\009novaio.setInput(oinp)\
\009\009\009if(inp == startw)then\
\009\009\009\009inp = \"\"\
\009\009\009end\
\009\009\009return inp\
\009\009end\
\009\009-- Dont let the user out of the read!\
\009\009if(novaio.getActive() == \"false\")then novaio.setActive(true) end\
\009end\
end\
function moveSideItem(id,to)\
\009local moveitem = sideitems[id]\
\009local toitem = sideitems[id+to]\
\
\009sideitems[id+to] = moveitem\
\009sideitems[id] = toitem\
\009selectedside = selectedside + to\
\009drawSideBar()\
end\
function deleteFile(file)\
\009file_selected = 0\
\009fs.delete(file)\
\009undrawFiles()\
\009getfiles()\
\009drawFiles()\
end\
function newFileFolder(forf,path,file)\
\009if(file == \"\" or file:find(\" \"))then return false end\
\009if(not fs.exists(path .. file))then\
\009\009if(forf == \"folder\")then\
\009\009\009if(file:sub(1,4) == \"disk\")then\
\009\009\009\009notify(\"Creation Error.\",\"Cannot create disk directory!\")\
\009\009\009\009return false\
\009\009\009end\
\009\009\009fs.makeDir(path .. file)\
\009\009elseif(forf == \"file\")then\
\009\009\009local f = fs.open(path .. file,\"w\")\
\009\009\009f.write(\"\")\
\009\009\009f.close()\
\009\009end\
\009\009getfiles()\
\009\009drawFiles()\
\009else\
\009\009notify(\"Creation Error.\",\"File or folder already exists.\")\
\009end\
end\
function renameSideItem(id,nname)\
     if(nname ~= \"\")then\
     \009 nname = icons[sideitems[id].t] .. \"&r \" .. nname\
     \009 sideitems[id].n = nname\
     end\
       drawSideBar()\
end\
function getSideItemType(id)\
\009return sideitems[id].t\
end\
function getSideItem(id)\
\009return sideitems[id]\
end\
function addPinnedFile(name,type,link)\
\009sideitems[#sideitems+1] = {n=name,t=type,href=link}\
\009pinnednames[link] = true\
\009drawFiles()\
\009drawSideBar()\
end\
function setClipboard(p,n,t)\
\009clipboard = {path=p,name=n,type=t}\
\009if(t == \"cut\")then\
\009\009drawFiles()\
\009end\
end\
function getSelectedSideItem()\
\009return sideitems[selectedside]\
end\
function getSelectedSide()\
\009return selectedside\
end\
function getSideAmmount()\
\009return #sideitems\
end\
function getSelectedFile()\
\009return file_selected\
end\
function getnamedpins()\
\009return pinnednames\
end\
function getClipboard()\
\009return clipboard\
end\
function removePinnedFile(link)\
 \009for i = 1, #sideitems do\
 \009\009if(sideitems[i].href == link)then\
 \009\009\009pinnednames[sideitems[i].href] = nil\
 \009\009\009table.remove(sideitems,i)\
 \009\009\009break\
 \009\009end\
 \009end\
 \009selectedside = 0\
\009drawFiles()\
 \009drawSideBar()\
end\
function getPinnedNames()\
\009pinnednames = {}\
 \009for i = 8, #sideitems do\
 \009\009if(sideitems[i].t ~= \"text\")then\
 \009\009\009pinnednames[sideitems[i].href] = true\
 \009\009end\
 \009end\
end\
function drawMenuClick(mop)\
\009local _, dny = term.getCursorPos()\
\009local dnx = inmenux+1\
\009sbc(colors.gray)\
\009stc(colors.black)\
\009write(mop.n)\
\009sleep(0.2)\
\009scp(dnx,dny)\
\009sbc(colors.lightGray)\
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
\009\009\009 undrawFiles()\
\009\009\009 drawFiles()\
\009\009\009 drawSideBar()\
\009\009\009 e[1] = nil\
\009\009\009 inmenu = false\
\009\009\009 return clicked.func(files[file_selected])\
\009\009else\
\009\009\009undrawFiles()\
\009\009\009drawFiles()\
\009\009\009drawSideBar()\
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
function isFileImage(file)\
\009local isImg = false\
\009local f = fs.open(file,\"r\")\
\009if(f)then\
\009\009if(tonumber(f.readAll():gsub(\"%s+\",\"\"),16) ~= nil) then\
\009\009\009 isImg = true\
\009\009end\
\009\009f.close()\
\009end\
\009return isImg\
end\
function getfiles()\
\009files = {}\
\009local folders = {}\
\009for k , v in pairs(fs.list(path:getraw())) do\
\009\009if(fs.isDir(path:getraw() .. v))then\
\009\009\009local spt = 'folder'\
\009\009\009if(v:sub(1,4) == \"disk\")then \
\009\009\009\009if(#v > 4)then\
\009\009\009\009\009if(tonumber(v:sub(5,#v)) ~= nil)then\
\009\009\009\009\009\009spt = \"disk\"\
\009\009\009\009\009end\
\009\009\009\009else\
\009\009\009\009\009spt = \"disk\" \
\009\009\009\009end\
\009\009\009end\
\009\009\009folders[#folders+1] = {n=v,t=spt}\
\009\009else\
\009\009\009local nt = 'file'\
\009\009\009if(v:sub(#v-3,#v) == '.zip')then nt = 'zip' end\
\009\009\009if(v:sub(#v-3,#v) == '.exe')then nt = 'exe' end\
\009\009\009if(path:getraw():find(\"CrossBow/games\") or \
\009\009\009\009path:getraw():find(\"rom/programs/fun\"))then nt = \"game\" end\
\009\009\009if(path:getraw():find(\"CrossBow/programs\"))then nt = \"executable\" end\
\009\009\009if(isFileImage(path:getraw() .. v))then nt = \"paint\" end\
\009\009\009files[#files+1] = {n=v,t=nt}\
\009\009end\
\009end\
\009-- Sort folders before files\
\009for k,v in pairs(files) do \
\009\009table.insert(folders, v) \
\009end\
\009files = folders\
end\
\
--]] Draw program layout\
function drawSideBar()\
\009term.current().setVisible(false)\
\009sbc(colors.white)\
\009pa.drawFilledBox(0,4,17,h,colors.white)\
\009sbc(1,1)\
\009local loopam = #sideitems\
\009if(#sideitems > h-5)then\
\009\009loopam = (h-5)+sideoffs\
\009end\
\009for i = 1+sideoffs, loopam do\
\009\009if(i-sideoffs < sidemax)then\
\009\009\009if(sideitems[i] ~= nil)then\
\009\009\009\009scp(1,(i-sideoffs)+4)\
\009\009\009\009write(string.rep(\" \",16))\
\009\009\009\009if(selectedside == i)then\
\009\009\009\009\009sbc(colors.lightGray)\
\009\009\009\009else\
\009\009\009\009\009sbc(colors.white)\
\009\009\009\009end\
\009\009\009\009fullwrite(sideitems[i].n,12,1,(i-sideoffs)+4)\
\009\009\009end\
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
\009pa.drawFilledBox(18,4,w-1,h,colors.white)\
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
\009local loopam = #files\
\009if(#files > h-4)then\
\009\009loopam = (h-4)+fileoffs\
\009end\
\009 for i = 1+fileoffs, loopam do\
\009 \009  if(i-fileoffs <= filemax)then\
\009 \009  \009 scp(19,(i-fileoffs)+4)\
\009\009\009 write(string.rep(\" \",30))\
\009\009\009 local namecolor = \" &r\"\
\009\009\009 local drawname = files[i].n\
\009\009\009 if(path:getraw() .. files[i].n == clipboard.path and clipboard.type == \"cut\")then\
\009\009\009  \009namecolor = \" &7\"\
\009\009\009end\
\009\009\009 if(pinnednames[path:getraw() .. files[i].n])then \
\009\009\009 \009 namecolor = \" &b\"\
\009\009\009 \009if(path:getraw() .. files[i].n == clipboard.path and clipboard.type == \"cut\")then\
\009\009\009 \009 \009namecolor = \" &e\"\
\009\009\009 \009end\
\009\009\009 end\
\009\009\009 fullwrite(icons[files[i].t] .. namecolor .. drawname ..\"&r\",12,19,(i-fileoffs)+4,file_selected == i)\
\009\009\009 scp(40,(i-fileoffs)+4)\
\009\009\009 if(not fs.isDir(path:getraw() .. files[i].n))then\
\009\009\009 \009write(tostring(fs.getSize(path:getraw() .. files[i].n) / 1000):sub(1,4) .. \"KB\")\
\009\009\009 end\
\009 \009  end\
\009 end \
\009 term.current().setVisible(true)\
end\
function renameFile(path,name,nname)\
\009local odir = shell.dir()\
\009shell.setDir(\"\")\
\009if(not fs.exists(path .. nname) and nname ~= \"\" and not nname:find(\" \"))then\
\009\009if(nname:sub(1,4) == \"disk\" and fs.isDir(path .. name))then\
\009\009\009shell.setDir(odir)\
\009\009\009notify(\"Rename Error.\",\"Cannot rename directory to * disk!\")\
\009\009\009return false\
\009\009end\
\009\009fs.move(path .. name, path .. nname)\
\009\009getfiles()\
\009elseif(nname ~= \"\" and not nname:find(\" \"))then\
\009\009notify(\"Couldn't rename file.\",\"File with name:  * \".. nname .. \", already exists.\")\
\009end\
\009drawFiles()\
\009shell.setDir(odir)\
end\
function runFile(fpath,args,noclick)\
\009local odir = shell.dir()\
\009sbc(colors.black)\
\009stc(colors.white)\
\009clr()\
\009scp(1,1)\
\009shell.setDir(\"\")\
\009if(isFileImage(fpath))then \
\009\009args = fpath\
\009\009fpath = \"paint\"\
\009\009noclick = true\
\009end\
\009if(shell.resolveProgram(fpath))then\
\009\009if(fs.exists(shell.resolveProgram(fpath)))then \
\009\009\009shell.run(fpath,args)\
\009\009\009if(not noclick)then\
\009\009\009\009ugapi.writecy(\"Click any where to return to NovaBrowse. \",9)\
\009\009\009\009os.pullEvent(\"mouse_click\")\
\009\009\009end\
\009\009else\
\009\009\009notify(\"Open file.\", \"&4File not found. \")\
\009\009end\
\009end\
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
function editfile(filepath)\
\009runFile(\"edit\",filepath,true)\
end\
function pasteFile(to)\
\009local odir = shell.dir()\
\009if(not fs.exists(to .. clipboard.name))then\
\009\009fs.copy(clipboard.path,path:getraw() .. clipboard.name)\
\009\009if(clipboard.type == \"cut\")then fs.delete(clipboard.path) end\
\009\009getfiles()\
\009\009drawFiles()\
\009else\
\009\009local ans = openYesNo(\"File transfer\",\"File exists, Rename file? \")\
\009\009if(ans)then\
\009\009\009local newname = openReadDialog(\"Rename paste file. \",clipboard.name)\
\009\009\009if(newname:find(\" \"))then\
\009\009\009\009notify(\"File rename \", \"Invalid file name. \")\
\009\009\009else\
\009\009\009\009clipboard.name = newname\
\009\009\009end\
\009\009\009return pasteFile(to)\
\009\009end\
\009end\
\009shell.setDir(odir)\
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
function opencloseMenu(type,x,y,yind)\
\009if(inmenu)then\
\009\009undrawFiles()\
\009\009drawFiles()\
\009\009drawSideBar()\
\009\009inmenu = false\
\009elseif(type==\"reg\")then\
\009\009local mtodraw = filemenu\
\009\009if(fs.isDir(path:getraw() .. files[file_selected].n))then\
\009\009\009mtodraw = foldermenu\
\009\009end\
\009\009drawingmenu = mtodraw\
\009\009inmenutype, inmenux, inmenuy = drawmenu(mtodraw,x,y)\
\009\009inmenu = true\
\009elseif(type==\"sidebar\")then\
\009\009drawingmenu = sidemenu\
\009\009inmenutype, _, inmenuy = drawmenu(sidemenu,5,y)\
\009\009inmenux = 5\
\009\009inmenu = true\
\009elseif(type==\"new\" and not fs.isReadOnly(path:getraw()) )then\
\009\009drawingmenu = emptymenu\
\009\009inmenutype,inmenux,inmenuy = drawmenu(emptymenu,x,y)\
\009\009inmenu = true\
\009end\
end\
local function update(e)\
\009if(inmenu)then\
\009\009updatemenu(e,inmenutype,inmenux,inmenuy)\
\009end\
\009if(e[1] == \"disk\")then\
\009\009getfiles()\
\009\009drawFiles()\
\009\009if(fs.exists(\"disk/autorun\"))then\
\009\009\009local ans = openYesNo(\"Disk detected \",\"A software disk has been * detected. \",\"Run\",\"Cancel\")\
\009\009\009if(ans == 1)then\
\009\009\009\009runFile(\"disk/autorun\")\
\009\009\009end\
\009\009elseif(disk.hasAudio(e[2]))then\
\009\009\009local ans = openYesNo(\"Music detected \",\"A music disk has been * inserted. \",\"Play\",\"Cancel\")\
\009\009\009if(ans == 1)then\
\009\009\009\009disk.playAudio(e[2])\
\009\009\009end\
\009\009else\
\009\009\009local ans = openYesNo(\"Disk detected \",\"A floppy disk has been * inserted. \",\"Open\",\"Cancel\")\
\009\009\009if(ans == 1)then\
\009\009\009\009setDir(\"disk/\")\
\009\009\009end\
\009\009end\
\009elseif(e[1] == \"disk_eject\")then\
\009\009if(path:getraw(\"disk/\"))then\
\009\009\009path:goback(1)\
\009\009end\
\009\009undrawFiles()\
\009\009getfiles()\
\009\009drawFiles()\
\009end\
\009if(e[1] == \"key\")then\
\009\009local key = e[2] \
\009\009if(selectedside > 0)then\
\009\009\009if(key == keys.up and sideitems[selectedside-1].t ~= nil and  \
\009 \009\009   sideitems[selectedside-1].t ~= \"text\" )then\
\009\009\009\009moveSideItem(selectedside,-1)\
\009\009\009elseif(key == keys.down and (selectedside < #sideitems) and \
\009 \009\009   (sideitems[selectedside+1].n ~= nil) and \
\009 \009\009    sideitems[selectedside+1].t ~= \"text\" )then\
\009\009\009\009moveSideItem(selectedside,1)\
\009\009\009end\
\009\009end\
\009end\
\009if(e[1] == \"mouse_click\")then\
\009\009 local x,y = e[3], e[4]    \
\009\009 -- Left clicked\
\009\009if(e[2] == 1)then\
\009\009\009if(x == w and y == 1)then\
\009\009\009\009clickExit()\
\009\009\009\009innova = false\
\009\009\009\009sbc(colors.white)\
\009\009\009\009clr()\
\009\009\009\009stc(colors.gray)\
\009\009\009\009ugapi.writecy(\"Thank you for using Nova Explore. \",9)\
\009\009\009\009ugapi.writecy(\"Click the screen to exit. \",10)\
\009\009\009\009os.pullEvent(\"mouse_click\")\
\009\009\009\009sbc(colors.black)\
\009\009\009\009clr()\
\009\009\009\009stc(colors.white)\
\009\009\009\009scp(1,1)\
\009\009\009\009return \
\009\009\009end\
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
\009\009\009 \009   if(e[2] == 1 and not inmenu)then\
\009\009\009\009 \009 \009if(fs.isDir(sideitems[syind].href) and sideitems[syind].t ~= \"text\")then\
\009\009\009\009 \009 \009    selectedside = syind\
\009\009\009\009 \009 \009  \009openHref(sideitems[syind].href)\
\009\009\009\009 \009 \009  \009drawSideBar()\
\009\009\009\009 \009 \009elseif(sideitems[syind].t ~= \"text\")then\
\009\009\009\009 \009 \009  \009if(selectedside == syind)then\
\009\009\009\009 \009 \009  \009 \009openHref(sideitems[syind].href)\
\009\009\009\009 \009 \009  \009else\
\009\009\009\009 \009 \009  \009    selectedside = syind\
\009\009\009\009 \009 \009  \009 \009drawSideBar()\
\009\009\009\009 \009 \009  \009end\
\009\009\009\009 \009 \009end\
\009\009\009\009   elseif(e[2] == 2)then\
\009\009\009\009   \009\009if(selectedside ~= 0)then\
\009\009\009\009 \009 \009\009opencloseMenu(\"sidebar\",x,y)\009\
\009\009\009\009 \009 \009end\
\009\009\009 \009   end\
\009\009\009 \009 end\
\009\009\009 elseif(yind <= #files and yind > 0)then\
\009\009 \009 \009if(y > 4 and x >= 18 and x <= 22+#files[yind].n)then\
\009\009 \009 \009   if(e[2] == 1 and not inmenu)then\
\009\009\009 \009 \009  if(file_selected == yind)then\
\009\009\009 \009 \009  \009if(fs.isDir(path:getraw() .. files[file_selected].n))then\
\009\009\009 \009 \009  \009\009if(inmenu)then inmenu = false end\
\009\009\009 \009 \009  \009 \009addDir(files[yind].n)\
\009\009\009 \009 \009  \009 else\
\009\009\009 \009 \009  \009 \009 runFile(path:getraw() .. files[file_selected].n)\
\009\009\009 \009 \009  \009end\
\009\009\009 \009 \009  else\
\009\009\009 \009 \009  \009 file_selected = yind\
\009\009\009 \009 \009  \009 drawFiles()\
\009\009\009 \009 \009  end\
\009\009\009 \009   elseif(e[2] == 2)then\
\009\009\009 \009   \009   if(file_selected == yind)then\
\009\009\009 \009   \009   \009\009opencloseMenu(\"reg\",x,y,yind)\
\009\009\009 \009   \009   else\
\009\009\009 \009   \009   \009\009opencloseMenu(\"new\",x,y,yind)\
\009\009\009\009\009   end\
\009\009 \009 \009   end\
\009\009 end\
\009\009end\
\009\009if(e[2] == 2 and not inmenu and x > 18)then\
\009\009 \009opencloseMenu(\"new\",x,y,1)\
\009\009end\
\009end\
\009if(e[1] == \"mouse_scroll\")then\
\009\009local dir = e[2]\
\009\009local x,y = e[3], e[4]\
\009\009if(dir == -1)then\
\009\009\009if(x > 16 and fileoffs > 0 )then\
\009\009\009\009fileoffs = fileoffs - 1\
\009\009\009\009drawFiles()\
\009\009\009elseif(x <= 16 and sideoffs > 0)then\
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
function displayError(err)\
\009sbc(colors.white)\
\009clr()\
\009stc(colors.gray)\
\009ugapi.writecy(\" Well, thats not supposed to happen. \",1)\
\009scp(2,3)\
\009stc(colors.lightGray)\
\009write(err)\
\009ugapi.writecy(\" Why you do dis to me :(. \",16)\
\009stc(colors.black)\
\009ugapi.writecy(\" Press any key to end NovaExplore. \",17)\
\009ugapi.writecy(\"  Click to restart NovaExplore. \",18)\
\009local e = {os.pullEvent()}\
\009if(e[1] == \"key\")then \
\009\009sbc(colors.black)\
\009\009clr()\
\009\009stc(colors.white)\
\009\009scp(1,1)\
\009elseif(e[1] == \"mouse_click\")then\
\009\009local odir = shell.dir()\
\009\009shell.setDir(\"\")\
\009\009shell.run(shell.getRunningProgram())\
\009\009shell.setDir(odir)\
\009end\
end\
function clickExit()\
\009scp(w,1)\
\009stc(colors.black)\
\009sbc(colors.pink)\
\009write(\"X\")\
\009sleep(0.2)\
\009scp(w,1)\
\009stc(colors.white)\
\009sbc(colors.red)\
\009write(\"X\")\
end\
function checkUpdate()\
\009if(http)then\
\009\009local upd = http.get(\"http://pastebin.com/raw/rpipr5pT\")\
\009\009if(upd ~= nil)then\
\009\009\009local cont = upd.readAll()\
\009\009\009local f = fs.open(shell.getRunningProgram(),\"r\")\
\009\009\009local pcont = f.readAll()\
\009\009\009f.close()\
\009\009\009if(cont ~= pcont)then\
\009\009\009\009local ans = openYesNo(\"Auto update\", \"Update detected, would you * like to update?.\")\
\009\009\009\009if(ans == 1)then\
\009\009\009\009\009local f = fs.open(shell.getRunningProgram(),\"w\")\
\009\009\009\009\009f.write(cont)\
\009\009\009\009\009f.close()\
\009\009\009\009\009notify(\"Auto update\", \"Updated, restart required.\")\
\009\009\009\009\009innova = false\
\009\009\009\009\009return shell.run(shell.resolveProgram(shell.getRunningProgram()))\
\009\009\009\009end\
\009\009\009end\
\009\009else\
\009\009\009notify(\"Auto update\", \"Failed to connect to pastebin.\")\
\009\009end\
\009else\
\009\009notify(\"Auto update\", \"Http is disabled, Failed to * check for updates.\")\
\009\009return\
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
\009scp(w,1)\
\009stc(colors.white)\
\009sbc(colors.red)\
\009write(\"X\")\
\009sbc(colors.black)\
end\
drawMain()\
getfiles()\
drawFiles()\
getPinnedNames()\
checkUpdate()\
\
local function loop()\
\009while innova do \
\009\009local e = {os.pullEvent()}\
\009\009update(e)\
\009end\
end\
local ok, err = pcall(loop)\
if(not ok)then\
\009if(term.current().setVisible)then\
\009\009term.current().setVisible(true)\
\009end\
\009displayError(err)\
end",
  },
  [ "//ugapi" ] = {
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
}

function file_write(file,data,s)
    local f = fs.open(file,"w")
    if(s)then f.write(textutils.serialize(data)) else
    f.write(data) end
    f.close()
end

write("Extract to: ")
local loc = read()
if(loc == "")then
  write("Extraction cancelled. ")
else
    local cont = textutils.serialize(content)
    for k,v in pairs(textutils.unserialize(cont)) do
          file_write(loc .. k,v.content)
          print("Extracting " .. k .. " to " .. loc .. k)
    end
    print("Files extracted to: " .. loc)
end
