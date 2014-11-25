At the momment this release only works as a service for distributions such as CentOS 7 and Fedora 19+
you can still run the start.sh script to run the server from a terminal.

For CentOS 7 you need to enable/install the epel repository:

        yum install epel-release

For Fedora 19+:

    *If you have the rpmfusion repositories then install ffmpeg from there and the server wont download it when it first boot up. If not then the first boot may take some time, you can also create/modify the file at /etc/opt/MediaBrowser/MediaBrowserServer/MediaBrowserServer.cfg and add you path for installffmpeg and ffprobe in the following format:
    FFmpeg="/bin/ffmpeg"
    FFprobe="/bin/ffprobe"
    
    Install the repo rpm from: 
        https://raw.githubusercontent.com/jose-pr/MediaBrowser.Releases/master/Repository/MediaBrowserServer-repositories.noarch.rpm
    Type command to get the latest repo:
        yum update MediaBrowserServer-repositories
    If your system meet the server dependancies you can go ahead and type:
        yum install MediaBrowserServer
    if not you can enable the MediaBrowserServer-Dependancies repo to supply the dependancies
        yum-config-manager --enable MediaBrowserServer-Dependancies
     and then proceed to install the server.
     
    You can start the service by typing:
        sudo service MediaBrowserServer start
    or
        sudo systemctl start MediaBrowserServer
        
    To stop/restart or see the status of the service substitute start with the appropiate command.
    
    To start the service whenever the system boots up:
        sudo systemctl enable MediaBrowserServer
    to stop it from starting when the system boots up:
        sudo systemctl disable MediaBrowserServer
    To enable Beta releases type
        yum-config-manager --enable MediaBrowserServer-Beta
         
    
System Tray Icon:

     To have a tray-icon just in the windows version install MediaBrowserServer-sysTray
        yum install MediaBrowserServer-sysTray
     
     after it is installed reload gnome by pressing [alt]+[f2] typing [r] in the box and pressing [enter].
     Start the tray icon by clicking on the Media Browser Server application.
     It will start the server service when you click on the application and close it if you click exit on the tray icon. 
     
     
