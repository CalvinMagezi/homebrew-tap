# Homebrew tap for Agent HQ

```bash
brew install CalvinMagezi/tap/agent-hq
```

Installs the `hq` binary from the signed stable release of [Agent HQ](https://github.com/CalvinMagezi/hq)
(macOS on Apple Silicon, Linux x86_64 and ARM). The formula is regenerated every six hours from the
release manifest, and its hashes are written only after the manifest's minisign signature verifies against the project key.

The web UI is not part of the formula; `curl -fsSL https://agent-hq.online/install.sh | bash` installs both.
Upgrade with `brew upgrade agent-hq`. `hq` also exists as a separate Homebrew formula; the two conflict.
