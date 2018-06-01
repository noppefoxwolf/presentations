footer: 🦊 @noppefoxwolf, 2018
slidenumbers: true

# [fit] App Protection

---

# noppe
@noppefoxwolf

iOSアプリ開発者 ８年目

🦊 が好きです！

potatotips初参戦です！

![right](IMG_0726.PNG)

---

![fit](charles-for-ios.jpg)

---

# Charles for iOSが発売されましたね！

- CharlesはiOSからの HTTP と HTTPS のトラフィックをキャプチャできるアプリ

- 通信系の**デバッグ**にとても便利ですよね！

---

自分のアプリの通信を見ていたら…

---

自分のアプリの通信を見ていたら…

偶然CharlesをつけっぱなしでTwitterのアプリを開いてしまった。

---

![inline fit](IMG_0907.JPG)

タイムラインの更新が出来ませんでした。

---

# [fit] 今回はこの動作を実装しました。

---

# Charlesの実装

まずCharlesの実装を確認します。
try! Swift Tokyo 2018 - Introducing Charles for iOS[^1]

![inline](スクリーンショット 2018-05-23 1.45.14.png)

[^1]: https://www.youtube.com/watch?v=RWotEyTeJhc

---

# Charlesの実装

NetworkExtensionを使って、VPN[^2]コネクションを貼っている。

iOSのVPNの常時接続機能を使えばアプリからすべてのIPトラフィックがトンネリング出来る。[^3]


[^2]: Virtual private network 仮想プライベートネットワーク

[^3]: https://developer.apple.com/documentation/networkextension

---

# [fit] アプリからVPNが貼られているかチェック出来ればOKそう

---

# VPN検出

`CFNetworking.framework`を使うことで、検出できる。

`CFNetworkCopySystemProxySettings()`

↑でシステムのインターネットプロキシ設定を取得出来ます。

---

```
Swift.Unmanaged<__ObjC.CFDictionary>(_value: {
    "__SCOPED__" =     {
        utun4 =         {
            HTTPSPort = 8080;
            HTTPSProxy = "10.78.2.43";
        };
    };
})
```

`__SCOPED__`にプロキシ設定が入っている
`tun`が含まれる設定はトンネルなので弾いて良い…？

---

# さいごに

---

# [fit]🦊 以上です！
# [fit]ありがとうございました












---

VPN検知

charlsがリリースされました

色々なアプリの通信を覗いた人もいるのでは？

偶然CharlesをつけっぱなしでTwitterのアプリを開いた所、通信が出来ませんでした。

今日はこれを実装します。

まずはCharlsの仕組みを簡単に解説
try!Swift2017で登壇されていた資料
http://niwatako.hatenablog.jp/entry/2018/03/02/122828
NetworkExtensionFramework使ってる

VPSの接続を検出出来れば良さそう


4G c
Optional(Swift.Unmanaged<__ObjC.CFDictionary>(_value: {
    ExcludeSimpleHostnames = 0;
    FTPEnable = 0;
    FTPPassive = 1;
    GopherEnable = 0;
    HTTPEnable = 1;
    HTTPPort = 8080;
    HTTPProxy = "10.78.2.43";
    HTTPSEnable = 1;
    HTTPSPort = 8080;
    HTTPSProxy = "10.78.2.43";
    ProxyAutoConfigEnable = 0;
    ProxyAutoDiscoveryEnable = 0;
    RTSPEnable = 0;
    SOCKSEnable = 0;
    "__SCOPED__" =     {
        utun4 =         {
            ExcludeSimpleHostnames = 0;
            FTPEnable = 0;
            FTPPassive = 1;
            GopherEnable = 0;
            HTTPEnable = 1;
            HTTPPort = 8080;
            HTTPProxy = "10.78.2.43";
            HTTPSEnable = 1;
            HTTPSPort = 8080;
            HTTPSProxy = "10.78.2.43";
            ProxyAutoConfigEnable = 0;
            ProxyAutoDiscoveryEnable = 0;
            RTSPEnable = 0;
            SOCKSEnable = 0;
        };
    };
}))

4G
Optional(Swift.Unmanaged<__ObjC.CFDictionary>(_value: {
}))

Wifi
Optional(Swift.Unmanaged<__ObjC.CFDictionary>(_value: {
    ExceptionsList =     (
        "*.local",
        "169.254/16"
    );
    FTPPassive = 1;
    "__SCOPED__" =     {
        en0 =         {
            ExceptionsList =             (
                "*.local",
                "169.254/16"
            );
            FTPPassive = 1;
        };
    };
}))

Wifi c

Optional(Swift.Unmanaged<__ObjC.CFDictionary>(_value: {
    ExcludeSimpleHostnames = 0;
    FTPEnable = 0;
    FTPPassive = 1;
    GopherEnable = 0;
    HTTPEnable = 1;
    HTTPPort = 8080;
    HTTPProxy = "10.78.2.43";
    HTTPSEnable = 1;
    HTTPSPort = 8080;
    HTTPSProxy = "10.78.2.43";
    ProxyAutoConfigEnable = 0;
    ProxyAutoDiscoveryEnable = 0;
    RTSPEnable = 0;
    SOCKSEnable = 0;
    "__SCOPED__" =     {
        en0 =         {
            ExceptionsList =             (
                "*.local",
                "169.254/16"
            );
            FTPPassive = 1;
        };
        utun4 =         {
            ExcludeSimpleHostnames = 0;
            FTPEnable = 0;
            FTPPassive = 1;
            GopherEnable = 0;
            HTTPEnable = 1;
            HTTPPort = 8080;
            HTTPProxy = "10.78.2.43";
            HTTPSEnable = 1;
            HTTPSPort = 8080;
            HTTPSProxy = "10.78.2.43";
            ProxyAutoConfigEnable = 0;
            ProxyAutoDiscoveryEnable = 0;
            RTSPEnable = 0;
            SOCKSEnable = 0;
        };
    };
}))

https://stackoverflow.com/questions/8131807/how-to-check-vpn-connectivity-in-iphone