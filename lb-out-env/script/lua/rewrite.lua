-- ngx.log(ngx.ERR, '-------------------------------')

local uri = ngx.var.uri
if uri == nil or ngx.re.find(uri, [[^/(__|\.well-known)]], 'jo') then
    return
end

-- ------------------------ 首页跳转 ------------------------
local is_mobile = ngx.var.is_mobile
local stype = ngx.var.stype
if uri == '/' then
    if stype == 'site' then
        if is_mobile == 'true' then
            ngx.req.set_uri("/web/index.html", true)
        else
            ngx.req.set_uri("/index.html", true)
        end
    elseif stype == 'api' then
        ngx_say_resp('API invalid URI', 401)
    elseif stype == 'adm' then
        ngx_say_resp('Adm invalid URI', 401)
    end
end
