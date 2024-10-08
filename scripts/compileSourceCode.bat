@echo off

rem 使用须知：修改CURRENT_DIR和SOURCE_DIR即可使用本脚本！！！！！！

rem 记录当前位置
set "CURRENT_DIR=%cd%"

rem jdk源码目录
cd ..
set "SOURCE_DIR=%cd%\src\source"
cd /d %CURRENT_DIR%

rem 编译rt_debug.jar存放的目录
set "RT_DEBUG_DIR=%CURRENT_DIR%\jdk_debug"

rem jdklib目录（编译代码要用的）
rem set "LIB_PATH=%JAVA_HOME%\jre\lib\rt.jar;%JAVA_HOME%\lib\tools.jar"
set "LIB_PATH=%JAVA_HOME%\jre\lib\rt.jar %JAVA_HOME%\lib\tools.jar"

rem rt_debug.jar需要存放的位置
set "RT_DEBUG_ENDORSED_DIR=%JAVA_HOME%\jre\lib\endorsed"

rem 显示JAVA_HOME变量
rem echo "%JAVA_HOME%"

rem 如果jdk_debug不存在，则进行创建
if not exist "%RT_DEBUG_DIR%" mkdir "%RT_DEBUG_DIR%"

rem 生成需要编译的文件列表
dir /B /S /X "%SOURCE_DIR%\*.java" > "%CURRENT_DIR%\filelist.txt"

rem 执行编译操作
rem javac可能不支持在指定cp的时候，写不同路径的jar包，这里简单起见，直接把rt.jar和tools.jar复制到当前目录下
rem javac -J-Xms16m -J-Xmx1024m -encoding UTF-8 -sourcepath %SOURCE_DIR% -cp %LIB_PATH% -d %RT_DEBUG_DIR% -g @filelist.txt >> log.txt 2>&1

rem 批量将jar包复制到当前目录下（如果不存在，则复制过去）
rem 临时存放路径的变量
set "my_path="
setlocal EnableDelayedExpansion
for %%i in (%LIB_PATH%) do (
rem setlocal
call:getFileName "%%i"
if not exist "!my_path!" copy /y "%%i" "%CURRENT_DIR%"
rem endlocal
)
setlocal DisableDelayedExpansion

javac -encoding UTF-8 -J-Xms16m -J-Xmx1024m -sourcepath %SOURCE_DIR% -cp rt.jar;tools.jar -d %RT_DEBUG_DIR% -g @filelist.txt >> log.txt 2>&1

rem 生成rt_debug.jar
cd /d "%RT_DEBUG_DIR%"&&jar cf0 rt_debug.jar *

rem 把新生成的jar包放到JDK_HOME\jre\lib\endorsed中（如果没有endorsed文件夹，则手动创建）
if not exist "%RT_DEBUG_ENDORSED_DIR%" mkdir "%RT_DEBUG_ENDORSED_DIR%"
copy /y "%RT_DEBUG_DIR%\rt_debug.jar" "%RT_DEBUG_ENDORSED_DIR%\rt_debug.jar"

rem pause&goto:eof
goto:eof&exit


rem 自定义函数：通过全路径获得文件名
:getFileName
rem for %%a in ("%~1") do (echo %%~nxa)
rem for %%a in ("%~1") do (echo %CURRENT_DIR%\%%~nxa)
for %%a in ("%~1") do (
set "my_path=%CURRENT_DIR%\%%~nxa"
)
goto:eof

rem 参考链接
rem 如何在bat脚本中定义函数？ https://www.jb51.net/article/53016.htm
rem 如何从文件全路径中提取文件名？ https://blog.csdn.net/techfield/article/details/83061295
rem 常用匹配模式 https://www.jb51.net/article/97588.htm
rem for循环中无法改变变量的值 https://zhidao.baidu.com/question/140583844767053805.html
rem https://www.cnblogs.com/mq0036/p/3478108.html
