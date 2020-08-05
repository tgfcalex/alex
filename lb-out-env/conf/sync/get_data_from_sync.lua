local redis = require "resty.redis"

-- 参数判断
local args = ngx.req.get_uri_args()
if not args.type then
    ngx.status = 400
    ngx.say ('bad args 1')
    return ngx.exit(ngx.status)
end
if not args.idc then
    ngx.status = 400
    ngx.say ('bad args 2')
    return ngx.exit(ngx.status)
end

-- redis连接
local red = redis:new()
red:set_timeout(1000)
local ok, err = red:connect("unix:/var/run/redis/redis.sock")
if not ok then
    ngx.status = 400
    ngx.say("failed to connect: ", err)
    return ngx.exit(ngx.status)
end

local res, err = red:auth("gamebox123")
if not res then
    ngx.status = 400
    ngx.say("failed to authenticate: ", err)
    return ngx.exit(ngx.status)
end
red:select('6')

-- main
local redis_key = string.format('core:%s_%s', args.type, args.idc)

local _data, err = red:get(redis_key)
red:set_keepalive(10000, 100)
if not _data or _data == ngx.null then
    ngx.status = 404
    ngx.say("failed to get ", redis_key, ": ", err)
    return ngx.exit(ngx.status)
else
    _data = string.trim(_data)
    local md5_str = ngx.md5(_data)
    if args.md5 == md5_str then
        ngx.status = 304  -- 校验md5, 未变更则返回304
        ngx.say('')
        return ngx.exit(ngx.status)
    else
        ngx.say(_data)
    end
    ngx.exit(200)
end

