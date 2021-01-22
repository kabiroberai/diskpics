# diskpics

DeveloperDiskImage patcher for debugging system processes on jailbroken iOS devices

## Usage

Clone this repo and run

```
./mount.sh <ip>[:<port>] [--force|-f]
```

where `<ip>` is the IP address used to ssh into your jailbroken device and `<port>` is an optional port (defaults to 22 or the port specified in the ssh config). If the patched disk is already mounted, an error will be raised. Use `--force` to ignore this if you know what you're doing.

This will allow you to debug system processes and apps from jailbroken packages which are installed on your device.

## Troubleshooting

On some devices/jailbreaks, you may encounter the following error:

```
mount_hfs: error on mount(): error = -1.
mount_hfs: Could not create property for re-key environment check: Operation timed out
mount_hfs: Operation not permitted
mount: /Developer failed with 1
```

There isn't any known solution to this at the moment, however there's a chance your jailbreak may already bestow the required entitlements upon your `debugserver`, so be sure to check for that first.

## Credits

[This](https://www.reddit.com/r/jailbreakdevelopers/comments/fskdv0/tutorial_debugging_your_tweak_in_any_app_with/) Reddit post by [Tanner Bennett](https://github.com/NSExceptional).

Licensed under the MIT license. See [LICENSE.md](LICENSE.md) for details.
