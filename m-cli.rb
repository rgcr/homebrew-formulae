# typed: strict
# frozen_string_literal: true

# Homebrew formula for m-cli, the Swiss Army Knife for macOS.
class MCli < Formula
  desc "Swiss Army Knife for macOS"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/refs/tags/v#{version}.tar.gz"
  version "2.0.8"
  sha256 "16e4caba51df326faec13ba6ae52ae12e26649e5087d95a769fcef85c0b87063"
  license "MIT"
  head "https://github.com/rgcr/m-cli.git", branch: "main"

  depends_on :macos

  def install
    prefix.install Dir["*"]

    inreplace prefix/"m" do |s|
      # Use absolute rather than relative path to plugins.
      s.sub!(/^MCLI_PATH=.+$/, "MCLI_PATH=#{prefix}")
      # Disable options "update" && "uninstall", they must be handled by brew
      s.sub!(/^\s*update_mcli\s*&&.*/,
             'printf "\'m-cli\' was installed by brew, try: brew update && brew upgrade m-cli\n" && exit 0')
      s.sub!(/^\s*uninstall_mcli\s*&&.*/,
             'printf "\'m-cli\' was installed by brew, try: brew uninstall m-cli\n" && exit 0')
      s.sub!(/^\s*get_version\s*&&.*/, "printf \"m-cli version: v#{version}\\n\" && exit 0")
    end

    inreplace prefix/"completions/bash/m" do |s|
      # Use absolute brew path for bash completion
      s.sub!(/^\s*local PLUGINS_DIR=.+$/, "local PLUGINS_DIR=#{prefix}/plugins")
    end

    inreplace prefix/"completions/zsh/_m" do |s|
      # Use absolute brew path for zsh completion
      s.sub!(/^\s*local PLUGINS_DIR=.+$/, "local PLUGINS_DIR=#{prefix}/plugins")
    end

    inreplace prefix/"completions/fish/m.fish" do |s|
      # Use absolute brew path for fish completion
      s.gsub!(%r{^\s*set plugins_dir "\$script_dir/plugins"$}, "set plugins_dir \"#{prefix}/plugins\"")
    end

    (prefix/"install.sh").unlink if (prefix/"install.sh").exist?

    bin.install_symlink "#{prefix}/m" => "m"
    bash_completion.install prefix/"completions/bash/m"
    zsh_completion.install prefix/"completions/zsh/_m"
    fish_completion.install prefix/"completions/fish/m.fish"
  end

  def caveats
    <<~EOS

      Some commands are executed with 'sudo' internally because they require root privileges to work correctly.
      Therefore, make sure you have sudo privileges to use this tool effectively.

    EOS
  end

  test do
    output = pipe_output("#{bin}/m --help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*Swiss Army Knife for macOS.*/, output)
  end
end
