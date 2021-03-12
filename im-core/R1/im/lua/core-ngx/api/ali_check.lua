
--model
local ngx           = ngx

local pairs    = pairs
local tonumber = tonumber
local string = string
local table = table

local public     = require("public")
local log        = require("log")
local rds        = require("resty.redis_iresty")
local uuid       = require("resty.jit-uuid")
local http       = require("resty.http")

--redis
local redis_db = public.json_decode(ngx.shared.nacos_redis:get("rds"))

function ali_check()
    --key
    local method    = ngx.var.request_method
    local cache_ngx = ngx.shared.nacos_public

    local ACCESS_KEY_SECRET = cache_ngx:get("afs_access_key_secret")
    local ACCESS_KEY_ID     = cache_ngx:get("afs_access_key_id")
    local REGION_ID         = cache_ngx:get("afs_region_id")

    local args = public.get_uri_args()
    local data = args["data"]
    local callback = args["callback"]
    local key = args["key"]

    if not data or not callback or not key then
        log.error("failed to get uri args: ")
        return ngx.exit(400)
        --return
    end

    local score_json_str = '{"200":"PASS","800":"BLOCK"}'

    --utctime format:2020-01-02T10:50:42Z
    local time_ngx    = ngx.utctime()
    local time_change = string.gsub(time_ngx, " ", "T")
    local time_utc    = table.concat({time_change, "Z"})

    --uuid
    uuid.seed(ngx.now())
    local signature_nonce = table.concat({uuid.generate_v4() , '_' , public.ali_check_url_encode(key)})

    local params_table = {
        -- 签名版本，写死
        SignatureVersion = '1.0',
        -- 无痕验证
        Action           = 'AnalyzeNvc',
        -- JSON格式
        Format           = 'JSON',
        -- 版本，写死
        Version          = '2018-01-12',
        -- 签名方法，写死
        SignatureMethod  = 'HMAC-SHA1',
        AccessKeyId      = ACCESS_KEY_ID,
        RegionId         = REGION_ID,
        SignatureNonce   = signature_nonce,
        Data             = data,
        ScoreJsonStr     = score_json_str,
        Timestamp        = time_utc
    }

    --键值排序
    local key_table = {}

    for i in pairs(params_table) do
        table.insert(key_table, i)
    end
    table.sort(key_table)

    -- 按照阿里签名方式，进行签名
    local params = "";
    for _, v in pairs(key_table) do
        params = table.concat({params , '&' , public.ali_check_url_encode(v) , '=' , public.ali_check_url_encode(params_table[v])})
    end
    local params_final   = string.sub(params, 2)
    local string_to_sign = table.concat({'GET' , '&' , public.ali_check_url_encode('/') , '&' , public.ali_check_url_encode(params_final)})
    local sha1_key       = table.concat({ACCESS_KEY_SECRET , '&'})
    local sign           = ngx.encode_base64(ngx.hmac_sha1(sha1_key, string_to_sign))


    local redis = rds:new(redis_db)

    local uri =  'http://afs.aliyuncs.com'
    local path = table.concat({uri,'/?' , params_final,'&Signature=',public.ali_check_url_encode(sign)})
    local method = 'GET'


    local httpc = http:new()

    httpc:set_timeout(5000)
    -- 调用阿里无痕验证接口，http 的
    local resp, err = httpc:request_uri( uri,
        {
            method = method,
            -- 参数拼接
            path = path
        })

    if not resp then
        log.error(key .. ", request error:", err)
        return ngx.exit(500)
    end

    local ali_data    = public.json_decode(resp.body)
    local bizcode = ali_data.BizCode

    log.error("data : " .. data)
    log.error("score_json_str : " .. score_json_str)
    log.error("params : " .. path)
    log.error("response : " .. resp.body)

    if bizcode == "200" then
        -- 清redis， key 要跟做限制时一样
        redis:select(0)
        redis:del("checkUser:".. key)
    else
        bizcode = '800'
        log.error(key .. ", 验证不通过 , body : " .. resp.body)
    end

    local result         = public.json_encode({result={code=tonumber(bizcode)}})
    local final_info_jsp = table.concat({callback, '(', result, ')'})
    ngx.print(final_info_jsp)
    httpc:close()
    -- 结束掉 ngx 中的流程，要不然可能会接着调用后面的 ngx 规则
    return ngx.exit(200)
end

ali_check()