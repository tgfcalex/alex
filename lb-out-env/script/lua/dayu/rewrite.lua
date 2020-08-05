
local version = ngx.var.version
local file = ngx.var.file
local debugInfo = string.format('version: %s |file: %s ', version, file)
ngx.log(ngx.ERR, debugInfo)
