# Brewmaster

Public distribution for Brewmaster, a macOS menu-bar companion for Homebrew package updates on Apple silicon Macs running macOS 14 or later.

## Install

```sh
brew install --cask paul-ej/brewmaster/brewmaster
```

Signed and notarized installers are available from [GitHub Releases](https://github.com/paul-ej/homebrew-brewmaster/releases). This repository contains the Homebrew cask and AutoPkg recipes; Brewmaster application source is maintained separately in a private repository.

## AutoPkg

```sh
autopkg repo-add https://github.com/paul-ej/homebrew-brewmaster
```

Create an override and review parent trust information before use. Generated download recipes pin the installer version and verify its Developer ID Installer signature.
