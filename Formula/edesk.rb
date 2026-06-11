class Edesk < Formula
  desc "A gh-style command-line interface for the eDesk API"
  homepage "https://github.com/Hamelyn-SL/edesk-cli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Hamelyn-SL/edesk-cli/releases/download/v0.1.1/edesk-aarch64-apple-darwin.tar.xz"
      sha256 "0755f7705486889d7c1ec5caa53bdead77789d4a06d15bbc30fbc27501a30138"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Hamelyn-SL/edesk-cli/releases/download/v0.1.1/edesk-x86_64-apple-darwin.tar.xz"
      sha256 "fae76d8cda7b8a5b1112c1b7f60088bb75dcd4f79a58fbd35f33d83aed723f56"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":  {},
    "x86_64-apple-darwin":   {},
    "x86_64-pc-windows-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "edesk" if OS.mac? && Hardware::CPU.arm?
    bin.install "edesk" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
