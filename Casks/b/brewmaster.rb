cask "brewmaster" do
  version "0.1.13"
  sha256 "e5a31e562b7d284930590b0f14dd0d4b3ed191b67990deb3f337d4b0d6af6d49"

  url "https://github.com/paul-ej/homebrew-brewmaster/releases/download/v#{version}/Brewmaster-#{version}.pkg"
  name "Brewmaster"
  desc "Policy-controlled Homebrew maintenance from the menu bar"
  homepage "https://github.com/paul-ej/homebrew-brewmaster"

  auto_updates true

  depends_on arch: :arm64
  depends_on macos: :sonoma

  pkg "Brewmaster-#{version}.pkg"

  uninstall pkgutil: "com.paul-ej.brewmaster",
            delete: "/Applications/Brewmaster.app"
end
