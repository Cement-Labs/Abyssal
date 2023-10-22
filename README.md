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

###### <p align="center">Simplify, Tidy and Master Your macOS Menu Bar[^menu_bar].</p>

[^menu_bar]: Also known as *Status Bar.*

### <div><!--Empty Lines--><br /><br /></div>

> [!IMPORTANT]
> **Abyssal** requires **macOS 13.0 Ventura**[^check_your_macos_version] and above to run.

[^check_your_macos_version]: [`↗ Find out which macOS your Mac is using`](https://support.apple.com/en-us/HT201260)

## Introduction & Usage

<div align="center">
  <img width="700" src="/Docs/Contents/English/Overview.png?raw=true" />
</div>

### Fundamentals

**Abyssal** divides your menu bar into three areas - the **Always Hide Area,** the **Hide Area** and the **Visible Area:**

- The **Always Hide Area**&emsp;Icons inside this area will be *hided forever,* unless you menually check them.
- The **Hide Area**&emsp;Icons inside this area follow certain rules. More often than not, you *don't see them.*
- The **Visible Area**&emsp;Icons inside this area suffer no restrictions. You can see them *all the time.*


The three areas are separated by two separators - the `Always Hide Separator`&ensp;<sub><picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Icons/Dark/DottedLine.png?raw=true" /><img height="17" src="/Docs/Contents/Icons/Light/DottedLine.png?raw=true" /></picture></sub> (the trailing one) and the `Hide Separator`&ensp;<sub><picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Icons/Dark/Line.png?raw=true" /><img height="17" src="/Docs/Contents/Icons/Light/Line.png?raw=true" /></picture></sub> (the middle one). Apart from this, there's another separator on the right - the `Menu Separator`&ensp;<sub><picture><source media="(prefers-color-scheme: dark)" srcset="/Docs/Contents/Icons/Dark/Dot.png?raw=true" /><img height="17" src="/Docs/Contents/Icons/Light/Dot.png?raw=true" /></picture></sub> (the leading one), its position doesn't matter, but it plays an important role.

> **Abyssal** will judge the order of the three separators, which means you don't need to care much about their position. For example, you are allowed to put the `Menu Separator` to the left of the `Always Hide Separator`, as they will swap their roles back automatically after your operation.

<br />

### Showing & Moving the Separators

In themes including the default theme, separators will be hidden by default. And when you open the menu, or move your cursor onto the menu bar[^cursor_onto_status_bar] and press the chosen modifiers, **Abyssal** will show all the separators. In the rest of the themes, separators won't be hidden, but their appearance will change automatically according to the status of the app. The show and hide of the separators also follow some special rules:

- When using themes that automatically hide the icons inside the separators, the `Menu Separator` will indicate the visibility of the status icons inside the **Hide Area**. If the `Menu Separator` **is visible,** it indicates that the status icons inside the **Hide Area** are **visible.** Otherwise the icons are **hidden.**
- When using other themes, all the separators perform together. If all of them are **translucent,** it indicates that the status icons inside the **Hide Area** are **visible.** Otherwise the icons are **hidden.**

[^cursor_onto_status_bar]: You need to move your cursor to the left of `Menu Separator` in order to trigger something. On monitors with notches, you may also need to move your cursor *between the the screen notch and the `Menu Separator`.*

Dragging the icons while holding <kbd>⌘ command</kbd> can change the order of the separators. For example, to put more icons into or out of the **Hide Area.**

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

## Preferences & Customizations

Let's take a look at how to customize **Abyssal**. Still remember? You can open the preferences menu by <kbd>right click</kbd>&ensp;/&ensp;<kbd>⌥ option</kbd> <kbd>click</kbd> on the `Menu Separator`.

The preferences are explained as follows:

<br />

### Theme

`Style: Pop Up Button`
  
Separators' appearances differ from theme to theme, and some themes will automatically hide separators, while others will not.

<br />

### Auto Shows

`Style: Switch`&ensp;`Default: On`
  
- **On**
    
  **Abyssal** will hide the status icons inside the **Hide Area** automatically when you are not using them, and show them when you need.
    
- **Off**
    
  You will need to control the visibility of the status icons manually.

<br />

### Feedback Intensity

`Style: Step Slider`&ensp;`Default: • · · · Disabled`

- **`• · · ·`&emsp;Disabled**
  
  Haptic feedback **Disabled.**
  
- **`· • · ·`&emsp;Light**
  
  **Light** haptic feedback intensity.
  
- **`· · • ·`&emsp;Medium**
  
  **Medium** haptic feedback intensity.
  
- **`· · · •`&emsp;Heavy**
  
  **Heavy** haptic feedback intensity.

> [!NOTE]
> Due to the limitations of macOS, you may not feel a strong haptic feedback.

<br />

### Use Always Hide Area

`Style: Switch`&emsp;`Default: On`

- **On**
  
  **Completely disable** the **Always Hide Area** and **hide** the `Always Hide Separator`.

- **Off**

  **Enable** the **Always Hide Area** and **show** the `Always Hide Separator`.

<br />

### Modifiers

`Style: List of Switches`&emsp;`Default: ⌥ ⌘`

- **`⌃`**

  Whether to use <kbd>⌃ control</kbd> as a modifier key.

- **`⌥`**

  Whether to use <kbd>⌥ option</kbd> as a modifier key.

- **`⌘`**

  Whether to use <kbd>⌘ command</kbd> as a modifier key.

> [!NOTE]
> Pressing only one of the chosen keys is enough to trigger the functions. It is recommended to keep the modifier key <kbd>⌘ command</kbd> enabled.

<br />

### Timeout

`Style: Step Slider`&emsp;`Default: · · · • · · · · · · · 30 seconds`

Set an optional timeout for `Auto Idling` to cancel automatically, ranging from `5 seconds` to `10 minutes`.

- **`· · · · · · · · · · •`&emsp;Disabled**

  **Disable** timeout for `Auto Idling`.

<br />

### Reduce Animation

`Style: Switch`&emsp;`Default: Off`

- **On**

  Animate the moves of **Abyssal.**

- **Off**

  Reduce animations to gain a more performant experience.

<br />

> [!WARNING]
> If you are using an **Intel** chip Mac, it is recommended to keep the `Reduce Animation` option **on** to ensure the smoothness of **Abyssal.**

<br />

### Starts with macOS

`Style: Switch`&emsp;`Default: Off`

- **Off**

  **Abyssal** will run in background after macOS launched.

- **On**

  You need to manually run **Abyssal** after macOS launched.

<br />

### What's More: Auto Idling

Due to the limitations of macOS, **Abyssal** cannot know whether you have opened a menu in the **Always Hide Area** or the **Hide Area.** If the **Auto Hide** function hides these status icons rashly, their menus will also move away. Therefore, **Abyssal** adopts an approach to avoid similar situations to the greatest extent.

Speaking generally, when you click on a place in the menu bar **where there is likely to have other status icons, and the status icon is likely to be inside the Hide Area or the Always Hide Area,** **Abyssal** will choose to pause the **Auto Hide** and enter the **Auto Idling** state. When you finish the operation, just move the cursor **over** the `Always Hide Separator` or the `Hide Separator`, and you can cancel the **Auto Idling** state and resume **Auto Hide** to hide the status icons. **Abyssal** also provides an optional timeout to automatically disable the **Auto Idling** state, which can be configured in the preferences menu.

**Auto Idling** will enable automatically accordng to your clicking position, and it will distinguish between the **Always Hide Area** and the **Hide Area.** It will only be activated when **Auto Hide** is enabled.

After you **triggered or canceled** **Auto Hide or Auto Idling,** **Abyssal** will give a haptic feedback[^haptic_feedback_support_needed].

[^haptic_feedback_support_needed]: Your device must support *haptic feedback.*

<br />

## Install & Run[^install_and_run]

[^install_and_run]: [`↗ Open a Mac app from an unidentified developer`](https://support.apple.com/guide/mac-help/mh40616/mac)

As an open-source and free software, **Abyssal** has no ability to pay for [Apple Developer Account.](https://developer.apple.com/help/account/)Thus, you can't install **Abyssal** from App Store, and you may need to allow **Abyssal** to run as an unidentified app.

> [!NOTE]
> You can download the installing disk image of **Abyssal** only from [Releases](https://github.com?KrLite/Abyssal/releases) page manually for now.
