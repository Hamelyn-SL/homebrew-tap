class Edesk < Formula
  desc "A gh-style command-line interface for the eDesk API"
  homepage "https://github.com/Hamelyn-SL/edesk-cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Hamelyn-SL/edesk-cli/releases/download/v0.2.0/edesk-aarch64-apple-darwin.tar.xz"
      sha256 "a6a75b45c189beb98ab8e29e3bc47a4d09004b3ef25e627043ff43550156c140"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Hamelyn-SL/edesk-cli/releases/download/v0.2.0/edesk-x86_64-apple-darwin.tar.xz"
      sha256 "18eda342ded77326363803edd2009195807e4e9effb36f22ba47e2d68a3e67c5"
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
