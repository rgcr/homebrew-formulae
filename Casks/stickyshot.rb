cask "stickyshot" do
  version "1.0.0"
  sha256 "dd39df273f0186ecbc1177bc1a3cff97bfa2ba49331082df1a88bffa6946fd55"

  url "https://github.com/rgcr/stickyshot/releases/download/v#{version}/StickyShot-#{version}-macos.dmg"
  name "StickyShot"
  desc "Screenshot tool with floating sticky preview windows"
  homepage "https://github.com/rgcr/stickyshot"

  depends_on macos: ">= :monterey"

  app "StickyShot.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/StickyShot.app"]
  end

  zap trash: [
    "~/.config/stickyshot",
    "~/Library/Preferences/com.stickyshot.app.plist",
  ]

  caveats <<~EOS
    StickyShot requires Accessibility and Screen Recording permissions.

    After installation:
        1. Open System Settings → Privacy & Security → Accessibility
        2. Add StickyShot.app
        3. Open System Settings → Privacy & Security → Screen Recording
        4. Add StickyShot.app

    Configuration is stored in: ~/.config/stickyshot/

    Default shortcut: ⌘⇧2
  EOS
end
