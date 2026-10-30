cask "brewmaster" do
  version "0.1.10"
  sha256 "d2457e23232a104932210d7d4530741b1510c7ccf1f2ad054be447a6fc3c7499"

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
