
-- 定时更新
local ngx      = ngx
local table    = table

local log      = require("log")
local public   = require("public")
local http     = require("resty.http")

-- 获取nacos变量
--local filepath = '/usr/local/openresty/nginx/lua/config/nacos.config'
--local config   = public.json_decode(public.readfile(filepath))

local config = public.get_config()

local _server = config.nacos_server
local _group  = config.nacos_group
local _tenant = config.nacos_tenant

local _dataid_signature_limit = config.nacos_dataid_rules
local _dataid_public          = config.nacos_dataid_public
local _dataid_redis           = config.nacos_dataid_redis
local _dataid_limit           = config.nacos_dataid_limit
local _time                   = 5

--nacos 变量组装函数
local function param(_dataid)
    local param = {
        _server = _server,
        _dataid = _dataid,
        _group  = _group,
        _tenant = _tenant
    }
    return param
end

--get configs
local function nacos_get_configs(_param)

    local _server = _param._server
    local _dataid = _param._dataid
    local _group  = _param._group
    local _tenant = _param._tenant

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
        log.error("request error:", err)
        return
    end

    local data    = resp.body

    httpc:close()
    return data

end

local function public_config_nacos(premature, _dict, _key, _param)
    if premature then
        return
    end
    log.info("public nacos start")
    local value = nacos_get_configs(_param)
    if value then
        local _table = public.json_decode(value)
        -- 更新至缓存
        for k, v in pairs(_table) do
            _dict:set(k, v)
        end
    end
    log.info("public nacos end")
end

local function nacos_config_update(premature, _dict, _key, _param)
    if premature then
        return
    end
    log.info("update nacos start ")
    local nacos_value = nacos_get_configs(_param)
    if nacos_value then
        -- 更新至缓存
        _dict:set(_key, nacos_value)
    end
    log.info("update  nacos end")
end

local function nacos_config(_code, _second, _func, _dict, _key, _param)
    -- 初始化函数
    if _code == 0 then
        ngx.timer.at(_second, _func, _dict, _key, _param)
    -- 定时更新函数
    elseif _code == 1 then
        ngx.timer.every(_second, _func, _dict, _key, _param)
    end
end

local function init_worker()
    if 0 == ngx.worker.id() then

        -- 初始化 redis info
        --nacos_config(0, 0, nacos_config_update, ngx.shared.nacos_redis, 'rds', param(_dataid_redis))
        --定时更新
        nacos_config(1, _time, nacos_config_update, ngx.shared.nacos_redis, 'rds', param(_dataid_redis))
        -- 初始化 验签规则
        nacos_config(0, 0, nacos_config_update, ngx.shared.nacos_signature_check, 'check_nacos', param(_dataid_signature_limit))
        --定时更新
        nacos_config(1, _time, nacos_config_update, ngx.shared.nacos_signature_check, 'check_nacos', param(_dataid_signature_limit))
        -- 初始化 redis info
        nacos_config(0, 0, nacos_config_update, ngx.shared.nacos_limit_rules, 'rules', param(_dataid_limit))
        --定时更新
        nacos_config(1, _time, nacos_config_update, ngx.shared.nacos_limit_rules, 'rules', param(_dataid_limit))

        -- 初始化 public 参数
        nacos_config(0, 0, public_config_nacos, ngx.shared.nacos_public, nil, param(_dataid_public))
        --定时更新
        nacos_config(1, _time, public_config_nacos, ngx.shared.nacos_public, nil, param(_dataid_public))

    end
end

init_worker()
