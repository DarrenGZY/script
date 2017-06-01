-- 2006.11.24 translation done by Li,Xizhi
NPL.load("(gl)script/ide/Locale.lua");
local L = CommonCtrl.Locale("IDE");
L:RegisterTranslations("zhCN", function() return {
	-- Shared assets
	["asset_headarrow"] = "character/common/headarrow/headarrow.x",
	["asset_headquest"] = "character/common/headquest/headquest.x",
	["asset_headexclaimed"] = "character/common/headexclaimed/headexclaimed.x",
	["asset_defaultPlayerModel"] = "character/v1/01human/baru/baru.x",
	["asset_defaultSkyboxModel"] = "model/Skybox/skybox3/skybox3.x",
	
	-- Common
	["OK"] = "确定",
	["Yes"] = "是",
	["No"] = "否",
	["Cancel"] = "取消",
	["Close"] = "关闭",
	["None"] = "无",
	["Delete"] = "删除",
	["Open"] = "打开",
	["Abort"] = "终止",
	["Retry"] = "重试",
	["Ignore"] = "忽略",
	["Edit"] = "编辑",
	["Snapshot"] = "快照",
	
	-- MCML
	["Browse..."] = "浏览...",
	["Root Directory"] = "根目录",
	["Model"] = "模型",
	["Texture"] = "贴图",
	["Character"] = "角色",
	["Script"] = "脚本",
	["all files(*.*)"] = "全部文件(*.*)",
	["MCML Browser"] = "MCML浏览器",
	["Previous Page"] = "上一页",
	["Next Page"] = "下一页",
	
	-- MCML for <pe:name>
	["you"] = "你",
	["youself"] = "你自己",
	["herself"] = "她自己",
	["himself"] = "他自己",
	["itself"] = "它自己",
	["anonymous"] = "匿名",
	["click to view the profile of %s"] = "点击查看%s的个人资料",
	["click to view its profile"] = "点击查看个人资料",
	
	-- MCML for <pe:pager>
	["Previous"] = "上一页",
	["Next"] = "下一页",
	-- MCML component
	["Not downloaded"] = "尚未下载",
	["Click to start download"] = "点击开始下载",
	["Downloading ..."] = "正在下载...",
	["Download complete"] = "下载完成",
	["Download terminated"] = "下载中断",
	["Completing: %d/%dKB"] = "已完成:%d/%dKB",
	
	-- auto tips
	["Tips:"] = "提示:",
	["press Ctrl key to sit!"] = "按Ctrl键坐在座位上",
	["mouse click on mark or press Ctrl key to change the building block!"] = "请用鼠标点击标记或按Ctrl键改变建筑模块!",
	["press Ctrl key to talk to it!"] = "按Ctrl键和人物对话",
	["press Shift key to mount on it!"] = "按Shift键驾驶",
	["press Space key to get off!"] = "按Space键可以跳下来",
	["press Shift key to switch to it!"] = "按Shift键切换人物",
	["press Esc key to cancel selection!"] = "按Esc键取消选择",
	["press Shift key and then Space key to get off!"] = "按Shift键,然后按Space键跳下来",
	["autotips"] = {
		"按住鼠标右键不放移动鼠标,同时按住W,A,S或D键可以控制人物",
		"按住鼠标左键不放移动鼠标,可以改变视角",
		"反复的按Space键,可以跳得更高",
		"按Esc键取消选择",
		"请经常保存您的世界",
	},
	
	-- common folders
	["Shared Media Folder"] = "Texture/sharedmedia/",
	["Advertisement Folder"] = "Texture/advertisement/",
	["Internet Folder"] = "Texture/internet/",
	["Audio Folder"] = "Audio/",
	
	["Do you want to delete old drawing at \n%s?"] = "你是否要删除上次的图画\n%s?",
	["open file dialog: texture file extensions"] = {"全部 (*.jpg; *.png; *.dds; *.swf; *.flv)", "图片 (*.jpg; *.png; *.dds)", "动画 (*.swf; *.flv)", },
	["My work"] = "我的创作",
	["Media lib"] = "媒体库",
	["Advertisement"] = "广告",
	["Internet"] = "互联网",
	["Reset image"] = "清除图片",
	["Draw by myself"] = "我来自己画",
	["Open file..."] = "打开文件...",
	["Random images:"] = "随机图片:",
	
	-- CharPropertyPage.lua
	["change appearance or skin"] = "改变外表或皮肤",
	["save to disk"] = "保存到磁盘",
	["I am"] = "我是",
	["behavior"] = "行为",
	["only character can be given a type"] = "人物才能被赋予类型。",
	["I become a "] = "我变成了",
	["I can not be changed to a dummy completely, since you are controlling me now."] = "我没有能彻底成为木头人，因为你还在操纵我。",
	["Custom character is not available now."] = "自定人人物还没有...",
	["Only character can have behaviors."] = "人物才能被赋予动作。",
	["I am about to bla bla bla"] = "我要自言自语了..",
	["Let me wander near here."] = "我要闲逛了...",
	["I am a piggy now."] = "我是跟屁虫..",
	["I am a shopkeeper"] = "我要开张了...",
	["I want to sell."] = "我要卖菜了...",
	["Ah, I am a dummy now."] = "啊, 我没IQ了...",
	["the terrain brush size can only be within (0.1, 100)"] = "地表贴图刷子的大小只能在[0.1, 100]之间",
	["the height field brush size can only be within (5, 250)"] = "地形刷子的大小只能在[5, 250]之间",
	["I will go home now."] = "回家喽!!!",
	["I am already near my home."] = "我已经在家附近了!!!",
	["My home is right here."] = "我的家就在这里!!!",
	["Donot you see me? I am here!"] = "我在这, 你看不见我么!!!",
	["I can not change skin"] = "我不能更换皮肤\r\n",
	["rename failed: you can only change the name of a character, when you are not controlling it, and that the name should be identical."] = "改名失败：你只能为没有附身的人物改名，并且名字不能重复。",
	["character has been saved"] = "人物已保存",
	["I am not an NPC in this world, so I can not be saved."] = "我不是这个世界的NPC，所以不能被保存。",
	["When you click on me, I will speak:\n%s"] = "当你点击我时,我会说:\n%q",
	
	-- worlds_db.lua
	["create world description"] = [[将创建新世界（缺省派生自空白世界）， 在程序的安装目录下将创建一个与世界同名的目录，里面包含世界资源。 世界名称只能为英文，不能有空格。]],
	["unnamed"] = "没有名字",
	["You do not have permission to do this action in this world\n"] = "您在这个世界中没有权限进行这个操作\n",
	
	-- load world, new world and save world
	["World Name"] = "世界名称",
	["Author Name"] = "作者",
	["Derived from"] = "派生自",
	["world name can not be empty"] = "世界名称不能为空",
	[" failed loading the world."] = "世界载入失败了。",
	[" world does not exist"] = "世界不存在",
	["scene has been saved to:\n"] = "场景被存盘至:\n",
	["scene has been saved.\n"] = "场景被存盘\n",
	["scene is not modified"] = "场景没有被更改过",
	["Do you want to save your current world?"] = "您希望保存当前世界么？",
	
	["_emptyworld presents an empty world. Please use another name."] = "_emptyworld是系统隐含世界，它代表一个空世界。请使用其他名字创建世界",
	["world with the same name already exist. To use the name, please manually delete the folder ./"] = "世界已经存在了，如想重新创建，请手工删除文件夹./",
	["Failed creating the world"] = "世界创建失败了。",
	["The base world does not exist"] = "被派生的世界不存在。",
	[" Failed loading the world."] = "世界载入失败了。",
	["This world is ready-only, you can not save it."] = "当前世界是只读的，您不能保存它",
	["%d loaded characters in the scene are saved. All visible world near the current player are saved."] = "共有%d个已加载的人物被保存，当前人物周围所有的地形、地表、物体等都被保存了。",
	["Save only modified content (fast)"] = "只保存修改过的内容(快!)",
	["Save Full"] = "完全保存",
	["Save everything in the scene (slow)"] = "保存当前人物周围所有的内容, 尽管他们从未被修改过。\r\n可能需要几分钟完成。",
	["snapshot"] = "拍照留影",
	["Upload my screen shot"] = "上传作品截图到我的小宇宙",
	["publish"] = "发布",
	["Upload my 3D world to community site"] = "发布我的动漫世界到<帕拉巫小宇宙>社区",
	["world is successfully packed to %s and ready for publication."] = "世界已经成功的压缩到%s, 可以发行了",
	["Click the save button to save your current world"] = "点击保存按钮，保存你的当前世界",
	["You do not have permission to save the world"] = "您没有保存这个世界的权限",
	
	-- loginbox.lua
	["Hi, %s. You are already signed in."] = "你好！%s 你已经成功登陆",
	["Unable to login, perhaps your user name and password is invalid."] = "对不起，目前无法登录，可能是您的用户名和密码不正确。",
	["sign out"] = "登出",
	["visit community website"] = "访问社区网站",
	["Please wait while login ..."] = "正在登陆，请等待...",
	["Network is not available, please try again later"] = "网络暂时无法连通，请稍候再试",
	["Stop login"] = "停止登陆",
	["Password can not be empty\n"] = "密码不能为空\n",
	["A new version is detected. Do you want to update now?"] = "检测到了新的版本，您是否希望现在更新?",
	["A new version is detected. You must update in order to use networking functions. Do you want to update now?"] = "检测到了新的版本，您必须更新才能使用网络功能。您是否希望现在更新?",
	
	
	-- OpenFileDialog.lua
	["Are you sure you want to delete the file\n %s ?"] = "您确定要删除文件\n%s?",
	["The file you specified does not exist:\r\n%s"] = "您指定的文件不存在:\r\n%s",
	["Are you sure that you want to open %s using external browser?"] = "您确定要用外部浏览器打开 %s 么?",
	["Are you sure that you want to create a folder at %s?"] = "您确定要创建文件夹 %s 么?",
	["Open File Directory:%s"] = "打开文件夹:%s",
	["File Type:"] = "文件类型:",
	["File Name:"] = "文件名:",
	["Look in:"] = "查找范围:",
	["Rename"] = "重命名",
	["Open folder with window explorer"] = "用Windows浏览器打开文件夹",
	["Please enter a different name in the file name editbox to rename it."] = "请在文件名输入框中输入您希望更改后的名字",
	["Unable to rename file %s\n to %s.Maybe due to insufficient access right."] = "无法将文件%s\n重命名为%s,可能权限不够.",
		
	-- object_editor.lua
	["Object"] = "物体",
	[" already exists. Please use a different name or leave it blank."] = " 已经存在，请不要给物体命名，或用另一个不同的名字",
	["Scene file: \n"] = "场景文件: \n",
	["successfully saved.\n"] = "存储成功.\n",
	["file has been overwritten after back up"] = "旧文件备份后，已被覆盖",
	["==distance too close==\nYou can not create the same object at the same location twice"] = "==物体距离太近了==\n您不能在同一位置重复创建物体",
	["Model does not exist:\r\n"] = "模型不存在:\r\n",
	[" \nhas already been loaded."] = " \n已被加载.",
	["OnLoadScript is not found"] = "物体加载文件没找到",
	["Object has been removed from the list, but is not deleted"] = "物体被从当前列表中移出，但没有被删除",
	["Object is not in the list"] = "物体不在列表中",
	["character has been removed from the scene"] = "角色已从场景中删除",
	["object has been removed from the scene"] = "物体已从场景中删除",
	["There is only one character left in the scene; you can not delete it."] = "场景中只剩下一个角色,你不能删除它.",
	["Object does not exist"] = "物体不存在",
	
	-- NetworkPannel.lua
	["Server does not exist\r\n"] = "服务器不存在\r\n",
	["Please enter your user name\r\n"] = "请输入用户名。\r\n",
	["Standalone"] = "单机模式",
	["Share my world"] = "共享我的世界",
	["My address:"] = "我的地址:",
	["Login another world"] = "登陆别人的世界",
	["User name:"] = "用户名:",
	["Password:"] = "密码:",
	["Login"] = "登陆",
	["Register"] = "注册",
	["Please register with ParaIDE (Press F5)->Network register"] = "请用ParaIDE (press F5)->Network 注册",
	-- explorer.lua
	["Address:"] = "地址:",
	["too many windows are opened"] = "您已经打开了太多的窗口",
	["Enter 3D World"] = "进入3D世界",
	["Open Web Site"] = "打开网页",
	["People's Comments"] = "朋友的评价:",
	["Leave comment:"] = "留言:",
	["Submit"] = "提交",
	["Host World"] = "共享我的世界",
	["Domain:"] = "域名:",
	["Remember user name and password"] = "记住我的用户名和密码",
	["Please login using your account"] = "请使用您的用户名和密码登陆",
	["Welcome %s! Your URL is:\r\nhttp://%s/%s"] = "%s，欢迎登陆！您的URL地址是\r\nhttp://%s/%s",
	["you does not have a personal world yet. Please create a new world with your user name "] = "您还没有创建自己的3D世界，请用您的用户名创建一个世界。用户名是 ",
	["homepage"] = "主页",
	["map"] = "地图",
	["Servers"] = "服务器",
	["My Game Server"] = "我的游戏主机",
	["My Space Server"] = "我的空间主机",
	["minimize window"] = "最小化窗口",
	["toggle window size"] = "切换窗口尺寸",
	["new window"] = "新建窗口",
	["last page"] = "上一页",
	["next page"] = "下一页",
	["stop"] = "停止",
	["refresh page"] = "刷新页面",
	["community map and search"] = "社区地图与搜索",
	["favourite"] = "收藏",
	["My home page"] = "我的主页",
	["History"] = "访问历史",
	["Email"] = "邮件",
	
	
	-- init_client.lua
	["Connecting..."] = "正在连接:",
	["Successfully logged in. \nworld name: %s\nRole: %s\nOnline users:%d\nGame Server Start Time:%s\nVisits: %d\n"] = "成功登陆游戏服务器\n世界名称：%s\n您的角色（权限）：%s\n当前用户数：%d\n服务器开机时间：%s\n访问数：%d\n",
	["The remote game server %s has just been restarted."] = "远程的游戏服务器 %s 刚刚被管理员重起了",
	["The server world is not synchronized with the local machine. Failed connecting to %s"] = "远程和本地的世界没有同步。同服务器%s 联机失败",
	["Sorry your client and server version does not match, please update your client or the server."] = "对不起，您的客户端的版本同游戏服务器的版本不兼容，请更新您的客户端",
	
	-- ActorMovieCtrl.lua
	["Current Time"] = "当前时间：",
	["Goto"] = "跳转",
	["Unit(s)"] = "单位(秒)",
	["save"] = "存盘",
	["load"] = "载入",
	["add"] = "添加",
	["dialog"] = "对话",
	["action"] = "动作",
	["effect"] = "特效",
	["loop"] = "循环",
	["loop frame has been inserted.To remove looping, just start record before the loop frame."] = "循环贞已被插入.如要删除循环,只需从前面的时刻开始录像.",
	["input must be numbers (in seconds)"] = "输入必须为数字（多少秒钟）",
	["actor movie file has been saved to: \n"] = "角色电影文件存盘到: \n",
	["actor movie file has been loaded: \n"] = "角色电影文件被载入: \n",
	-- ClipMovieCtrl.lua
	["clip name"] = "片段名：",
	["actors"] = "演员表：",
	["remove"] = "移出",
	["refresh"] = "刷新",
	[" does not exist"] = " 不存在.",
	
	-- movie lib
	["actor: "] = "角色: ",
	[" has been added to the current movie"] = " 已加入到当前电影",
	[" is not found in the scene"] = " 没有在场景中找到",
	[" is already in the movie actor list"] = " 已经在当前电影的角色列表中",
	["actor movie file has been successfully created"] = "角色电影文件创建成功:",
	["movie has been loaded. File: \n"] = "电影被加载 文件: \n",
	["movie file has been successfully saved:\r\n%s\r\nmovie contains non character objects:%d\r\n"] = [[
电影文件已被成功存盘:
%s
电影包含非角色人物: %d
]],
	-- loaderUI.lua
	["Loading ..."] = "载入中...",
	
	-- property_control.lua
	["undo"] = "撤销",
	["apply"] = "应用",
	["update"] = "更新",
	
	-- terrain_editor.lua
	["terrain and surface textures have been saved"] = "地貌和地表贴图已被保存",
	["%.1fm"] = "%.1f米",
	
	-- AI
	["selling fresh vegetable!"] = "买菜喽...新鲜的蔬菜...",
	["Hi, wanna some vegetable?"] = "你好！来买点蔬菜么",
	["Cheap! Cheap! Come and buy!"] = "黄瓜一块五二斤, 您要几斤",
	["Today is the first day. Everything is free."] = "今天开张,我请客...",
	["Welcome my guest! Come and see my shop."] = "你好！这位客官, 来小店吃顿便饭吧",
	["Wanna some drink?"] = "七两二锅头, 来咯~~~",
	["zzz..."] = "自言自语...",
	["Hi, there!"] = "你好！",
	["What can I do for you?"] = "你叫我有事么！",
	
	-- add_action.lua
	["add action:"] = "添加动作：",
	["hide"] = "隐藏",
	["close"] = "关闭",
	
	-- demo/recorder/main.lua
	["Video Recorder"] = "视频录像机",
	["Tips: Record video to any video file format"] = "提示：录制视频到任何视频文件格式",
	["FPS:"] = "帧率:",
	["Whether to use stereo video mode"] = "是否使用立体视频输出",
	["Stereo Separation:"] = "立体分离度:",
	["Custom"] = "自定义",
	["No"] = "否",
	["Yes"] = "是",
	["==Successfully in recording mode=="] = "==成功进入录像模式==\n点击左上角圆圈按钮后开始录像(快捷键F9)\n录像分辨率= %d X %d\n解码器:%s\n隐藏2D图形界面:%s\n视频文件:%s\n帧率:%d\n使用立体视频输出:%s\n立体分离度:%.3f\n",
	["==exited recording mode==\nOutput video file: %s"] = "==已退出录像模式==\n输出视频文件:%s",
	["save to"] = "存放到：",
	["file"] = "文件",
	["resolution"] = "分辨率：",
	["codec"] = "编码器：",
	["current codec"] = "当前编码器",
	["select another"] = "自选编码器",
	["hide UI"] = "隐藏界面",
	["whether to include user interface in the video"] = "是否在视频中包含用户界面",
	["Take screenshot"] = "截图(F11)",
	["Begin recording"] = "开始录制",
	
	-- chat_client.lua
	["[%s]says to all: %s\n"] = "[%s]对大家说: %s\n",
	
	-- UploadWorldPage.lua
	["Publishing:"] = "发布世界:",
	["visit my web space"] = "访问我的小宇宙",
	["successfully uploaded your 3D world"] = "成功的发布了您的3D世界",
	["Upload is broken"] = "上传被中断了",
	["world format is not correct"] = "世界格式不对",
	["Your service of 3D space server is not open."] = "您没有申请开通在线3D空间服务",
	["Your world is too big; you need to apply to the administrators."] = "您的世界太大了，需要向管理员申请才能上传",
	["Uploading to %s; Total file size %d KB"] = "正在上传您的世界到 %s; 文件大小 %d KB",
	["Upload complete!"] = "上传完成了",
	
	["Synchronizing:"] = "正在同步世界:",
	["Hide download"] = "后台下载",
	["Enter world"] = "进入世界",
	["Successfully synchronized world, click enter world!"] = "成功同步了世界，请点击进入世界按钮",
	["Please wait. It may take a few minutes."] = "请耐心等待, 可能需要几分钟",
	["Download is terminated"] = "下载过程终止了",
	["Server connection is not found or broken"] = "无法连接远程的服务器或与之连接中断了",
	["Connecting remote server, please wait..."] = "正在连接服务器，请稍候...",
	["Successfully retrieved IP; now sync with the 3D space server..."] = "成功的从服务器获得了IP信息, 正在同步3D空间数据...",
	["This user does not have any public 3D world"] = "此用户没有提供可浏览的3D世界",
	["Space server type is not supported"] = "不支持用户的空间服务器类型",
	["The user does not have a space server"] = "此用户没有开通3D空间服务，您不能访问它的个人世界",
	["3D world file is 100% synchronized!"] = "世界文件100%同步了！",
	["Download is terminated"] = "下载中断了",
	["Now synchronizing 3D space data: %d/%d bytes"] = "正在同步3D空间数据: %d/%d 字节",
	["Now downloading today's recommended 3D world"] = "正在下载今天推荐的3D世界...",
	["No 3D world to download today"] = "今天没有推荐的3D世界可下载",
	["Connecting to "] = "正在连接:",
	
	["Open history files..."] = "打开历史文件...",
	["All my works"] = "我的全部作品",
	["Upload my screenshot"] = "上传我的作品截图",
	["History..."] = "历史...",
	["Upload"] = "上传",
	["Title:"] = "作品标题:",
	["Abstract:"] = "作品说明:",
	["Category:"] = "作品类别:",
	["Upload arkwork category table"] = {"科幻", "游戏", "美术", "电影", "体育", "音乐", "英语", "历史",  "其他", },
	["My screenshot"] = "我的作品截图",
	["Please wait until the last transmission is finished."] = "请等待上一个作品传输完毕",
	["Uploading your work to the community web, please wait..."] = "正在上传您的作品到社区网,请耐心等待..",
	["Unable to upload your work, your local file does not exist"] = "您的作品暂时无法上传到社区网; 本地文件不存在",
	["Screen shot successfully uploaded\n%s\nSending article, please wait...\n\n"] = "作品截图成功上传到了社区网:\n%s\n正在提交作品到社区, 请耐心等待...\n\n",
	["Unable to upload your work\n"] = "您的作品暂时无法上传到社区网\n",
	["We are unable to upload your work to the community website\n"] = "您的作品暂时无法上传到社区网\n",
	["Work successfully uploaded:\nURL is %s\nDo you want to view it in a web browser?\n\n"] = "作品成功上传到了社区网:\n作品地址为%s\n是否现在用浏览器打开?\n\n",
	
	-- SimpleNPCTalkEditor.lua
	["Copy"] = "复制",
	["Copy the dialog of this character to be applied on other characters"] = "将这个人物的对话复制下来，将来可以用于其他人物",
	["Paste"] = "粘贴",
	["Apply the last copied dialog on this character"] = "将上一次复制的对话，用于这个人物身上",
	["NPC Event Table"] = {"当你点击我时，我会说:", "当你走近我时，我会说:", "当你离开我时，我会说:", "当我发现你时，我会说:", "我每时每刻都会说:", },
	["Tips: Enter dialog text on the edit boxes, each paragraph on a single line, then click OK button."] = "提示: 在横线上输入对话文字，每行一段话，然后点击确定",
	["Insert Media..."] = "插入媒体...",
	["Wear !"] = "头戴！",
	["Whether to display a ! mark on the head of the character"] = "是否在人物头顶显示一个感叹号！",
	["Wear ?"] = "头戴？",
	["Whether to display a ? mark on the head of the character"] = "是否在人物头顶显示一个问号？",
	["Sound and image file extensions table"] = {"声音(*.wav)", "图像(*.png; *.jpg; *.dds)", "动画(*.swf; *.flv)", "全部(*.wav; *.png; *.jpg; *.dds; *.swf; *.flv)", },
	["Sound Lib"] = "声音库",
	["Record"] = "录制",
	
} end);