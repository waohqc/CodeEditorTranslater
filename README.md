# CodeEditorTranslater
## 一个Xcode插件，选中源码、注释，翻译，英文转中文，以注释形式插入到上文
## AppStore：https://apps.apple.com/cn/app/codeeditortranslater/id6445995068?mt=12
### 1.配置CodeEditorTranslater
系统设置中搜索“扩展”，选择“扩展，Extensions”，点击XcodeSourceEditor，选择CodeEditorTranslater
<img src="https://user-images.githubusercontent.com/93604397/225652119-8e4081f8-522b-407b-83c7-3d27bc6d28c3.jpg" width="50%" height="50%">
<img src="https://user-images.githubusercontent.com/93604397/225653618-93b0177c-b797-4a11-b15f-60a5360ccffd.jpg" width="50%" height="50%">
### 2.翻译
打开Xcode，在代码编辑区选中英文句子/单词，顶部工具栏选择Editor->CodeEditorTranslater->EngToCN
<img src="https://user-images.githubusercontent.com/93604397/225653782-75bbee2c-a142-4595-b0a3-639920c1791c.jpg" width="50%" height="50%">
### 3.查看翻译
翻译将会在选中的句子/单词上方以注释形式添加
<img src="https://user-images.githubusercontent.com/93604397/225654004-62aded06-b182-42e8-a70f-864df5a4e623.jpg" width="70%" height="70%">
<img src="https://user-images.githubusercontent.com/93604397/225654021-70d531d4-0cc5-4a63-9e5d-d443796be91f.jpg" width="70%" height="70%">
### 4.为CodeEditorTranslater配置快捷键
打开Xcode，顶部工具栏选择Xcode->Settings，将输入法切换到ABC(否则可能无法输入快捷键)，选择Key Bindings，搜索EngToCN，双击后输入新的快捷键，我这里配置的是Command+T。
<img src="https://user-images.githubusercontent.com/93604397/225654250-b21ca42c-8e8d-4e34-af88-d68dc1c42c9b.jpg" width="70%" height="70%">
### 5.关于翻译源
翻译源使用有道翻译网页api，无cookie访问
