# famd
flutter aria2 m3u8 downloader，使用flutter+aria2+m3u8开发的一个M3U8下载器  
## 下载地址
[安卓与PC版下载地址（阿里云OSS）](https://rootvip.cn/archives/66.html)  
大文件上传到github太难了，新版本会优先上传到这里！   

[安卓版google play下载](https://play.google.com/store/apps/details?id=cn.rootvip.famd)  
google play为付费下载，付费版与免费版功能一模一样，如果您想支持我，可下载付费版！  

## 视频介绍
[2.5版介绍](https://www.bilibili.com/video/BV1sc411Z7FT/)
https://www.bilibili.com/video/BV1sc411Z7FT  

[1.0版介绍](https://www.bilibili.com/video/BV1nH4y1Z7aG)
https://www.bilibili.com/video/BV1nH4y1Z7aG   

## 注意
只支持http或https的M3U8地址下载

## 开发思路
1、解析m3u8文件获取里面ts列表，m3u8的视频是由很多个ts文件组成的，所以首先就先要解析m3u8文件获取里面ts列表的下载地址  
2、调用cmd命令启动aria2  
3、使用http请求aria2 RPC服务，把ts列表加入aria2下载，aria2是支持RPC服务的，使用http请求来操作aria2就可以了  
4、如果ts是加密的，先解密ts文件，m3u8里面会有key，用那个key解密ts文件就可以了，如果没有key，说明ts没加密，不用解密ts  
5、下载完成后调用cmd命令使用ffmpeg把下载的ts列表合并成一个视频

## 项目运行
```
flutter run -d windows
```
```
flutter run -d linux
```
```
运行flutter run -d android会列出你的设备名称，然后把“android”替换为你的设备名称。
例：flutter run -d xxxxx(xxxxx为你的设备名称)
```
## 注意：
1、windows版因为ffmpeg.exe太大，一直提交失败，所以没上传提交上来，请自行下载ffmpeg.exe放到 windows/bin/plugin/ffmpeg/ffmpeg.exe  
2、Linux也是分CPU架构的，请自行找到aria2和ffmpeg对应的CPU架构文件，放在linux/bin/plugin中， 我只能在虚拟机里调试linux版，虚拟机装的linux是x86_64。因此这里只有x86_64的文件。  
3、android版的aria2文件也是因为太大一直提交失败,请到 https://github.com/devgianlu/aria2lib 找到src/main/jniLibs下的aria2文件放到本项目android目录下的src/main/jniLibs中即可。  
4、IOS暂时不支持，手机版需要写一点原生代码，我不会IOS开发，因此目前本项目还没适配IOS。

## 截图
#### Android
<img src="./screenshot/a1.jpg" width="200">
<img src="./screenshot/a2.jpg" width="200">
<img src="./screenshot/a3.jpg" width="200">
<img src="./screenshot/a4.jpg" width="200">
<img src="./screenshot/a5.jpg" width="200">

#### Windows
<img src="./screenshot/w1.png" width="400">
<img src="./screenshot/w2.png" width="400">
<img src="./screenshot/w3.png" width="400">
<img src="./screenshot/w4.png" width="400">
<img src="./screenshot/w5.png" width="400">

## 支持
FamdM3U8视频下载器源码已在GitHub上全部开源。您可在GitHub上免费下载源码以及安装包。  

如果您想支持一下作者，您可以[前往B站工房](https://gf.bilibili.com/item/detail/1107456011)请作者喝杯奶茶表示鼓励。