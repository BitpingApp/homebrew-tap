class DistributedMetrics < Formula
  desc "A monitoring tool backed by Bitping's distributed network, exposed as a Prometheus metrics endpoint"
  homepage "https://bitping.com"
  version "1.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.2.3/distributed-metrics-aarch64-apple-darwin.tar.xz"
      sha256 "7709e57fd07603e1275092ff6e3bf57eb7d550ba8f44630575ced5528447f955"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.2.3/distributed-metrics-x86_64-apple-darwin.tar.xz"
      sha256 "360bc3487c16f57f3439f2ec82d7e8a5a19a1c03d4d5c54a0b6e1c83d4657a10"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.2.3/distributed-metrics-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6acbc1c7d656f0a699bba6a4786936c2745e97f53d4cf30640e05ea8f3963d03"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.2.3/distributed-metrics-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d577fbd695b3294bfe192d7fe23f01cfc0f0d361fe84e355f6a7a9dc48a778e7"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
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
    bin.install "distributed-metrics" if OS.mac? && Hardware::CPU.arm?
    bin.install "distributed-metrics" if OS.mac? && Hardware::CPU.intel?
    bin.install "distributed-metrics" if OS.linux? && Hardware::CPU.arm?
    bin.install "distributed-metrics" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
