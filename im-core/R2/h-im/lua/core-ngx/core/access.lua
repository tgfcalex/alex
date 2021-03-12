--
--

local public     = require("public")
local log        = require("log")
local ipmatcher  = require("resty.ipmatcher")
local getenv     = os.getenv

local host       = ngx.var.host
local addr       = ngx.var.remote_addr

-- 获取配置
--local check_host = public.get_check_host()
--local white_list = public.get_ip_white_list()
local check_host = getenv("check_host")
local white_list = getenv("ip_white_list")

local check_host_table = public.split(check_host, ",")
local white_list_table = public.split(white_list, ",")

local ip = ipmatcher.new(white_list_table)

if ip:match(addr) == true then
    log.info("addr : " .. addr .. " 是白名单")
    return
end

for _, v in pairs(check_host_table) do
    if v == host then
        public.limit()
        public.checkSignature()
        return
    end
end
