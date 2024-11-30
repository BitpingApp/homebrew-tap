class DnsMetricCollector < Formula
  desc "A monitoring tool backed by Bitping's distributed network, exposed as a Prometheus metrics endpoint"
  homepage "https://bitping.com"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/0.1.0/dns-metric-collector-aarch64-apple-darwin.tar.xz"
      sha256 "d22f7f908819c738c5b582c00041bfbee6491e5c25bcf9b14a460d093de281ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/0.1.0/dns-metric-collector-x86_64-apple-darwin.tar.xz"
      sha256 "fada6c9cc18a1ea90a58869d944c43e00557df2e0bb12dc846fe36f7b672af37"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/BitpingApp/distributed-metrics/releases/download/0.1.0/dns-metric-collector-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "42084ee83656c2edcbb35678232689322bee58d513a0ce17e376f31b9c43255c"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
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
