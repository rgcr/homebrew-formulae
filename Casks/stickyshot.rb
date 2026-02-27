cask "stickyshot" do
  version "1.1.0"
  sha256 "902b65e637dfede4c39633ae36d2de8c9f1e2ac096720270940087e0fa045277"

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

    After installation (or upgrade):
      1. System Settings → Privacy & Security → Accessibility → Add StickyShot
      2. System Settings → Privacy & Security → Screen Recording → Add StickyShot


    Note: After upgrading, you may need to re-grant permissions.
    Remove and re-add StickyShot in both settings if hotkey stops working.


    Open StickyShot app and start taking screenshots!
    Default shortcut: ⌘⇧2

  EOS
end
