-- by will, jeff, wayne


--package.cpath = '/usr/local/openresty/nginx/script/lua/module/cpath/?.so;'.. package.cpath
package.path  = '/usr/local/openresty/nginx/script/lua/?.lua;'.. package.path

require "resty.core"

---------------------------------------------------- common functions begin ----------------------------------------------------------
--- Check if a file or directory exists in this path
function exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then return true end  -- Permission denied, but it exists
   end
   return ok, err
end


function string.trim(s)  -- 支持字符串前后 trim
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function ipv4StringToNum(ipv4)
    local o1, o2, o3, o4 = ipv4:match("(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)")
    local num = 2 ^ 24 * o1 + 2 ^ 16 * o2 + 2 ^ 8 * o3 + o4
    return tonumber(num)
end

function ngx_say_resp(info, status)
    ngx.status = status
    if type(info) == 'table' and next(info) ~= nil then
        ngx.header['Content-Type'] = 'application/json; charset=utf-8'
        local cjson_safe = require "cjson.safe"
        ngx.say(cjson_safe.encode(info))
    else
        ngx.header['Content-Type'] = 'text/html; charset=utf-8'
        ngx.say(info)
    end
    ngx.exit(ngx.status)
end

function get_resp_body()  -- body_filter_by_lua* 适用
    local chunk, eof= ngx.arg[1], ngx.arg[2]
    ngx.ctx.buffered = (ngx.ctx.buffered or "") .. chunk
    if eof == true then
        local resp_content = ngx.ctx.buffered
        local zlib = require "zlib"
        local stream = zlib.inflate()
        local status, result  = pcall(stream, resp_content)  -- 解压
        if status then resp_content = result  end
        ngx.ctx.buffered = nil
        return  resp_content
    end
end

---------------------------------------------------- 解析 env_json   -----------------------------------------------------
-- 初始化配置 table
domain_env_tbl = {} -- table(domain, table(key, value))
siteid_env_tbl = {}        -- table('adm'/'site', table(site_id, table(key, value)))
env_vars = {}       -- talbe('adm'/'site'/'3rd', table(key, value))

function table_from_file(file)
    local tbl, err = {}, nil
    local f, _err= io.open(file, "rb")
    if f == nil then
        err =  _err
    else
        local jsonstr = f:read("*all")
        f:close()
        local cjson_safe = require "cjson.safe"
        tbl, err = cjson_safe.decode(jsonstr)
        if tbl == nil then
            err =  filename .. ": ".. err
        end
    end
    return tbl, err
end

function parse_env_conf_by_domain(origin_domain_tbl)
    local res_tbl = {}
    local ngx_re = require "ngx.re"
    for stype, value in pairs(origin_domain_tbl) do
        local domains = value['domains']
        if domains ~= '' then
            local domain_tbl = ngx_re.split(domains, ',')
            for _, domain in pairs(domain_tbl) do
                local prop_value_tbl = {}
                for prop, prop_value in pairs(origin_domain_tbl[stype]) do
                    if prop ~= 'except' and prop ~= "domains" then
                        prop_value_tbl[prop] = prop_value
                    end
                end
                prop_value_tbl["env_stype"] = stype
                res_tbl[domain] = prop_value_tbl
            end

            local excepts = origin_domain_tbl[stype]['except']
            if excepts ~= nil then
                for _, except_tbl in pairs(excepts) do
                    local domains_tbl = ngx_re.split(except_tbl['domains'], ',')
                    for _, d in pairs(domains_tbl) do  -- 遍历例外域名
                        if res_tbl[d] ~= nil then
                            for p, v in pairs(except_tbl) do
                                if p ~= 'domains' then
                                    res_tbl[d][p] = v
                                end
                            end
                        else
                            ngx.log(ngx.ERR, d, " : Not in <", stype, "> <domains>" )
                        end
                    end
                end
            end
        end
    end
    return res_tbl
