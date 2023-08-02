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

###### <p align="center">Simplify, Tidy and Master Your macOS Menu Bar[^menu_bar].</p>

[^menu_bar]: Also known as *Status Bar.*

### <div><!--Empty Lines--><br /><br /></div>

> ***Note***&emsp;
> **Stalker** requires **macOS 12.0 Monterey**[^check_your_macos_version] and above.

[^check_your_macos_version]: [`↗ Find out which macOS your Mac is using`](https://support.apple.com/en-us/HT201260)

## Introduction & Usage

<div align="center">
  <img width="700" src="/Docs/Contents/English/Overview.png?raw=true" />
</div>

### Basic Stuffs

**Stalker** divides your menu bar into three areas - <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub>, <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> and <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Visible Area-3A659E" /><img src="https://img.shields.io/badge/Visible Area-BADDFF" /></picture></sub>：

- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub>&emsp;Icons inside this area will be *hided forever,* unless you menually check them.
- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>&emsp;Icons inside this area follow certain rules. More often than not, you *don't see them.*
- <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Visible Area-3A659E" /><img src="https://img.shields.io/badge/Visible Area-BADDFF" /></picture></sub>&emsp;Icons inside this area suffer no restrictions. You can see them *all the time.*


The three areas are separated by two separators - `Always Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture> and `Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Line.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Line.png?raw=true" /></picture>. Apart from this, there's another icon on the right - `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>, its position doesn't matter, but it plays an important role.

> **Stalker** will judge the order of the three separators, which means you don't need to care much about their position. For example, you are allowed to put `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture> to the left of `Always Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture> as it will turn into the new `Always Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture> automatically.

### Show & Move Separators

In themes including the default theme, separators will be hidden by default. And when you open the menu, or move your cursor onto the menu bar[^cursor_onto_status_bar] and press <kbd>⌘ Command</kbd> or <Kbd>⌥ Option</kbd>, **Stalker** will show all the separators. In the rest of the themes, separators won't be hidden, but their appearance will change automatically according to the status of the app. The show and hide of the separators also follow some special rules:

- When using themes that hide separators, `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture> will indicate the visibility of icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>. If `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture> **is visible,** it represents icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> are **visible.** Otherwise, it represents icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> are **hidden.**
- When using other themes, all the separators will indicate the visibility of icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> together. If all the separators are **translucent,** it represents icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> are **visible.** Otherwise, it represents icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> are **hidden.**

[^cursor_onto_status_bar]: You need to move your cursor to the left of `Menu Icon` in order to trigger something. On monitors with notches, you may also need to move your cursor *to the right of the screen notch.*

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

Let's take a look at how to customize **Stalker**. You can open the preferences menu by:

- <kbd>Right Click</kbd> `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>.
- <kbd>⌥ Option</kbd> <kbd>Click</kbd> `Menu Icon`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/Dot.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/Dot.png?raw=true" /></picture>.

The menu items are explained as follows:

<br />

<table>
  <tr>
    <th align="left">
      <h6>Theme<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Theme.png?raw=true" /><img align="right" height="12" alt="Default: Stalker" src="/Docs/Contents/Preferences/Light/Theme.png?raw=true" /></picture></h6>
    </th>
  </tr>
  <tr>
    <td>
      Separator's appearances differ from theme to theme, and some themes will automatically hide separators, while others will not.
    </td>
  </tr>
</table>

<table>
  <tr>
    <th align="left">
      <h6>Auto Shows<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="Default: Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture></h6>
    </th>
  </tr>
  <tr>
    <td>
      <picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img width="20.8" alt="Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>
      &emsp;
      You will need to control the visibility of icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> manually.
    </td>
  </tr>
  <tr>
    <td>
      <picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img width="20.8" alt="On" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>
      &emsp;
      <b>Stalker</b> will hide icons inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> automatically when you are not using them, and show them when you need.
    </td>
  </tr>
</table>

###### Feedback Intensity<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-0.png?raw=true" /><img align="right" height="12" alt="Default: Disabled" src="/Docs/Contents/Preferences/Light/Slider-0.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-0.png?raw=true" /><img height="12" alt="Disabled" src="/Docs/Contents/Preferences/Light/Slider-0.png?raw=true" /></picture>&emsp;Haptic feedback **Disabled.**

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-1.png?raw=true" /><img height="12" alt="Light" src="/Docs/Contents/Preferences/Light/Slider-1.png?raw=true" /></picture>&emsp;**Light** haptic feedback intensity.

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-2.png?raw=true" /><img height="12" alt="Medium" src="/Docs/Contents/Preferences/Light/Slider-2.png?raw=true" /></picture>&emsp;**Medium** haptic feedback intensity.

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Slider-3.png?raw=true" /><img height="12" alt="Heavy" src="/Docs/Contents/Preferences/Light/Slider-3.png?raw=true" /></picture>&emsp;**Heavy** haptic feedback intensity.

> Due to the limitations of macOS, you may not feel a strong haptic feedback.

<br />

###### Use Always Hide Area<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="Default: Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;**Completely disbble** <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub> and **completely hide** `Always Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture>.

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="On" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**Enable** <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub> and **show** `Always Hide Separator`&thinsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/DefaultTheme/Dark/DottedLine.png?raw=true" /><img height="12" src="/Docs/Contents/DefaultTheme/Light/DottedLine.png?raw=true" /></picture>.

###### Reduce Animation<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="Default: Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;Reduce the animation in order to make **Stalker** run more smoothly.

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="On" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;Show the animation to make **Stalker** prettier.

> If you are using an Intel chip Mac, it is recommended to keep the `Reduce Animation` option as&emsp;<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="On" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;to ensure the smoothness of **Stalker.**

<br />

###### Starts with macOS<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img align="right" height="12" alt="Default: Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-Off.png?raw=true" /><img height="12" alt="Off" src="/Docs/Contents/Preferences/Light/Switch-Off.png?raw=true" /></picture>&emsp;You need to manually open **Stalker** every time you start macOS.

<picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Preferences/Dark/Switch-On.png?raw=true" /><img height="12" alt="On" src="/Docs/Contents/Preferences/Light/Switch-On.png?raw=true" /></picture>&emsp;**Stalker** will automatically start when you start macOS.

### Attention Required

###### Auto Idling

Due to the limitations of macOS, **Stalker** cannot know whether you have opened a menu in <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub> or <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>. If the `Auto Hide` function hides these icons rashly, the menu will also move with it. Therefore, **Stalker** adopts a detection method to avoid similar situations to the greatest extent.

Speaking generally, when you click on a place in the menu bar **where there is likely to be other icons, and the icon is likely to be inside <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub> or <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub>**, **Stalker** will choose to pause `Auto Hide` and enter the `Auto Idle` state. When you finish the operation, just move the cursor gently **over** any separator of **Stalker**, and you can cancel `Auto Idle` and resume `Auto Hide`.

`Auto Idle` will enable automatically accordng to your clicking position, and it will distinguish <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Always Hide Area-5C167F" /><img src="https://img.shields.io/badge/Always Hide Area-EFD9FF" /></picture></sub> and <sub><picture><source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Hide Area-903150" /><img src="https://img.shields.io/badge/Hide Area-FFC9D9" /></picture></sub>. When you **move your cursor over** any separator of **Stalker**, both `Auto Idle` states will be canceled.

`Auto Idle` will only be activated when `Auto Hide` is activated.

###### Haptic Feedback

As you **trigger** `Auto Hide`, **cancel** `Auto Hide`, **trigger** `Auto Idle` and **cancel** `Auto Idle`, **Stalker** will provide a haptic feedback[^haptic_feedback_support_needed].

[^haptic_feedback_support_needed]: Your device must support *Haptic Feedback.*

### <div><!--Empty Lines--><br /><br /></div>

## Install & Run[^install_and_run]

[^install_and_run]: [`↗ Open a Mac app from an unidentified developer`](https://support.apple.com/guide/mac-help/mh40616/mac)

As an open-sourced and free software, **Stalker** has no ability to pay for [Apple Developer Account.](https://developer.apple.com/help/account/)Thus, you can't install **Stalker** from App Store, and you may need to allow **Stalker** to run as an unidentified app.

### Steps to Follow

> ***Note***&emsp;
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

### <div><!--Empty Lines--><br /><br /></div>

<blockquote>
  <details>
    <summary>
      <code>Contributors</code>
    </summary>
    <br />
    <table>
      <tr>
        <td>
          <!--KrLite-->
          <a href="https://github.com/KrLite">
            <img src="https://github.com/KrLite.png?size=125" />
          </a>
          <br />
          <b>KrLite</b>
          <br />
          <sup>
            Project Leader
          </sup>
        </td>
        <td>
          <!--芯梢-->
          <a href="https://github.com/Xinshao-air">
            <img src="https://github.com/Xinshao-air.png?size=125" />
          </a>
          <br />
          <b>芯梢</b>
          <br />
          <sup>
            Tests & Images
          </sup>
        </td>
      </tr>
    </table>
  </details>
</blockquote>
