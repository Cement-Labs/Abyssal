<blockquote>
  <details>
    <summary>
      <code>あ ←→ A</code>
    </summary>
    <!--Head-->
    &emsp;&ensp;<sub><b>Abyssal</b> supports the following languages. <a href="/Docs/ADD_A_LOCALIZATION.md"><code>↗ Add a localization</code></a></sub>
    <br />
    <!--Body-->
    <br />
    &emsp;&ensp;English
    <br />
    &emsp;&ensp;<a href="/Docs/简体中文.md">简体中文</a>
  </details>
</blockquote>

### <div><!--Empty Lines--><br /><br /></div>

# <p align="center"><img width="172" src="/Abyssal/Assets.xcassets/AppIcon.appiconset/icon_512x512@2x@2x.png?raw=true" /><br />Abyssal</p><br />

###### <p align="center">Simplify, tidy and master your macOS menu bar[^menu_bar].</p>

[^menu_bar]: Also known as _Status Bar._

### <div><!--Empty Lines--><br /><br /></div>

> [!IMPORTANT]
> 
> **Abyssal** requires **macOS 14.0 Sonoma**[^check_your_macos_version] or above to run.

[^check_your_macos_version]: [`↗ Find out which macOS your Mac is using`](https://support.apple.com/en-us/HT201260)

## Introduction & Usage

<div align="center">
  <img width="700" src="/Docs/Contents/English/Overview.png?raw=true" />
</div>

### Fundamentals

**Abyssal** divides your menu bar into three areas - the **Always Hide Area,** the **Hide Area** and the **Visible Area:**

- The **Always Hide Area**&emsp;Icons inside this area will be _hided forever,_ unless you menually check them.
- The **Hide Area**&emsp;Icons inside this area follow certain rules. More often than not, you _don't see them._
- The **Visible Area**&emsp;Icons inside this area suffer no restrictions. You can see them _all the time._

The three areas are separated by two separators - the `Always Hide Separator`&ensp;<sub><picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Icons/Dark/DottedLine.png?raw=true" /><img height="17" src="/Docs/Contents/Icons/Light/DottedLine.png?raw=true" /></picture></sub> (the furthest one from the screen corner) and the `Hide Separator`&ensp;<sub><picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Icons/Dark/Line.png?raw=true" /><img height="17" src="/Docs/Contents/Icons/Light/Line.png?raw=true" /></picture></sub> (the middle one). Apart from these, there's another separator on the nearest side to the screen corner - the `Menu Separator`&ensp;<sub><picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Icons/Dark/Dot.png?raw=true" /><img height="17" src="/Docs/Contents/Icons/Light/Dot.png?raw=true" /></picture></sub>, which's position doesn't matter, but plays an important role.

> **Abyssal** will automatically judge the order of the three separators, which means you don't need to care much about their position. For example, you are allowed to put the `Menu Separator` to the other side of the `Always Hide Separator`, as they will automatically swap their roles to the correct ones after your operation.

<br />

### Showing & Moving the Separators

In many themes including the default theme, the separators are invisible (transparent) by default. If you _open the menu,_ or _move your cursor onto the menu bar[^cursor_onto_status_bar] and press the chosen modifiers,_ the separators will be visible (partly opaque). In the rest of the themes, the separators will always be visible, but their appearance may change automatically according to the status of **Abyssal**

The visibilities of the separators can also indicate:

- When using themes that automatically hide the separators, the `Menu Separator` will indicate the visibility of the status icons inside the **Hide Area**. If the `Menu Separator` **is visible,** then the status icons inside the **Hide Area** are **visible.** Otherwise the icons are **hidden.**
- When using other themes, all the separators perform together. If all of them are **translucent,** then the status icons inside the **Hide Area** are **visible.** Otherwise the icons are **hidden.**

[^cursor_onto_status_bar]: You need to move your cursor further away from the screen corner than the `Menu Separator` in order to trigger something. On monitors with notches, you may also need to move your cursor _between the the screen notch and the `Menu Separator`._

Dragging the icons while holding <kbd>⌘ command</kbd> can reorder the status icons and the separators. For example, to put more icons into or out of the **Hide Area.**

<br />

### Clicking on the Separators

You can perform different actions by clicking on the separators of **Abyssal,** no matter whether they are visible:

<br />

#### The Always Hide Separator

- **<kbd>click</kbd>&emsp;/&emsp;<kbd>right click</kbd>**

  **Show / hide** the status icons inside the **Hide Area.**

<br />

#### The Hide Separator

- **<kbd>click</kbd>&emsp;/&emsp;<kbd>right click</kbd>**

  **Show / hide** the status icons inside the **Hide Area.**

<br />

#### The Menu Separator

- **<kbd>click</kbd>**

  **Show / hide** the status icons inside the **Hide Area.**

- **<kbd>⌥ option</kbd> <kbd>click</kbd>**

  **Open / close** the preferences menu.

<br />

### What's More: Auto Idling

Due to the limitations of macOS, **Abyssal** cannot know whether you have opened a menu in the **Always Hide Area** or the **Hide Area.** If the **Auto Hide** function hides these status icons rashly after your cursor leave the menu bar, their menus will also move away. Therefore, **Abyssal** adopts an approach to avoid similar situations to the greatest extent.

Speaking specifically, when you click on a place in the menu bar **where there is likely to have other status icons, and the status icon is likely to be inside the Hide Area or the Always Hide Area,** **Abyssal** will choose to pause the **Auto Hide** and enter the **Auto Idling** state. When you finish the operation, just move the cursor **over** the `Always Hide Separator` or the `Hide Separator`, and you can cancel the **Auto Idling** state and resume **Auto Hide** to hide the status icons. **Abyssal** also provides an optional timeout to automatically disable the **Auto Idling** state, which can be configured in the preferences menu.

**Auto Idling** will enable automatically accordng to your clicking position, and it will distinguish between the **Always Hide Area** and the **Hide Area** - different areas trigger different reactions. It will only be activated when **Auto Hide** is enabled.

After you **triggered or canceled** **Auto Hide or Auto Idling,** **Abyssal** will generate a haptic feedback[^haptic_feedback_support_needed].

[^haptic_feedback_support_needed]: Your device must support _haptic feedback._

<br />

## Install & Run

> [!NOTE]
> 
> As an open source and free software, **Abyssal** can't afford an [Apple Developer Account.](https://developer.apple.com/help/account) Therefore, you can't install **Abyssal** directly from App Store, and you may need to allow **Abyssal** to run as an unidentified app[^open_as_unidentified].
>
> You can download the zipped app of **Abyssal** only from [Releases](https://github.com?KrLite/Abyssal/releases) page manually for now.

[^open_as_unidentified]: [`↗ Open a Mac app from an unidentified developer`](https://support.apple.com/guide/mac-help/mh40616/mac)
