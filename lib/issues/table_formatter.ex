defmodule Issues.TableFormatter do
  @spec print_table(list(), list()) :: :ok
  def print_table(rows, headers) do
    columns = split_into_columns(rows, headers)
    result = TableRex.quick_render!(columns, headers)

    IO.puts(result)
  end

  @spec split_into_columns(list(), list()) :: list()
  def split_into_columns(rows, headers) do
    for row <- rows do
      for header <- headers do
        Map.get(row, header, "")
        |> to_string()
        |> truncate(60)
      end
    end
  end

  @spec truncate(binary(), any()) :: binary()
  def truncate(string, length) do
    if String.length(string) > length do
      String.slice(string, 0..(length - 4)) <> "..."
    else
      string
    end
  end
end
