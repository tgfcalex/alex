local args = ngx.req.get_uri_args()

--ngx_say_resp(args.tbl, 200)


if args.tbl then
    if args.tbl == 'env_vars' then
        ngx_say_resp(env_vars, 200)
    elseif args.tbl == 'domain_env_tbl' then
        ngx_say_resp(domain_env_tbl, 200)
    elseif args.tbl == 'siteid_env_tbl' then
        ngx_say_resp(siteid_env_tbl, 200)
    elseif args.tbl == 'flush' then
        local ok = init()
        if ok then
            ngx_say_resp('init() OK.', 200)
        end
    else
        ngx_say_resp('Invalid value', 401)
    end
else
    ngx_say_resp('Invalid arg', 401)
end
