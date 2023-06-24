<blockquote>
  <details>
    <summary>
      <code>あ ←→ A</code>
    </summary>
    <!--Head-->
    &emsp;&ensp;<sub><b>Stalker</b> supports the following languages. <a href="/Docs/ADD_A_LOCALIZATION.md"><code>↗ Add a localization</code></a></sub>
    <br />
    <!--Body-->
    <br />
    &emsp;&ensp;English
    <br />
    &emsp;&ensp;<a href="/Docs/简体中文.md">简体中文</a>
  </details>
</blockquote>

### <div><!--Empty Lines--><br /><br /></div>

# <p align="center"><img width="172" src="/Stalker/Assets.xcassets/AppIcon.appiconset/icon_512x512@2x@2x.png?raw=true" /><br />Stalker</p><br />

### <div><!--Empty Lines--><br /><br /></div>

###### <p align="center">Simplify, Tidy and Master Your macOS Menu Bar.[^menu_bar]。</p>

[^menu_bar]: Also known as *Status Bar.*

### <div><!--Empty Lines--><br /><br /></div>

> **Note**&emsp;
> **Stalker** requires **macOS 12.0 Monterey**[^check_your_macos_version] and above.

[^check_your_macos_version]: [`↗ Find out which macOS your Mac is using`](https://support.apple.com/en-us/HT201260)

## Introduction & Usage

<div align="center">
  <img width="700" src="/Docs/Contents/English/Overview.png?raw=true" />
</div>

### <div><!--Empty Lines--><br /><br /></div>

### Basic Stuffs

**Stalker** 将你的菜单栏划分为三个区域 - <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub>、<sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 和 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/显示区域-3A659E" /><img src="https://img.shields.io/badge/显示区域-BADDFF" /></picture></sub>：

- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub>&emsp;此区域内的图标将被<i>永远隐藏，</i>除非你主动查看它们。
- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub>&emsp;此区域内的图标遵循一定的显示逻辑。通常情况下，*你看不到它们。*
- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/显示区域-3A659E" /><img src="https://img.shields.io/badge/显示区域-BADDFF" /></picture></sub>&emsp;此区域内的图标*不受影响。*

这三个区域由两个图标分割 - `永远隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture> 和 `隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Line.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Line.png?raw=true" /></picture>。除此之外，最右侧还有一个图标 - `菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>，它的位置无关紧要，但是不可或缺。

> **Stalker** 会判断以上三个图标的先后顺序，因此你可以随意拖动它们。例如，将 `菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture> 拖动到 `永远隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture> 的左侧是被允许的，因为它会自动变成新的 `永远隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture>。

### Show & Move Icons

在包括默认主题在内的一些主题中，图标会被默认隐藏。而当设置菜单打开，或在你将鼠标移动至菜单栏上[^mouse_onto_status_bar]并按下 <kbd>⌘ Command</kbd> 或 <Kbd>⌥ Option</kbd> 时，**Stalker** 会显示全部图标。在剩下的主题中，图标不会被隐藏，但是会根据应用状态自动改变外观。图标的显示和隐藏还遵循一些特别规则：

- 在使用默认隐藏图标的主题时，`菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture> 会指示处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标的显示状态。若 `菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture> <b>显示，</b>代表处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标将**不会被隐藏。** 反之，代表处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标将**隐藏。**
- 在使用其它主题时，所有图标会一同指示处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标的显示状态。若所有图标<b>变为半透明，</b>代表处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标将**不会被隐藏。** 反之，代表处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标将**隐藏。**

[^mouse_onto_status_bar]: You may need to move your mouse onto the right half of the menu bar on monitors with notches.

按住 <kbd>⌘ Command</kbd> 并拖动可以更改图标顺序。例如，将更多的图标放入或移出 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub>。

### Click on the Icons

你可以通过点按 **Stalker** 的不同图标进行不同的操作，无论图标是否显示：

###### 永远隐藏线&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture>

<table>
  <tr>
    <th colspan="2">
      <kbd>左键点按</kbd> 和 <kbd>右键点按</kbd>
    </th>
  </tr>
  <tr>
    <td>
      <b>隐藏</b>处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标
    </td>
    <td>
      <b>显示</b>处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标
    </td>
  </tr>
</table>

###### 隐藏线&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Line.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Line.png?raw=true" /></picture>

<table>
  <tr>
    <th colspan="2">
      <kbd>左键点按</kbd> 和 <kbd>右键点按</kbd>
    </th>
  </tr>
  <tr>
    <td>
      <b>隐藏</b>处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标
    </td>
    <td>
      <b>显示</b>处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标
    </td>
  </tr>
</table>

###### 菜单图标&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>

<table>
  <tr>
    <th colspan="2">
      <kbd>左键点按</kbd>
    </th>
    <th colspan="2">
      <kbd>右键点按</kbd> 和 <kbd>⌥ Option</kbd> <kbd>左键点按</kbd>
    </th>
  </tr>
  <tr>
    <td>
      <b>隐藏</b>处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标
    </td>
    <td>
      <b>显示</b>处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标
    </td>
    <td>
      <b>打开</b>设置菜单
    </td>
    <td>
      <b>关闭</b>设置菜单
    </td>
  </tr>
</table>

### Preferences & Customizations

让我们回顾一下，要调整 **Stalker** 设置，你可以通过以下方法打开设置菜单：

- <kbd>右键点按</kbd> `菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>。
- <kbd>⌥ Option</kbd> <kbd>左键点按</kbd> `菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>。

菜单中各项设置的作用如下：

<br />

###### 主题<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Theme.png?raw=true" /><img align="right" height="12" alt="默认值：Stalker" src="/Docs/Contents/Preferences/Light/Theme.png?raw=true" /></picture>

不同主题间的显示效果迥异，并且一些主题会自动隐藏分隔图标，另一些则不会。

###### 自动隐藏<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="默认值：关" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="关" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;需要手动控制处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标的显示和隐藏状态。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="开" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**Stalker** 会在你不需要使用菜单栏时自动隐藏处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标。

###### 反馈强度<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-0.png?raw=true" /><img align="right" height="12" alt="默认值：关闭" src="/Docs/Contents/Preferences/Light/Slider-0.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-0.png?raw=true" /><img height="12" alt="关闭" src="/Docs/Contents/Preferences/Light/Slider-0.png?raw=true" /></picture>&emsp;**关闭**震感反馈。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-1.png?raw=true" /><img height="12" alt="轻度" src="/Docs/Contents/Preferences/Light/Slider-1.png?raw=true" /></picture>&emsp;**轻度**震感反馈。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-2.png?raw=true" /><img height="12" alt="中度" src="/Docs/Contents/Preferences/Light/Slider-2.png?raw=true" /></picture>&emsp;**中度**震感反馈。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-3.png?raw=true" /><img height="12" alt="重度" src="/Docs/Contents/Preferences/Light/Slider-3.png?raw=true" /></picture>&emsp;**重度**震感反馈。

> 由于 macOS 的限制，你可能无法感受到明显的震感反馈。

<br />

###### 使用永远隐藏区域<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="默认值：关" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="关" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;**完全禁用** <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub> 并且**不显示** `永远隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture>。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="开" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**启用** <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub> 并且**显示** `永远隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture>。

###### 减少动画<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="默认值：关" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="关" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;减少动画以减少性能占用。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="开" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;正常显示动画。

> 如果你正在使用 Intel 芯片的 Mac，建议保持 `减少动画` 选项为&emsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="开" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;以保证运行流畅。

<br />

###### 随 macOS 启动<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="默认值：关" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="关" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;你需要手动开启 **Stalker**。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="开" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**Stalker** 将随 macOS 启动。

### Attention Required

###### Auto Idling

因为 macOS 的限制，**Stalker** 无法知道你是否打开了处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub> 或 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单。如果这时 `自动隐藏` 功能贸然隐藏了这些图标，那么菜单也会随之移动。为此，**Stalker** 采用了一种检测方式以最大程度的避免类似情况的发生。

简单来说，当你在菜单栏中点按了一处**很可能有其它图标，且该图标很可能处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 或 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub>** 的位置时，**Stalker** 会选择暂停 `自动隐藏`，进入 `自动闲置` 状态。 当你结束操作后，只需将鼠标轻轻**移过** **Stalker** 的任意一个图标上方，就可以取消 `自动闲置`，恢复 `自动隐藏`。

`自动闲置` 会根据你的点按位置自动开启，且会区分 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub> 和 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub>。当你**移过** **Stalker** 的任意图标上方时，这两种 `自动闲置` 状态都会被取消。

`自动闲置` 只在 `自动隐藏` 激活时激活。

###### Haptic Feedback

当你**触发** `自动隐藏`、**取消** `自动隐藏`、**触发** `自动闲置` 和**取消** `自动闲置` 时，**Stalker** 会提供震感反馈[^haptic_feedback_support_needed]。

[^haptic_feedback_support_needed]: Your device must support *Haptic Feedback.*

### <div><!--Empty Lines--><br /><br /></div>

## Install & Run[^install_and_run]

[^install_and_run]: [`↗ Open a Mac app from an unidentified developer`](https://support.apple.com/guide/mac-help/mh40616/mac)

### <div><!--Empty Lines--><br /><br /></div>

As an open-sourced and free software, **Stalker** has no ability to pay for [Apple Developer Account.](https://developer.apple.com/help/account/)Thus, you can't install **Stalker** from App Store, and you may need to allow **Stalker** to run as an unidentified app.

### Steps to Follow

> **Note**&emsp;
> You can download the installing disk image of **Stalker** only from [Releases](https://github.com?KrLite/Stalker/releases) page manually for now.

<h6>

<blockquote>
1
<div align="center">
  <!--Mount DMG-->
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="/Docs/Contents/English/Dark/1.png?raw=true"
     />
    <img
      width="562"
      src="/Docs/Contents/English/Light/1.png?raw=true"
     />
  </picture>
</div>
Mount the <code>.dmg</code> disk image
<br />
Drag Stalker to the Applications Folder
</blockquote>

<br />

<blockquote>
2
<div align="center">
  <!--Show in Finder-->
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="/Docs/Contents/English/Dark/2.png?raw=true"
     />
    <img
      width="372"
      src="/Docs/Contents/English/Light/2.png?raw=true"
     />
  </picture>
</div>
If a pop-up window appears, choose <code>Show in Finder</code>
</blockquote>

<br />

<blockquote>
3
<div align="center">
  <!--Right Click and Open-->
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="/Docs/Contents/English/Dark/3.png?raw=true"
     />
    <img
      width="1149"
      src="/Docs/Contents/English/Light/3.png?raw=true"
     />
  </picture>
</div>
<kbd>Right Click</kbd> Stalker
<br />
Choose <code>Open</code>
</blockquote>

<br />

<blockquote>
4
<div align="center">
  <!--Open-->
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="/Docs/Contents/English/Dark/4.png?raw=true"
     />
    <img
      width="372"
      src="/Docs/Contents/English/Light/4.png?raw=true"
     />
  </picture>
</div>
Choose <code>Open</code>
</blockquote>

</h6>

