-- ngx.log(ngx.ERR, '-------------------------------')

local uri = ngx.var.uri
if uri == nil or ngx.re.find(uri, [[^/(__|\.well-known)]], 'jo') then
    return
end

local real_host = ngx.var.real_host
local client_ip = ngx.var.client_ip
local stype     = ngx.var.stype

if stype == "" then
    local info =  {message = "not stype",status = false, code = "OP00", Host = _host}
    ngx_say_resp(info, 401)
elseif not real_host then
    ngx.log(ngx.ERR, 'HOST null')
    return ngx.exit(303)
end

-- ------------------------ 站点 ID ------------------------
local site_id = domain_info(real_host, "siteId")
if site_id == nil then
    if domain_env_tbl[real_host] == nil then
        return ngx.exit(303)  -- redis 没有, 并且 env_json 也没有, 会返回 303 域名不存在
    else
        site_id = 0
        local _ =  update_env_tbl(domain_env_tbl, real_host, 'siteId', site_id)
    end
end

-- ------------------------ domain type ------------------------
--local domainSubsysCode = domain_info(real_host, "domainSubsysCode")
--if stype == "site" then
--    if domainSubsysCode == "boss" or domainSubsysCode == "api" then
--        local info = {status = false, msg = 'error subsys'}
--        ngx_say_resp(info, 401)
--    end
--end
local pageUrl = domain_info(real_host, "pageUrl")
if stype == "site" then
    if pageUrl == "/process.html" or pageUrl == "/manager/passport/login.html" then
        local info =  {message = "error subsys",status = false, code = "OP01", Host = _host}
        ngx_say_resp(info, 401)
    end
end

-- ------------------------ 是否挂维护 ------------------------
local is_maintain, _ = config_result('is_maintenance', stype, real_host, site_id)
if is_maintain == 'true' then
    local _ = maintenance_info(stype)
end


local method = ngx.req.get_method()
local scheme    = ngx.var.scheme
local is_mobile = ngx.var.is_mobile

if method == "GET" then
    -- ------------------------ 跳 https ------------------------
    if stype == 'site' and scheme == 'http' and ( not ngx.var.http_referer )then
        local is_force_ssl, _ = config_result('is_force_ssl', stype, real_host, site_id)
        if is_force_ssl == 'true' then
            local is_have_ssl = is_have_ssl(real_host)
            if is_have_ssl then
                local request_uri = ngx.var.request_uri
                local _ = https_response(real_host, ':443', request_uri)
            end
        end
    end
    -- ------------------------ html 缓存 ------------------------

end




-- ------------------------ 机房线路 ID ------------------------
local core_idc_no, _ = config_result('core_idc_no', stype, real_host, site_id)
ngx.var.core_idc_no = core_idc_no  -- proxy_pass 需要
ngx.var.siteid = site_id           -- 核心 r uuid 需要



-- ------------------------ 定制 OP cookies ------------------------
local is_html = ngx.re.find(uri, [[\.html$]], 'jo')
if is_html then
    local is_flush_op_cookies = is_flush_op_cookies(client_ip)
end


--
--


