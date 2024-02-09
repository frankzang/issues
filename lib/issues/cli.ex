defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handles the command line interface.
  """

  @spec run([binary()]) :: :help
  @doc """
  Main entry point for the CLI.
  """
  def run(argv) do
    parse_args(argv)
  end

  @spec parse_args([binary()]) :: :help | {binary(), binary(), integer()}
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
end
