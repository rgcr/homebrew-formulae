class TMuxManager < Formula
  version "0.2.1"
  desc "Lightweight tmux session and project manager written in Bash"
  homepage "https://github.com/rgcr/t-mux-manager"
  url "https://github.com/rgcr/t-mux-manager/archive/refs/tags/v#{version}.tar.gz"
  sha256 "275dfa07986638e4105362c50b79ad70d7195f76be2428892f51c0891c2927f4"
  license "MIT"
  head "https://github.com/rgcr/t-mux-manager.git", branch: "main"

  depends_on "yq"

  def install
    bin.install "t"
    bash_completion.install "completions/t.bash" => "t"
    zsh_completion.install "completions/t.zsh" => "_t"
    fish_completion.install "completions/t.fish"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/t -V")
    assert_match "Usage:", shell_output("#{bin}/t -h")
  end
end
