### 概要
lets encryptでssl証明書を発行するのにめちゃくちゃ時間がかかったので備忘録

Makefileにコマンドをまとめておいたので、適宜書き換えて使ってください。

### 共通設定

nginxのconfに下記を追記してcertのチェックが通るようにする。/your/cert/check/dirを絶対pathにしないとmacosの場合めんどいことになる可能性高いので、絶対pathがおすすめ。example.comと/your/cert/check/dirを書き換える。portはルーターに向けて開放しているもので。


```
  # macos /usr/local/etc/nginx/nginx.conf

  server {
      listen       80;
      server_name  example.com;

      location ^~ /.well-known/acme-challenge/ {
          root /your/cert/check/dir;
          index index.html;
      }

      error_page   500 502 503 504  /50x.html;
      location = /50x.html {
          root   html;
      }
  }

  server {
      listen 443 ssl;
      server_name  example.com;
      ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

      location / {
          root html;
          index index.html;
      }

      error_page   500 502 503 504  /50x.html;
      location = /50x.html {
          root   html;
      }
  }
```

certと秘密鍵は下記のpathに追加されるので、先に追加しておくと楽だろう。
```
   /etc/letsencrypt/live/example.com/fullchain.pem
   /etc/letsencrypt/live/example.com/privkey.pem
```

### macosでの設定
参考
`https://certbot.eff.org/lets-encrypt/osx-nginx`


nginx用のオプションがあるが、brewでインストールしているとwebroot-pathがずれたりnginxのconfの設定をbrewの方ではなく他のlinuxでの標準のetc/nginxにみにいったりしてバグりめんどいので、これも面倒臭いが発行からのnginxのconfの書き換えは自分で行う。

```
brew install certbot

mkdir your/cert/check/dir
chmod 777 your/cert/check/dir

sudo certbot certonly --webroot --webroot-path your/cert/check/dir -d example.com

echo "0 0 1 * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q"" | sudo t e -a /etc/crontab > /dev/null
```

certが生成されたファイルの親ディレクトリを全て順番に、どの階層もchmod 755などで読み取り権限与えないとnginxで読み取れないので注意。

参考記事
https://qiita.com/sadayuki-matsuno/items/afbd960198bd0ae1101f
