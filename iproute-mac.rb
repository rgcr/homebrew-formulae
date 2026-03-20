class IprouteMac < Formula
  version "0.1.0"
  desc "Linux iproute2 (ip, bridge, ss) reimplemented natively for macOS"
  homepage "https://github.com/rgcr/iproute-mac"
  url "https://github.com/rgcr/iproute-mac/archive/refs/tags/v#{version}.tar.gz"
  sha256 "b12f50765d07a903c8b569d0ea787a4b8b0254437499a37ebfaa84827d068953"
  license "MIT"
  head "https://github.com/rgcr/iproute-mac.git", branch: "main"

  depends_on :macos
  depends_on "go" => :build

  conflicts_with "iproute2mac", because: "both install `ip`,`ss` and `bridge` binaries"

  def install
    ldflags = "-s -w -X github.com/rgcr/iproute-mac/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "-o", bin/"ip", "./cmd/ip"
    system "go", "build", *std_go_args(ldflags:), "-o", bin/"bridge", "./cmd/bridge"
    system "go", "build", *std_go_args(ldflags:), "-o", bin/"ss", "./cmd/ss"

    # Shell completions
    generate_completions_from_executable(bin/"ip", "completion")
    generate_completions_from_executable(bin/"bridge", "completion")
    generate_completions_from_executable(bin/"ss", "completion")

    # Man pages
    man8.install "docs/man/ip.8"
    man8.install "docs/man/bridge.8"
    man8.install "docs/man/ss.8"
  end

  def caveats
    <<~EOS
      Some commands require root privileges:

        sudo ip link set en0 down
        sudo ip neigh add 10.0.0.1 lladdr aa:bb:cc:dd:ee:ff dev en0

      Wi-Fi SSID/BSSID require Location Services to be enabled for
      the terminal application.
    EOS
  end

  test do
    assert_match "iproute2 for macOS", shell_output("#{bin}/ip --help 2>&1")
    assert_match "link", shell_output("#{bin}/ip link show 2>&1")
    assert_match "bridge", shell_output("#{bin}/bridge --help 2>&1")
  end
end
