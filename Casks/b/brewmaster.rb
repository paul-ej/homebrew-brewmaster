cask "brewmaster" do
  version "0.1.5"
  sha256 "b89599ba68d208122bd6903c93fbbaff0089035e76b70456030b4a488e540038"

  url "https://github.com/paul-ej/brewmaster/releases/download/v#{version}/Brewmaster-#{version}.pkg"
  name "Brewmaster"
  desc "Policy-controlled Homebrew maintenance from the menu bar"
  homepage "https://github.com/paul-ej/brewmaster"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  pkg "Brewmaster-#{version}.pkg"

  uninstall pkgutil: "com.paul-ej.brewmaster",
            delete: "/Applications/Brewmaster.app"
end
