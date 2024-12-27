class DnsMetricCollector < Formula
  desc "A monitoring tool backed by Bitping's distributed network, exposed as a Prometheus metrics endpoint"
  homepage "https://bitping.com"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.0/dns-metric-collector-aarch64-apple-darwin.tar.xz"
      sha256 "5d28110fc5a687a76fc62c15d7b52bf6b710e1f5598f7335d26996d2f87405e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.0/dns-metric-collector-x86_64-apple-darwin.tar.xz"
      sha256 "35b51cee31ea14e2d806053e9a997b37fdbdf08a1af06a49d4c068a35474a40d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.0/dns-metric-collector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "224bece9efdf7ac8ba75fed3a832d386aac9fbd0dbaf17a4f0fd84b3e78ce8dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.0/dns-metric-collector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84c728d129f78e79cfdb28f1e1c7911605c8e3cfbd32d5319d4cebfa364c2538"
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
    bin.install "dns-metric-collector" if OS.mac? && Hardware::CPU.arm?
    bin.install "dns-metric-collector" if OS.mac? && Hardware::CPU.intel?
    bin.install "dns-metric-collector" if OS.linux? && Hardware::CPU.arm?
    bin.install "dns-metric-collector" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
