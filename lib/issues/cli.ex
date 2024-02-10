defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handles the command line interface.
  """

  @spec run([binary()]) :: list()
  @doc """
  Main entry point for the CLI.
  """
  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @spec parse_args([binary()]) :: :help | {String.t(), String.t(), integer()}
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_tuple()
  end

  defp args_to_tuple([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  defp args_to_tuple([user, project]) do
    {user, project, @default_count}
  end

  defp args_to_tuple(_) do
    :help
  end

  defp process(:help) do
    IO.puts("""
    Usage: issues [user] [project] [count | #{@default_count}]

    Options:
      -h, --help  Show this help message and exit.
    """)

    System.halt(0)
  end

  defp process({user, project, count}) do
    Issues.Github.fetch(user, project)
    |> decode_response
    |> sort_descending_order()
    |> take_last(count)
  end

  defp decode_response({:ok, body}), do: body

  defp decode_response({:error, error}) do
    IO.puts("Error fetching from githbub #{error["message"]}")

    System.halt(2)
  end

  @spec sort_descending_order(list()) :: list()
  def sort_descending_order(issues) do
    issues
    |> Enum.sort(&(&1["created_at"] > &2["created_at"]))
  end

  @spec take_last(list(), integer()) :: list()
  def take_last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end
end
