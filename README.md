# famd
flutter aria2 m3u8 downloader，使用flutter+aria2+m3u8开发的一个M3U8下载器。

[使用说明](https://www.bilibili.com/video/BV1nH4y1Z7aG)
https://www.bilibili.com/video/BV1nH4y1Z7aG

#### 初学者的第一个flutter应用,代码写的乱七八糟的。参考价值不大，可借鉴开发思路。
目前只打包了Windows版本，其他平台还在研究中。

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
注意：因为ffmpeg.exe太大，所以没上传提交上来，请自行下载ffmpeg.exe放到 windows/bin/plugin/ffmpeg/ffmpeg.exe
## 截图
#### Windows
![](https://sddman.oss-cn-shenzhen.aliyuncs.com/flutter/famd/win/1.jpg)
![](https://sddman.oss-cn-shenzhen.aliyuncs.com/flutter/famd/win/2.jpg)
![](https://sddman.oss-cn-shenzhen.aliyuncs.com/flutter/famd/win/3.jpg)
![](https://sddman.oss-cn-shenzhen.aliyuncs.com/flutter/famd/win/4.jpg)

