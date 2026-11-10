class AgentHq < Formula
  desc "Local-first AI agent hub: one binary, a markdown vault, chat relays and a web UI"
  homepage "https://agent-hq.online"
  version "0.9.1-main.419"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-darwin-aarch64.tar.gz"
      sha256 "8bc2344c0cb20c0753d47dbfe53e4a30bd83837fcff44c4c7fe1dff60901cbc4"
    end
    on_intel do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-darwin-x86_64.tar.gz"
      sha256 "b23b42877adaad1776c2d54c3630557348456c16500077469360457c6f01bd9a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-linux-aarch64.tar.gz"
      sha256 "105d82ffd1fdfb4d04638b546c24e877f4658053cb32315ed2f05da3391582c4"
    end
    on_intel do
      url "https://github.com/CalvinMagezi/hq/releases/download/v#{version}/hq-#{version}-linux-x86_64.tar.gz"
      sha256 "314b37070001daeef7e2b4a8ad74dc37745725e6625d2b4c06604537aa4d4d9b"
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
