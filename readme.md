# Common CI workflow

This goal of this repo is to define a single Github workflow which will be used
in multiple Status projects which share the same common steps required
for testing:
- setting up the build matrix (different OSes, different Nim versions)
- installing the build dependencies
- building Nim and Nimble
- running the tests




## Usage

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
