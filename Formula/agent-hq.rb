class AgentHq < Formula
  desc "Local-first AI agent hub: one binary, a markdown vault, chat relays and a web UI"
  homepage "https://agent-hq.online"
  version "0.9.1-main.467"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-darwin-aarch64.tar.gz"
      sha256 "9e045e667268f6584877fdea722601ba2bfb3b345c1a8b3d60db8b3df2c3dccd"
    end
    on_intel do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-darwin-x86_64.tar.gz"
      sha256 "b8cf7c6248a4bc367e4efa78b510a0a7b1341761b5ddcb0938946ff59806c5e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-linux-aarch64.tar.gz"
      sha256 "835069d43bb021503d0ca65f2eda26848282fde42b3521512a19f887010c2483"
    end
    on_intel do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-linux-x86_64.tar.gz"
      sha256 "2d5d082a80f137180e1c231f476507efa947754566f260b339ff46e8f58265ab"
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
