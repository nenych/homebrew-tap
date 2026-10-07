class Chcli < Formula
  desc "Interactive ClickHouse client with autocomplete, profiles and OAuth/OIDC login"
  homepage "https://github.com/nenych/chcli"
  url "https://github.com/nenych/chcli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b295469668ba3becf7c41934e91ff4a902eb2403731c875283346cc4a3b27c0d"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/chcli"
    doc.install "THIRD_PARTY_NOTICES.md"
    generate_completions_from_executable(bin/"chcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chcli version")
    # No server is involved: resolving a configuration exercises most of the code.
    assert_match "type: password", shell_output("#{bin}/chcli config show --host localhost")
  end
end
