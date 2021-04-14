#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

#------------------ colors -------------------

$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "White"

#--------------- custom prompt ---------------

function prompt {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

  $(if (Test-Path variable:/PSDebugContext) { '[DBG] ' }
    elseif($principal.IsInRole($adminRole)) { '[ADMIN] ' }
    else { '' }
  ) + $(Get-Location) +
    $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
}

#---------------- git aliases ----------------

function status { git status }
function add { git add $args }
function commit { git commit -m $args }
function checkout { git checkout $args }
function branch { git branch $args }

New-Alias -Name g -Value git
New-Alias -Name gs -Value status
New-Alias -Name ga -Value add
New-Alias -Name gco -Value commit
New-Alias -Name gch -Value checkout
New-Alias -Name gb -Value branch
New-Alias -Name vim -Value nvim

Clear-Host