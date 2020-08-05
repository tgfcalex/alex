local ky = {opgit_ip = "35.229.152.11",
gbgit_ip = "35.201.188.239",
lbgit_ip = "35.194.147.209",
atgit_ip = "35.229.220.205",
spgit_ip = "104.155.229.10",
uigit_ip = "35.201.139.24",
opgit2_ip = "35.221.156.34",
tegit_ip = "103.100.140.33"
}

function domain_ip()
   local domain_name = ngx.var.host     
   if domain_name == "opgit-2.xvhey.com" then
      value = ky['opgit2_ip']
   else
      domain_head = string.sub(domain_name,1,5)
      domain_key = domain_head .. "_ip"
      value = ky[domain_key]
   end
   return value
end
