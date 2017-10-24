#!/bin/sh

set -e

# Emby Server Installer

if [ -n "$1" ]; then
  emby_version="$1"
else
  emby_version="3.2.34.0"
fi

atexit() {
  if [ $? -ne 0 ]; then
    echo
    echo "ERROR: Installation of Emby Server failed" >&2
    echo "ERROR: Please contact apps@emby.media with the full output above" >&2
  fi
}
trap atexit EXIT

ubuntu_trusty() {
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod trusty main" > /etc/apt/sources.list.d/dotnet.list'

  echo
  echo "Installing Emby Server"

  sudo apt-get update
  curl $options -L https://github.com/MediaBrowser/Emby/releases/download/${emby_version}/emby-server-deb-systemd_${emby_version}_amd64.deb -o emby-server-deb-systemd_${emby_version}_amd64.deb
  sudo dpkg -i emby-server-deb-systemd_${emby_version}_amd64.deb || true
  sudo apt-get -f install
}

ubuntu_xenial() {
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnet.list'

  echo
  echo "Installing Emby Server"

  sudo apt-get update
  curl $options -L https://github.com/MediaBrowser/Emby/releases/download/${emby_version}/emby-server-deb-systemd_${emby_version}_amd64.deb -o emby-server-deb-systemd_${emby_version}_amd64.deb
  sudo dpkg -i emby-server-deb-systemd_${emby_version}_amd64.deb || true
  sudo apt-get -f install
}

curl_options=""
test -n "$INSECURE_SSL" && curl_options="--insecure"

distro=$(cat /etc/os-release | grep '^ID=' | cut -d '=' -f 2 | tr -d '"')
arch=$(uname -m)
version=$(cat /etc/os-release | grep '^VERSION_ID=' | cut -d '=' -f 2 | tr -d '"')

if [ "$arch" != "x86_64" ]; then
  echo
  echo "ERROR: Unsupported architecture - $arch" >&2
  exit 1
fi

