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
local _root = '/var/gb/conf/download/'
local _uri = ngx.var.uri
local ori_path = _root.._uri
--local app_host = ngx.var.host
local app_host = "dsda3112.com"
if not file_exists(ori_path) then
    ngx.exit(404)
end
local plist_host = ngx.var.http_plisthost
if plist_host == nil then
    real_uri = _uri
else
    real_uri = '/rewrite/'..plist_host.._uri
    real_path = _root..real_uri
    if not file_exists(real_path) then
        content = read_common_file(ori_path)
        rewrite_content = string.gsub(content, app_host, plist_host);
        write_common_file(rewrite_content, real_path)

    end
end
ngx.req.set_uri(real_uri)
