class DistributedMetrics < Formula
  desc "A monitoring tool backed by Bitping's distributed network, exposed as a Prometheus metrics endpoint"
  homepage "https://bitping.com"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.2.1/distributed-metrics-aarch64-apple-darwin.tar.xz"
      sha256 "d5ea62e5061cc96ccabc5c43bc550292c40b9fe13e408efd67cc4b1491e179db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.2.1/distributed-metrics-x86_64-apple-darwin.tar.xz"
      sha256 "d67e171c9c01408a5d90d7e0d767af040e71491d06c0ffc0f3204a6de21f53b1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.2.1/distributed-metrics-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cd1cdead59234df40b81d01818a3156750c01539a4a7903ea479d4bcc086b16d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.2.1/distributed-metrics-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "75ef1081cb55ab9ac6f6c1ff59ce28fce6182d8702d7e3eb47ad34a08245333e"
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
