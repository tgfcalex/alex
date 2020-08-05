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
local args = ngx.req.get_uri_args()
red:select('6')
--redis_key = 'rcenter_res_'..args.core_idc_no
local redis_key
local args = ngx.req.get_uri_args()
if args.platform == 'gb' then
    redis_key = 'rcenter_res'
elseif args.platform == 'pb' then
    redis_key = 'pb_rcenter_res'
end
local _body = string.trim(red:get(redis_key))
red:close()
md5_str = ngx.md5(_body)
if args.md5 == md5_str then
    ngx.say('')
else
    ngx.say(_body)
end
ngx.exit(200)
