#IM域名收費證書
#放置目錄/var/git/im-outsite/
使用步驟在gitlab放置keys公鑰

#建立clone
mkdir -p /var/git/
cd /var/git/
git clone ssh://git@git.chats-boss.com:6666/ops/im-outsite.git

#同步拉取
cd /var/git/im-outsite/
git pull

#git push 
很煩 我不說 