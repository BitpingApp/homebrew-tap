class Bping < Formula
  desc "A command line utility to ping a website from anywhere in the world!"
  homepage "https://bitping.com"
  version "2.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/bping/releases/download/2.1.0/bping-aarch64-apple-darwin.tar.xz"
      sha256 "2cb2bf859887dc40d0456b261533fe5da20a466755af765896b1107289e2acb0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/bping/releases/download/2.1.0/bping-x86_64-apple-darwin.tar.xz"
      sha256 "c2b81f36770fb9506929ee24c9db6ef43f43629fecdc118976478f1ee0f184d1"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/BitpingApp/bping/releases/download/2.1.0/bping-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "faeab5deae1809411827d155001ff3137009c2dbba5db827e11258487cee1a01"
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
