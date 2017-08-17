defmodule Alegro.Api.VideoViewTest do
  use Alegro.ConnCase, async: true
  import Phoenix.View

  test "video.json" do
    video = %Alegro.Video{id: "1", title: "dogs"}
    content = Alegro.Api.VideoView.render("video.json", %{video: video})
    assert content == %{
      id: video.id,
      title: video.title,
      inserted_at: video.inserted_at,
      updated_at: video.updated_at,
    }
  end

  test "index.json" do
    videos =
      [%Alegro.Video{id: "1", title: "dogs"},
       %Alegro.Video{id: "2", title: "cats"}]
      |> render_many(Alegro.Api.VideoView, "video.json")
    content = Alegro.Api.VideoView.render("index.json", %{videos: videos})
    assert content == %{
      data: %{
        items: videos
      }
    }
  end

  test "show.json" do
    video =
      %Alegro.Video{id: "1", title: "dogs"}
      |> render_one(Alegro.Api.VideoView, "video.json")
    content = Alegro.Api.VideoView.render("show.json", %{video: video})
    assert content == %{
      data: video
    }
  end
end
