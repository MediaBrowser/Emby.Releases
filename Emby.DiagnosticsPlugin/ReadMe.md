# Emby.DiagnosticsPlugin

The Diagnostics Plugin for Emby Server exposes a number of settings that allow us to better analyze problems and pinpoint errors.

```diff
!  Disclaimer:
!  The exposed settings are meant to be applied only on explicit request by our support staff. 
!  They are not meant to complement Emby's regular settings, they are not meant for
!  tweaking Emby behavior in general or for fixing certain problems.
```

## System Requirements

The plugin comes as a single file (Emby.DiagnosticsPlugin.dll), which is valid for all platforms on which Emby Server is running.

The minimum required version of Emby Server is 4.4.0.3

## Download and Installation

The plugin is currently not available from the plugin catalog and needs to be installed manually.

- Please download the plugin from HERE.
- Extract the zip file
- Put Emby.DiagnosticsPlugin.dll into the "plugins" subfolder of your Emby installation
- Restart Emby

## Usage

After installing, there will be an additional navigation menu entry at the server dashboard:

![image](https://user-images.githubusercontent.com/4985349/71327492-605f1980-2509-11ea-8d42-76c7dd33dae2.png)


Please apply settings as instructed by the Emby Support staff then click `Save` and follow any additional instructions you might have been given.


## Generating EDD Files

The Diagnostics Plugin will also allow you to generate "EDD" (Emby Diagnostic Data) files.

Those files are including a lot more information than is available in the logfiles, yet the most important part is the media data analysis. 

Media analysis will parse both, transcoding Input and Output and extract detailed (frame-level) information from them?r


### Activating EDD File Generation

- Go to the "Diagnostic Options" dashboard page and scroll down to the bottom
- Check all three check-boxes 
- Enter 500 or 1000 for the frame count

**Important Note:** Activating this will cause some significant CPU load each time you have stopped plaback). This should only be activated when it's really needed).

### Submitting EDD Files

- Those files get saved by Emby into the normal log folder, but they are not visible from the Emby Server Dashboard.
- Please access the file system directly to obtain one of those files.

### Privacy

- EDD files are containing JSON-formatted text which can be reviewed at any time, there's no "secret" information transmitted to Emby
- You can always send us your logs and data files via Private Message, if you want to avoid posting that publicly in the forums!

## Additional Notes

- The diagnostic options are volatile and not being saved anywhere. 
- After restarting Emby Server, all settings will be lost.
