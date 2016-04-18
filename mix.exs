defmodule PublicSuffix.Mixfile do
  use Mix.Project

  def project do
    [app: :public_suffix,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :idna,
        :logger,
      ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "1.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:idna, "~> 1.2"},
    ]
  end
end

defmodule Mix.Tasks.PublicSuffix.SyncFiles do
  use Mix.Task

  @shortdoc "Syncs the files from publicsuffix.org"
  @data_dir Path.expand("data", __DIR__)

  def run(_) do
    File.mkdir_p!(@data_dir)
    sync_file "https://publicsuffix.org/list/public_suffix_list.dat", "public_suffix_list.dat"
    sync_file "https://raw.githubusercontent.com/publicsuffix/list/master/tests/test_psl.txt", "tests.txt"
  end

  defp sync_file(remote_url, local_path) do
    local_path = Path.join(@data_dir, local_path)

    [
      "curl",
      "-s",
      remote_url,
      "--output",
      local_path,
    ]
    |> Enum.join(" ")
    |> Mix.shell.cmd

    IO.puts "Synced #{remote_url} to #{local_path}"
  end
end