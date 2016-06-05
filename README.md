# PushNotificationEverything

关于iOS系统通知的方方面面。

Everything tha about notification in iOS.

*** 

## 开发者文档翻译

1. [通知那些事儿（一）：简介](http://wenghengcong.com/2016/04/通知那些事儿（一）：简介/)
2. [通知那些事儿（二）：深度剖析本地与远程通知](http://wenghengcong.com/2016/04/通知那些事儿（二）：深度剖析本地与远程通知/)
3. [通知那些事儿（三）：注册、调度及处理用户通知](http://wenghengcong.com/2016/04/通知那些事儿（三）：注册、调度及处理用户通知/)
4. [通知那些事儿（四）：Apple Push Notification Service](http://wenghengcong.com/2016/05/通知那些事儿（四）：Apple-Push-Notification-Service/)
5. [通知那些事（五）：远程通知有效载荷](http://wenghengcong.com/2016/05/%E9%80%9A%E7%9F%A5%E9%82%A3%E4%BA%9B%E4%BA%8B%EF%BC%88%E4%BA%94%EF%BC%89%EF%BC%9A%E8%BF%9C%E7%A8%8B%E9%80%9A%E7%9F%A5%E6%9C%89%E6%95%88%E8%BD%BD%E8%8D%B7/)

***

## 测试工具-Testing

**Cn**

[Knuff](https://github.com/KnuffApp/Knuff)是一个用来测试远程推送的客户端。

[Houston](https://github.com/nomad/houston)简易实现了发送APNs通知。

[SmartPush](https://github.com/shaojiankui/SmartPush)一款IOS苹果远程推送测试程序,Mac OS下的APNS工具APP。

**En**

[Knuff](https://github.com/KnuffApp/Knuff) is a Mac client for testing push notification.

[Houston](https://github.com/nomad/houston) is a simple gem for sending Apple Push Notifications.

[SmartPush](https://github.com/shaojiankui/SmartPush)iOS Push Notification Debug App.

***

## 相关博客或文档-Blog

* [Local and Remote Notification Programming Guide](https://developer.apple.com/library/mac/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/Introduction.html#//apple_ref/doc/uid/TP40008194-CH1-SW1)

* [极光推送](http://blog.jpush.cn/)

* [Push Notifications Tutorial: Getting Started](https://www.raywenderlich.com/123862/push-notifications-tutorial)

* [Push Issues](https://developer.apple.com/library/ios/technotes/tn2265/_index.html)

***

## 第三方服务

* [极光推送](https://www.jpush.cn/)

	多次用过极光推送，服务相对来说还算稳定，功能齐全，支持分类、别名和标签。
	
	API简洁，开发文档完整，推荐！
	
	有收费服务。

* [友盟推送](http://mobile.umeng.com/push)

	友盟是较早做APP应用相关服务的，其最大的优势是服务联动，包括统计服务、崩溃跟踪等都可以采用友盟的。推送也做的不错。用过一次，没什么特别体会。

* [百度云推送](http://push.baidu.com/)
* [腾讯信鸽](http://xg.qq.com/)

	起步比较晚，功能相对简单，试用过，没极光和友盟专业，但是背靠腾讯，应该会慢慢完善。
	
	目前不推荐。

* [个推](http://www.getui.com/)

	功能最丰富，开发文档也很完整，没用过。

* [云巴推送](http://yunba.io/products/push/)

	采用MQTT协议实现的推送。可以研究下这个技术。

***

## 最佳实践-Best Practice

***


## 问答-Q&A

*About Settings*

[detect “Allow Notifications” is on/off for iOS8](http://stackoverflow.com/questions/25111644/detect-allow-notifications-is-on-off-for-ios8)

[Push Notification ON or OFF Checking in iOS](http://stackoverflow.com/questions/20374801/push-notification-on-or-off-checking-in-ios)

[iOS 8 enabled device not receiving PUSH notifications after code update](http://stackoverflow.com/questions/25909568/ios-8-enabled-device-not-receiving-push-notifications-after-code-update)

[Show on Lock Screen push notification settings?](http://stackoverflow.com/questions/36697355/show-on-lock-screen-push-notification-settings)



*Receive notification twice*

[Reset push notification settings for app](http://stackoverflow.com/questions/2438400/reset-push-notification-settings-for-app?lq=1)


[iOS Push Notification Banner shown twice for a single Push](http://stackoverflow.com/questions/33047914/ios-push-notification-banner-shown-twice-for-a-single-push)

*device token*

[Does the APNS device token ever change, once created?](http://stackoverflow.com/questions/6652242/does-the-apns-device-token-ever-change-once-created)

[does app give different device token on re-installing again](http://stackoverflow.com/questions/33888962/does-app-give-different-device-token-on-re-installing-again)

[极光推送的设备唯一性标识 RegistrationID](http://blog.jpush.cn/registrationid/)


*unique id for ios device*

[UIDevice uniqueIdentifier Deprecated - What To Do Now?](http://stackoverflow.com/questions/6993325/uidevice-uniqueidentifier-deprecated-what-to-do-now)

[Always get a unique device id in iOS 7](http://stackoverflow.com/questions/19606773/always-get-a-unique-device-id-in-ios-7)

[objective C iOS Device ID in iOS7](http://stackoverflow.com/questions/19329765/objective-c-ios-device-id-in-ios7)

[iOS unique user identifier](http://stackoverflow.com/questions/7273014/ios-unique-user-identifier?lq=1)

[Unique id in ios](http://stackoverflow.com/questions/20453785/unique-id-in-ios)


***