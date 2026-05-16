# Extract any archive
extract() {
  if [[ "$1" == "--help" ]]; then
    echo "Usage: extract <file>"
    echo "Supported: .tar.bz2, .tar.gz, .bz2, .rar, .gz, .tar, .tbz2, .tgz, .zip, .Z, .7z"
    return 0
  fi

  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1"    ;;
      *.tar.gz)  tar xzf "$1"    ;;
      *.bz2)     bunzip2 "$1"    ;;
      *.rar)     unrar e "$1"    ;;
      *.gz)      gunzip "$1"     ;;
      *.tar)     tar xf "$1"     ;;
      *.tbz2)    tar xjf "$1"    ;;
      *.tgz)     tar xzf "$1"    ;;
      *.zip)     unzip "$1"      ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1"       ;;
      *)         echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Securely shred all files in the current directory tree
nuke() {
  if [[ "$1" == "--help" ]]; then
    echo "Usage: nuke"
    echo "WARNING: Securely deletes ALL files in the current directory and subdirectories."
    echo "Uses shred to overwrite files, making recovery nearly impossible."
    return 0
  fi

  echo -n "Are you sure you want to nuke all files in this directory? (y/n): "
  read confirmation

  if [[ "$confirmation" == "y" ]]; then
    find . -type f -exec shred -uvz {} \;
  else
    echo "Nuke operation canceled."
    return 0
  fi
}

# Network reset
reset_iptables() {
  sudo iptables -F
  sudo iptables -t nat -F
  sudo iptables -t mangle -F
  sudo iptables -X
  sudo iptables -P INPUT ACCEPT
  sudo iptables -P FORWARD ACCEPT
  sudo iptables -P OUTPUT ACCEPT
  echo "iptables has been flushed."
}

reset_firewalld() {
  sudo systemctl stop firewalld
  sudo systemctl disable firewalld
  sudo systemctl enable firewalld
  echo "firewalld has been flushed."
}
