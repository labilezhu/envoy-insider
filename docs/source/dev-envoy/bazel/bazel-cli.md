
### Overriding repositories from the command line

> https://docs.bazel.build/versions/4.2.1/external.html#overriding-repositories-from-the-command-line



To override a declared repository with a local repository from the command line, use the `--override_repository` flag. Using this flag changes the contents of external repositories without changing your source code.

For example, to override `@foo` to the local directory `/path/to/local/foo`, pass the `--override_repository=foo=/path/to/local/foo` flag.

Some of the use cases include:
 - Debugging issues. For example, you can override a http_archive repository to a local directory where you can make changes more easily.
 - Vendoring. If you are in an environment where you cannot make network calls, override the network-based repository rules to point to local directories instead.


### Using proxies

Bazel will pick up proxy addresses from the `HTTPS_PROXY` and `HTTP_PROXY` environment variables and use these to download HTTP/HTTPS files (if specified).

### Caching of external dependencies
By default, Bazel will only re-download external dependencies if their definition changes. Changes to files referenced in the definition (e.g., patches or BUILD files) are also taken into account by bazel.

To force a re-download, use `bazel sync`.


