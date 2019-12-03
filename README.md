# SuperGreenLab App

The mobile and web app for management of [SuperGreenLab] builds.

## End-User Usage

This application is not yet ready for end-user usage.

## Developing

### Prerequisites

- [`flutter`]

### Running the app on a connected mobile device

1. Plug in your device
    - Verify that flutter can find it by running `flutter devices`
    - The device ID may look something like `0GA36TEX9A`
2. Execute `flutter run`
    - You may need to run it like `flutter run -d 0GA36TEX9A`

### Running the app in a web browser (experimental)

From the root of this repository run the following command.

```shell
$ flutter run -d web-server # web-server is the (virtual) device's ID
```

This should (if not, please reach out to us on [Discord]) print something
similar to the following.

```
Launching lib/main.dart on Web Server in debug mode...
Building application for the web...                                 9.1s
lib/main.dart is being served at http://localhost:50901/

Warning: Flutter's support for web development is not stable yet and hasn't
been thoroughly tested in production environments.
For more information see https://flutter.dev/web
```

In a web browser navigate to `http://localhost:50901` (or whatever URL is printed).

You should now see the app.

[SuperGreenLab]: https://www.supergreenlab.com/
[`flutter`]: https://flutter.dev/
[Discord]: https://discord.gg/crdYzgy