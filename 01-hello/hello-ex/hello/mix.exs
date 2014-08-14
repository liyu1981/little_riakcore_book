defmodule Hello.Mixfile do
  use Mix.Project

  def project do
    [ app: :hello,
      version: "0.0.1",
      elixir: "~> 0.12.5",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Hello, [] }]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:meck, git: "git://github.com/basho/meck.git", tag: "0.8.1", override: true},
      {:riak_core, git: "git://github.com/basho/riak_core", tag: "1.4.9"}
    ]
  end
end
