-- ngx.log(ngx.ERR, '-------------------------------')

local uri = ngx.var.uri
if uri == nil or ngx.re.find(uri, [[^/(__|\.well-known)]], 'jo') then
    return
end

-- 跨域
local m = ngx.re.find(uri, [[\.(eot|ttf|woff|svg|otf|woff2|js|css)$]], "jo")
if m then
    ngx.header["Access-Control-Allow-Origin"] = '*'
end
