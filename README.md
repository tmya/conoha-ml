# conoha-ml
ConoHa VPSにMIRACLE LINUX 8.4のISOファイルをマウントするもの for Windows 10

### 注意事項

無保証です。

基本的にはPowerShell / Windows 10で動きますが、直接PowerShellを使うにはポリシーの設定等が必要なためbatファイルをラッパーとして同梱しています。

**NOTE:** ファイル一式をダウンロードした後、`*.ps`ファイルや`*.bat`ファイルのプロパティから`ブロックの解除`が必要な事があります。

**NOTE:** VPSのプランが512MBだとインストールに失敗します。[公式](https://www.cybertrust.co.jp/miracle-linux/environment.html)には2GB 必須と記載があります。

### 使い方

事前にマウントしたい対象のVPSをシャットダウンしておいてください。起動しているとマウントに失敗します。

#### ISOのマウント

まず`config.ps1`を右クリックして`編集`を選ぶかテキストエディタで開き、1～4行目の設定欄を埋めます。

ConoHaコントロールパネルにログインし、左側のメニューのAPIから設定情報を閲覧することができます。APIユーザーを作成していない方は[公式マニュアル](https://support.conoha.jp/v/addapiuser/)を参照。パスワードを忘れた場合の再設定もできるようです。

例：

```powershell
[string]$CNH_USERNAME = "gxxx12345678"
[string]$CNH_PASSWORD = "1234abcd"
[string]$CNH_TENANT_NAME = "gxxt12345678" # ← ユーザー名と似てるけどちょっと違う
[string]$CNH_REGION_NAME = "tyo1"
```

保存して終了します。

`ISOダウンロードとマウント.bat`をダブルクリックするとMIRACLE LINUX 8.4のISOをConoHaにアップロードし、ConoHa側でダウンロードが完了するとVPSにISOをマウントする機能（[conoha-iso](https://github.com/hironobu-s/conoha-iso)を使用）が動きます。

conoha-isoの[insertの説明](https://github.com/hironobu-s/conoha-iso#insert)に沿って対象のVPSとISOを選ぶとマウントが可能です。

#### ISOのアンマウント

`ISOのアンマウント.bat`をダブルクリックするとconoha-isoの[eject](https://github.com/hironobu-s/conoha-iso#eject)機能が動きますのでVPSを選ぶとアンマウントできます。

### おまけ

`config.ps1`の$ML_ISO_URLを他のディストリビューションのISOファイルに書き換えるとそのISOファイルをConoHaにマウントできると思われます。
