defmodule Alegro.Api.VideoView do
  use Alegro.Web, :view

  def render("index.json", %{videos: videos}) do
    %{
      videos: Enum.map(videos, &video_json/1)
    }
  end

  def render("show.json", %{video: video}) do
    %{
      video: video_json(video)
    }
  end

  def video_json(video) do
    %{
      id: video.id,
      title: video.title,
      inserted_at: video.inserted_at,
      updated_at: video.updated_at,
    }
  end
end
