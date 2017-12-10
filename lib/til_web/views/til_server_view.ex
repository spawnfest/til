defmodule TilWeb.Views.TilServerView do
  use TilWeb, :view

  defp markdown_to_html(body) do
    {:ok, html, []} =
      Earmark.as_html(body, %Earmark.Options{
        gfm: true,
        breaks: false
      })

    {:safe, html}
  end
end
