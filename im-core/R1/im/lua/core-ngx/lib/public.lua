
module(..., package.seeall)

local ngx           = ngx
local tonumber = tonumber
local string     = string
local table     = table

local public     = require("public")
local log        = require("log")
local rds        = require("resty.redis_iresty")
local limit_req  = require("resty.limit.req")
local cjson_safe = require("cjson.safe")
local uuid       = require("resty.jit-uuid")
local http       = require("resty.http")


-----------------------------
local base_table = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9"}

-- 获取配置文件
local filepath = '/usr/local/openresty/nginx/lua/config/nacos.config'
--local rdspath = '/usr/local/openresty/nginx/lua/config/rds.config'

--读取配置文件
function readfile(_filepath)
    local f    = io.open(_filepath, "r")
    local file = f:read("*all")
    f.close()
    return file
end

--计分函数
local function socre_incr(_dict, _args, _score, _ttl)
    if _dict:get(_args) then
        _dict:incr(_args, _score)
    else
        _dict:safe_add(_args, _score, _ttl)
    end
    return
end
--split函数
function split(str, separator)
    local start_index = 1
    local split_index = 1
    local reslut = {}

    while true do
       local last_index = string.find(str, separator, start_index)
       if not last_index then
           reslut[split_index] = string.sub(str, start_index, #str)
           break
       end
           reslut[split_index] = string.sub(str, start_index, last_index - 1)
           start_index = last_index + #separator
           split_index = split_index + 1
       end
       return reslut
end

--url encode
function url_encode(_s)
    _s = string.gsub(_s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(_s, " ", "+")
end

--url decode
function url_decode(_s)
    _s = string.gsub(_s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return _s
end

--json转table
function json_decode(_data)
    local json = cjson_safe.decode(_data)
    return json
end

--table转json
function json_encode(_data)
    local json = cjson_safe.encode(_data)
    return json
end

function ali_check_url_encode(_s)
    _s = string.gsub(_s, "([^%w%.%-%_%~ ])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    _s = string.gsub(_s, " ", "+")
    _s = string.gsub(_s, "+", "%%20")
    return _s
end

--获取get value 函数
function get_uri_args()
    local args, err = ngx.req.get_uri_args()

    if err == "truncated" then
        log.error("truncated", err)
    end

    if not args then
        log.error("failed to get uri args: ")
        return
    end

    local xx = {}

    for key, value in pairs(args) do
        if key ~= "signatureNonce" then
            xx[key] = value
        end
    end
    return xx
end

--获取post value 函数
function get_post_args()
    local args, err = ngx.req.get_post_args()
    if err == "truncated" then
        log.error("truncated", err)
    end

    if not args then
        log.error("failed to get uri args: ", err)
        return
    end

    local xx = {}
    for key, val in pairs(args) do
        if type(public.json_decode(key)) == "table" then
            -- json 方式
            xx = public.json_decode(key)
            -- 排除 signatureNonce 字段
            xx["signatureNonce"] = nil
        else
            -- form表单方式
            if key ~= "signatureNonce" then
                xx[key] = val
            end
        end
    end
    return xx
end
-----------------------------
--get configs
function nacos_get_configs(_server, _dataid, _group, _tenant)

    local method       = 'GET'
    local default_path = '/nacos/v1/cs/configs'
    local path         = table.concat({default_path, '?dataId=', _dataid, '&group=', _group, '&tenant=', _tenant})

    local httpc = http:new()
    httpc:set_timeout(5000)
    local resp, err = httpc:request_uri( _server,
        {
            method     = method,
            path       = path,
        })

    if not resp then
        log.error("nacos request error:", err)
        return
    end

    local data    = resp.body
    httpc:close()

    return data
end
-----------------------------
--ngx.print 函数
function ngx_say(_code)
    local msg = { code = _code, msg = "" }
    local info = json_encode(msg)
    ngx.print(info)
end

-- 获取配置文件信息ali
function get_config()
    local config   = json_decode(readfile(filepath))
    return config
end

-- 获取配置文件信息
function get_rds_config()
    local config   = json_decode(readfile(rdspath))
    return config
end
-- 获取需要拦截的 host
function get_check_host()
    local cache = ngx.shared.nacos_public
    if cache then
        local check_host = cache:get("check_host")
        if check_host then
            return check_host
        end
    end
    -- 如果缓存为空，取配置文件中的值
    return get_config().check_host
end

-- 获取ip白名单
function get_ip_white_list()
    local cache = ngx.shared.nacos_public
    if cache then
        local ip_white_list = cache:get("ip_white_list")
        if ip_white_list then
            return ip_white_list
        end
    end
    -- 如果缓存为空，取配置文件中的值
    return get_config().ip_white_list
end

function is_white(_addr)

end

function limit()
    -- 获取规则，json --> table
    --local rule = json_decode(nacos_get_configs(nacos_limit.server, nacos_limit.dataid, nacos_limit.group, nacos_limit.tenant))
    local rules = json_decode(ngx.shared.nacos_limit_rules:get("rules"))

    local uri = ngx.var.uri
    -- 默认不需要限制
    local flag = false;
    local rule = nil
    for _, v in pairs(rules) do
        rule = v
        local interface = rule["interface"]
        -- 完全匹配
        if interface == uri then
            flag = true
            break
        end

        -- 包含 ** ，接口通配，以 通配前缀开头的接口，匹配规则
        local from, to, err = ngx.re.find(interface, "[%*%*]+", "jio")
        if from then
            local m = string.sub(interface, 1, from-1)
            local f, t, e = ngx.re.find(uri, m, "jo")
            if f then
                flag = true
                break
            end
        end
    end

    if not rule or flag == false then
        -- 没有触发规则，直接通过
        return
    end

    -- 判断 header 是否存在 limit_key
    local limit_key  = rule.limit_key
    local headers    = ngx.req.get_headers()
    local header_key = headers[limit_key]
    if not header_key then
        return ngx.exit(403)
    end
    
    local json_content_type = "application/json";

    local key = table.concat({"checkUser", ":", uri , "_" , header_key})
    local black_key = key .. "_" .. "black"

    -- 查询redis 是否存在 rule.score
    local redis_db    = json_decode(ngx.shared.nacos_redis:get("rds"))
    local redis   = rds:new(redis_db)
    redis:select(0)
    --local is_limit = redis:get(key)
    local black_value = redis:get(black_key)

    --if is_limit and tonumber(is_limit) > rule.scores then
    if black_value then
        -- 已经限制了，返回异常
        --local content_type = headers["Content-Type"]
        --local check_content_type = string.find(content_type, json_content_type)
        --if check_content_type then
	    --    ngx.header["Content-Type"] = headers["Content-Type"]
	    --end
        ngx.header.content_type = json_content_type
        --ngx_say("-9000")
        local msg = { code = "-9000", msg = "", validateCode = black_value }
        local info = json_encode(msg)
        ngx.print(info)
        return ngx.exit(200)
    end

    local is_limit  = redis:incr(key)
    redis:expire(key,rule.ttl)

    -- 加完次数，达到限制，锁3600秒
    if is_limit >= rule.scores then
        -- 设置时间种子
        -- 把 os.time()返回的数值字串倒过来再取高位7位。 这样，即使 os.time()变化很小,随机数种子也会很大
        math.randomseed(tostring(os.time()):reverse():sub(1, 7))
        local validate_code = {}
        for i = 1, 32 do
            table.insert (validate_code, base_table[math.random(1,table.getn(base_table))])
        end
        black_value = table.concat(validate_code)
        redis:set(black_key, black_value)
        redis:expire(black_key, rule.close_time)
    end
    return
end

-- 验证签名
function checkSignature()

    local _check_json = ngx.shared.nacos_signature_check:get("check_nacos")
    local _method     = ngx.var.request_method

    local request_uri = ngx.var.uri

    -- 默认不需要验签
    local flag = false;

    --local expireTime   = _check['expireTime']
    --local signatureKey = _check['signatureKey']
    local expireTime   = 1
    local signatureKey = "token"
    local checkList = public.json_decode(_check_json)
    for i, v in pairs(checkList) do
        local checkTable = checkList[i]
        local interface = checkTable["interface"]
        -- 完全匹配
        if interface == request_uri then
            flag = checkTable["check"]
            expireTime   = checkTable['expireTime']
            signatureKey = checkTable['signatureKey']
            break
        end

        -- 包含 ** ，接口通配，以 通配前缀开头的接口，匹配规则
        local from, to, err = ngx.re.find(interface, "[%*%*]+", "jio")
        if from then
            local m = string.sub(interface, 1, from-1)
            local f, t, e = ngx.re.find(request_uri, m, "jo")
            if f then
                flag = checkTable["check"]
                expireTime   = checkTable['expireTime']
                signatureKey = checkTable['signatureKey']
                break
            end
        end
    end

    if flag == false then
        --ngx.say("不需要验证")
        return
    end
    log.info("method = " .. _method .. ", uri = " .. request_uri .. " , expireTime = " .. expireTime .. " , signatureKey : ".. signatureKey .. " , check : " .. tostring(flag))

    local redis_db    = json_decode(ngx.shared.nacos_redis:get("rds"))
    local redis   = rds:new(redis_db)

    local headers = ngx.req.get_headers()

    -- 获取uri/post args
    local args = nil
    if _method == 'GET' then
        args = get_uri_args()
    else
        args = get_post_args()
    end

    local token     = headers[signatureKey]
    local signature = headers['signature']
    local userId    = headers['userId']

    local nonceStr          = args['nonceStr']
    local timeStamp         = args['timeStamp']
    local signatureVersion  = args['signatureVersion']

    log.info(request_uri .. " 参数 : " .. public.json_encode(args))
    --没有 token 不需要验证，没有 signatureVersion ，老版本，不验证
    if not token or not signatureVersion then
        return
    end

    local json_content_type = "application/json"

    --必要条件不能为nil
    if not signature or not timeStamp or not userId or not nonceStr then
        log.error(request_uri .. " 必要参数为空")
	    --local content_type = headers["Content-Type"]
        --local check_content_type = string.find(content_type, json_content_type)
        --if check_content_type then
        --    ngx.header["Content-Type"] = headers["Content-Type"]
        --end
        ngx.header.content_type = json_content_type
        ngx_say("-9001")
        return ngx.exit(200)
    end

    --token
    if signatureKey then
        --signature
        if not signature then
            log.error(request_uri .. " 签名参数为空")
	        --local content_type = headers["Content-Type"]
            --local check_content_type = string.find(content_type, json_content_type)
            --if check_content_type then
            --    ngx.header["Content-Type"] = headers["Content-Type"]
            --end
            ngx.header.content_type = json_content_type
            ngx_say("-9001")
            return ngx.exit(200)
        end

        ------------------------------------------------
        --timestamp
        --1578022766.681 --> 1578022766681
        local time_ng         = ngx.now() * 1000
        local check_timestamp = time_ng - timeStamp
        if check_timestamp > expireTime * 1000 then
            log.error(request_uri .. " 请求已过期。check_timestamp : " .. check_timestamp .. " , time_ng : " .. time_ng)
	        --local content_type = headers["Content-Type"]
            --local check_content_type = string.find(content_type, json_content_type)
            --if check_content_type then
            --    ngx.header["Content-Type"] = headers["Content-Type"]
            --end
            ngx.header.content_type = json_content_type
            ngx_say("-9002")
            return ngx.exit(200)
        end

        ------------------------------------------------
        --nonceStr
        redis:select(0)
        local key          = 'checkSign'
        local uri          = { request_uri, "_", userId, "_", nonceStr }
        local value        = table.concat(uri)
        local key_all      = table.concat({key,":",value})
        local rds_nonceStr = redis:get(key_all)
        if rds_nonceStr then
            log.error(request_uri .. " 请求重复。rds_nonceStr : " .. rds_nonceStr)
	        --local content_type = headers["Content-Type"]
            --local check_content_type = string.find(content_type, json_content_type)
            --if check_content_type then
            --    ngx.header["Content-Type"] = headers["Content-Type"]
            --end
            ngx.header.content_type = json_content_type
            ngx_say("-9003")
            return ngx.exit(200)
        end

        redis:set(key_all, value)
        redis:expire(key_all, expireTime)

        ------------------------------------------------
        --method 键值排序
        local tb_sort = {}
        for i in pairs(args) do
            table.insert(tb_sort, i)
        end
        table.sort(tb_sort)

        --拼接字符串
        local param_str = ""
        for i, v in pairs(tb_sort) do
            param_str = table.concat({param_str,public.url_encode(v),"=",public.url_encode(args[v]),"&"})
        end

        ------------------------------------------------

        local signatureNonce  = string.sub(token, 6, 15)
        local info            = {param_str, 'signatureNonce', "=", signatureNonce}
        log.info(request_uri .. " 签名参数。 info : " .. table.concat(info))

        local check_signature = ngx.md5(table.concat(info))

        if string.lower(check_signature) ~= string.lower(signature) then
            log.error(request_uri .. " 签名验证失败。 signature : " .. signature .. " , check_signature : " .. check_signature)
            --local content_type = headers["Content-Type"]
            --local check_content_type = string.find(content_type, json_content_type)
            --if check_content_type then
            --    ngx.header["Content-Type"] = headers["Content-Type"]
            --end
            ngx.header.content_type = json_content_type
            ngx_say("-9001")
            return ngx.exit(200)
        end
    end

    --ngx_say("200")
    return
end
