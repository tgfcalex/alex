local ssl = require "ngx.ssl"
ssl.clear_certs()
local server_name = ssl.server_name()
if server_name ~= nil then
    server_name = string.gsub(server_name,"^www%.","")
    local file = io.open("/var/git/ssl/" .. server_name ..".pem")
    if file == nil then
        file = io.open("/usr/local/openresty/nginx/conf/letsencrypt/ssl/" .. server_name .."/fullchain1.pem")
        if file == nil then
            file = io.open("/var/git/ssl/nginx.pem")
        end
    end
    local f = assert(file)
    local pem_cert_chain = f:read("*a")
    local der_cert_chain, err = ssl.cert_pem_to_der(pem_cert_chain)
    ssl.set_der_cert(der_cert_chain)
    f:close()

    local kfile = io.open("/var/git/ssl/" .. server_name ..".key.pem")
    if kfile == nil then
        kfile = io.open("/usr/local/openresty/nginx/conf/letsencrypt/ssl/" .. server_name .."/privkey1.pem")
        if kfile == nil then
            kfile = io.open("/var/git/ssl/nginx.key.pem")
        end
    end
    local k = assert(kfile)
    local pem_priv_key = k:read("*a")
    local der_priv_key, err = ssl.priv_key_pem_to_der(pem_priv_key)
    ssl.set_der_priv_key(der_priv_key)
    k:close()
end
