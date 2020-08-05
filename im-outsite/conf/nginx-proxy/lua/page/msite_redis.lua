local redis_cluster = require("redis_cluster")

local cluster_id = "test_cluster"

local startup_nodes = {
    {"192.168.40.1", 6379},
    {"192.168.41.1", 6379},
    {"192.168.42.1", 6379},
    {"192.168.40.2", 6379},
    {"192.168.41.2", 6379},
    {"192.168.42.2", 6379},
    {"192.168.40.3", 6379},
    {"192.168.41.3", 6379},
    {"192.168.42.3", 6379}
}

local opt = {
    timeout = 100,
    keepalive_size = 100,
    keepalive_duration = 60000
}

local rc = redis_cluster:new(cluster_id, startup_nodes, opt)

rc:initialize()

local lang = ngx.var.cookie__LANGUAGE
if not lang then
    lang = 'zh_CN'
end

local _host = ngx.var.host
local _host_pre = string.sub(_host,0,4)
local _host_without = ""
if _host_pre == "www." then
    _host = string.sub(_host,5,string.len(_host))
end

local siteId, err = rc:send_cluster_command("get", "data:DOMAIN_SITE:" .. _host)

if not siteId or siteId == ngx.null or not lang then
    ngx.log(ngx.ERR, _host, "的站点id为空！")
    return
else
    local page, err = rc:send_cluster_command("get", "msites:" .. siteId .. ":".. lang ..":" .. ngx.var.request_uri)
    if not page or page == ngx.null then
      	return
    else
	ngx.header["ISMSITE"] = "true"
        ngx.say(page)
        ngx.exit(200)
        return

    end
end
