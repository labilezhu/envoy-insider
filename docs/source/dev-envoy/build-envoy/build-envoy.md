# 构建 Envoy

Envoy 使用 Bazel 作为其构建框架。但要构建 Envoy，不一定要了解 Bazel 的所有概念。如果你对 Bazel 的概念好奇，可以先阅读 {doc}`/dev-envoy/bazel/bazel` 一节。

以下假设：
- 用户目录是 `/home/labile`
- 使用 Envoy 版本 `1.35.0-dev`

## 获取 Envoy 源码

```bash
mkdir -p /home/labile/opensource
cd /home/labile/opensource
git clone https://github.com/envoyproxy/envoy.git
cd envoy
# 这里使用 main 分支（Envoy 1.35.0-dev）， 一般需要指定 release，如： git checkout tags/v1.34.1 -b v1.34.1 
```

## 构建 Envoy



container 方法构建 Envoy 。有两种方法，如果你使用了  vscode dev container 开发环境，可以直接在 “Envoy VSCode Dev Container 构建 Envoy” ，否则用 “CI Docker Image 构建 Envoy” 。



### CI Docker Image 构建 Envoy



要构建 Envoy 可执行文件的调试版本，您可以运行：

```bash
./ci/run_envoy_docker.sh './ci/do_ci.sh debug.server_only'
```



这个脚本实际运行的类似以下命令：


```bash
BUILD_DIR=/build
GOPROXY=https://proxy.golang.org,direct
ENVOY_BUILD_IMAGE=envoyproxy/envoy-build-ubuntu:cb86d91cf406995012e330ab58830e6ee10240cb@sha256:d38457962937370aa867620a5cc7d01c568621fc0d1a57e044847599372a8571


docker run --rm -u root:root -v /run/user/1000/keyring/ssh:/run/user/1000/keyring/ssh -e SSH_AUTH_SOCK -v /tmp/envoy-docker-build:/build -v /home/labile/opensource/envoy:/source -e BUILD_DIR -e HTTP_PROXY -e HTTPS_PROXY -e NO_PROXY -e GOPROXY -e BAZEL_STARTUP_OPTIONS -e BAZEL_BUILD_EXTRA_OPTIONS -e BAZEL_EXTRA_TEST_OPTIONS -e BAZEL_REMOTE_CACHE -e BAZEL_STARTUP_EXTRA_OPTIONS -e CI_BRANCH -e CI_SHA1 -e CI_TARGET_BRANCH -e DOCKERHUB_USERNAME -e DOCKERHUB_PASSWORD -e ENVOY_DOCKER_SAVE_IMAGE -e ENVOY_STDLIB -e BUILD_REASON -e BAZEL_REMOTE_INSTANCE -e GCP_SERVICE_ACCOUNT_KEY -e GCP_SERVICE_ACCOUNT_KEY_PATH -e NUM_CPUS -e ENVOY_BRANCH -e ENVOY_RBE -e ENVOY_BUILD_IMAGE -e ENVOY_SRCDIR -e ENVOY_BUILD_TARGET -e ENVOY_BUILD_DEBUG_INFORMATION -e ENVOY_BUILD_FILTER_EXAMPLE -e ENVOY_COMMIT -e ENVOY_HEAD_REF -e ENVOY_PUBLISH_DRY_RUN -e ENVOY_REPO -e ENVOY_TARBALL_DIR -e ENVOY_GEN_COMPDB_OPTIONS -e GCS_ARTIFACT_BUCKET -e GCS_REDIRECT_PATH -e GITHUB_REF_NAME -e GITHUB_REF_TYPE -e GITHUB_TOKEN -e GITHUB_APP_ID -e GITHUB_INSTALL_ID -e MOBILE_DOCS_CHECKOUT_DIR -e BAZELISK_BASE_URL -e ENVOY_BUILD_ARCH -e SYSTEM_STAGEDISPLAYNAME -e SYSTEM_JOBDISPLAYNAME envoyproxy/envoy-build-ubuntu:cb86d91cf406995012e330ab58830e6ee10240cb@sha256:d38457962937370aa867620a5cc7d01c568621fc0d1a57e044847599372a8571 /bin/bash -lc groupadd --gid 1000 -f envoygroup           && useradd -o --uid 1000 --gid 1000 --no-create-home --home-dir /build envoybuild           && usermod -a -G pcap envoybuild           && chown envoybuild:envoygroup /build           && chown envoybuild /proc/self/fd/2           && sudo -EHs -u envoybuild bash -c 'cd /source && ./ci/do_ci.sh dev'
```





