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

###### <p align="center">简化、整理并掌控你的 macOS 菜单栏[^status_bar]。</p>

[^status_bar]: 又称*状态栏。*

### <div><!--Empty Lines--><br /><br /></div>

> **Note**&emsp;
> **Stalker** 需要在 **macOS 12.0 Monterey**[^check_your_macos_version] 及以上版本中运行。

[^check_your_macos_version]: [`↗ 确定你的 Mac 使用的是哪个 macOS 版本`](https://support.apple.com/zh-cn/HT201260)

## 了解与使用

<div align="center">
  <img width="700" src=“/Docs/Contents/简体中文/Overview.png?raw=true" />
</div>

### <div><!--Empty Lines--><br /><br /></div>

### 运行逻辑

**Stalker** 将你的菜单栏划分为三个区域 - <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub>、<sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 和 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/显示区域-3A659E" /><img src="https://img.shields.io/badge/显示区域-BADDFF" /></picture></sub>：

- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub>&emsp;此区域内的图标将被<i>永远隐藏，</i>除非你主动查看它们。
- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub>&emsp;此区域内的图标遵循一定的显示逻辑。通常情况下，*你看不到它们。*
- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/显示区域-3A659E" /><img src="https://img.shields.io/badge/显示区域-BADDFF" /></picture></sub>&emsp;此区域内的图标*不受影响。*

这三个区域由两个图标分割 - `永远隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dotted%20Line.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dotted%20Line.png?raw=true" /></picture> 和 `隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Line.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Line.png?raw=true" /></picture>。除此之外，最右侧还有一个图标 - `菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dot.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dot.png?raw=true" /></picture>，它的位置无关紧要，但是不可或缺。

> **Stalker** 会判断以上三个图标的先后顺序，因此你可以随意拖动它们。例如，将 `菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dot.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dot.png?raw=true" /></picture> 拖动到 `永远隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dotted%20Line.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dotted%20Line.png?raw=true" /></picture> 的左侧是被允许的，因为它会自动变成新的 `永远隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dotted%20Line.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dotted%20Line.png?raw=true" /></picture>。

### 显示并移动图标

在包括默认主题在内的一些主题中，图标会被默认隐藏。而当设置菜单打开，或在你将鼠标移动至菜单栏上[^mouse_onto_status_bar]并按下 <kbd>⌘ Command</kbd> 或 <Kbd>⌥ Option</kbd> 时，**Stalker** 会显示全部图标。在剩下的主题中，图标不会被隐藏，但是会根据应用状态自动改变外观。图标的显示和隐藏还遵循一些特别规则：

- 在使用默认隐藏图标的主题时，`菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dot.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dot.png?raw=true" /></picture> 会指示处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标的显示状态。若 `菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dot.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dot.png?raw=true" /></picture> <b>显示，</b>代表处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标将**不会被隐藏。** 反之，代表处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标将**隐藏。**
- 在使用其它主题时，所有图标会一同指示处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标的显示状态。若所有图标<b>变为半透明，</b>代表处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标将**不会被隐藏。** 反之，代表处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标将**隐藏。**

[^mouse_onto_status_bar]: 在刘海屏的显示器上，你可能需要将鼠标移动到*屏幕右半侧*的菜单栏上。

按住 <kbd>⌘ Command</kbd> 并拖动可以更改图标顺序。例如，将更多的图标放入或移出 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub>。

### 点按图标

你可以通过点按 **Stalker** 的不同图标进行不同的操作，无论图标是否显示：

###### 永远隐藏线&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dotted%20Line.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dotted%20Line.png?raw=true" /></picture>

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

###### 隐藏线&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Line.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Line.png?raw=true" /></picture>

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

###### 菜单图标&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dot.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dot.png?raw=true" /></picture>

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

### 设置与自定义

让我们回顾一下，要调整 **Stalker** 设置，你可以通过以下方法打开设置菜单：

- <kbd>右键点按</kbd> `菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dot.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dot.png?raw=true" /></picture>。
- <kbd>⌥ Option</kbd> <kbd>左键点按</kbd> `菜单图标`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dot.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dot.png?raw=true" /></picture>。

菜单中各项设置的作用如下：

<br />

###### 主题<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Theme.png?raw=true" /><img align="right" height="12" alt="默认值：Stalker" src=“/Docs/Contents/Preferences/Light/Theme.png?raw=true" /></picture>

不同主题间的显示效果迥异，并且一些主题会自动隐藏分隔图标，另一些则不会。

###### 自动隐藏<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="默认值：关" src=“/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="关" src=“/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;需要手动控制处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标的显示和隐藏状态。

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="开" src=“/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**Stalker** 会在你不需要使用菜单栏时自动隐藏处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单栏图标。

###### 反馈强度<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Slider-0.png?raw=true" /><img align="right" height="12" alt="默认值：关闭" src=“/Docs/Contents/Preferences/Light/Slider-0.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Slider-0.png?raw=true" /><img height="12" alt="关闭" src=“/Docs/Contents/Preferences/Light/Slider-0.png?raw=true" /></picture>&emsp;**关闭**震感反馈。

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Slider-1.png?raw=true" /><img height="12" alt="轻度" src=“/Docs/Contents/Preferences/Light/Slider-1.png?raw=true" /></picture>&emsp;**轻度**震感反馈。

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Slider-2.png?raw=true" /><img height="12" alt="中度" src=“/Docs/Contents/Preferences/Light/Slider-2.png?raw=true" /></picture>&emsp;**中度**震感反馈。

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Slider-3.png?raw=true" /><img height="12" alt="重度" src=“/Docs/Contents/Preferences/Light/Slider-3.png?raw=true" /></picture>&emsp;**重度**震感反馈。

> 由于 macOS 的限制，你可能无法感受到明显的震感反馈。

<br />

###### 使用永远隐藏区域<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="默认值：关" src=“/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="关" src=“/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;**完全禁用** <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub> 并且**不显示** `永远隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dotted%20Line.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dotted%20Line.png?raw=true" /></picture>。

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="开" src=“/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**启用** <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub> 并且**显示** `永远隐藏线`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/简体中文/Dark/Dotted%20Line.png?raw=true" /><img height="12" src=“/Docs/Contents/简体中文/Light/Dotted%20Line.png?raw=true" /></picture>。

###### 减少动画<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="默认值：关" src=“/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="关" src=“/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;减少动画以减少性能占用。

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="开" src=“/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;正常显示动画。

> 如果你正在使用 Intel 芯片的 Mac，建议保持 `减少动画` 选项为&emsp;<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="开" src=“/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;以保证运行流畅。

<br />

###### 随 macOS 启动<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="默认值：关" src=“/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="关" src=“/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;你需要手动开启 **Stalker**。

<picture><source media="(prefers-color-scheme: dark)" srcset=“/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="开" src=“/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**Stalker** 将随 macOS 启动。

### 需要注意的操作

###### 自动闲置

因为 macOS 的限制，**Stalker** 无法知道你是否打开了处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub> 或 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 的菜单。如果这时 `自动隐藏` 功能贸然隐藏了这些图标，那么菜单也会随之移动。为此，**Stalker** 采用了一种检测方式以最大程度的避免类似情况的发生。

简单来说，当你在菜单栏中点按了一处**很可能有其它图标，且该图标很可能处于 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub> 或 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub>** 的位置时，**Stalker** 会选择暂停 `自动隐藏`，进入 `自动闲置` 状态。 当你结束操作后，只需将鼠标轻轻**移过** **Stalker** 的任意一个图标上方，就可以取消 `自动闲置`，恢复 `自动隐藏`。

`自动闲置` 会根据你的点按位置自动开启，且会区分 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/永远隐藏区域-5C167F" /><img src="https://img.shields.io/badge/永远隐藏区域-EFD9FF" /></picture></sub> 和 <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/隐藏区域-903150" /><img src="https://img.shields.io/badge/隐藏区域-FFC9D9" /></picture></sub>。当你**移过** **Stalker** 的任意图标上方时，这两种 `自动闲置` 状态都会被取消。

`自动闲置` 只在 `自动隐藏` 激活时激活。

###### 震感反馈

当你**触发** `自动隐藏`、**取消** `自动隐藏`、**触发** `自动闲置` 和**取消** `自动闲置` 时，**Stalker** 会提供震感反馈[^haptic_feedback_support_needed]。

[^haptic_feedback_support_needed]: 你的设备需要支持 *Haptic 震感反馈。*

### <div><!--Empty Lines--><br /><br /></div>

## 安装与运行[^install_and_run]

[^install_and_run]: [`↗ 打开来自身份不明开发者的 Mac App`](https://support.apple.com/zh-cn/guide/mac-help/mh40616/mac)

### <div><!--Empty Lines--><br /><br /></div>

作为开源免费软件，**Stalker** 暂无能力支付[苹果开发者账户](https://developer.apple.com/cn/help/account/)的会员费。因此，你无法在 App Store 中下载 <b>Stalker，</b>并且可能需要允许 **Stalker** 以未验证应用的身份运行。

### 安装步骤

> **Note**&emsp;
> 目前，你只能在 [Releases](https://github.com?KrLite/Stalker/releases) 页面手动下载 **Stalker**  的安装磁盘映像。

<h6>

<blockquote>
1
<div align="center">
  <!--Mount DMG-->
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="/Docs/Contents/简体中文/Dark/1.png?raw=true"
     />
    <img
      width="562"
      src="/Docs/Contents/简体中文/Light/1.png?raw=true"
     />
  </picture>
</div>
装载 <code>.dmg</code> 磁盘映像
<br />
将 Stalker 拖动到 Applications 文件夹中
</blockquote>

<br />

<blockquote>
2
<div align="center">
  <!--Show in Finder-->
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="/Docs/Contents/简体中文/Dark/2.png?raw=true"
     />
    <img
      width="372"
      src="/Docs/Contents/简体中文/Light/2.png?raw=true"
     />
  </picture>
</div>
若弹出窗口，选择 <code>在访达中显示</code>
</blockquote>

<br />

<blockquote>
3
<div align="center">
  <!--Right Click and Open-->
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="/Docs/Contents/简体中文/Dark/3.png?raw=true"
     />
    <img
      width="1149"
      src="/Docs/Contents/简体中文/Light/3.png?raw=true"
     />
  </picture>
</div>
<kbd>右键点按</kbd> Stalker
<br />
选择 <code>打开</code>
</blockquote>

<br />

<blockquote>
4
<div align="center">
  <!--Open-->
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="/Docs/Contents/简体中文/Dark/4.png?raw=true"
     />
    <img
      width="372"
      src="/Docs/Contents/简体中文/Light/4.png?raw=true"
     />
  </picture>
</div>
选择 <code>打开</code>
</blockquote>

</h6>

