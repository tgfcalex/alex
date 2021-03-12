
--model
local ngx           = ngx

local pairs    = pairs
local tonumber = tonumber
local string = string
local table = table

local public     = require("public")
local log        = require("log")
local rds        = require("resty.redis_iresty")

local function say_success()
    ngx.header.content_type = "application/json"
    public.ngx_say("1")
    return ngx.exit(200)
end

local function say_fail(_code)
    ngx.header.content_type = "application/json"
    public.ngx_say(_code)
    return ngx.exit(200)
end

function human_check()

    local args = public.get_post_args()

    local rules = public.json_decode(ngx.shared.nacos_limit_rules:get("rules"))
    local param_uri = args["uri"]
    local endpoint = args["endpoint"]
    local validate_num = args["validateNum"]
    local uri = param_uri
    if "api" == endpoint then
        uri = "/" .. endpoint .. param_uri
    end

    log.info("validate :  uri = " .. uri .. " , validateNum = " .. validate_num)
    -- 判断以哪个字段为key作的限制
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
        say_success()
    end

    -- 判断 header 是否存在 limit_key
    local limit_key  = rule.limit_key
    local headers    = ngx.req.get_headers()
    local header_key = headers[limit_key]
    if not header_key then
        return ngx.exit(403)
    end

    local key = table.concat({"checkUser", ":", uri , "_" , header_key})
    local black_key = key .. "_" .. "black"

    -- 查询redis 是否存在
    local redis_db    = public.json_decode(ngx.shared.nacos_redis:get("rds"))
    local redis   = rds:new(redis_db)
    redis:select(0)
    --local is_limit = redis:get(key)
    local black_value = redis:get(black_key)

    -- 没有被限制，直接通过
    if not black_value then
        say_success()
    end

    local validate_code_nonce  = string.sub(black_value, 6, 15)
    local check_num_str = validate_code_nonce .. param_uri .. header_key

    log.info("check_num_str ....... " .. check_num_str)

    local check_num_md5 = ngx.md5(check_num_str)

    if string.lower(check_num_md5) ~= string.lower(validate_num) then
        log.error(uri .. " 人机验证失败。 validate_num : " .. validate_num .. " , check_num : " .. check_num_md5)
        say_fail("-9005")
    end

    -- 验证通过，删除redis
    redis:del(key)
    redis:del(black_key)
    say_success()
end

human_check()