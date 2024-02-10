defmodule CLITest do
  use ExUnit.Case

  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_descending_order: 1]

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

  test "sort descending order" do
    result =
      fake_created_at(["2017-01-01", "2017-01-02", "2017-01-03"])
      |> sort_descending_order()

    assert result == [
             %{"created_at" => "2017-01-03"},
             %{"created_at" => "2017-01-02"},
             %{"created_at" => "2017-01-01"}
           ]
  end

  @spec fake_created_at([list()]) :: [list()]
  defp fake_created_at(values) do
    for value <- values, do: %{"created_at" => value}
  end
end
