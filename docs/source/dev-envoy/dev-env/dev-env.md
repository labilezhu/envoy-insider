# 开发环境

Envoy 的开发环境有多种类型。本书以 VSCode 的 [Developing inside a Container](https://code.visualstudio.com/docs/devcontainers/containers) 即 Envoy Dev Container 作为开发环境，应该是最简单的方式。



以下假设：

- 用户目录是 `/home/labile`
- 使用 Envoy 版本 `1.35.0-dev`



先看看 Envoy 源码库中 vscode dev container 相关的源文件：


```
.devcontainer/Dockerfile
.devcontainer/README.md
.devcontainer/setup.sh
.devcontainer/devcontainer.json
```



-  `devcontainer.json` 定义了这个 vscode dev container 使用了什么扩展等等：

```json
  	"dockerFile": "Dockerfile",

	"postCreateCommand": ".devcontainer/setup.sh",

	"extensions": [
        "github.vscode-pull-request-github",
        "zxh404.vscode-proto3",
        "bazelbuild.vscode-bazel",
        "llvm-vs-code-extensions.vscode-clangd",
        "vadimcn.vscode-lldb",
        "webfreak.debug",
        "ms-python.python"
      ]
```



- `setup.sh` 定义了 container 启动后的初始化脚本
- `Dockerfile` 定义了 dev container docker image 

```
FROM gcr.io/envoy-ci/envoy-build:cb86d91cf406995012e330ab58830e6ee10240cb@sha256:56b66cc84065c88a141963cedbbe4198850ffae0dacad769f516d0e9081439da
```

可见，基础 image 还是 Envoy CI Docker Image。



## 搭建开发环境

VSCode 打开 checkout 下来的源码目录。打开后如果 VSCode 未提示 “Reopen in Container”，那么自行执行 “Reopen in Container” 操作

### 刷新 vscode 代码数据库

要有好的源代码导航效果，必须刷新编译数据库。

有两种方法

- VSCode task 方法

.vscode/tasks.json :

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Refresh Compilation Database",
      "type": "shell",
      "command": "ENVOY_GEN_COMPDB_OPTIONS=\"--vscode --include_headers\" ./ci/do_ci.sh refresh_compdb",
      "problemMatcher": []
    },
```

在 VSCode 中执行： `Tasks: Run task` -> `Refresh Compilation Database`



- 命令行运行 方法

```bash
# 对于在中国大陆的开发者，可能需要预先设置 `http_proxy`、`https_proxy`、`all_proxy` 等代理环境变量。
/workspaces/envoy$ ./ci/do_ci.sh refresh_compdb
```
参见 [Refresh compilation database](https://github.com/envoyproxy/envoy/tree/main/tools/vscode#refresh-compilation-database)。
这将运行 Envoy 的部分构建，可能需要一段时间，具体取决于机器性能。

`ci/do_ci.sh refresh_compdb` 是一个用于刷新编译数据库的脚本。它可能需要一些时间来生成代码补全所需的所有依赖项，例如 protobuf 生成的代码、外部依赖等。如果你修改了 proto 定义，或更改了任何 Bazel 结构，请重新运行该脚本，以确保代码补全功能正常。



> 请注意，建议禁用 VSCode 的 Microsoft C/C++ 插件，改用 `vscode-clangd` 来进行 C/C++ 代码补全。



整个刷新编译库的过程在我的 4 core 机器中用了 1389 秒：

```
INFO: Analyzed 5211 targets (41 packages loaded, 107418 targets configured).
INFO: Found 5211 targets...
INFO: Elapsed time: 1389.588s, Critical Path: 704.21s
INFO: 10183 processes: 7537 internal, 1 local, 2644 processwrapper-sandbox, 1 worker.
INFO: Build completed successfully, 10183 total actions
```



> 我的环境中，曾经试过 build 失败。原因大概是 vscode dev container image 过时需要更新。用 vscode 的 `Dev Containers: Rebuild without cache and reopen in container` 命令可以修正。



完成后会生成 `compile_commands.json` 文件。



上面命令执行完成后，可能还得通知 vscode 的 `clangd` 扩展。执行 vscode 命令: `clangd: Restart language server`



### 生成调试配置



`tools/vscode/generate_debug_config.py` 是一个用于生成 VSCode 调试配置的脚本，生成的配置将写入 `.vscode/launch.json` 文件中。配置的名称格式为 `<debugger type> <bazel target>`。

例如：

```bash
tools/vscode/generate_debug_config.py --debugger gdb //source/exe:envoy-static --args "-c envoy.yaml"

