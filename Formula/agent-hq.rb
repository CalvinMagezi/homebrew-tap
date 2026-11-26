class AgentHq < Formula
  desc "Local-first AI agent hub: one binary, a markdown vault, chat relays and a web UI"
  homepage "https://agent-hq.online"
  version "0.9.1-main.659"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-darwin-aarch64.tar.gz"
      sha256 "f04f0f883ee92d896201ea55345a1263fe03637a7da81eaf6eed2b10a052b087"
    end
    on_intel do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-darwin-x86_64.tar.gz"
      sha256 "1ef61a3eb6e3a05ac23235a26b0097eb5a86999285d12942a1f3e59c6d8ccd27"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-linux-aarch64.tar.gz"
      sha256 "3dc2c57bf691d41f20cfcc25d255da256c422129df017c7ec384cab05c95b74e"
    end
    on_intel do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-linux-x86_64.tar.gz"
      sha256 "f33e59b131d1a5eb146665bf8cb1d838bd8142cacda588b6d08cb6d783aec7b2"
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
