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

**Stalker** divides your menu bar into three areas - <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub>, <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> and <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Visible Area-3A659E" /><img src="https://img.shields.io/badge/Visible Area-BADDFF" /></picture></sub>：

- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub>&emsp;Icons inside this area will be *hided forever,* unless you menually check them.
- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>&emsp;Icons inside this area follow certain rules. More often than not, you *don't see them.*
- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Visible Area-3A659E" /><img src="https://img.shields.io/badge/Visible Area-BADDFF" /></picture></sub>&emsp;Icons inside this area suffer no restrictions. You can see them *all the time.*


The three areas are separated by two separators - `Always Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture> and `Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Line.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Line.png?raw=true" /></picture>. Apart from this, there's another icon on the right - `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>, its position doesn't matter, but it plays an important role.

> **Stalker** will judge the order of the three separators, which means you don't need to care much about their position. For example, you are allowed to put `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture> to the left of `Always Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture> as it will turn into the new `Always Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture> automatically.

### Show & Move Separators

In themes including the default theme, separators will be hidden by default. And when you open the menu, or move your mouse onto the menu bar[^mouse_onto_status_bar] and press <kbd>⌘ Command</kbd> or <Kbd>⌥ Option</kbd>, **Stalker** will show all the separators. In the rest of the themes, separators won't be hidden, but their appearance will change automatically according to the status of the app. The show and hide of the separators also follow some special rules:

- When using themes that hide separators, `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture> will indicate the visibility of icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>. If `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture> **is visible,** it represents icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> are **visible.** Otherwise, it represents icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> are **hidden.**
- When using other themes, all the separators will indicate the visibility of icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> together. If all the separators are **translucent,** it represents icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> are **visible.** Otherwise, it represents icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> are **hidden.**

[^mouse_onto_status_bar]: You may need to move your mouse onto the right half of the menu bar on monitors with notches.

Dragging the icons while holding <kbd>⌘ Command</kbd> can change the order of the icons. For example, to put more icons into or out of <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>.

### Click on the Icons

You can perform different actions by clicking on the separators of **Stalker**, no matter whether they are visible:

###### Always Hide Separator&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture>

<table>
  <tr>
    <th colspan="2">
      <kbd>Click</kbd> and <kbd>Right Click</kbd>
    </th>
  </tr>
  <tr>
    <td>
      <b>Hide</b> icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>
    </td>
    <td>
      <b>Show</b> icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>
    </td>
  </tr>
</table>

###### Hide Separator&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Line.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Line.png?raw=true" /></picture>

<table>
  <tr>
    <th colspan="2">
      <kbd>Click</kbd> and <kbd>Right Click</kbd>
    </th>
  </tr>
  <tr>
    <td>
      <b>Hide</b> icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>
    </td>
    <td>
      <b>Show</b> icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>
    </td>
  </tr>
</table>

###### Menu Icon&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>

<table>
  <tr>
    <th colspan="2">
      <kbd>Click</kbd>
    </th>
    <th colspan="2">
      <kbd>Right Click</kbd> and <kbd>⌥ Option</kbd> <kbd>Click</kbd>
    </th>
  </tr>
  <tr>
    <td>
      <b>Hide</b> icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>
    </td>
    <td>
      <b>Show</b> icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>
    </td>
    <td>
      <b>Open</b> the preferences menu
    </td>
    <td>
      <b>Close</b> the preferences menu
    </td>
  </tr>
</table>

### Preferences & Customizations

让我们回顾一下，要调整 **Stalker** 设置，你可以通过以下方法打开设置菜单：

- <kbd>Right Click</kbd> `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>。
- <kbd>⌥ Option</kbd> <kbd>Click</kbd> `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>。

菜单中各项设置的作用如下：

<br />

###### 主题<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Theme.png?raw=true" /><img align="right" height="12" alt="Default: Stalker" src="/Docs/Contents/Preferences/Light/Theme.png?raw=true" /></picture>

不同主题间的显示效果迥异，并且一些主题会自动隐藏分隔图标，另一些则不会。

###### 自动隐藏<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="Default: Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;需要手动控制处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> 的菜单栏图标的显示和隐藏状态。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="On" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**Stalker** 会在你不需要使用菜单栏时自动隐藏处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> 的菜单栏图标。

###### 反馈强度<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-0.png?raw=true" /><img align="right" height="12" alt="Default: Disabled" src="/Docs/Contents/Preferences/Light/Slider-0.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-0.png?raw=true" /><img height="12" alt="Disabled" src="/Docs/Contents/Preferences/Light/Slider-0.png?raw=true" /></picture>&emsp;Haptic feedback **Disabled.**

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-1.png?raw=true" /><img height="12" alt="Light" src="/Docs/Contents/Preferences/Light/Slider-1.png?raw=true" /></picture>&emsp;**Light** haptic feedback.

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-2.png?raw=true" /><img height="12" alt="Medium" src="/Docs/Contents/Preferences/Light/Slider-2.png?raw=true" /></picture>&emsp;**Medium** haptic feedback.

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-3.png?raw=true" /><img height="12" alt="Heavy" src="/Docs/Contents/Preferences/Light/Slider-3.png?raw=true" /></picture>&emsp;**Heavy** haptic feedback.

> 由于 macOS 的限制，你可能无法感受到明显的震感反馈。

<br />

###### 使用Always Hide Area<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="Default: Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;**完全禁用** <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub> 并且**不显示** `Always Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture>。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="On" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**启用** <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub> 并且**显示** `Always Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture>。

###### 减少动画<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="Default: Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;减少动画以减少性能占用。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="On" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;正常显示动画。

> 如果你正在使用 Intel 芯片的 Mac，建议保持 `减少动画` 选项为&emsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="On" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;以保证运行流畅。

<br />

###### 随 macOS 启动<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="Default: Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;你需要手动开启 **Stalker**。

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="On" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**Stalker** 将随 macOS 启动。

### Attention Required

###### Auto Idling

因为 macOS 的限制，**Stalker** 无法知道你是否打开了处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub> 或 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> 的菜单。如果这时 `自动隐藏` 功能贸然隐藏了这些图标，那么菜单也会随之移动。为此，**Stalker** 采用了一种检测方式以最大程度的避免类似情况的发生。

简单来说，当你在菜单栏中点按了一处**很可能有其它图标，且该图标很可能处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> 或 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub>** 的位置时，**Stalker** 会选择暂停 `自动隐藏`，进入 `自动闲置` 状态。 当你结束操作后，只需将鼠标轻轻**移过** **Stalker** 的任意一个图标上方，就可以取消 `自动闲置`，恢复 `自动隐藏`。

`自动闲置` 会根据你的点按位置自动开启，且会区分 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub> and <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>。当你**移过** **Stalker** 的任意图标上方时，这两种 `自动闲置` 状态都会被取消。

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