end

function _parse_env_conf_core_idc(idc_key, idc_value_tbl, env_tbl)
    local ngx_re = require "ngx.re"
    local site_ids_tbl = ngx_re.split(idc_value_tbl['site_ids'], ',')
    idc_value_tbl['site_ids'] = nil  -- 获取 site_ids_tbl 后, 清除 key: site_ids

    local core_idc_no = (string.gsub(idc_key, "core_idc_", ""))
    for stype, value in pairs(idc_value_tbl) do
        for _, site_id in ipairs(site_ids_tbl) do
            local section = string.format("%s:%s", site_id,stype)
            if env_tbl[section] ~= nil then
                ngx.log(ngx.ERR, section, ' : repeat ID <core_idc_', env_tbl[section]['core_idc_no'], " | core_idc_", core_idc_no, ">")
            else
                local _tmp = {core_idc_no=core_idc_no}
                for conf_key, conf_value in pairs(value) do
                    if conf_key ~= 'except' then
                        _tmp[conf_key] = conf_value
                    end
                end
                env_tbl[section] = _tmp
            end
        end

        local excepts = value['except']
        if excepts ~= nil then
            for _, exc_tbl in pairs(excepts) do
                local exc_id_tbl = ngx_re.split(exc_tbl['site_ids'], ',')
                for _, exc_id in ipairs(exc_id_tbl) do  -- 遍历例外站点
                    local exc_section = string.format("%s:%s", exc_id,stype)
                    if env_tbl[exc_section] ~= nil then
                        for exc_key, exc_vlue in pairs(exc_tbl) do
                            if exc_key ~= 'site_ids' then
                                env_tbl[exc_section][exc_key] = exc_vlue
                            end
                        end
                    else
                        ngx.log(ngx.ERR, id, ': except ID not in site_ids')
                    end
                end
            end
        end
    end
end

function parse_env_conf_core_idc(env_conf_tbl)
    env_conf_tbl["by_domain"] = nil  --不处理 by_domain
    local res_tbl = {}
    for idc_key, idc_value_tbl in pairs(env_conf_tbl) do
        _parse_env_conf_core_idc(idc_key, idc_value_tbl, res_tbl)
    end
    return res_tbl
end

---------------------------------------------------- redis   -----------------------------------------------------

function connect_redis()  -- 连接redis, 使用完后务必自行手动关闭
    local redis = require "resty.redis"
    local red = redis.new()
    red:set_timeout(1000)
    local ok, err = red:connect("unix:/var/run/redis/redis.sock")
    if not ok then
        ngx.log(ngx.ERR, "failed to connect: ", err)
        return nil
    end
    -- 请注意这里 auth 的调用过程, 一次验证, 多次复用
    local count, err = red:get_reused_times()
    if 0 == count then
        local ok, err = red:auth("gamebox123")
        if not ok then
            ngx.log(ngx.ERR, "failed to auth: ", err)
            return
        end
    elseif err then
        ngx.log(ngx.ERR, "failed to get reused times: ", err)
        return
    end
    return red
end

function close_redis(redis_instance)  --关闭redis(放入连接池)
    if not redis_instance then
        return nil
    end
    -- 使用完成的redis对象放入到连池中不要直接close
    -- 设置连接池数量为100,最大闲置为10S
    local ok, _ = redis_instance:set_keepalive(10000, 100)
    if not ok then
        ngx.log(ngx.ERR,"failed to set keepalive: ", err)
        return nil
    end
end
---------------------------------------------------- OP 接口方法   -----------------------------------------------------

