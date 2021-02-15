if(not(tool:IfDir('./plugins/faith/player/')))then
	tool:CreateDir('./plugins/faith/')
	tool:CreateDir('./plugins/faith/player/')
end
if(not(tool:IfFile('./plugins/faith/nickname.json')))then
	tool:WriteAllText('./plugins/faith/nickname.json','{\n\t"§2N§3M§4S§eL":200,\n\t"§eCreeper!":150\n}')
end
if(not(tool:IfFile('./plugins/faith/onuse.json')))then
	tool:WriteAllText('./plugins/faith/onuse.json','{}')
end
local json = require("./plugins/faith/dkjson")
local formidd = {}
local nickname = json.decode(tool:ReadAllText('./plugins/faith/nickname.json'))
local onuse = json.decode(tool:ReadAllText('./plugins/faith/onuse.json'))
local page = {}
local config = json.decode(tool:ReadAllText('./plugins/faith/config.json'))
local function checkkkname()
	local nmsl = {}
	for key,value in pairs(nickname)do
		table.insert(nmsl,key)
    end
	return json.encode(nmsl)
end 
local function getnametbale()
	local nmsl = {}
	for key,value in pairs(nickname)do
		table.insert(nmsl,key)
    end
	return nmsl
end 
local function checkifbuy(num,pln)
	local file = io.open('plugins/faith/player/'..pln..'.txt',"r")
	local nick = getnametbale()[num]
	if file then
		for line in file:lines() do
			if(line == nick)then
				io.close(file)
				return true
			end
		end
	end
	return false
end
local function getplnicklist(pln)
	local list = {}
	local file = io.open('./plugins/faith/player/'..pln..'.txt',"r")
	if file then
		for line in file:lines() do
			table.insert(list,line)
		end
	end
	return json.encode(list)
end
local function checkmoney(num)
	return getnametbale()[num]
end
local function getplnicktable(pln)
	local list = {}
	local file = io.open('./plugins/faith/player/'..pln..'.txt',"r")
	if file then
		for line in file:lines() do
			table.insert(list,line)
		end
	end
	return list
end
local function faithname(a)
	if(a.cmd == '/faith')then
		gui = luaapi:createGUI(config["form_title"])
		gui:AddDropdown(config["form_Dropdown"],0,checkkkname())
		gui:AddToggle(config["form_Toggle"])
		page[a.playername] = 'main'
		formidd[a.playername] = gui:SendToPlayer(luaapi:GetUUID(a.playername))
		return false
	elseif(a.cmd == '/faith help')then
		local msg = config["command_help"]
		mc:sendText(luaapi:GetUUID(a.playername),msg)
		return false
	elseif(a.cmd == '/faith list')then
		page[a.playername] = 'chose'
		formidd[a.playername] = mc:sendSimpleForm(luaapi:GetUUID(a.playername),config["command_list"],'',getplnicklist(a.playername))
		return false
	elseif(a.cmd == '/faith view')then
		mc:sendText(luaapi:GetUUID(a.playername),'[§3faith§r] '..config["command_view"]..onuse[a.playername])
		return false
	end
end
function byyyynick(a)
	if(a.formid == formidd[a.playername])and(not(a.selected=='null')and(page[a.playername] == 'main'))then
		se = json.decode(a.selected)
		if(not(se[2]))then
			if(checkifbuy(se[1]+1,a.playername))then
				onuse[a.playername] = getnametbale()[se[1]+1]
				tool:WriteAllText('./plugins/faith/onuse.json',json.encode(onuse))
				mc:sendText(a.uuid,'[§3faith§r] '..config["nick_change"]..onuse[a.playername])
			else
				mc:sendText(a.uuid,'[§3faith§r] '..config["nick_donot_have"])
			end
		else
			if(checkifbuy(se[1]+1,a.playername))then
				mc:sendText(a.uuid,'[§3faith§r] '..config["nick_already_have"])
			else
				if(not(tonumber(mc:getscoreboard(a.uuid,config["scoreboard_name"])) < nickname[checkmoney(se[1]+1)]))then
					tool:AppendAllText('./plugins/faith/player/'..a.playername..'.txt',getnametbale()[se[1]+1]..'\n')
					mc:sendText(a.uuid,'[§3faith§r] '..config["nick_buy_success"])
				else
					mc:sendText(a.uuid,'[§3faith§r] '..string.sub(config["money_donot_enough"],'%money%',nickname[checkmoney(se[1]+1)]))
				end
			end
		end
	elseif(a.formid == formidd[a.playername])and(not(a.selected=='null')and(page[a.playername] == 'chose'))then
		onuse[a.playername] = getplnicktable(a.playername)[tonumber(a.selected)+1]
		tool:WriteAllText('./plugins/faith/onuse.json',json.encode(onuse))
		mc:sendText(a.uuid,'[§3faith§r] '..config["nick_change"]..onuse[a.playername])
	end
end
function jionnonil(a)
	formidd[a.playername] = 'null'
	if(not(tool:IfFile('./plugins/faith/player/'..a.playername..'.txt')))then
		tool:AppendAllText('./plugins/faith/player/'..a.playername..'.txt','')
	end
end
function faithchat(a)
	if(not(onuse[a.playername] == nil))then
		local shat = '<['..onuse[a.playername]..'§r]'..a.playername..'> '..a.msg
		mc:runcmd('tellraw @a {"rawtext":[{"text":"'..shat..'"}]}')
		print('{['..os.date('%Y-%m-%d %H:%M:%S')..' Chat] 玩家 '..a.playername..' 说:'..a.msg)
		--{[2021-02-15 09:43:05 Chat] 玩家 gqf0902 说:哈哈哈
		return false
	end
end		
mc:setCommandDescribe('faith',config["command_describe"])
luaapi:Listen('onLoadName',jionnonil)
luaapi:Listen('onFormSelect',byyyynick)
luaapi:Listen('onInputText',faithchat)
luaapi:Listen('onInputCommand',faithname)
print('[INFO] [Faith] 称号系统加载成功！')
print('[INFO] [Faith] 作者：Lition')
print('[INFO] [Faith] If you have any question , pelase do not hesitate and free contact me! QQ:2959435045')
print('[INFO] [Faith] 当前版本：1.3.0')