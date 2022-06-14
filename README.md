###### Documentation languages

| en_US - this file |[zh_CN](README-zh_CN.md) |
|-------|-------|

Official CLI for Flutter Template to build Flutter Modules easily.

```shell
  // To install:
  pub global activate flutter_template_cli 
  // (to use this add the following to system PATH: [FlutterSDKInstallDir]\bin\cache\dart-sdk\bin
  
  flutter pub global activate flutter_template_cli
  
  // To create a flutter project in the current directory:
  // Note: By default it will take the folder's name as project name
  // You can name the project with `ftc create project:my_project`
  // If the name has spaces use `ftc create project:"my cool project"`
  ftc create project
  ftc create package
  ftc create plugin
  ftc create module
  
  // To generate the chosen structure on an existing project:
  ftc init
  
  // To install a package in your project (dependencies):
  ftc install camera
  
  // To install several packages from your project:
  ftc install http path camera
  
  // To install a package with specific version:
  ftc install path:1.6.4
  
  // You can also specify several packages with version numbers
  
  // To install a dev package in your project (dependencies_dev):
  ftc install flutter_launcher_icons --dev
  
  // To remove a package from your project:
  ftc remove http
  
  // To remove several packages from your project:
  ftc remove http path
  
  // To update CLI:
  ftc update
  // or `ftc upgrade`
  
  // Shows the current CLI version:
  ftc -v
  // or `ftc -version`
  
  // For help
  ftc help
```

# Exploring the CLI

let's explore the existing commands in the cli

### Create project

```shell
  ftc create project
```

Using to generate a new project, after creating the default directory, it will run a `get init` next command

### Init

```shell
  ftc init
```

Use this command with care it will overwrite all files in the lib folder.
[flutter-getx-with-null-safety-template](https://github.com/nEdAy/flutter-getx-with-null-safety-template).

### Separator file type

One day a user asked me, if it was possible to change what the final name of the file was, he found it more readable to use: `my_controller_name.controller.dart`, instead of the default generated by the cli: `my_controller_name_controller. dart` thinking about users like him we added the option for you to choose your own separator, just add this information in your pubsepc.yaml

Example:

```yaml
flutter_template_cli:
  separator: "."
```

### Are your imports disorganized?

To help you organize your imports a new command was created: `ftc sort`, in addition to organizing your imports the command will also format your dart file. thanks to [dart_style](https://pub.dev/packages/dart_style).
When using get sort all files are renamed, with the [separator](#separator-file-type).
To not rename use the `--skipRename` flag.

You are one of those who prefer to use relative imports instead of project imports, use the `--relative` option. flutter_template_cli will convert.

### Internationalization of the cli

CLI now has an internationalization system.

to translate the cli into your language:

1. create a new json file with your language, in the [translations](/translations) folder
2. Copy the keys from the [file](/translations/en.json), and translate the values
3. send your PR.