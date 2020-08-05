local root = '/usr/local/openresty/nginx/script/lua/dayu/'
local version = ngx.var.version
local file = ngx.var.file



local uri = ngx.var.uri
local api_path = string.format('%s/%s/%s.lua', root, version, file)

if not exists(api_path) then
    ngx_say_resp('Invalid API: '..uri, 403)
end





--
--ngx.req.read_body()
--local args, err = ngx.req.get_post_args()
--
--if err == "truncated" then
--  --one can choose to ignore or reject the current request here
--end
--
--if not args then
-- ngx.say("failed to get post args: ", err)
-- return
--end
--for key, val in pairs(args) do
-- if type(val) == "table" then
--     ngx.say(key, ": ", table.concat(val, ", "))
-- else
--     ngx.say(key, ": ", val)
-- end
--end
--