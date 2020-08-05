#!/usr/bin/env lua
--
-- Created by IntelliJ IDEA.
-- User: tim
-- Date: 18-12-7
-- Time: 上午9:34
-- To change this template use File | Settings | File Templates.
--

function file_exists(filename)
    local file = io.open(filename, "rb")
    if file then file:close() end
    return file ~= nil
end
function read_common_file(filename)
    local f = ""
    local content = ""
    f = io.input(filename)
    content = io.read("*a")
    f:close()
    return content
end
function write_common_file(content, filename)
    local f = ""
    if not file_exists(filename) then
        os.execute('mkdir -p '..'$(dirname '..filename..')')
    end
    f = io.output(filename)
    io.write(content)
    io.flush()
    io.close()
end
local _root = '/var/download/gb/'
local _uri = ngx.var.uri
local ori_path = _root.._uri
local app_host = 'dsda3112.com' -- 模板文件域名
if not file_exists(ori_path) then
    ngx.exit(404)
end

local plist_host = ngx.var.host  -- 替换成实际域名
if plist_host == 'dsda3112.com' or plist_host == nil then
    return
else
    content = read_common_file(ori_path)
    rewrite_content = string.gsub(content, app_host, plist_host)
    ngx.header["Content-Disposition"]= "attachment;"
    ngx.say(rewrite_content)
    ngx.exit(200)
end
