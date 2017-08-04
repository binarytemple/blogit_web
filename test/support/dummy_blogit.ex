defmodule DummyBlogit do
  @meta %{
    "en" => [
      %Blogit.Models.Post.Meta{
        name: "post1", author: "meddle", category: "Test",
        preview: "<h1>First Bost</h1>",
        created_at: ~N[2017-05-21 08:46:50], pinned: false,
      },
      %Blogit.Models.Post.Meta{
        name: "post2", author: "slavi", preview: "<h1>Second Bost</h1>",
        created_at: ~N[2017-07-25 18:36:33], pinned: false,
      },
      %Blogit.Models.Post.Meta{
        name: "post3", author: "valo", preview: "<h1>Third Bost</h1>",
        created_at: ~N[2017-04-26 16:26:26], pinned: false,
      },
      %Blogit.Models.Post.Meta{
        name: "post4", author: "andi", preview: "<h1>Fourth Bost</h1>",
        created_at: ~N[2017-03-13 21:55:26], pinned: false,
      }
    ],
    "bg" => [
      %Blogit.Models.Post.Meta{
        name: "публикация1", category: "Test",
        preview: "<h1>Първа Бубликация</h1>",
        created_at: ~N[2017-05-21 08:46:50], pinned: false,
      },
      %Blogit.Models.Post.Meta{
        name: "публикация2",
        preview: "<h1>Втора Бубликация</h1>",
        created_at: ~N[2017-06-15 15:18:39], pinned: false,
      }
    ]
  }

  @configuration %{
    "en" => %Blogit.Models.Configuration{
      title: "My blog"
    },
    "bg" => %Blogit.Models.Configuration{
      title: "Моят блог"
    },
  }

  def list_posts(options \\ []) do
    from = Keyword.get(options, :from, 0)
    size = Keyword.get(options, :size, 5)
    language = Keyword.get(options, :language, "en")

    (@meta[language] || []) |> Enum.drop(from)|> Enum.take(size)
  end

  def configuration(options \\ []) do
    @configuration[Keyword.get(options, :language, "en")]
  end

  def post_by_name(name, options \\ []) do
    language = Keyword.get(options, :language, "en")
    post = (@meta[language] || []) |> Enum.find(&(&1.name == to_string(name)))

    if is_nil(post), do: :error, else: post
  end

  def filter_posts(params, options \\ []) do
    options |> list_posts() |> Enum.filter(fn post ->
      Enum.all?(params, fn {key, val} ->
        Map.fetch!(post, String.to_atom(key)) == val
      end)
    end)
  end
end
