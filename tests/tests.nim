import
  std/strutils

const
  gitBranch = strip(staticExec("git branch --show-current"))
  gitRevision = strip(staticExec("git rev-parse --short=8 HEAD"))
  nimFullBanner = staticExec("nim --version")

func getNimGitHash(): string =
  const gitPrefix = "git hash: "
  let tmp = splitLines(nimFullBanner)
  if tmp.len == 0:
    return
  for line in tmp:
    if line.startsWith(gitPrefix) and line.len > 8 + gitPrefix.len:
      result = line[gitPrefix.len ..< gitPrefix.len + 8]

echo "Hello World"
echo "Nim version : ", NimVersion
echo "Nim git hash: ", getNimGitHash()
echo "Git branch  : ", gitBranch
echo "Git revision: ", gitRevision
echo "Host OS     : ", hostOS
echo "Host CPU    : ", hostCPU
