# Home Assistant Add-on: ser2net (dev)

This is the development channel of the **ser2net server** add-on. It runs
the image built from the latest commit on the `main` branch, instead of the
latest release. Use it to try fixes and features before they are released.
It may be broken at any time.

It is configured exactly like the release add-on. See the
[ser2net server documentation][docs] for all options.

## Getting the latest dev build

The dev add-on's version is always `dev`, so Home Assistant doesn't offer
updates when a new dev build is published. To get the newest build,
uninstall the add-on and install it again. Write down your configuration
first, because uninstalling removes it.

## Running alongside the release add-on

You can install both add-ons, but they use the same host ports by
default (`7000` and `7001`), and only one can open a given serial device.
Stop one before starting the other, or change the ports in the
**Network** section of one of them.

[docs]: https://github.com/felix920506/hass-addon-ser2net/blob/main/ser2net/DOCS.md
