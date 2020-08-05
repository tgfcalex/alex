# 平时的修改内容添加到这，做个备忘录

##  hall-ngx 添加 location 匹配 onlinePay
```markdown
location /onlinePay {
        proxy_pass http://lb-hall/hall/onlinePay;

```