function search_location_by_ip(ipv4_str)  -- 根据ip查询ip库，获取其对应的地理位置信息
    local ip_int = ipv4StringToNum(ipv4_str)
    local red = connect_redis()
    red:select('9')
    local value, _ = red:zRangeByScore('ip_db', ip_int, 'inf', 'WITHSCORES', 'LIMIT', '0', '1')
    close_redis(red)
    local result = {}
    if value == nil or value == ngx.null then
        result = "Not Found"
    else
        local ngx_re = require "ngx.re"
        value = ngx_re.split(value[1], ',')
        result["country"] =  value[2] or ngx.null
        result["province"] =  value[3] or ngx.null
        result["city"] =  value[4] or ngx.null
        result["isp"] =  value[5] or ngx.null
    end
    local info = {IP = ipv4_str, IP_int = ip_int, result = result}
    ngx_say_resp(info, 200)

end

---------------------------------------------------- common functions end ----------------------------------------------------------


---------------------------------------------------- 站点信息 begin ----------------------------------------------------
function real_host()
    local _host = ngx.var.host or 'None'
    return _host
end

function client_ip()
    local stype = ngx.var.stype
    local ip
    if stype == 'adm' or stype == 'api' then
        ip = ngx.var.remote_addr
    else
        ip = ngx.var.remote_addr or "0.0.0.0"
    end
    --local headers = ngx.req.get_headers()
    --local ip = headers["X-REAL-IP"] or headers["X_FORWARDED_FOR"] or ngx.var.remote_addr or "0.0.0.0"
    return ip
end

function conf_from_tbl(tbl, sections, conf_key)
    if tbl ~= nil and sections ~= nil and conf_key ~= nil then
        local sections_tbl = tbl[sections]
        if sections_tbl ~= nil then
            local var = sections_tbl[conf_key]
            if var ~= nil then
                return var
            end
        end
    end
    return nil
end

function update_env_tbl(tbl, sections, key, value)
    if sections ~= nil and key ~= nil and value ~= nil then
        if type(tbl[sections]) == 'table' then
            tbl[sections][key] = value
        else
            local tmp_tbl = {}
            tmp_tbl[key] = value
            tbl[sections] = tmp_tbl
        end
    end
end

function config_result(_conf_key, ...)
    local args = {...}
    local  _stype, _domain, _site_id = args[1], args[2], args[3]
    local value, where
    value = conf_from_tbl(env_vars, _stype, _conf_key)                 -- 宿主机 env_vars
    where = 'host'
    if value == nil and _domain ~= nil then
        value = conf_from_tbl(domain_env_tbl, _domain, _conf_key)      -- 域名 domain_env_tbl
        where = 'domain_env_tbl'
        if value == nil and _site_id ~= nil then
            local section = string.format("%s:%s", _site_id, _stype)
            value = conf_from_tbl(siteid_env_tbl, section, _conf_key)  -- 站点id stype_tbl
            where = 'siteid_env_tbl'
        end
    end
    if where == 'siteid_env_tbl' and value ~= nil then
        local _ = update_env_tbl(domain_env_tbl, _domain, _conf_key, value)
    end
    return value, where
end

function domain_info_from_rds(domain, field)
    -- 获取域名接口信息， field 包括"siteId", "domainSubsysCode", "pageUrl"
    local rds_key = 'domain:' .. domain
    local red = connect_redis()
    red:select(0)
    local res, _ = red:hget(rds_key, field)
    close_redis(red)
    if not res or res == ngx.null then return nil end
    local _ = update_env_tbl(domain_env_tbl, domain, field, res)
    return res
end

function domain_info(domain, conf_key)
    local res, where
    res = conf_from_tbl(domain_env_tbl, domain, conf_key)  -- 域名 domain_env_tbl
    where = 'domain_env_tbl'
    if res == nil then
        res = domain_info_from_rds(domain, conf_key)       -- 从 redis 获取
        where = 'redis'
    end
    return res, where
end

function site_info_from_rds(site_id)
    local rds_key = 'site:' .. site_id
    local red = connect_redis()
    red:select(0)
    local res, _ = red:get(rds_key)
    close_redis(red)
    if not res or res == ngx.null then return nil end
    return res
end

---------------------------------------------------- 站点信息 end -----------------------------------------------------


