defmodule CLITest do
  use ExUnit.Case

  doctest Issues

  import Issues.CLI, only: [parse_args: 1]

  test ":help is returned when -h or --help is passed" do
    assert parse_args(["--help"]) == :help
    assert parse_args(["-h"]) == :help
  end

  test "three values returned if three values given" do
    assert parse_args(["user", "project", "5"]) == {"user", "project", 5}
  end

  test "default count is used if only two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
end
