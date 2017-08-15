defmodule Alegro.Api.VideoController do
  use Alegro.Web, :controller
  alias Alegro.Video

  def index(conn, _params) do
    videos = Repo.all(Video)
    render conn, "index.json", videos: videos
  end

  def show(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    render(conn, "show.json", video: video)
  end
end
