@echo off

set git_dirs=markdown python studium

(for %%i in (%git_dirs%) do (
   echo,
   echo cd into %%i...
   cd C:\Users\me\%%i && git pull
))

echo Done.
pause
exit 0