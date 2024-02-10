defmodule Issues.Github do
  @user_agent [{"User-Agent", "Elixir fsantos.fs37@gmail.com"}]

  @spec fetch(any(), any()) :: {:error, any()} | {:ok, any()}
  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  defp issues_url(user, project) do
    "#{Application.fetch_env!(:issues, :github_url)}/repos/#{user}/#{project}/issues"
  end

  defp handle_response({:ok, %{status_code: status_code, body: body}}) do
    {
      status_code
      |> check_response_status,
      body
      |> Poison.Parser.parse!()
    }
  end

  defp check_response_status(200), do: :ok

  defp check_response_status(_), do: :error
end
