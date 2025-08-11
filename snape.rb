class Snape < Formula
  desc "A Severus Snippet Manager - Handle your snippets with precision"
  homepage "https://github.com/rgcr/snape"
  url "https://github.com/rgcr/snape/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0358494a964a02ab899815b7ef3f988ded59875a99033580c794c870f9baab13"
  license "MIT"
  head "https://github.com/rgcr/snape.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."

    # Create snippets directory structure for documentation
    (prefix/"share/snape").mkpath

    # Install example snippets
    (prefix/"share/snape/examples").mkpath
    (prefix/"share/snape/examples/hello.txt").write "Hello, World!"
    (prefix/"share/snape/examples/greeting.txt").write "Hi there!\n\nHope you're having a great day!"
    (prefix/"share/snape/examples/hello-world.go").write <<~EOS
      package main

      import "fmt"

      func main() {
      \tfmt.Println("Hello, World!")
      }
    EOS
  end

  def post_install
    # Create user's snippets directory if it doesn't exist
    snape_dir = "#{Dir.home}/.snape"
    unless Dir.exist?(snape_dir)
      FileUtils.mkdir_p(snape_dir)
      ohai "Created snippets directory: #{snape_dir}"

      # Copy example snippets to user directory
      examples_dir = "#{prefix}/share/snape/examples"
      if Dir.exist?(examples_dir)
        Dir.glob("#{examples_dir}/*").each do |file|
          dest = File.join(snape_dir, File.basename(file))
          FileUtils.cp(file, dest) unless File.exist?(dest)
        end
        ohai "Installed example snippets to #{snape_dir}"
      end
    end
  end

  def caveats
    <<~EOS
      Snape has been installed! 🧙

      Snippets are stored in: ~/.snape/

      Usage:
        snape                    # Launch snippet selector
        snape --help             # Show help options
        snape --verbose          # Verbose mode
        snape --width-size 300   # Custom window width (200-600)
        snape --height-size 450  # Custom window height (200-600)

      Hotkey Integration (Recommended):

      • Hammerspoon (macOS):
        Add to ~/.hammerspoon/init.lua:
        hs.hotkey.bind({"cmd", "shift"}, "s", function()
          hs.task.new("#{HOMEBREW_PREFIX}/bin/snape", nil, nil, {}):start()
        end)

      • skhd (macOS):
        Add to ~/.config/skhd/skhdrc:
        cmd + shift - s : #{HOMEBREW_PREFIX}/bin/snape

      • i3wm (Linux):
        Add to ~/.i3/config:
        bindsym $mod+s exec  #{HOMEBREW_PREFIX}/bin/snape

      Add your own snippets as text files in ~/.snape/
      Each file becomes a selectable snippet with the filename as the name.
      Extension is not shown as part of the snippet name unless there are multiple files with the same name.
    EOS
  end

  test do
    # Test basic help functionality
    assert_match "Snape - A Severus Snippet Manager", shell_output("#{bin}/snape --help")

    # Test that binary exists and is executable
    assert_predicate bin/"snape", :exist?
    assert_predicate bin/"snape", :executable?

    # Test version/build info (if available)
    system bin/"snape", "--help"
  end
end
