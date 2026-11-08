# Template for the Homebrew cask. The release workflow replaces 0.1.0 and 8a073ff18ad06a976cb74c4aec55cefaf3e2eb5f88551318ab0e130a27448945
# and pushes the result to the tap repository (see docs/releasing.md).
cask "cubiclings" do
  version "0.1.0"
  sha256 "8a073ff18ad06a976cb74c4aec55cefaf3e2eb5f88551318ab0e130a27448945"

  url "https://github.com/muhyal/cubiclings/releases/download/v#{version}/Cubiclings_#{version}_universal.dmg"
  name "Cubiclings"
  desc "Pixel office for your AI coding agents"
  homepage "https://cubiclings.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app updates itself; Homebrew should not fight it.
  auto_updates true
  # The app needs macOS 14.5: its styles use CSS light-dark(), which WebKit supports from
  # Safari 17.5 (macOS 14.5). Homebrew can only require a major release, so Sonoma is the floor
  # here, the app's LSMinimumSystemVersion (tauri.conf.json) enforces 14.5, and the caveat says so.
  depends_on macos: ">= :sonoma"

  app "Cubiclings.app"

  caveats <<~EOS
    Cubiclings needs macOS 14.5 or later. On macOS 14.0 to 14.4, update macOS first.
  EOS

  # Before the app goes, remove its hook entries from ~/.claude/settings.json and
  # ~/.codex/hooks.json (only lines that run Cubiclings; a backup of each changed file is kept).
  # The installed hook lives in app data; skipped when it isn't there.
  uninstall_preflight do
    hook = File.expand_path("~/Library/Application Support/com.cubiclings.desktop/bin/cubiclings-hook")
    system_command hook, args: ["--uninstall-hooks"], must_succeed: false if File.executable?(hook)
  end

  zap trash: [
    "~/Library/Application Support/com.cubiclings.desktop",
    "~/Library/Caches/com.cubiclings.desktop",
    "~/Library/Preferences/com.cubiclings.desktop.plist",
    "~/Library/Saved Application State/com.cubiclings.desktop.savedState",
    "~/Library/WebKit/com.cubiclings.desktop",
  ]
end
