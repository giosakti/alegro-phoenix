defmodule Alegro.Api.VideoViewTest do
  use Alegro.ConnCase, async: true

  test "video_json" do
    video = %Alegro.Video{id: "1", title: "dogs"}
    content = Alegro.Api.VideoView.video_json(video)
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
      |> Enum.map(&Alegro.Api.VideoView.video_json/1)
    content = Alegro.Api.VideoView.render("index.json", %{videos: videos})
    assert content == %{
      videos: videos
    }
  end

  test "show.json" do
    video =
      %Alegro.Video{id: "1", title: "dogs"}
      |> Alegro.Api.VideoView.video_json
    content = Alegro.Api.VideoView.render("show.json", %{video: video})
    assert content == %{
      video: video
    }
  end
end
