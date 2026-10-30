cask "brewmaster" do
  version "0.1.12"
  sha256 "f0591a8605be6bf77aaa99f4d3968973eb58fb9956df1f63d00be98b20f0c2a4"

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
