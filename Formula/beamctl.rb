class Beamctl < Formula
  desc "Command-line control for a Logitech Litra Beam LX light"
  homepage "https://github.com/nenych/beamctl"
  url "https://github.com/nenych/beamctl/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4059f8924a7a53514fe8aff240e17b94426d65a9a132a899dab70fc163def091"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    pkgshare.install "70-beamctl.rules" if OS.linux?
  end

  def caveats
    on_linux do
      <<~EOS
        Non-root users need a udev rule before they can talk to the light:
          sudo cp #{pkgshare}/70-beamctl.rules /etc/udev/rules.d/
          sudo udevadm control --reload && sudo udevadm trigger
        then reconnect the light. See #{homepage}#linux-access-to-the-light
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/beamctl version")
  end
end
