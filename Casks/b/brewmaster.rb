cask "brewmaster" do
  version "0.1.4"
  sha256 "468ed7668ca31bc4813c5fdf10071f15e14dc3d7920b9f2d3d4f02fbb3e136f9"

  url "https://github.com/paul-ej/brewmaster/releases/download/v#{version}/Brewmaster-#{version}.pkg"
  name "Brewmaster"
  desc "Policy-controlled Homebrew maintenance from the menu bar"
  homepage "https://github.com/paul-ej/brewmaster"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  pkg "Brewmaster-#{version}.pkg"

  uninstall pkgutil: "com.paul-ej.brewmaster",
            delete: "/Applications/Brewmaster.app"
end