case $distro in
  debian)
    echo
    echo "Installing requirements"

    sudo apt-get update
    sudo apt-get install curl libunwind8 gettext apt-transport-https

    echo
    echo "Downloading Microsoft's GPG key to /etc/apt/trusted.gpg.d/microsoft.gpg"

    curl $options https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

    echo
    echo "Installing the Dotnet Core repository to /etc/apt/sources.list.d/dotnet.list"

    case $version in
      8)
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-jessie-prod jessie main" > /etc/apt/sources.list.d/dotnet.list'
        ;;

      9)
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnet.list'
        ;;

      *)
        echo
        echo "ERROR: Unsupported $distro version - $version" >&2
        exit 1
        ;;
    esac

    echo
    echo "Installing Emby Server"

    sudo apt-get update
    curl $options -L https://github.com/MediaBrowser/Emby/releases/download/${emby_version}/emby-server-deb-systemd_${emby_version}_amd64.deb -o emby-server-deb-systemd_${emby_version}_amd64.deb
    sudo dpkg -i emby-server-deb-systemd_${emby_version}_amd64.deb || true
    sudo apt-get -f install
    ;;

  ubuntu)
    echo
    echo "Installing requirements"

    sudo apt-get update
    sudo apt-get install curl

    echo
    echo "Downloading Microsoft's GPG key to /etc/apt/trusted.gpg.d/microsoft.gpg"

    curl $options https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

    echo
    echo "Installing the Dotnet Core repository to /etc/apt/sources.list.d/dotnet.list"

    case $version in
      14.04)
        ubuntu_trusty
        ;;

      16.04)
        ubuntu_xenial
        ;;

      17.04)
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-zesty-prod zesty main" > /etc/apt/sources.list.d/dotnet.list'

        echo
        echo "Installing Emby Server"

        sudo apt-get update
        curl $options -L https://github.com/MediaBrowser/Emby/releases/download/${emby_version}/emby-server-deb-systemd_${emby_version}_amd64.deb -o emby-server-deb-systemd_${emby_version}_amd64.deb
        sudo dpkg -i emby-server-deb-systemd_${emby_version}_amd64.deb || true
        sudo apt-get -f install
        ;;

      *)
        echo
        echo "ERROR: Unsupported $os version - $version" >&2
        exit 1
        ;;
    esac
    ;;

  linuxmint)
    echo
    echo "Installing requirements"

    sudo apt-get update
    sudo apt-get install curl

    echo
    echo "Downloading Microsoft's GPG key to /etc/apt/trusted.gpg.d/microsoft.gpg"

    curl $options https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

    echo
    echo "Installing the Dotnet Core repository to /etc/apt/sources.list.d/dotnet.list"

    case $version in
      17|17.1|17.2|17.3)
        ubuntu_trusty
        ;;

      18|18.1|18.2)
        ubuntu_xenial
        ;;

      *)
        echo
        echo "ERROR: Unsupported $os version - $version" >&2
        exit 1
        ;;
    esac
    ;;

  centos)
    echo
    echo "Installing requirements"

    sudo yum install curl libicu libunwind

    echo
    echo "Importing Microsoft's GPG key"

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    echo
    echo "Installing the Dotnet Core repository to /etc/yum.repos.d/dotnet.repo"

    case $version in
      7)
        sudo sh -c 'echo -e "[packages-microsoft-com-prod]\nname=packages-microsoft-com-prod\nbaseurl=https://packages.microsoft.com/yumrepos/microsoft-rhel7.3-prod\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/dotnet.repo'
        ;;

      *)
        echo
        echo "ERROR: Unsupported $os version - $version" >&2
        exit 1
        ;;
    esac

    echo
    echo "Installing Emby Server"

    sudo yum install https://github.com/MediaBrowser/Emby/releases/download/${emby_version}/emby-server-rpm-systemd_${emby_version}_x86_64.rpm
    sudo firewall-cmd --permanent --add-service=emby-server
    sudo firewall-cmd --reload
    ;;

  fedora)
    echo
    echo "Installing requirements"

    if [ "$version" -lt 26 ]; then
      sudo dnf install curl libicu libunwind
    else
      sudo dnf install curl compat-openssl10 libicu libunwind libicu
    fi

    echo
    echo "Importing Microsoft's GPG key"

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    echo
    echo "Installing the Dotnet Core repository to /etc/yum.repos.d/dotnet.repo"

    case $version in
      25|26)
        sudo sh -c 'echo -e "[packages-microsoft-com-prod]\nname=packages-microsoft-com-prod\nbaseurl=https://packages.microsoft.com/yumrepos/microsoft-rhel7.3-prod\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/dotnet.repo'
        ;;

      *)
        echo
        echo "ERROR: Unsupported $os version - $version" >&2
        exit 1
        ;;
    esac

    echo
    echo "Installing Emby Server"

    sudo dnf install https://github.com/MediaBrowser/Emby/releases/download/${emby_version}/emby-server-rpm-systemd_${emby_version}_x86_64.rpm
    sudo firewall-cmd --permanent --add-service=emby-server
    sudo firewall-cmd --reload
    ;;

  opensuse)
    echo
    echo "Installing requirements"

    sudo zypper install curl libicu libunwind

    echo
    echo "Importing Microsoft's GPG key"

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    echo
    echo "Installing the Dotnet Core repository to /etc/zypp/repos.d/dotnet.repo"

    case $version in
      42.2|42.3|2017*|2018*)
        sudo sh -c 'echo -e "[packages-microsoft-com-prod]\nname=packages-microsoft-com-prod\nbaseurl=https://packages.microsoft.com/yumrepos/microsoft-rhel7.3-prod\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/dotnet.repo'
        ;;

      *)
        echo
        echo "ERROR: Unsupported $os version - $version" >&2
        exit 1
        ;;
    esac

    echo
    echo "Installing Emby Server"

    sudo zypper install https://github.com/MediaBrowser/Emby/releases/download/${emby_version}/emby-server-rpm-systemd_${emby_version}_x86_64.rpm
    ;;
  *)
    echo
    echo "ERROR: Unsupported distro - $distro" >&2
    exit 1
    ;;
esac

echo
echo "Successfully installed Emby Server"