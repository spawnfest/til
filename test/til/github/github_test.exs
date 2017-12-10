defmodule TilWeb.GithubTest do
  use ExUnit.Case

  describe "parse_front_matter" do
    import Til.Github

    setup do
      contents =
        Path.relative_to_cwd("lib/templates/hello_world.md")
        |> File.read!()

      {:ok, contents: contents}
    end

    test "parses front matter", %{contents: contents} do
      {title, tags, body} = parse_front_matter(contents)
      assert title == "Hello, World!"
      assert tags == ["hello-world", "tilhub"]

      assert body =~ "This is the beginning of an awesome new habit for me!"
    end
  end
end
