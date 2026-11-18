class AgentHq < Formula
  desc "Local-first AI agent hub: one binary, a markdown vault, chat relays and a web UI"
  homepage "https://agent-hq.online"
  version "0.9.1-main.519"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-darwin-aarch64.tar.gz"
      sha256 "b765d96d280e81dc09917ced455969db550b174a2da09b8ddd4f99b3066f4641"
    end
    on_intel do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-darwin-x86_64.tar.gz"
      sha256 "cbd9fbe633ef212882373ebeef9c159e6b12479b8d7ef86d5ed9409a2c7b5ffa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-linux-aarch64.tar.gz"
      sha256 "70971eecba4460c8288ab185054496808114e95759c21125163bfb4257620b1c"
    end
    on_intel do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-linux-x86_64.tar.gz"
      sha256 "5f73009a2f4a34f7d0efc84c5507a921115e5993f68bab7e7f30209cb3efab86"
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
