class DistributedMetrics < Formula
  desc "A monitoring tool backed by Bitping's distributed network, exposed as a Prometheus metrics endpoint"
  homepage "https://bitping.com"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.2/distributed-metrics-aarch64-apple-darwin.tar.xz"
      sha256 "1557ed1f40e9867ecea39a9c052820b9caebf7bf5daed520c87b81ac28a18692"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.2/distributed-metrics-x86_64-apple-darwin.tar.xz"
      sha256 "d8b6f529523756bd312e1b503efa85cbf7d8278736802183bb9061b2ffd4febc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.2/distributed-metrics-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ab8a38cbb88d6df541ca46be25fb98a343bb5db6b5ac7e76254fe0c497cb1c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.2/distributed-metrics-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "59dbb21071e583f2f1575076bb71d4e12b0d1e71000b333bed078aeccb2cd547"
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
