defmodule Alegro.Api.VideoView do
  use Alegro.Web, :view

  def render("video.json", %{video: video}) do
    %{
      id: video.id,
      title: video.title,
      inserted_at: video.inserted_at,
      updated_at: video.updated_at,
    }
  end

  def render("index.json", %{videos: videos}) do
    %{
      data: %{
        items: render_many(videos, Alegro.Api.VideoView, "video.json")
      }
    }
  end

  def render("show.json", %{video: video}) do
    %{
      data: render_one(video, Alegro.Api.VideoView, "video.json")
    }
  end
end
