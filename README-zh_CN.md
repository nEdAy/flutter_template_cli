###### 文档支持语言

| [en_US](README.md) | zh_CN - 本文件 |
|-------|-------|

Flutter 模板的官方 CLI。

```shell
  // 安装:
  pub global activate flutter_template_cli 
  // 使用本命令需要设置系统环境变量: [FlutterSDK安装目录]\bin\cache\dart-sdk\bin
  
  flutter pub global activate flutter_template_cli
  
  // 在当前目录创建一个 Flutter 项目:
  // 注: 默认使用文件夹名称作为项目名称
  // 你可以使用 `ftc create project:my_project` 给项目命名
  // 如果项目名称有空格则使用 `ftc create project:"my cool project"`
  ftc create project
  ftc create package
  ftc create plugin
  ftc create module
  
  // 在现有项目中生成所选结构:
  ftc init
  
  // 为你的项目安装依赖:
  ftc install camera
  
  // 为你的项目安装多个依赖:
  ftc install http path camera
  
  // 为你的项目安装依赖(指定版本号):
  ftc install path:1.6.4
  
  // 你可以为多个依赖指定版本号
  
  // 为你的项目安装一个dev依赖(dependencies_dev):
  ftc install flutter_launcher_icons --dev
  
  // 为你的项目移除一个依赖:
  ftc remove http
  
  // 为你的项目移除多个依赖:
  ftc remove http path
  
  // 更新 CLI:
  ftc update
  // 或 `ftc upgrade`
  
  // 显示当前 CLI 版本:
  ftc -v
  // 或 `ftc -version`
  
  // 帮助
  ftc help
```

# 探索 CLI

让我们看看 CLI 都有啥命令吧

### 新建项目

```shell
  ftc create project
```

用来新建一个项目, 创建默认目录之后, 它会运行一个 `ftc init`

### 初始化

```shell
  ftc init
```

这条命令要慎用，它会覆盖 lib 文件夹下所有内容。
[flutter-getx-with-null-safety-template](https://github.com/nEdAy/flutter-getx-with-null-safety-template)。

### 拆分不同类型文件

有一天有个用户问我，是否可能修改一下最终文件名，他发现 `my_controller_name.controller.dart` 比 CLI 生成的默认文件 `my_controller_name_controller. dart` 更具有可读性，考虑到像他这样的用户，我加了个选项，可以让你选择你自己的分隔符，只需要在你的 pubsepc.yaml 里这样写

例子:

```yaml
flutter_template_cli:
  separator: "."
```

### 你的 import 乱不乱?

为了帮你管理你的 import 我加了个新命令: `ftc sort`, 除了帮你排序整理 import, 这条命令还帮你格式化 dart 文件。感谢 [dart_style](https://pub.dev/packages/dart_style).
 `ftc sort` 会用 [separator](#separator-file-type) 重命名所有文件。
如果不想重命名文件，使用 `--skipRename` 。

如果你喜欢用相对路径写 import, 使用 `--relative` 选项. flutter_template_cli 会自动转换。

### cli 国际化

CLI 现在有一套国际化系统。

如果你想把 CLI 翻译成你的语言:

1. 在 [translations](/translations) 目录创建一个你语言对应的json文件
2. 从 [file](/translations/en.json) 复制所有key, 然后翻译成你的语言
3. 发送你的 PR.
