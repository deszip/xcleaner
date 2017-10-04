# xcleaner 
![](https://www.bitrise.io/app/ce6e2398ea118a40/status.svg?token=31hcFmLhHf5FUfU_PU5wDQ&branch=master)
[![codecov](https://codecov.io/gh/deszip/xcleaner/branch/master/graph/badge.svg)](https://codecov.io/gh/deszip/xcleaner)

Simple tool to clean some of the stuff created by XCode.<br>
Looks at next locations and tries to remove some of the stuff located here:
```
~/Library/Developer/Xcode/DerivedData
~/Library/Developer/Xcode/Archives
~/Library/Developer/Xcode/iOS DeviceSupport
~/Library/Developer/Xcode/watchOS DeviceSupport
~/Library/Developer/CoreSimulator/Devices
/Library/Developer/CoreSimulator
```

## Installation

```brew install deszip/tools/xclean```

## Usage

```
Cleans some of the stuff created by XCode.
May corrupt or remove any random data on your or your neighbours discs, you were warned :)

Usage:
xclean [-l] <TARGET> [-r] <TARGET> [-t] <TIMEOUT> [-a] <APPNAME>

Arguments:
<TARGET>                  Traget to clean. Available targets: DerivedData, Archives, DeviceSupport, CoreSimulator
<TIMEOUT>                 Timeout value in seconds.
<APPNAME>                 Name of the app as it appears in simulator, CFBundleDisplayName key from Info.plist.

Options:
-l --list <TARGET>        Lists files that could be relatively safely removed.
Pass target name to list only it.
If no value passed - uses all targets.
-r --remove <TARGET>      Removes files listed by -l
-t --timeout <TIMEOUT>    Sets interval for assuming file is old.
-r and -l will process only files with last access date older than timeout
-a -app <APPNAME>         Sets application name for filtering in simulators. Used only for CoreSimulator target.
e.g. xclean -l CoreSimulator -a SomeApp will list all instances of 'SomeApp' in simulators.
-v --version              Print the version of the application
```

Some examples:<br>
- List all targets showing info on how much space could be freed<br>`xclean -l`
- Same as above but only for derived data<br>`xclean -l DerivedData`
- Removes all derived data older than an hour<br>`xclean -r DerivedData -t 3600`

## Contacts
If you have improvements or concerns, feel free to post [an issue](https://github.com/deszip/xcleaner/issues) and write details.
