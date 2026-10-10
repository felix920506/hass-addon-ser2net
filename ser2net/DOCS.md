# Home Assistant Add-on: ser2net

This add-on runs [ser2net][ser2net], which makes a serial device plugged
into your Home Assistant host reachable over the network. It supports
RFC 2217, so remote clients can change port settings such as baud rate or
RTS/DTR.

## Requirements

- A Home Assistant installation that includes the Supervisor, so either
  **Home Assistant OS** or **Home Assistant Supervised**. Home Assistant
  Container and Home Assistant Core do not support add-ons.
- A serial device (USB-to-serial adapter, Zigbee/Z-Wave stick, etc.)
  connected to the Home Assistant host.

## Installation

### Option 1: Add the add-on repository (recommended)

1. In Home Assistant, go to **Settings** → **Add-ons** → **Add-on Store**.
2. Click the **⋮** menu (top right) and choose **Repositories**.
3. Paste the repository URL and click **Add**:

   ```text
   https://github.com/felix920506/hass-addon-ser2net
   ```

4. Close the dialog. If the add-on does not show up, open the **⋮** menu
   again and click **Check for updates**, then reload the page.
5. Scroll to the **ser2net Home Assistant Add-on** section and click
   **ser2net server**.
6. Click **Install**. The Supervisor downloads the prebuilt add-on image
   from the GitHub Container Registry.

You can also open the "add repository" dialog straight from this link,
if [My Home Assistant][my-ha] is set up:

[![Open your Home Assistant instance and show the add add-on repository dialog with this repository URL pre-filled.][my-badge]][my-link]

### Option 2: Install as a local add-on

Use this if you want to change the add-on yourself, or if your Home
Assistant host can't reach GitHub.

1. Install the **Samba share** or **Advanced SSH & Web Terminal** add-on so
   you can reach the `/addons` folder on the host.
2. Copy the `ser2net` folder from this repository into `/addons`, so you
   end up with `/addons/ser2net/config.yaml`.
3. Go to **Settings** → **Add-ons** → **Add-on Store**, open the **⋮**
   menu and click **Check for updates**.
4. **ser2net server** shows up under **Local add-ons**. Open it and click
   **Install**.

## Configuration

After installing, open the add-on's **Configuration** tab before you start
it.

Example configuration:

```yaml
serial_device: /dev/serial/by-id/usb-FTDI_FT232R_USB_UART_A10K1234-if00-port0
max_connections: 1
enable_admin_interface: true
```

### Option: `serial_device`

What ser2net connects to. It accepts any of these forms:

| Value                 | Connects to                                               |
| --------------------- | --------------------------------------------------------- |
| `/dev/...`            | A serial device on the Home Assistant host.               |
| `socket://HOST:PORT`  | A raw TCP port, such as a terminal server port.           |
| `rfc2217://HOST:PORT` | A telnet / RFC 2217 port on a remote serial server.       |
| Anything else         | Passed to ser2net unchanged as a [gensio][gensio] string. |

For a local device, pick the `/dev/serial/by-id/...` path when you can.
Paths like `/dev/ttyUSB0` and `/dev/ttyACM0` can change after a reboot or
when you plug in another device. To see the devices on your host, go to
**Settings** → **System** → **Hardware** → **⋮** → **All hardware**.

The value isn't checked when you save it. If ser2net can't use it, the
add-on keeps running, but the add-on log shows an error and clients
can't connect.

Default: `/dev/ttyACM0`

#### Example: share a terminal server port between several clients

```yaml
serial_device: socket://172.20.3.167:1027
max_connections: 4
enable_admin_interface: true
```

Every connected client sees the output from the remote port, and what
any of them types is sent to it.

### Option: `max_connections`

How many network clients can be connected to the serial port at once.
Most serial devices expect only one client, so leave this at `1` unless you
know you need more. Set it higher to share one port between several
clients, as in the terminal server example above.

Default: `1`

### Option: `enable_admin_interface`

Turns on ser2net's admin interface on its own TCP port. You can use it to
view and control ser2net connections from a plain TCP client, for example
`telnet <host> 7001`.

The admin interface has no authentication. Turn it off if your network is
not trusted.

Default: `true`

### Option: `log_level`

Optional. Sets how much the add-on logs. Possible values:

- `trace`
- `debug`
- `info`
- `notice`
- `warning`
- `error`
- `fatal`

Set it to `debug` to print the generated ser2net configuration in the
add-on log.

## Network ports

| Container port | Default host port | Purpose                                     |
| -------------- | ----------------- | ------------------------------------------- |
| `12345/tcp`    | `7000`            | Serial data (raw TCP or telnet / RFC 2217). |
| `12346/tcp`    | `7001`            | Admin interface, if enabled.                |

To change the host ports, open the **Configuration** tab and edit the
**Network** section. Leave a port empty to turn it off.

## Starting the add-on

1. Optionally, on the **Info** tab, turn on **Start on boot** and
   **Watchdog**.
2. Click **Start**.
3. Open the **Log** tab and check that ser2net started without errors.
   The log shows the ser2net version and, if it is enabled, the admin
   interface port.

## Connecting to the serial port

Replace `homeassistant.local` with your Home Assistant host name or IP
address, and `7000` with the host port you set.

- **RFC 2217, for example pySerial**: use the URL
  `rfc2217://homeassistant.local:7000`. The client can then change baud
  rate, parity, flow control and so on.
- **Linux virtual serial port with socat**:

  ```bash
  socat pty,link=/tmp/ttyV0,raw,echo=0 tcp:homeassistant.local:7000
  ```

- **Quick test with telnet**: `telnet homeassistant.local 7000`.

## Troubleshooting

- **The add-on doesn't show up after adding the repository.** Click
  **⋮** → **Check for updates** in the Add-on Store and reload the page.
  Then check **Settings** → **System** → **Logs** → **Supervisor** for
  repository errors.
- **Clients connect but nothing happens.** Check the add-on log for a
  `device configuration ... invalid` error, which means ser2net couldn't
  use the `serial_device` value.
- **The add-on stops right after starting.** Check that the device chosen
  in `serial_device` exists and that no other add-on or integration (such
  as ZHA or Z-Wave JS) is using it.
- **Clients can't connect.** Check that the host port is set in the
  **Network** section and that no firewall between the client and the Home
  Assistant host blocks it. With `max_connections: 1`, a second client is
  refused while the first is still connected.

## Support

Got questions or found a bug? [Open an issue on GitHub][issue].

[gensio]: https://github.com/cminyard/gensio
[issue]: https://github.com/felix920506/hass-addon-ser2net/issues
[my-badge]: https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg
[my-ha]: https://my.home-assistant.io/
[my-link]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Ffelix920506%2Fhass-addon-ser2net
[ser2net]: https://github.com/cminyard/ser2net
