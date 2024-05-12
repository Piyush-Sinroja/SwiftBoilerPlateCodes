fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios register_new_device

```sh
[bundle exec] fastlane ios register_new_device
```

Register new devices

### ios sync_appstore_apple_credentials

```sh
[bundle exec] fastlane ios sync_appstore_apple_credentials
```

Install AppStore apple provisional profiles and certificates

### ios sync_dev_apple_credentials

```sh
[bundle exec] fastlane ios sync_dev_apple_credentials
```

Install Dev apple provisional profiles and certificates

### ios upload_testflight_dev

```sh
[bundle exec] fastlane ios upload_testflight_dev
```

Upload to TestFlight Dev

### ios upload_testflight_stage

```sh
[bundle exec] fastlane ios upload_testflight_stage
```

Upload to TestFlight stage

### ios upload_testflight_prod

```sh
[bundle exec] fastlane ios upload_testflight_prod
```

Upload to TestFlight Prod

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
