cask "brewmaster" do
  version "0.1.15"
  sha256 "dd96aff7be1e6aea0ecb8d5c32bfaba4a2b186bb854069a321c91b03109f41cd"

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
