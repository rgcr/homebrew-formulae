cask "stickyshot" do
  version "1.2.0"
  sha256 "12cea59cae7bc5ee8f246ea45e1b312d49cbc2ae615f19327870e0a561f46a0f"

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

  uninstall delete: [
    "~/Library/Preferences/com.stickyshot.app.plist",
  ]

  zap trash: [
    "~/.config/stickyshot",
    "~/Library/Preferences/com.stickyshot.app.plist",
  ]

  caveats <<~EOS
    StickyShot requires Accessibility and Screen Recording permissions.

    Before granting permissions, stop the current app:
      killall StickyShot

    Follow the onboarding guide on first launch, or manually grant permissions:
      1. System Settings → Privacy & Security → Accessibility → Add StickyShot
      2. System Settings → Privacy & Security → Screen Recording → Add StickyShot

    Note: After upgrading, you may need to re-grant permissions.
    Remove and re-add StickyShot in both settings if hotkey stops working.


    Open StickyShot app and start taking screenshots!
      Default shortcut: ⌘⇧2

  EOS
end
