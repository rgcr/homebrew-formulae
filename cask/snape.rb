cask "snape" do
  version "2.0.0"
  sha256 "279ad796d6bf0a856abe9766d36823de483717d43afae07decf42873044e3567"

  url "https://github.com/rgcr/snape/releases/download/v#{version}/Snape-#{version}-macos.dmg"
  name "Snape"
  desc "A Severus Snippet Manager - handle your snippets with precision"
s homepage "https://github.com/rgcr/snape"

  depends_on macos: ">= :ventura"

  app "Snape.app"

  zap trash: [
    "~/.config/snape",
    "~/Library/Preferences/com.snape.snippetmanager.plist",
  ]

  caveats <<~EOS
    Snippets are stored in: ~/.config/snape/

    To set up a global hotkey, see:
    https://github.com/rgcr/snape#hotkey-integration
  EOS
end
