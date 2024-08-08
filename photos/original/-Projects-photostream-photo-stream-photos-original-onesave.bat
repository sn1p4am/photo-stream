@echo off
setlocal enabledelayedexpansion

REM 创建目标目录
set "target_dir=%~dp0one-saved"
if not exist "%target_dir%" mkdir "%target_dir%"

REM 遍历当前目录及所有子目录中的文件
for /r %%i in (*) do (
    REM 跳过目标目录中的文件
    if /i "%%~dpi" neq "%target_dir%\" (
        set "filename=%%~nxi"
        set "filepath=%%~fi"

        REM 构建一个独特的文件名，加入相对路径来避免冲突
        set "relative_path=%%~pi"
        set "relative_path=!relative_path:%~dp0=!"
        set "relative_path=!relative_path:\=-!"
        set "target_filepath=%target_dir%\!relative_path!!filename!"

        REM 检查目标文件是否存在
        if exist "!target_filepath!" (
            set "base=%%~ni"
            set "ext=%%~xi"
            set /a counter=1

            REM 循环添加 -re 后缀直到没有重名文件
            :checkname
            set "new_filename=!base!-re!counter!!ext!"
            if exist "%target_dir%\!new_filename!" (
                set /a counter+=1
                goto checkname
            )
            set "target_filepath=%target_dir%\!new_filename!"
        )

        REM 复制文件到目标目录
        copy /y "%%~fi" "!target_filepath!" >nul
    )
)

echo Done!
pause
