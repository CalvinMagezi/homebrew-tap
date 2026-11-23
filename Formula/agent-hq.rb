class AgentHq < Formula
  desc "Local-first AI agent hub: one binary, a markdown vault, chat relays and a web UI"
  homepage "https://agent-hq.online"
  version "0.9.1-main.652"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-darwin-aarch64.tar.gz"
      sha256 "f6563e3553c4da0b7be882c7a093a6e352c597b30905fde619d245e7d6d4594a"
    end
    on_intel do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-darwin-x86_64.tar.gz"
      sha256 "cba426797c5e6177dc15aa244f131f30c2f98d9daf029f57d45b11f529f33ca9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-linux-aarch64.tar.gz"
      sha256 "e8cb54a1b0857e3303d6371e2d5c64149c198c72b451ddacd9655ddd453c1e1b"
    end
    on_intel do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-linux-x86_64.tar.gz"
      sha256 "f887aebccfc402ab0826c9a3d71306d860c74a62714ae31dac3446f3856ac8b9"
    end
  end

  conflicts_with "hq", because: "both install an `hq` binary"

  def install
    bin.install "hq"
  end

  def caveats
    <<~EOS
      Next steps:
        hq install     scaffold your vault and config
        hq env         add an LLM API key
        hq doctor      check the setup
        hq start all   daemon, API and web UI at http://localhost:5678

      The web UI is not part of this formula. The install script at
      https://agent-hq.online/install.sh installs it for you.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hq --version")
  end
end
