# diskpics

DeveloperDiskImage patcher for debugging system processes on jailbroken iOS devices

## Usage

Clone this repo and run

```
./mount.sh <ip>[:<port>] [--force]
```

where `<ip>` is the IP address used to ssh into your jailbroken device and `<port>` is an optional port (defaults to 22).

This will allow you to debug system processes and apps from jailbroken packages which are installed on your device.

## Credits

[This](https://www.reddit.com/r/jailbreakdevelopers/comments/fskdv0/tutorial_debugging_your_tweak_in_any_app_with/) Reddit post by [Tanner Bennett](https://github.com/NSExceptional).

Licensed under the MIT license. See [LICENSE.md](LICENSE.md) for details.