---------------------------------------------------- 资源白名单处理 begin ----------------------------------------------------
---------------------------------------------------- 静态资源路径白名单处理 end ----------------------------------------------------

---------------------------------------------------- 维护处理 begin ----------------------------------------------------
function maintenance_info(stype)
    if stype == 'api' then
        local info = {code = "M001",message = "系统维护中"}
        ngx_say_resp(info, 607)
    end

    --return ngx.exec('/__error_/608.html')
    local file = '/usr/local/openresty/nginx/html/'.. stype .. '/608.html'
    local f = io.open(file)
    local info
    if f ~= nil then
        info = f:read("*a")
        f:close()
    end
    ngx_say_resp(info, 607)
end
---------------------------------------------------- 维护处理 end -----------------------------------------------------

function is_mobile()
    local from_cookies = ngx.var.cookie_ACCESS_TERMINAL
    if from_cookies ~= nil then
        if from_cookies == 'mobile' then
            return "true"
        end
    end
    local _ua = ngx.req.get_headers().user_agent or '-'
    local _ua = string.lower(_ua)
    local m = ngx.re.find(_ua, [[ios|android|ip(ad|hone|od)|kindle|blackberry|windows (ce|phone)]], "joi")
    if m then
        return 'true'
    end
    return 'false'
end

---------------------------------------------------- ip白名单 begin ----------------------------------------------------
---------------------------------------------------- ip白名单 end -----------------------------------------------------


---------------------------------------------------- ip黑名单 begin ----------------------------------------------------
---------------------------------------------------- ip黑名单 end -----------------------------------------------------


---------------------------------------------------- 国家地区访问限制 begin ----------------------------------------------------
---------------------------------------------------- 国家地区访问限制 end -----------------------------------------------------


---------------------------------------------------- 访问次數限制 begin ----------------------------------------------------
function denycc(token, count, seconds)
    count = 1
    seconds = 30
    local limit = ngx.shared.lua_cache
    local req,_=limit:get(token)
    if req then
        if req > count then
             ngx.exit(503)
            return true
        else
             limit:incr(token, 1)
        end
    else
        limit:set(token, 1, seconds)
    end
    return false
end

---------------------------------------------------- 访问次數限制 end ------------------------------------------------------

function decompress_str(_str)
    local table_insert = table.insert
    local table_concat = table.concat
    local zlib = require("ffi-zlib")
    local count = 0
    local output_table = {}
    local chunk = 16384

    local input = function(bufsize)
        local start = count > 0 and bufsize*count or 1
        local data = _str:sub(start, (bufsize*(count+1)-1) )
        count = count + 1
        return data
    end

    local output = function(data)
        table_insert(output_table, data)
    end
    -- local ok, err = zlib.deflateGzip(input, output, chunk)
    local ok, err = zlib.inflateGzip(input, output, chunk)
    if not ok then
        return nil, err
    end
    local output_data = table_concat(output_table,"")
    return output_data
end

---------------------------------------------------- 跳轉處理 begin ----------------------------------------------------
---------------------------------------------------- 跳轉處理 end ------------------------------------------------------


---------------------------------------------------- html缓存 begin ----------------------------------------------------
---------------------------------------------------- html缓存 end ----------------------------------------------------
function get_random(num)  -- 生成16进制字符串，变量num指定长度
    local resty_random = require "resty.random"
    local resty_str = require "resty.string"
    local random = resty_str.to_hex(resty_random.bytes(num))
    return random
end

function is_flush_op_cookies(_client_ip)
    local opid = ngx.var.cookie_opid
    if(opid == nil) then
        opid = get_random(4)
    end
    local opkey = ngx.md5(_client_ip .. opid .. 'tim')
    if (ngx.var.cookie_opkey ~= opkey) then
        local expires = ngx.cookie_time(ngx.time() + 60 * 5)
        ngx.header["Set-Cookie"] = {
            "opkey=" .. opkey..';Path=/;Expires='..expires,
            "opid="  .. opid ..';Path=/;Expires='..expires
        }
        return true
    else
        return false
    end
