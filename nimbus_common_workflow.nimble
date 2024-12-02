# Package
version       = "0.1.0"
author        = "Status Research & Development GmbH"
description   = "nimbus-common-workflow"
license       = "MIT"
skipDirs      = @["tests"]
srcDir        = "tests"

# Dependencies
requires "nim >= 1.6.0"

# This is a dummy nimble file to let the
# "nimble install -y --depsOnly" in common.yml
# runs correctly when executing CI.
