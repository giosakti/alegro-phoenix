defmodule Alegro.Api.VideoControllerTest do
  use Alegro.ConnCase

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert(:user, username: username)
      conn = assign(build_conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      {:ok, conn: conn}
    end
  end

  test "#index renders a list of videos", %{conn: conn} do
    video = insert(:video)

    conn = get conn, api_video_path(conn, :index)
    assert json_response(conn, 200) == render_json(Alegro.Api.VideoView, "index.json", videos: [video])
  end

  test "#show renders a single video", %{conn: conn} do
    video = insert(:video)

    conn = get conn, api_video_path(conn, :show, video)
    assert json_response(conn, 200) == render_json(Alegro.Api.VideoView, "show.json", video: video)
  end
end
