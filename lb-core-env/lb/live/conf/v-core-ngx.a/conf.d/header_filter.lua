-- 生成16进制字符串，变量num指定长度
function random_str(num)
    local resty_random = require "resty.random"
    local resty_str = require "resty.string"
    local random = resty_str.to_hex(resty_random.bytes(num))
    return random
end

-- 定制uuid
function uuid_str()
    local site_id = tonumber(ngx.var.http_siteid) or 0
    local idc_no = tonumber(ngx.var.idc) or 0

    local cookie_uid = ngx.var.cookie_UID or '00000000'
    local timestamp = os.time()
    local random = random_str(2)

    -- 5位站点id + 2位机房 + 8位cookie_UID + 10位 TimeStamp + 4位随机数
    local uuid = string.format("%05d-%02d-%s-%s%s", site_id, idc_no, cookie_uid, timestamp, random)
    return uuid
end

---- main
local uri = ngx.var.uri
local ngx_resp = require "ngx.resp"
if uri ~= nil then
    --local m = ngx.re.find(uri, [[(\.html|/)$]], "jo")    -- 仅 html 请求做uuid
    local var_uuid = ngx.var.uuid
    if var_uuid ~= nil then
        local uuid = uuid_str()
        ngx.var.uuid = uuid
        ngx_resp.add_header("uuid", uuid)  -- add_header
    end
end