end

---------------------------------------------------- ssl处理 begin ----------------------------------------------------
function is_have_ssl(server_name)
    --检查当前访问的域名是否有对应的ssl证书，用于是否强制跳转https的判断
    local pay_ssl_path =  "/var/lb/ssl/pay/"
    local free_ssl_path = "/var/lb/ssl/free/"
    server_name = string.gsub(server_name, "^www%.", "")

    local payf = pay_ssl_path .. server_name .. ".pem"
    local freef = free_ssl_path .. server_name .. "/fullchain1.pem"

    local is_have_ssl, _ = exists(payf)
    if not is_have_ssl then
        is_have_ssl, _ = exists(freef)
    end
    return is_have_ssl
end

function https_response(domain, port, uri)
    local _content = 'https://'..domain..port..uri
    return ngx.redirect(_content, 301)
    --local html = [[<html><meta http-equiv="refresh" content="0;url=https://%s%s%s"></html>]]
    --local _content = string.format(html, domain, port, uri)
    --ngx_say_resp(_content, 200)
end

---------------------------------------------------- ssl处理 end ----------------------------------------------------


---------------------------------------------------- 获取配置参数 begin ----------------------------------------------------

---------------------------------------------------- 获取配置参数 end   ----------------------------------------------------
function init_env_vars(file)
    -- 取值优先的宿主机配置, 读文件直接获取加载到内存
    local ok, err = {}, nil
    if exists(file) then
        ok, err = table_from_file(file)
    end
    return ok, err
end


-- 初始化
function init()
    domain_env_tbl, siteid_env_tbl, env_vars = {}, {}, {}  -- 清空

    local env_conf_file = '/usr/local/openresty/nginx/conf/common/env-conf.json'
    local origin_env_tbl = table_from_file(env_conf_file)
    if origin_env_tbl ~= nil then
        if origin_env_tbl["by_domain"] ~= nil then  -- 域名
            domain_env_tbl = parse_env_conf_by_domain(origin_env_tbl["by_domain"])
            origin_env_tbl["by_domain"] = nil  -- 用完清掉
        end
        -- siteid_env_tbl
        siteid_env_tbl = parse_env_conf_core_idc(origin_env_tbl)
    end

    env_vars = init_env_vars('/var/lb/conf/env')

    return  domain_env_tbl and siteid_env_tbl and env_vars
end


local _ = init()


--[[
---------------------- env_vars -------------------

env_vars =
{
  "adm": {
    "conf_key1": "conf_value1",
    "conf_key2": "conf_value2"
  },
  "site": {
    "conf_key1": "conf_value1",
    "conf_key2": "conf_value2"
  },
  "3rd": {
    "conf_key1": "conf_value1",
    "conf_key2": "conf_value2"
  }
}

---------------------- domain_env_tbl -------------------
domain_env_tbl =
{
  "domain1": {
    "conf_key1": "conf_value1",
    "conf_key2": "conf_value2"
  },
  "domain2": {
    "conf_key1": "conf_value1",
    "conf_key2": "conf_value2"
  },
  "domain3": {
    "conf_key1": "conf_value1",
    "conf_key2": "conf_value2"
  }
}

---------------------- env_tbl -------------------
env_tbl =
{
  "site_id1:adm": {
      "conf_key1": "conf_value1",
      "conf_key2": "conf_value2"
    },
  "site_id2:adm": {
      "conf_key1": "conf_value1",
      "conf_key2": "conf_value2"
  },
  "site_id1:site": {
      "conf_key1": "conf_value1",
      "conf_key2": "conf_value2"
  }
  "site_id2:site": {
      "conf_key1": "conf_value1",
      "conf_key2": "conf_value2"
  }
}

]]