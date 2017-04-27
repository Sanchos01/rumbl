defmodule InfoSys.Wolfram do
  import SweetXml
  alias InfoSys.Result

  def start_link(query, query_ref, owner, limit) do
    Task.start_link(__MODULE__, :fetch, [query, query_ref, owner, limit])
  end

  defp save_resp(resp) do
    {:ok, file} = File.open "wolfram.xml", [:write]
    IO.binwrite file, "#{resp}"
    File.close file
    resp
  end

  def fetch(query_str, query_ref, owner, _limit) do
    query_str
    |> fetch_xml()
    |> save_resp()
    |> (fn x -> cond do
      x |> xpath(~x"/queryresult/@success") == 'true' ->
        x |> xpath(~x"/queryresult/pod[contains(@title, 'Result') or contains(@title, 'Definitions')]/subpod/plaintext/text()"s)
          |> case do
            "" -> nil
            resp -> send_results(resp, query_ref, owner)
          end
      true -> nil
      end
    end).()
  end

  defp send_results(nil, query_ref, owner) do
    send(owner, {:results, query_ref, []})
  end

  defp send_results(answer, query_ref, owner) do
    results = [%Result{backend: "wolfram", score: 95, text: answer}]
    send(owner, {:results, query_ref, results})
  end

  @http Application.get_env(:info_sys, :wolfram)[:http_client] || :httpc
  defp fetch_xml(query_str) do
    {:ok, {_, _, body}} = @http.request(
      String.to_char_list("http://api.wolframalpha.com/v2/query"<>
        "?appid=#{app_id()}"<>
        "&input=#{URI.encode_www_form(query_str)}&format=plaintext"))
    body
  end

  def app_id, do: Application.get_env(:info_sys, :wolfram)[:app_id]
end