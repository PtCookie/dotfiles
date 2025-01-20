# Alias
Function baf {bat.exe --style full $args}
Function bap {bat.exe --paging=always $args}
Function l {lsd.exe -F $args}
Function ll {lsd.exe -lF $args}
Function la {lsd.exe -AlF $args}
Function lsa {lsd.exe -alF $args}
Set-Alias -Name unset -Value Remove-Variable

# Functions
Function Set-LocationToWorkspace
{
  if (Test-Path variable:WORKDIR)
  {
    Set-Location $WORKDIR
  }
  elseif (Test-Path -Path $HOME\Workspaces)
  {
    Set-Location $HOME\Workspaces
  }
  else
  {
    Write-Warning "Error: WORKDIR or Workspaces not found."
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
Set-Alias -Name workdir -Value Set-LocationToWorkspace
Set-Alias -Name which -Value Get-FileLocation
Set-Alias -Name rmrf -Value Remove-RecurseItem

# Set PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Starship prompt initialization
Invoke-Expression (&starship init powershell)
