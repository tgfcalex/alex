
local uri = ngx.var.uri
local m = ngx.re.match(uri, [[/__purge(/.*)]], "jo")
local from = ngx.re.find(m[1], [[(\.html|^/)$]], 'jo')

ngx.log(ngx.ERR, '-----0-----', uri, '--from: ', from)
if not from then
    return
end

local uri = m[1]

local site_id = get_site_id()
local args = ngx.req.get_uri_args()
local db = 2
local redis_key
local red = connect_redis()












if args.flush then
    if args.flush == "all" then
        ngx.log(ngx.ERR, '----', args.flush)
    elseif args.flush == "pc" then
        db = 2
    elseif args.flush == "mobile" then
        db = 4
    elseif args.flush == "lottery" then
        db = 7
    elseif args.flush == "lottery-mobile" then
        db = 8
    else
        close_redis(red)
        ngx_say_resp('Invalid args', 401)
    end

    redis_key = site_id ..  '_*'
    red:select(db)

end


local redis_key = site_id .. '_' .. uri .. '_*'

local db = 2
red:select(db)
local result = red:keys(redis_key)
local info = {}
if result and result ~= ngx.null then
    for _, html in ipairs(result) do
        local ok = red:del(html)
        if ok and ok ~= ngx.null then
            info[html] = 'ok'
        end
    end
end
close_redis(red)
ngx_say_resp(info, 200)
