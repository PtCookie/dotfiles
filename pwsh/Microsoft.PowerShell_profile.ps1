# Functions
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

# Functions works as Alias
if (Get-Command bat -ErrorAction SilentlyContinue)
{
  Function baf
  {
    bat.exe --style full $args
  }
  Function bap
  {
    bat.exe --paging=always $args
  }
}
if (Get-Command lsd -ErrorAction SilentlyContinue)
{
  Function l
  {
    lsd.exe -F $args
  }
  Function ll
  {
    lsd.exe -lF $args
  }
  Function la
  {
    lsd.exe -AlF $args
  }
  Function lsa
  {
    lsd.exe -alF $args
  }
}
Function workdir
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
Function which
{
  (Get-Command $args).Source
}
Function rmrf
{
  Remove-Item -Recurse -Force $args
}

# Alias
Set-Alias -Name unset -Value Remove-Variable

# Set PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Starship prompt initialization
if (Get-Command starship -ErrorAction SilentlyContinue)
{
  Invoke-Expression (&starship init powershell)
}

# Fast Node Manager setup
if (Get-Command fnm -ErrorAction SilentlyContinue)
{
  fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}
