# TaleTime

Children may discover a novel way to listen to audiobooks with the help of the revolutionary Android and iOS software TaleTime.

In addition to offering parents the chance to record the stories themselves, we also provide professionally recorded audiobooks. Recording is incredibly practical and, naturally, is something that anyone with a little understanding of technology can perform. Children at TaleTime can also decide how the stories will develop on their own.

<!-- <div class="d-lg-none">
    <p class="lead">
        <a href="app">Test out our online demo!</a>
    </p>
</div> -->
*[Test out our online demo](https://taletime-2022.web.app/#/)*

## Write a new Story

TaleTime depends on authors producing new works! The information below is for you if you want to help grow the application.

To become a taletime story-teller, all you need is to register an account, create a 'story-teller' profile and start recording as many stories as you wish. 


## Contributing

Everyone may contribute to improving TaleTime as it is an open source project. The entire source code is available on [GitHub](https://github.com/TaleTime/TaleTime_2/tree/main/taletime),  where you can also learn more about contributing.

Please ensure that your code adheres to the same style as the existing codebase whether adding a new feature or resolving a problem, and make an effort to write your code as simply as you can. Additionally, test your modifications before committing them, and only do so if they don't damage anything. You must use English for commenting.
## Installation
TODO Disclaimer
### Flutter
Download current [Flutter Version](https://docs.flutter.dev/get-started/install) and follow the installation guide for your OS. Here you will install Flutter and Android Studio, you will update your path Variable to use cmd's more easily inside the shell and configure your Android Emulator. The process is well documented and the cmd "flutter doctor" helps you find and solve any problems you might encounter. 
#### Disclaimer
During installation on Windows it might be necessary to update the included dart, use "flutter pub upgrade --major-versions" if needed. For any other encountered error you can use [Google](https://www.google.de/), the Flutter community is very active and helpful.

### IDE
We recommend using [Visual Studio Code](https://code.visualstudio.com/) because its a lightweight IDE which can be customized to your needs. In addition to that the Project is already configured to it and offers a few benefits.
#### Recommended Plugins
##### Code Spell Checker: streetsidesoftware.code-spell-checker
Offers Spellchecking for English, other language packages can be downloaded aswell 
##### Markdown All in One: yzhang.markdown-all-in-one
All in one Markdown solution
##### Flutter: Dart-Code.flutter
Flutter Extension with Dart
##### Flutter Intl: localizely.flutter-intl
Flutter localization binding from .arb files with official Intl library
##### Gradle for Java: vscjava.vscode-gradle
Manage Gradle Projects, run Gradle tasks and provide better Gradle file authoring experience in VS Code
##### vscode-commandbar: gsppvo.vscode-commandbar
Visual Studio Code Command bar
##### Git Graph: mhutchie.git-graph
View a Git Graph of your repository, and perform Git actions from the graph.
##### GitLens - Git supercharged: eamodio.gitlens
Supercharge Git within VS Code — Visualize code authorship at a glance via Git blame annotations and CodeLens, seamlessly navigate and explore Git repositories, gain valuable insights via rich visualizations and powerful comparison commands, and so much more.

### iOS Development setup 
TBD  

## Developing
Always open the "taletime" folder inside your IDE to make sure all cmds are working
### internationalization: l10n
All User visible Messages must be translated.

1. Add a new variable to all internationalization files (app_en.arb,...). Be sure to prefix translation which are only used on one side with the class name in CamelCase, this ensures at least some  clearness in the internationalization files.\
Example: "pageClass_pageTitle":"Title of or Page",
2. Run "flutter gen-l10n" to update your internationalization files. In VsCode you can use the commandbar button "Update l10n". This has to be done for any internationalization change.
3. Call " AppLocalizations.of(context)!.\<your_variable_name> inside your Class. It will Autoimport "import 'internationalization/localizations_ext.dart';". The "!" is needed to tell flutter that the variable won't be null.\
Example:  AppLocalizations.of(context)!.pageClass_pageTitle
4. To see your internationalization inside your App you have to restart the application.

## Current Features

### Login and Registration

- Create a new Account
- Login to your Account
- Reset Password

### Profiles

- Create/Edit/Delete Listener/Storyteller Profiles

### Listener

- Search Stories
- Listen to Stories
- Add Stories to Favorites

### Storyteller

- Record a Story
- Play your recorded Story
- Upload/Save your recorded Story

### Settings

- Change Language (English/German)
- Light-and Darkmode
- Change Password


## About us

This project is in active development by several students of [Hochschule für Technik und Wirtschaft des Saarlandes](http://www.htwsaar.de).

