# Common CI workflows
[![GH action-nimbus-common-workflow](https://github.com/status-im/nimbus-common-workflow/actions/workflows/ci.yml/badge.svg)](https://github.com/status-im/nimbus-common-workflow/actions/workflows/ci.yml)

This goal of this repo is to define standardized GitHub Actions workflows
to be used in Status projects for common tasks like testing and documentation generation.

For testing, there is `common.yml` that provides commonly required steps:
- setting up the build matrix (different OSes, different Nim versions)
- installing the build dependencies
- building Nim and Nimble
- running the tests

For docs, there is `docs.yml` that sets up mdBook and Nim, builds and publishes
the docs to GitHub Pages.





## `common.yml` Usage

To use this workflow, in the project's `.github/workflows/<name>.yml`you need
to refer to it inside of `jobs.<name>.uses` field.\
For example, the full file might look like this:

```yaml
name: CI
on:
  push:
    branches:
      - master
  pull_request:
  workflow_dispatch:

jobs:
  build:
    uses: status-im/nimbus-common-workflow/.github/workflows/common.yml@main
```

By default, it is assumed that your project uses `nimble test` for its testing.





### Customizing the test command

In a case where you don't just run `nimble test`, or when you need some additional
commands (e.g. installing additional libraries) before running the tests,
you can specify the `jobs.<name>.with.test-command`.\
For example:

```yaml
name: CI
on:
  push:
    branches:
      - master
  pull_request:
  workflow_dispatch:

jobs:
  build:
    uses: status-im/nimbus-common-workflow/.github/workflows/common.yml@main
    with:
      test-command: |
          nimble install -y toml_serialization json_serialization unittest2
          nimble test
```

Or to run several different test commands:

```yaml
name: CI
on:
  push:
    branches:
      - master
  pull_request:
  workflow_dispatch:

jobs:
  build:
    uses: status-im/nimbus-common-workflow/.github/workflows/common.yml@main
    with:
      test-command: |
          nimble install -y libbacktrace
          nimble test
          nimble test_libbacktrace
          nimble examples
```





### Customizing the Nim versions used in testing

By default, this workflow tests a package with the following Nim versions:
- `version-1-6`
- `version-2-0`
- `version-2-2`
- `devel`

To test with a different set of Nim versions, specify them in
`jobs.<name>.with.nim-versions` using the following syntax (make sure to include
both outer single quotes and inner double quotes as in the example):

```yaml
name: CI
on:
  push:
    branches:
      - master
  pull_request:
  workflow_dispatch:

jobs:
  build:
    uses: status-im/nimbus-common-workflow/.github/workflows/common.yml@main
    with:
      nim-versions: '["version-2-0", "version-2-2"]'
```





## `docs.yml` Usage

Similarly to `common.yml`, to use this workflow,
refer to it in your project's `.github/workflows/<name>.yml`:

```yaml
name: Build Docs

on:
  push:
    branches:
      - master
  workflow_dispatch:

jobs:
  docs:
    uses: status-im/nimbus-common-workflow/.github/workflows/docs.yml@main
```

By default, it is assumed that your project uses `nimble docs` to generate the docs.





### Customizing the docs command

You can customize the command used to produce the docs
by defining `docs-command` value:

```yaml
name: Build Docs
on:
  push:
    branches:
      - master
  workflow_dispatch:

jobs:
  docs:
    uses: status-im/nimbus-common-workflow/.github/workflows/docs.yml@main
    with:
      docs-command: |
          nimble install nimble@#head -y
          nimble doc --outdir:docs/apidocs --project --index:on src/myproject.nim"
          mdbook build book -d docs
```





### Customizing mdBook version and preprocessors

By default, this workflow uses the latest mdBook and no preprocessors
to build the docs.

To pin the mdBook version, set `mdbook-version`:

```yaml
name: Build Docs

on:
  push:
    branches:
      - master
  workflow_dispatch:

jobs:
  docs:
    uses: status-im/nimbus-common-workflow/.github/workflows/docs.yml@main
    with:
      mdbook-version: "0.5.2"
```

If your documentation requires mdBook preprocessors, list them as a JSON array
in `mdbook-preprocessors`:

```yaml
name: Build Docs

on:
  push:
    branches:
      - master
  workflow_dispatch:

jobs:
  docs:
    uses: status-im/nimbus-common-workflow/.github/workflows/docs.yml@main
    with:
      mdbook-version: "0.5.2"
      mdbook-preprocessors: >-
        [
          "mdbook-open-on-gh@3.0.0",
          "mdbook-toc@0.15.3",
          "mdbook-admonish@1.20.0"
        ]
```

You can list the preprocessors with specific versions or without them
(then the latest version will be installed).





### Customizing the Nim version

By default, the latest stable Nim version is installed.

You can override that with `nim-version`:

```yaml
name: Build Docs

on:
  push:
    branches:
      - master
  workflow_dispatch:

jobs:
  docs:
    uses: status-im/nimbus-common-workflow/.github/workflows/docs.yml@main
    with:
      nim-version: "0.5.2"
```

This can be handy if you run Nim code during documentation build
(e.g. "nim doc") and your project requires a specific Nim version.





### Customizing the branch and directory to publish

By default, this workflow will publish the docs from `./docs` directory
to `gh-pages` branch.

If your `docs-command` puts the generated docs into a different directory
or you want to publish from a different branch,
use `publish-dir` and `publish-branch`:

```yaml
name: Build Docs

on:
  push:
    branches:
      - master
  workflow_dispatch:

jobs:
  docs:
    uses: status-im/nimbus-common-workflow/.github/workflows/docs.yml@main
    with:
      publish-dir: "./book"
      publish-branch: "documentation"
```
