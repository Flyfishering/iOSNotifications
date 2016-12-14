
> 下面说明远程服务器通知的payload json格式

# 通用

{
    "aps" : {
        "alert" : "Hello World!",
        "sound" : "default",
        "category" : "example-category",
        "thread" : "example-thread",
        "thread-identifier" : "example-thread-identifier"
    }
    "custom-field" : "some value",
}

# 自定义界面
1. 

{
    "aps":{
        "alert":{
            "title":"快起床第十三",
            "body":"真的起不来？"
        },
    "sound":"default",
    "category":"customUI",
    "mutable-content":1
    },
}

注意：category必须和Info.plist中的UNNotificationExtensionCategory一致。

2. 
//在此处修改category，可达到对应category的手段！！！
//可以配合服务端针对category来进行不同的自定义页面的设置。
/*
{
    "aps":{
        "alert":{
            "title":"快起床第十三",
            "body":"真的起不来？"
         },
        "sound":"default",
        "category":"customUI",
        "mutable-content":1
    },
    "url":"http://www.baidu.com",
    "js_category":"customUI",
    "image":"http://p2.so.qhmsg.com/t01570d67d63111d3e7.jpg"
}
//上面category，另外一个定义了的：customUIWeb，用于展示web页面；


# 图片加载

//此处自定义一个字段image，用于下载地址：

{
    "aps":{
        "alert":{
            "title":"快起床",
            "body":"真的起不来？"
        },
        "sound":"default",
        "mutable-content":1,
    },
    "image":"http://p2.so.qhmsg.com/t01570d67d63111d3e7.jpg"
}

//同时，需要注意的是，在下载图片是采用http时，需要在extension info.plist加上 app transport
//注意：image读取的层次结构