tools/vscode/generate_debug_config.py --debugger lldb //source/exe:envoy-static --args "-c envoy.yaml"
```

这将为 GDB 在 `launch.json` 中生成一个名为 `gdb //source/exe:envoy-static` 的配置项。该脚本也可以用于为测试生成调试配置。

生成的 `gdb` 配置兼容 [Native Debug](https://marketplace.visualstudio.com/items?itemName=webfreak.debug) 插件，而 `lldb` 配置则兼容 [VSCode LLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb) 插件。



>注意，以上只是摘录自 Envoy 文档 [Tools for VSCode](https://github.com/envoyproxy/envoy/blob/main/tools/vscode/README.md) 。我的环境上用 Envoy 1.34.1 是运行执行失败的。原因： [when build envoy in dev container, it fail for ld.lld: error: undefined symbol: std::__1::basic_string. #39416](https://github.com/envoyproxy/envoy/issues/39416)。所以才用了 main 分支： 1.35.0-dev



```
INFO: Analyzed target //source/exe:envoy-static (1163 packages loaded, 41666 targets configured).
[11,761 / 16,238] 4 actions, 3 running
    Compiling external/v8/noicu/torque-generated/src/builtins/frames-tq-csa.cc [for tool]; 5s processwrapper-sandbox
INFO: Found 1 target...
Target //source/exe:envoy-static up-to-date:
  bazel-bin/source/exe/envoy-static
INFO: Elapsed time: 15517.542s, Critical Path: 133.47s
INFO: 11886 processes: 2827 internal, 1 local, 9057 processwrapper-sandbox, 1 worker.
INFO: Build completed successfully, 11886 total actions
```

生成：`.vscode/launch.json` ：

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "gdb //source/exe:envoy-static",
            "request": "launch",
            "arguments": "-c envoy.yaml",
            "type": "gdb",
            "target": "/build/.cache/bazel/_bazel_vscode/2d35de14639eaad1ac7060a4dd7e3351/execroot/envoy/bazel-out/k8-dbg/bin/source/exe/envoy-static",
            "debugger_args": [
                "--directory=/build/bazel_root/base-envoy-compdb/execroot/envoy"
            ],
            "cwd": "${workspaceFolder}",
            "valuesFormatting": "disabled"
        },
        {
            "name": "my gdb //source/exe:envoy-static",
            "request": "launch",
            "arguments": "-c envoy.yaml",
            "type": "gdb",
            "target": "/build/.cache/bazel/_bazel_vscode/2d35de14639eaad1ac7060a4dd7e3351/execroot/envoy/bazel-out/k8-dbg/bin/source/exe/envoy-static",
            "debugger_args": [
                "--directory=/build/.cache/bazel/_bazel_vscode/2d35de14639eaad1ac7060a4dd7e3351/execroot/envoy"
            ],
            "cwd": "${workspaceFolder}",
            "valuesFormatting": "disabled"
        },
        {
            "name": "lldb //source/exe:envoy-static",
            "program": "/build/.cache/bazel/_bazel_vscode/2d35de14639eaad1ac7060a4dd7e3351/execroot/envoy/bazel-out/k8-dbg/bin/source/exe/envoy-static",
            "sourceMap": {
                "/proc/self/cwd": "/workspaces/envoy",
                "/proc/self/cwd/external": "/build/bazel_root/base-envoy-compdb/execroot/envoy/external",
                "/proc/self/cwd/bazel-out": "/build/bazel_root/base-envoy-compdb/execroot/envoy/bazel-out"
            },
            "cwd": "${workspaceFolder}",
            "args": [
                "-c",
                "envoy.yaml"
            ],
            "type": "lldb",
            "request": "launch"
        }
    ]
}
```



在我的环境中，只有 lldb 可以 debug 成功。

## 参考

- [Envoy Dev Container (experimental)](https://github.com/envoyproxy/envoy/blob/main/.devcontainer/README.md)
- [Tools for VSCode](https://github.com/envoyproxy/envoy/blob/main/tools/vscode/README.md)



