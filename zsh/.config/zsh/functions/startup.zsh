# Credit: 
# Load all custom settings from one cached file
recreateCachedSettingsFile() {
  setopt EXTENDED_GLOB
  local cachedSettingDir=$ZSH_CONFIG_HOME/cache
  local cachedSettingsFile=$cachedSettingDir/settings.zsh
  local recreateCache=false
  local rcFiles
  if [[ ! -s ${cachedSettingsFile} ]]; then
    recreateCache=true
  else
    rcFiles=($HOME/.zgenom/sources/init.zsh)
    rcFiles+=($HOME/.config/zsh/*.zsh)
    rcFiles+=($HOME/.secrets.zsh)
    for rcFile in $rcFiles; do
      if [[ -s $rcFile && $rcFile -nt $cachedSettingsFile ]]; then
        recreateCache=true
      fi
    done
  fi
  if [[ "$recreateCache" = true ]]; then
    if [[ ! -d $cachedSettingDir ]]; then
      mkdir $cachedSettingDir
    fi
    touch $cachedSettingsFile
    echo "# This file is generated automatically, do not edit by hand!" > $cachedSettingsFile
    echo "# Edit the files in ~/.config/zsh instead!" >> $cachedSettingsFile
    # Zgen
    if [[ -s $HOME/.zgenom/sources/init.zsh ]]; then
      echo ""               >> $cachedSettingsFile
      echo "#"              >> $cachedSettingsFile
      echo "# Zgen:"        >> $cachedSettingsFile
      echo "#"              >> $cachedSettingsFile
      cat $HOME/.zgenom/sources/init.zsh >> $cachedSettingsFile
    fi
    zcompile $cachedSettingsFile
  fi
}
