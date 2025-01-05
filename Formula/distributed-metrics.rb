class DistributedMetrics < Formula
  desc "A monitoring tool backed by Bitping's distributed network, exposed as a Prometheus metrics endpoint"
  homepage "https://bitping.com"
  version "1.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.8/distributed-metrics-aarch64-apple-darwin.tar.xz"
      sha256 "331b41d6d29594da3bb72b1e3c81334e9cdd44970d0c409937efb1e185b91147"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.8/distributed-metrics-x86_64-apple-darwin.tar.xz"
      sha256 "94dfdc6a305ef7b8c50c1822f505ce07502990048222a167505b2cb284f53689"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.8/distributed-metrics-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d8ab2add3a6b3bf04a3b65e6abcf68c8646732e9f81ec6a715227d3836865900"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.8/distributed-metrics-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "675e5a4c81933aeb7fd9eda09247815401b53f3001e5d7058d490684c400bf1c"
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