### Envoy VSCode Dev Container 构建 Envoy

要构建 Envoy 可执行文件的调试版本，您可以运行：

```bash
./ci/do_ci.sh debug.server_only
```

日志输出：

```
ENVOY_SRCDIR=/workspaces/envoy
ENVOY_BUILD_TARGET=//source/exe:envoy-static
ENVOY_BUILD_ARCH=x86_64
Setting test_tmpdir to /build/tmp.
building using 4 CPUs
building for x86_64
clang toolchain with libc++ configured: clang-libc++
bazel debug build...
Building (type=debug target=//source/exe:envoy-static debug=//source/exe:envoy-static.dwp name=envoy)...
ENVOY_BIN=source/exe/envoy-static
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
INFO: Analyzed target //source/exe:envoy-static (2 packages loaded, 2234 targets configured).
INFO: Found 1 target...
Target //source/exe:envoy-static up-to-date:
  bazel-bin/source/exe/envoy-static
INFO: Elapsed time: 14421.891s, Critical Path: 126.50s
INFO: 16082 processes: 7056 internal, 1 local, 9024 processwrapper-sandbox, 1 worker.
INFO: Build completed successfully, 16082 total actions
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
INFO: Analyzed target //source/exe:envoy-static.dwp (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //source/exe:envoy-static.dwp up-to-date:
  bazel-bin/source/exe/envoy-static.dwp
INFO: Elapsed time: 32.486s, Critical Path: 14.73s
INFO: 57 processes: 1 internal, 56 processwrapper-sandbox.
INFO: Build completed successfully, 57 total actions
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
INFO: Analyzed target //test/tools/schema_validator:schema_validator_tool (7 packages loaded, 109 targets configured).
INFO: Found 1 target...
Target //test/tools/schema_validator:schema_validator_tool up-to-date:
  bazel-bin/test/tools/schema_validator/schema_validator_tool
INFO: Elapsed time: 106.536s, Critical Path: 48.37s
INFO: 304 processes: 272 internal, 32 processwrapper-sandbox.
INFO: Build completed successfully, 304 total actions
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
INFO: Analyzed target //test/tools/router_check:router_check_tool (24 packages loaded, 187 targets configured).
INFO: Found 1 target...
Target //test/tools/router_check:router_check_tool up-to-date:
  bazel-bin/test/tools/router_check/router_check_tool
INFO: Elapsed time: 537.451s, Critical Path: 114.86s
INFO: 133 processes: 67 internal, 66 processwrapper-sandbox.
INFO: Build completed successfully, 133 total actions
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
INFO: Analyzed target //test/tools/config_load_check:config_load_check_tool (8 packages loaded, 119 targets configured).
INFO: Found 1 target...
Target //test/tools/config_load_check:config_load_check_tool up-to-date:
  bazel-bin/test/tools/config_load_check/config_load_check_tool
INFO: Elapsed time: 265.921s, Critical Path: 110.42s
INFO: 62 processes: 36 internal, 26 processwrapper-sandbox.
INFO: Build completed successfully, 62 total actions
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
WARNING: The following configs were expanded more than once: [clang-libc++, libc++, clang]. For repeatable flags, repeats are counted twice and may lead to unexpected behavior.
INFO: Analyzed target @@com_github_ncopa_suexec//:su-exec (1 packages loaded, 3 targets configured).
INFO: Found 1 target...
Target @@com_github_ncopa_suexec//:su-exec up-to-date:
  bazel-bin/external/com_github_ncopa_suexec/su-exec
INFO: Elapsed time: 20.893s, Critical Path: 0.11s
INFO: 9 processes: 7 internal, 2 processwrapper-sandbox.
INFO: Build completed successfully, 9 total actions
Copying binary for image build...
```



整个构建过程在我的 4 core 机器中用了数小时：



生成的可执行文件于：`/build/envoy/x64/source/exe/envoy/envoy`



## 参考

- [Generating compile commands](https://github.com/envoyproxy/envoy/tree/main/ci#on-linux)
- [Building Envoy with the CI Docker image](https://github.com/envoyproxy/envoy/blob/main/bazel/README.md#building-envoy-with-the-ci-docker-image)
- [Developer use of CI Docker images](https://github.com/envoyproxy/envoy/blob/main/ci/README.md)





