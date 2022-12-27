# Alias
Function baf {bat.exe --style full $args}
Function bap {bat.exe --paging=always $args}
Function l {lsd.exe -F $args}
Function ll {lsd.exe -lF $args}
Function la {lsd.exe -AlF $args}
Function lsa {lsd.exe -alF $args}
Set-Alias -Name unset -Value Remove-Variable

# Functions
Function Set-ProjectLocation
{
  if (Test-Path variable:WORKDIR)
  {
    Set-Location $WORKDIR
  }
  elseif (Test-Path -Path $HOME\Projects)
  {
    Set-Location $HOME\Projects
  }
  else
  {
    Write-Warning "No Projects found."
  }
}
Function Get-FileLocation
{
  (Get-Command $args).Source
}
Function Remove-RecurseItem
{
  Remove-Item -Recurse -Force $args
}
Function Get-HistoryPath
{
  (Get-PSReadLineOption).HistorySavePath
}
Function Mount-Drive
{
  wsl.exe --mount \\.\PHYSICALDRIVE0 --bare
}
Function Dismount-Drive
{
  wsl.exe --unmount \\.\PHYSICALDRIVE0
}
# Alias for functions
Set-Alias -Name workdir -Value Set-ProjectLocation
Set-Alias -Name which -Value Get-FileLocation
Set-Alias -Name rmrf -Value Remove-RecurseItem

# Starship prompt initialization
Invoke-Expression (&starship init powershell)
