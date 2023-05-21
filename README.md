# 自述文件

本项目为BJUT汇编语言程序设计课程配套项目。

在安装DosBox和Python后，可以一键运行。

支持Windows、Linux、MacOS系统。

## 代码示例

查看 program.asm。

## 参考资料

`https://suiyuanjian.com/117.html`

## 使用方法

* 可以安装 Visual Studio Code（`https://code.visualstudio.com`）等代码编辑器用来编辑 MASM 汇编代码（需要安装 MASM 插件）。

1. 安装 DOSBox（`https://www.dosbox.com`）以运行 16 位 DOS 程序。

2. 根据需要修改 `program.asm`。

3. 安装 Python（`https://www.python.org`）。

4. 从终端运行 `python run.py <ASM_FILE>`，启动 DOSBox，编译、链接并执行 program.asm 中的汇编代码。

* 使用脚本创建和运行储存于独立文件夹中的项目（适用MacOS/Linux，需提前安装DOSBox）

1. 给予脚本执行权限: `chmod +x ./new.sh ./run.sh`

2. 创建项目: `./new.sh <task_name>`，会在当前文件夹下创建一个名为`task_name`的文件夹，并在其中创建一个`task_name.asm`文件，即主程序入口文件。

3. 编译并运行项目: `./run.sh <task_name>`（项目若不存在，则会自动创建）