class Bping < Formula
  desc "The bping application"
  homepage "https://github.com/BitpingApp/bping"
  version "2.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/bping/releases/download/2.0.4/bping-aarch64-apple-darwin.tar.xz"
      sha256 "c11f9bdc8d2e2e8f4ceaddac0f9a1079e37bb4c9015dbbd2338ad513c6debd61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/bping/releases/download/2.0.4/bping-x86_64-apple-darwin.tar.xz"
      sha256 "0ee7397c563e52b4876854310b0ce0535b9eeab9bfc188f73bb6bd09dd16d046"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/BitpingApp/bping/releases/download/2.0.4/bping-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0f7cbcefa531af95e0f2438565ca2eeba61ce7ae2fb3e50dd7bdba9566feae34"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "bping" if OS.mac? && Hardware::CPU.arm?
    bin.install "bping" if OS.mac? && Hardware::CPU.intel?
    bin.install "bping" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
