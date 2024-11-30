class Bping < Formula
  desc "A command line utility to ping a website from anywhere in the world!"
  homepage "https://bitping.com"
  version "2.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/bping/releases/download/2.0.5/bping-aarch64-apple-darwin.tar.xz"
      sha256 "a58862eb5157f307ee83519520427245de49c38ba02e961b021ae44c111109a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/bping/releases/download/2.0.5/bping-x86_64-apple-darwin.tar.xz"
      sha256 "916963d6fc0c428b3061b70bf473d80209c834955c7c4d23fecc5cefeca0a7a2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/BitpingApp/bping/releases/download/2.0.5/bping-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f7ad962b8d50738a6fc63316f8ddfe54e0ed65c97787362fa371df8959dca6ff"
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
