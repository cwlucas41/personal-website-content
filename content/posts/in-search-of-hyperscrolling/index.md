---
title: "In Search of Hyperscrolling"
date: 2022-11-27T19:17:55-08:00
description: "Solutions for fast scrolling with a trackball"
categories:
- 'tech'
tags:
- 'ergonomics'
- 'firmware'
---
<!--summary-->
I was first introduced to hyperscrolling on the scroll wheel of my beloved G502 mouse. At first it was a novelty, but I've grown to appreciate hyper-fast scrolling when working with large documents/web pages. I use a trackball now as my primary pointing device due to ergonomics, since switching I've been looking for ways to keep the advantages of hyperscrolling; after venturing into custom firmware I think I've found a perfect solution for me.

<!--more-->

## Hyperscrolling

For those that haven't had the pleasure, the scroll wheel on the G502, and several other Logitech mice, allows the user to both have great precision when scrolling slowly (like any ordinary scroll wheel) or to have great speed and scroll through documents very quickly with a flick of the finger. The G502 handles this by having a physical button under the scroll wheel that turns the scrolling detents on and off; in the off-state the wheel is allowed to free-spin with low friction - facilitating quick navigation. Newer mice like the MX Master 3 have engineered-out the need for the physical button and the mouse automatically unlocks the wheel for free-spinning when it is rotated quickly[^1]. I find both implementations extremely satisfying to use and, overall, hyperscrolling allows me to navigate long documents easily when I'm already using my mouse for navigation.

Here's a [video](https://youtu.be/TRwPCHR5PCE) featuring the G502 and demonstrating what I mean.

## Problem

Now if hyperscrolling is so great then why is there anything else to say here?
1. I now use a trackball instead of a mouse for ergonomic reasons
2. Logitech makes trackballs, but, at least currently, they don't have hyperscroll wheels

## First solution - Linux only
For several years I used laptops running Ubuntu as my primary computers for doing work.

On those machines, I used the `ScrollMethod` and `ScrollButton` options of the libinput driver (see [Ubuntu man page](https://manpages.ubuntu.com/manpages/focal/man4/libinput.4.html)) to enable the behavior of using the trackball itself as a scroll wheel. This mode is enabled only when pushing the configured button and I mapped it to an extra button on the device.

The config looked something like this:
```
Section "InputClass"
  # ...
  MatchDriver   "libinput"

  # from man page: Enables a scroll method.
  #   Permitted values are none, twofinger, edge,  button.
  #   Not all  devices  support  all options, if an option is unsupported,
  #   the default scroll option for this device is used.
  Option        "ScrollMethod" "button"

  # from man page: Designates  a button as scroll button.
  #   If the ScrollMethod is button and the button is logically held down,
  #   x/y axis movement is converted into scroll events.
  Option        "ScrollButton" "11"
EndSection
```

This worked great for years. Then I switched to a Mac at work and also started to use my Windows desktop (using WSL) for personal projects at home wile also using my Linux laptop sometimes. As far as I can tell, neither Windows or macOS has native support for "ScrollButton" behavior and I'd like to have hyperscrolling on all three platforms.

## Searching for a cross-platform solution
So I started looking for devices:
* the Elecom trackball I was previously using has "Mouse Assistant" driver software but it doesn't have any features for using the trackball as a scroll wheel
* Kensington trackballs also did not seem to support the feature through their driver software
* as previously mentioned: Logitech doesn't have hyperscroll wheels on their trackballs
  - there is an option to configure "Pan Scrolling" via the "Logitech Options" software, but the setting isn't saved to the device so it necessitates having the software installed and running on all platforms. 
    - I have not been impressed with Logitech device management software before and would prefer not to have it running on my machines

Even if there was support through device software for the scrolling I want, all of the software packages only run on Windows and macOS, so I'd still have to use the libinput option when using Linux machines.

## Hardware support!

The solution? Just as hyperscrolling is a hardware feature on the Logitech mice, I realized that I needed to find an input device that has native support for what I want.

## Customizable firmware
I eventually found the [Ploopy classic-trackball](https://ploopy.co/classic-trackball/). It is about the same size as my previous, Elecom trackball which is why I chose that specific model, but there are also other models in different sizes and configurations. It has a customized keymap from the developers to enable something they call "Drag Scroll"[^2] which sounded promising, but the firmware is also completely customizable so I knew I'd be able to configure it the way I want through writing some code.

I was worried about there only being five mouse buttons (left [MB1], middle[MB2], and right click[MB3] + back [MB4] and forward [MB5]) because I thought I'd have to lose one of those function to have an "enable drag scroll" button. I figured that even if that's how the drag scroll keymap worked, I could customize the firmware to do something like "only go into drag scroll when forward and back are pressed at about the same time".

That fear turned out to be unfounded! After building the drag scroll keymap and flashing it onto the device[^3], I found that the actual behavior allows the "forward" button still function normally if pressed and released quickly. When held it chords to activate a second layer of functionality where "left click" then puts the trackball into drag scroll mode and the forward event does not happen [^4].

After discovering this, it was pretty easy to implementy my own keymap[^5] with the following changes from the stock drag scroll keymap:
> * sets `PLOOPY_DRAGSCROLL_INVERT` so that drag scroll direction matches scroll wheel direction
> * sets `PLOOPY_DRAGSCROLL_MOMENTARY` - I find it being momentary is easier as 1. I only use it for short periods, and 2. I found it annoying that I could put it in drag scroll mode and then forget it is in that mode.
> * sets `PLOOPY_DRAGSCROLL_MULTIPLIER` to something that feels good - I found the default value made drag scroll way too sensitive to be useful for me
> * changes drag scroll chording to `BTN4 + BTN1` from `BTN5 + BTN1` - I like using my ring finger over my pinky when momentary mode is enabled

The result is a device that I'm happy with. As another benefit on the Ploopy, the physical trackball is rolling on ball bearings so it can continue to spin when flicked. This combos very nicely with drag scroll mode.

## Conclusion

At the end of all of this, I have a trackball:
* that is ergonomic and comfortable for me to use
* that supports something really close to hyperscrolling
* with the exact same behavior across any OS using only generic mouse drivers on the platform

Now I need one of these for my desk at work too - this seems to be the only downside.


<!--footnotes-->
[^1]: I think I remember reading that this is implemented with electromagnets. In any case, it makes for a very nice experience.
[^2]: https://github.com/qmk/qmk_firmware/tree/master/keyboards/ploopyco/trackball/keymaps/drag_scroll
[^3]: https://github.com/ploopyco/classic-trackball/wiki/Appendix-C%3A-QMK-Firmware-Programming
[^4]: I don't know how this really works, but from spying on keypresses with `xev` it seems the mouse is actually not sending "button 4 press" events exactly when the button is pressed and then sending the full "pressed, released" sequence only when the press and release happens within a quick period of time. Enabling drag scroll mode results in no events for the button being logged. I'm guessing that this behavior is coming from inside the qmk layers implementation which is invoked by the [`LT(1, KC_BTN5)` call](https://github.com/qmk/qmk_firmware/blob/master/keyboards/ploopyco/trackball/keymaps/drag_scroll/keymap.c#L24) in the keymap
[^5]: https://github.com/qmk/qmk_firmware/commit/f50d88967e1d9f75c39df45a76f5ea53f4a46826