defmodule BlogitWeb.Repo do
  def all(Blogit.Post, limit \\ nil), do: all_posts(limit)
  def all(Blogit.Configuration, _), do: [get(Blogit.Configuration, nil)]
  def all(_, _), do: []

  def get(Blogit.Post, id), do: Blogit.post_by_name(String.to_atom(id))
  def get(Blogit.Configuration, _), do: Blogit.configuration
  def get(module, id) do
    Enum.find all(module), fn entry -> entry.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn entry ->
      Enum.all?(params, fn {key, val} -> Map.get(entry, key) == val end)
    end
  end

  def all_by(module, params, deep \\ []) do
    Enum.filter all(module), fn entry ->
      Enum.all?(params, fn {key, val} ->
        data = Enum.reduce(deep, entry, fn (current, acc) ->
          Map.fetch!(acc, current)
        end)
        Map.get(data, key) == val
      end)
    end
  end

  defp all_posts(nil), do: Blogit.list_posts |> published
  defp all_posts(n) when is_integer(n) do
    Blogit.list_posts |> published |> Enum.take(n)
  end

  defp published(posts) do
    posts |> Enum.filter(fn post -> post.meta.published end)
  end
end
