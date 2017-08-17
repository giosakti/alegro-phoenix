defmodule Alegro.Api.VideoControllerTest do
  use Alegro.ConnCase

  @valid_attrs %{url: "http://youtu.be", title: "vid", description: "a vid"}
  @invalid_attrs %{title: ""}

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert(:user, username: username)
      conn = assign(build_conn(), :current_user, user)
      {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user}
    else
      {:ok, conn: put_req_header(conn, "accept", "application/json"), user: %Alegro.User{}}
    end
  end

  test "#index renders a list of videos", %{conn: conn, user: _user} do
    video = insert(:video)

    conn = get conn, api_video_path(conn, :index)
    assert json_response(conn, 200) == render_json(Alegro.Api.VideoView, "index.json", videos: [video])
  end

  describe "#create video" do
    test "renders video when data is valid", %{conn: conn, user: _user} do
      conn = post conn, api_video_path(conn, :create), video: @valid_attrs
      assert %{
        "id" => id,
        "inserted_at" => inserted_at,
        "updated_at" => updated_at,
      } = json_response(conn, 201)["data"]

      conn = get conn, api_video_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "title" => "vid",
        "inserted_at" => inserted_at,
        "updated_at" => updated_at,
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_video_path(conn, :create), video: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  test "#show renders a single video", %{conn: conn, user: _user} do
    video = insert(:video)

    conn = get conn, api_video_path(conn, :show, video)
    assert json_response(conn, 200) == render_json(Alegro.Api.VideoView, "show.json", video: video)
  end

  describe "update video" do
    setup [:create_video]

    test "renders video when data is valid", %{conn: conn, video: %Alegro.Video{id: id} = video} do
      conn = put conn, api_video_path(conn, :update, video), video: @valid_attrs
      assert %{
        "id" => ^id,
        "inserted_at" => inserted_at,
        "updated_at" => updated_at,
      } = json_response(conn, 200)["data"]

      conn = get conn, api_video_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "title" => "vid",
        "inserted_at" => inserted_at,
        "updated_at" => updated_at,
      }
    end

    test "renders errors when data is invalid", %{conn: conn, video: video} do
      conn = put conn, api_video_path(conn, :update, video), video: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  test "#delete delete existing video", %{conn: conn, user: _user} do
    video = insert(:video)

    conn = delete conn, api_video_path(conn, :delete, video)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, api_video_path(conn, :show, video)
    end
  end

  defp create_video(_) do
    video = insert(:video)
    {:ok, video: video}
  end
end
