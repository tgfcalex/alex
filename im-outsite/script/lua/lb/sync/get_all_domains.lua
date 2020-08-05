local redis = require "resty.redis"
local str = require "resty.string"
local red = redis.new()
local ok , err = red.connect(red,"127.0.0.1","6379")

red:set_timeout(1000)
if not ok then
    ngx.exit(_return_code)
end

local res, err = red:auth("gamebox123")
if not res then
    ngx.exit(_return_code)
end
red:select('6')
local redis_key
local args = ngx.req.get_uri_args()
if args.platform == 'pb' then
    redis_key = 'pb_domains'
else
    redis_key = 'domains'
end

-- 取值判断, 连接池
local _res, err = red:get(redis_key)
if not _res then
    ngx.exit(404)
    return
end

if _res == ngx.null then
    ngx.exit(404)
    return
end
local _body = string.trim(_res)
local ok, err = red:set_keepalive(10000, 100)
if not ok then
    ngx.exit(404)
    return
end
--local _body = string.trim(red:get(redis_key))
--red:close()
md5_str = ngx.md5(_body)
if args.md5 == md5_str then
    ngx.say('')
else
    ngx.say(_body)
end
ngx.exit(200)
