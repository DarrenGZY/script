----------------------------------------------------
-- 2007.8.22 original localization done by WangTian
----------------------------------------------------

NPL.load("(gl)script/ide/Locale.lua");
local L = CommonCtrl.Locale("ParaWorld");
L:RegisterTranslations("zhCN", function() return {
	-- event_handlers.lua
	["Successfully logged in!"] = "登陆成功！",
	["Log in failed. User does not exist"] = "登陆失败。用户不存在",
	["Connection with server is broken:"] = "同服务器连接中断：",
	["Connection with the following user is broken:"] = "同下面用户的连接中断：",
	
	-- ebook_db.lua
	["standard"] = "标准",
	["an empty book"] = "空白的书",
	["In this edition, you can only create books with no more than %d pages."] = "在本版中，您只能创建最多%d页的书",
	["Please enter a valid book name with letters only."] = "请输入一个有效的书名，书名只能由普通文字与字母组成",
	["Unable to create the book, perhaps you do not have access right to the disk directory."] = "无法创建图书，也许您没有足够的计算机权限。",
	["book already exist, please use a different book name."] = "这本书已经存在，请用一个不同的书名",
	["invalid zip file"] = "无效的图书文件",
	["This book is read only. It can not be saved."] = "这本书是只读的。它不能被保存。",
	["This book is read only. Page save is ignored."] = "这本书是只读的。页中内容的保存被忽略了。",
	["Failed saving file to "] = "保存到文件失败了，也许文件是只读的 ",
	["Successfully uploaded page %d: %s\n\n"] = "成功上传了第%d页：%s\n\n",
	["Your current account can not upload 3D EBook with page media extension %s\n"] = "您目前的帐户不能上传扩展名为%s的电子书插图\n",
	["Uploading ebook, please wait patiently...\n"] = "正在上传电子书，请耐心等待...\n",
	["This book is read-only. You can only publish a book which is editable."] = "这本书是只读的。您只能发布可以编辑的电子书。",
	["The EBook file %s already exists. Do you want to overwrite it?"] = "电子书%s已经存在，您是否希望覆盖它？",
	["The EBook %s is successfully generated and ready for publication. Do you want to open its folder with windows explorer?"] = "可以发行的电子书%s已经保存成功。是否用Windows浏览器打开图书所在目录?",
	
	-- Web services & web page
	["RegProduct.asmx"] = "http://www.minixyz.com/RegProduct.asmx",
	["AuthUser.asmx"] = "http://www.minixyz.com/AuthUser.asmx",
	["SubmitArticle.asmx"] = "http://www.minixyz.com/SubmitArticle.asmx",
	["SubmitEBook.asmx"] = "http://www.minixyz.com/SubmitEBook.asmx",
	["UploadUserFile.asmx"] = "http://www.minixyz.com/UploadUserFile.asmx",
	["Register.aspx"] = "http://www.minixyz.com/cn/Register.aspx",
	["community.aspx"] = "http://www.minixyz.com/cn/community.aspx",
	["login domain table"] = {"www.minixyz.com", "www.kids3dmovie.com", "www.paraengine.com", },
	["CheckVersion.asmx"] = "http://www.minixyz.com/CheckVersion.asmx",
	["http://www.kids3dmovie.com"] = "http://www.minixyz.com",
	
	-- common
	["OK"] = "确定",
	["Cancel"] = "取消",
	["Close"] = "关闭",
	["Save"] = "保存",
	["Network is not available, please try again later"] = "网络暂时无法连通，请稍候再试",
	["Press Any Key to Continue"] = "按任意键继续",	
	["Function is not available in this edition."] = "此功能暂时没有开放",
	["Function is only available to community edition users."] = "网络社区功能目前只向社区版内测用户提供，您希望登陆我们的社区网站了解更多的内容么?",
	["Product Customer Service"] = "客户服务: support@kids3dmovie.com",
	["Kids Movie Platform Version"] = "动漫创作平台 V 1.1.0",
	["Copyright@2004-2007 ParaEngine Tech Studio"] = true,
	-- the help book
	["Book of Help"] = "电子书教程.zip",
	-- the deafult book
	["Default Book"] = "新手指南.zip",
	
	-- ebook.lua
	["standard"] = "标准",
	["delux"] = "豪华",
	["simple"] = "简单",
	["default book does not exist "] = "缺省的图书不存在 ",
	["Enter your text here..."] = "文字",
	["Chapter %d"] = "第 %d 章",
	["Invalid texture path"] = "图片没有找到",
	["Click to enter the world of:\r\n%s"] = "点击进入世界:\r\n%s",
	["Texture/EBook/nextpage.png"] = true,
	["Texture/EBook/lastpage.png"] = true,
	["Open Help Book"] = "打开帮助图书",
	["Texture/EBook/ebook_bg.png"] = "Texture/EBook/ebook_bg.png;0 0 932 698",
	["Texture/EBook/menu_mybooks.png"] = true,
	["Texture/EBook/menu_newbook.png"] = true,
	["Texture/EBook/menu_downbook.png"] = true,
	["Texture/EBook/menu_publish.png"] = true,
	["Texture/EBook/menu_savebook.png"] = true,
	["Texture/EBook/menu_back.png"] = true,
	["Texture/EBook/menu_drawing.png"] = true,
	["Texture/EBook/menu_files.png"] = true,
	["Texture/EBook/menu_networking.png"] = true,
	["Texture/EBook/menu_audio.png"] = true,
	["Texture/EBook/menu_3dworlds.png"] = true,
	["Edit page title"] = "编辑页面标题",
	["Edit page content"] = "编辑页面内容",
	["Create a new page"] = "创建新的一页",
	["Delete current page"] = "删除当前页",
	["Lock/Unlock book"] = "锁定/解锁本书",
	["Do you want to save the screen shot of the current world to the book?\r\nCurrent book chapter is %s"] = "您希望将当前画面保存到书中么？\r\n当前的章节名为 %s",
	["Save(No GUI)"] = "保存(无界面)",
	["Save screen shot without 2D graphic user interface"] = "保存当前画面(但不包含2D界面)",
	["Save screen shot with everything"] = "保存当前画面(包含全部界面)",
	["Are you sure you want to delete the current page %s ?"] = "你确定要删除当前页(%s)么？",
	
	-- ebook: MainMenu.lua and mediamenu.lua
	["Delete"] = "删除",
	["Open"] = "打开",
	["Book Name"] = "书名",
	["Upload to web"] = "上传到网络",
	["Print"] = "打印",
	["Export Zip File"] = "导出Zip文件",
	["Chapter 1"] = "第 1 章",
	["Book successfully created. You can now edit the book."] = "成功的创建了图书。您可以编辑您的图书了。",
	["Please select a world from the list first"] = "请先从列表中选择一个世界",
	["World Path"] = "世界目录",
	["Create a world based on an existing world"] = "根据已有世界创建一个新世界",
	["Create an empty world"] = "创建一个空白的世界",
	["Use scene objects in the base world"] = "使用已有世界中的物体",
	["Use characters in the base world"] = "使用已有世界中的人物",
	["Start World"] = "开始世界",
	["Congratulations!"] = "恭喜！",
	["Screen Shot"] = "截图",
	["Movies"] = "电影",
	["All"] = "全部",
	["Clear"] = "清除",
	["Media Path"] = "媒体路径",
	["Maintain Aspect Ratio"] = "保持长宽比",
	["- Embed some body else's world in your book"] = "- 将朋友的世界收藏于书中",
	["- Corperatively build 3D world with others"] = "- 和朋友共同创建世界",
	["- Invite friends to help building your world"] = "- 邀请朋友访问你的世界",
	["Function is now in alpha test"] = "此功能正在Alpha测试阶段",
	["I want to participate!"] = "我要参加！",
	["Record"] = "录制",
	["Play"] = "播放",
	["Stop"] = "暂停",
	["Play my own voice (need a microphone)"] = "播放我的录音(需要麦克风)",
	["Play sound from a file"] = "播放文件",
	["sec"] = "秒",
	["Loop music"] = "循环播放",
	["the file specified does not exist."] = "指定的文件不存在。",
	["You are not able to record sound. Please make sure you have a microphone installed on your computer. And that you have write permission on system disk."] = "您无法录音: 也许你的计算机没安装麦克风，或者您没有磁盘访问权限。",
	["Your voice is now being recorded. Please speak in front of your microphone"] = "您的声音正在被录制； 请对着麦克风讲话。",
	["Auto save player position"] = "自动保存玩家位置",
	["Select a book below and click open button"] = "从列表中选择一本书，然后点击打开",
	["Enter book name and click OK button"] = "输入书名，然后点击确定按钮",
	["Download books from our web site"] = "从互联网上下载图书:",
	["Total Number of Books:"] = "图书总数:",
	["Most recent books:"] = "最近的书:",
	["%s(readonly)"] = "%s(只读)",
	["invalid book file"] = "无法打开",
	["return to book"] = "返回到图书\r\n右键点击保存并返回",
	["Are you sure you want to remove the associated world %s from this page?"] = "您确定要取消3D世界%s同这一页的连接么?",
	
--
--script/kids/3DMapSystemApp/Developers/TranslateFilePage.lua
[ "已经覆盖. 你可以恢复原来文件在temp/tranlated_files/" ] = true, 
[ "结果已经复制到裁剪版中. 你可以Ctrl-V到任何编辑器中" ] = true, 
[ "只有NPL文件才可以生成" ] = true, 
[ "请选择一个有效的NPL或MCML文件" ] = true, 

--
-- script/kids/3DMapSystemUI/Desktop/DesktopWnd.lua
[ "正在以单机模式运行!" ] = true, 
[ "你确定要退出程序么?" ] = true, 
[ "正在验证用户身份, 请等待..." ] = true, 
[ "返回登陆页" ] = true, 
[ "欢迎 %s, 登录成功!" ] = true, 
[ "用户名和密码不能为空, 如果你尚未注册, 请点击新建用户按钮." ] = true, 

--
-- script/kids/3DMapSystemApp/appkeys.lua
[ "载入/保存 虚拟世界; 发布/下载虚拟世界; 管理游戏世界服务器。" ] = true, 
[ "在3D世界中用画笔绘制图案和贴图：可以在可换贴图的3D模型上绘制，可以用外部图片，电影，Flash文件做模型贴图" ] = true, 
[ "快速屏幕截图、上传图片、浏览其他玩家上传的图片" ] = true, 
[ "浏览、使用、制作3D工程图；与朋友分享你的3D作品. 主要是简化用户在平时和某些APP中的创作。应该也会有人创造出非常好的工程图，在关系网中流传开来。玩家的背包中可以有朋友的，自己的，他人的工程图纸。工程图APP是官方比较重要的APP之一" ] = true, 
[ "创建新的虚拟世界向导。向导提供事先制作好的世界，用户可以直接修改来生成自己的世界。 " ] = true, 
[ "让玩家和其他应用程序建立任务的应用程序。 任务是和奖励紧密联系的。用户和其他APP可以通过Task APP 制作和发放任务。任务支持多种完成条件和奖励条件。" ] = true, 
[ "编辑自然环境的应用程序: 包括天空、海洋、陆地等" ] = true, 
[ "用户可以上传和使用图片相册、3D模型，并和朋友共享。用户可以将图片和3D模型有选择的加入到自己的创作工具栏中，在3D世界中使用。应用程序开发者也可以将资源发布到自己的应用程序首页，推荐给应用程序的用户。" ] = true, 
[ "管理/同步所有用户的信息Profile (mcml). 用户的信息包括基本信息、朋友列表(social graph)、应用程序博客App boxes(Avatar, Map land, ...)等" ] = true, 
[ "编辑人物的种族、相貌、衣着和道具，以及玩家的化身(avatar)管理." ] = true, 
[ "浏览、阅读、制作3D电子书。3D电子书由玩家创作的文字，图片，声音，3D世界组成。 用户可以用它制作App帮助和说明书，贺卡，相册等等，发布后可以和朋友共享。" ] = true, 
[ "为应用程序开发商和用户提供可交易物品的背包空间服务, 同时包括物品管理，不同背包内的物品买卖和交易" ] = true, 
[ "聊天即时通讯: 支持组、好友列表、隐私管理等" ] = true, 
[ "建筑换装系统。像搭积木一样制作一个房子: 地板、楼层、窗户、桌面、装饰等" ] = true, 
[ "在3D世界中显示小地图：包括玩家和NPC位置, 应用程序传送点位置等" ] = true, 
[ "帕拉巫世界介绍: 包含30分钟的社区引导、社区教程、制作群、APP开发网 & SDK、帮助、CG等. 30分钟的社区引导包括：注册，建立3D形象，加入城市，学习3D的操作，创建和浏览关系网和应用程序" ] = true, 
[ "应用程序开发者，用来调试NPL程序的工具集" ] = true, 
[ "提供2D、3D的地图服务：包括地球尺度的虚拟土地的浏览、买卖、交易、基于Map的广告、个人地图、搜索等等" ] = true, 
[ "为应用程序开发商和用户集中的提供创建、加入他人世界的房间服务" ] = true, 
[ "内嵌的Internet网页浏览器. 可以在3D世界中直接打开并操作网页。支持多种窗口模式和3D材质模式。应用程序开发商可以调用。" ] = true, 
[ "添加/删除程序的应用程序" ] = true, 
[ "创建模型等" ] = true, 
[ "游戏内的缺省用户桌面, 允许用户自定义在游戏内桌面, 添加Widgets等" ] = true, 
[ "为应用程序开发商和用户提供用户行为在人际关系网中的传播" ] = true, 
[ "进化宠物系统.宠物是社交动物,可以被玩家领养." ] = true, 
[ "更改桌面及所有UI的图形风格,背景音乐等。" ] = true, 
[ "创建开发其他应用程序的应用程序。" ] = true, 
[ "让玩家建立自己的组群、公会、公司。玩家可以浏览、加入其他人建立的组织，参加组织的讨论、活动等。组群的用户通常会聚集在城市中的某些位置。某些庞大、活跃、地理位置集中的组群可以向官方申请成为新的城市。" ] = true, 
[ "给其他应用程序提供多种样式的可定制的首页。开发者只需写一行代码就可以让自己的APP首页具有下面功能: (1) 大厅服务：用户可以通过首页创建或加入其他人或开发者的3D在线世界 (2) 商城：用户可以买到此应用程序的物品 (3) BBS论坛：发布收集用户意见，开发者消息等 (4) 美术资源管理：制定哪些相册图片，3D模型可以显示在创建工具栏中，在3D世界中使用。" ] = true, 
[ "给其他应用程序提供BBS论坛方式的聊天、留言板窗口。大多数APP的首页都有一个使用本应用的论坛，上面可以收集用户意见、发布消息等" ] = true, 
[ "更改计算机的图形、声音、键盘等的设置" ] = true, 
[ "在游戏中录制流媒体视频: 支持AVI,WMV, Xvid, Divx, 3D立体Stereo输出等。" ] = true, 
[ "提供各种样式的登陆与认证窗口。支持官网和第三方认证方式，应用程序开发商和用户都可以使用。" ] = true, 

--
-- script/kids/3DMapSystemUI/Desktop/AppTaskBar.lua
[ "星图" ] = true, 
[ "当前应用程序桌面" ] = true, 
[ "锁定/解锁应用程序按钮" ] = true, 
[ "我的首页" ] = true, 

--
-- script/kids/3DMapSystemApp/Login/app_main.lua
[ "个人档案" ] = true, 
[ "登陆 -- 帕拉巫" ] = true, 
[ "制作群" ] = true, 
[ "官网" ] = true, 
[ "确认要退出游戏么?" ] = true, 
[ "注销" ] = true, 
[ "登陆窗口" ] = true, 
[ "首页" ] = true, 
[ "制定桌面首页" ] = true, 
[ "退出" ] = true, 
[ "确认要注销, 并返回登陆页么?" ] = true, 
[ "登陆" ] = true, 
[ "教程" ] = true, 
[ "我的首页" ] = true, 

--
-- script/kids/3DMapSystemApp/profiles/app_main.lua
[ "个人档案" ] = true, 
[ "找朋友" ] = true, 
[ "个人世界" ] = true, 
[ "我的个人档案" ] = true, 
[ "访问世界" ] = true, 
[ "我的好友" ] = true, 
[ "朋友" ] = true, 
[ "隐私管理" ] = true, 
[ "我的档案" ] = true, 
[ "邀请朋友" ] = true, 
[ "App注册" ] = true, 
[ "个人信息, 交友" ] = true, 
[ "我的首页" ] = true, 

--
-- script/kids/3DMapSystemUI/Settings/app_main.lua
[ "欢迎页" ] = true, 
[ "帮助" ] = true, 
[ "设置..." ] = true, 
[ "欢迎页面" ] = true, 
[ "设置" ] = true, 
[ "帮助页" ] = true, 
[ "提交Bug" ] = true, 

--
-- script/kids/3DMapSystemApp/EditApps/app_main.lua
[ "添加/删除程序" ] = true, 

--
-- script/kids/3DMapSystemUI/Desktop/StartAppPage.lua
[ "创造、共享3D工程图纸" ] = true, 
[ "聊天" ] = true, 
[ "截图上传, 视频录像" ] = true, 
[ "世界" ] = true, 
[ "美术资源创作工具" ] = true, 
[ "大自然" ] = true, 
[ "PEDN 开发网与工具箱" ] = true, 
[ "改变天空,陆地,海洋" ] = true, 
[ "资源管理" ] = true, 
[ "创造" ] = true, 
[ "即时通讯;传送到朋友身边" ] = true, 
[ "截图与录像" ] = true, 
[ "工程图" ] = true, 
[ "帕拉巫开发" ] = true, 
[ "养宠物的游戏" ] = true, 
[ "宠物" ] = true, 
[ "电子书" ] = true, 
[ "创造3D世界的工具集" ] = true, 
[ "创建、发布3D世界向导" ] = true, 
[ "制作3D电子书" ] = true, 
[ "我的档案" ] = true, 
[ "人物形象" ] = true, 
[ "个人信息, 交友" ] = true, 
[ "改变3D人物的形象" ] = true, 

--
-- script/kids/3DMapSystemApp/worlds/app_main.lua
[ "星图" ] = true, 
[ "加载3D世界" ] = true, 
[ "世界" ] = true, 
[ "你需要发布世界, 其他玩家才能进入你的世界和你共同创造交流" ] = true, 
[ "新建世界向导" ] = true, 
[ "连接" ] = true, 
[ "世界服务器" ] = true, 
[ "新建3D世界" ] = true, 
[ "我的星球" ] = true, 
[ "创建世界" ] = true, 
[ "还没有建立同游戏服务的链接, 请稍候尝试连接" ] = true, 
[ "载入玩家家园世界" ] = true, 
[ "保存 & 发布世界" ] = true, 
[ "创建、发布3D世界向导" ] = true, 
[ "请经常保存您的世界" ] = true, 
[ "你可以从别人创建的世界中派生自己的世界" ] = true, 
[ "保存&发布世界" ] = true, 
[ "载入世界" ] = true, 

--
-- script/kids/3DMapSystemApp/WebBrowser/app_main.lua
[ "Web浏览器" ] = true, 
[ "您确定要使用Windows浏览器打开文件 %s?" ] = true, 
[ "MCML浏览器" ] = true, 
[ "外部浏览器" ] = true, 

--
-- script/kids/3DMapSystemUI/Creator/app_main.lua
[ "模型" ] = true, 
[ "用建筑部件盖一层或多层的房子: 请先建地基" ] = true, 
[ "你可以在画板类的物体上涂鸦, 点击这类物体时,左侧会出现画板" ] = true, 
[ "贴图属性" ] = true, 
[ "创造工具集" ] = true, 
[ "人物属性" ] = true, 
[ "编辑" ] = true, 
[ "创造" ] = true, 
[ "人物" ] = true, 
[ "鼠标右键点击物体, 察看属性" ] = true, 
[ "你可以改变部分动物的皮肤颜色, 比如黑猫, 白猫" ] = true, 
[ "编辑面板" ] = true, 
[ "按Esc键取消选择" ] = true, 
[ "在你盖房子前, 可以先将地表铲平" ] = true, 
[ "属性" ] = true, 
[ "创造3D世界的工具集" ] = true, 
[ "这里你可以创造出植物, 动物, 建筑物, 交通工具等" ] = true, 
[ "请经常保存您的世界" ] = true, 
[ "你可以赋予人物各种角色, 请创建并点击人物" ] = true, 
[ "点击物体, 然后点击平移, 可以将物体移到当前人物的脚下" ] = true, 
[ "部件" ] = true, 

--
-- script/kids/3DMapSystemUI/Env/app_main.lua
[ "更改地貌与地表" ] = true, 
[ "更改海洋的颜色与水面高度" ] = true, 
[ "更改天空和云雾的颜色与样式" ] = true, 
[ "陆地" ] = true, 
[ "大自然" ] = true, 
[ "海洋" ] = true, 
[ "天空" ] = true, 
[ "改变天空,陆地,海洋" ] = true, 
[ "请经常保存您的世界" ] = true, 
[ "改变地表色彩时, 可以用鼠标右键点击图案将其擦除" ] = true, 
[ "环境设置" ] = true, 
[ "在你盖房子前, 可以先将地表铲平" ] = true, 

--
-- script/kids/3DMapSystemUI/MyDesktop/app_main.lua
[ "发送Bug或建议" ] = true, 
[ "您进入了行走模式. 请按 R 键返回跑步模式" ] = true, 
[ "显示当前应用程序帮助(F1键)" ] = true, 
[ "我的桌面" ] = true, 
[ "跑步(R)" ] = true, 
[ "切换飞翔和着陆状态(F键)" ] = true, 
[ "保存或发布世界" ] = true, 
[ "按Enter键,打开对话面板" ] = true, 
[ "通过右下角的许多按钮, 你可以找到帕拉巫世界中的其他居民" ] = true, 
[ "您进入了飞行状态. 请按 F 键返回重力状态" ] = true, 
[ "当前世界服务器状态" ] = true, 
[ "切换跑步和走路状态(R键)" ] = true, 
[ "点击鼠标中键可以瞬移" ] = true, 
[ "缺省桌面" ] = true, 
[ "反复的按Space键,可以跳得更高" ] = true, 
[ "显示/隐藏小地图: 包括玩家和NPC位置等" ] = true, 
[ "按住鼠标左键不放移动鼠标,可以改变视角" ] = true, 
[ "显示/隐藏提示文字" ] = true, 
[ "显示/隐藏群体聊天窗口(Enter键)" ] = true, 
[ "显示提示" ] = true, 
[ "点击左下角的按钮, 可以切换到其他应用程序桌面" ] = true, 
[ "按住鼠标右键不放移动鼠标,同时按住W,A,S或D键可以控制人物" ] = true, 
[ "飞翔(F)" ] = true, 
[ "显示/隐藏提示" ] = true, 
[ "显示截图(F11键)" ] = true, 
[ "我的首页" ] = true, 

--
-- script/kids/3DMapSystemUI/ScreenShot/app_main.lua
[ "无法保存截图" ] = true, 
[ "快速截图 (F11)" ] = true, 
[ "电影拍摄,屏幕截图" ] = true, 
[ "电影与截图" ] = true, 
[ "屏幕截图" ] = true, 

--
-- script/kids/3DMapSystemUI/Desktop/ContextMenu.lua
[ "聊天" ] = true, 
[ "空白(无智能)" ] = true, 
[ "保存" ] = true, 
[ "全部文件(*.*)" ] = true, 
[ "驾驶" ] = true, 
[ "编辑" ] = true, 
[ "删除" ] = true, 
[ "无法获取%s的个人信息" ] = true, 
[ "交互" ] = true, 
[ "相对播放" ] = true, 
[ "加为密友" ] = true, 
[ "属性" ] = true, 
[ "对话" ] = true, 
[ "绝对播放" ] = true, 
[ "查看用户首页" ] = true, 
[ "人物电影" ] = true, 
[ "到我身边" ] = true, 
[ "电影人" ] = true, 
[ "移动" ] = true, 
[ "临时文件" ] = true, 
[ "场景角色" ] = true, 
[ "载入..." ] = true, 
[ "跟屁虫" ] = true, 
[ "收藏" ] = true, 
[ "电影" ] = true, 
[ "录制" ] = true, 
[ "停止" ] = true, 
[ "无法创建:" ] = true, 
[ "复制" ] = true, 
[ "人工智能" ] = true, 
[ "正在获取%s的个人信息, 请稍候..." ] = true, 
[ "坐在这里" ] = true, 
[ "保存..." ] = true, 
[ "URL跳转" ] = true, 
[ "附身" ] = true, 
[ "随机走动" ] = true, 
[ "NPC(RPG游戏)" ] = true, 
[ "暂停" ] = true, 
[ "人物电影文件(*.txt)" ] = true, 

--
-- script/kids/3DMapSystemApp/Login/TutorialPage.lua
[ "介绍PEDN开发网, 应用程序架构, 创建属于你的3D互联网产业(建设中...)" ] = true, 
[ "介绍PEDN开发网, 应用程序架构, 创建属于你的3D互联网产业.(建设中...)" ] = true, 
[ "新手村" ] = true, 
[ "提高篇" ] = true, 
[ "worlds/Official/新手之路" ] = true, 
[ "各种评选活动的颁奖地点(建设中...)" ] = true, 
[ "结交新朋友(建设中...)" ] = true, 
[ "情侣岛" ] = true, 
[ "高级篇" ] = true, 
[ "基础篇" ] = true, 
[ "开发篇" ] = true, 
[ "教你基本人物操作, 使用工具, 创造3D家园, 探索3D社交网络" ] = true, 
[ "开发者村" ] = true, 
[ "如果你有7-12岁的孩子, 可以陪他们一起创作, 全面提高儿童的想像力, 创造力, 领导力(建设中...)" ] = true, 
[ "教你制作智能人物, 拍摄电影, 以及部分社交平台功能(建设中...)" ] = true, 
[ "儿童篇" ] = true, 
[ "worlds/Official/新手之路/preview.jpg" ] = true, 
[ "儿童村" ] = true, 
[ "颁奖岛" ] = true, 

--
-- script/kids/3DMapSystemApp/Login/ParaworldStartPage.lua
[ "3D世界(*.zip;*.)" ] = true, 
[ "确认密码与密码不一致\n" ] = true, 
[ "地址栏" ] = true, 
[ "恭喜！注册成功！\n 请您查收Email激活您的登录帐号." ] = true, 
[ "全部文件(*.*)" ] = true, 
[ "我最近使用过的" ] = true, 
[ "worlds/Official/新手之路" ] = true, 
[ "名字太短了\n" ] = true, 
[ "更改背景" ] = true, 
[ "正在连接注册服务器, 请等待" ] = true, 
[ "官方缺省背景" ] = true, 
[ "您是何时出生的?" ] = true, 
[ "请选择出生日期\n" ] = true, 
[ "Email地址格式不正确\n" ] = true, 
[ "密码太短了\n" ] = true, 
[ "从3D世界或文件..." ] = true, 
[ "我的世界" ] = true, 
[ "全部3D世界" ] = true, 
[ "图片(*.jpg; *.png; *.dds)" ] = true, 
[ "系统主题背景" ] = true, 
[ "背景设置..." ] = true, 
[ "视频(*.avi; *.wmv; *.swf)" ] = true, 
[ "无背景" ] = true, 
[ "图片和视频" ] = true, 
[ "世界目录(*.)" ] = true, 
[ "新手村背景" ] = true, 
[ "开始桌面页" ] = true, 

--
-- script/kids/3DMapSystemApp/Login/LoginProcedure.lua
[ "登陆成功, 正在同步用户信息, 请稍候..." ] = true, 
[ "账号已是激活状态不必再次激活" ] = true, 
[ "申请土地" ] = true, 
[ "无法从服务器获取用户信息, 可能服务器正忙, 请稍候再试." ] = true, 
[ "连接的主机没有反应,连接尝试失败" ] = true, 
[ "选择形象" ] = true, 
[ "身份信息" ] = true, 
[ "发送成功, 请查看你的邮箱" ] = true, 
[ "数据不存在或已被删除" ] = true, 
[ "是否希望重新发送确认信到你注册时提供的邮箱?" ] = true, 
[ "未知服务器错误, 请稍候再试" ] = true, 

--
-- script/kids/3DMapSystemApp/profiles/ProfileManager.lua
[ "<pe:name uid='%s'/>和<pe:name uid='%s'/>成为了好朋友" ] = true, 
[ "添加失败了, 查看log了解原因" ] = true, 
[ "已经删除, 你的好友列表会稍后更新" ] = true, 
[ "不能加自己为好友." ] = true, 
[ "刚刚同意了你的好友请求" ] = true, 
[ "已向对方发送了好友请求" ] = true, 
[ "传送到世界" ] = true, 
[ "你在帕拉巫又多了一位新朋友" ] = true, 
[ "你们已经是好友了" ] = true, 
[ "<pe:name uid='%s'/>请求加你为朋友<a onclick='Map3DSystem.App.profiles.ProfileManager.AddAsFriend' param1='%s'>同意</a>" ] = true, 
[ "您确定要删除好友么?" ] = true, 
[ "不能删除自己" ] = true, 
[ "删除失败,  查看log了解原因" ] = true, 
[ "添加成功, 你们已成为了好友" ] = true, 

} end);