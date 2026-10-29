cask "brewmaster" do
  version "0.1.6"
  sha256 "7f6dea9cb9c029e1422667d346084871916f73d57a98c5d1b874fafda5b35878"

  url "https://github.com/paul-ej/homebrew-brewmaster/releases/download/v#{version}/Brewmaster-#{version}.pkg"
  name "Brewmaster"
  desc "Policy-controlled Homebrew maintenance from the menu bar"
  homepage "https://github.com/paul-ej/homebrew-brewmaster"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  pkg "Brewmaster-#{version}.pkg"

  uninstall pkgutil: "com.paul-ej.brewmaster",
            delete: "/Applications/Brewmaster.app"
end
