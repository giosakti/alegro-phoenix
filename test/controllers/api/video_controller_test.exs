defmodule Alegro.Api.VideoControllerTest do
  use Alegro.ConnCase

  @valid_attrs %{url: "http://youtu.be", title: "vid", description: "a vid"}
  @invalid_attrs %{title: ""}

  setup %{conn: _conn} = config do
    if username = config[:login_as] do
      user = insert(:user, username: username)
      {:ok, jwt, claims} = Guardian.encode_and_sign(user)
      {:ok, %{user: user, jwt: jwt, claims: claims}}
    else
      {:ok, %{user: %Alegro.User{}}}
    end
  end

  @tag login_as: "max"
  test "#index renders a list of videos", %{conn: conn, user: _user, jwt: jwt} do
    video = insert(:video)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get(api_video_path(conn, :index))
    assert json_response(conn, 200) == render_json(Alegro.Api.VideoView, "index.json", videos: [video])
  end

  describe "#create video" do

    @tag login_as: "max"
    test "renders video when data is valid", %{conn: conn, user: _user, jwt: jwt} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post(api_video_path(conn, :create), video: @valid_attrs)
      assert %{
        "id" => id,
        "inserted_at" => inserted_at,
        "updated_at" => updated_at,
      } = json_response(conn, 201)["data"]

      new_conn = build_conn()
      new_conn = new_conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(api_video_path(new_conn, :show, id))
      assert json_response(new_conn, 200)["data"] == %{
        "id" => id,
        "title" => "vid",
        "inserted_at" => inserted_at,
        "updated_at" => updated_at,
      }
    end

    @tag login_as: "max"
    test "renders errors when data is invalid", %{conn: conn, user: _user, jwt: jwt} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post(api_video_path(conn, :create), video: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  @tag login_as: "max"
  test "#show renders a single video", %{conn: conn, user: _user, jwt: jwt} do
    video = insert(:video)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get(api_video_path(conn, :show, video))
    assert json_response(conn, 200) == render_json(Alegro.Api.VideoView, "show.json", video: video)
  end

  describe "update video" do
    setup [:create_video]

    @tag login_as: "max"
    test "renders video when data is valid", %{conn: conn, jwt: jwt, video: %Alegro.Video{id: id} = video} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put(api_video_path(conn, :update, video), video: @valid_attrs)
      assert %{
        "id" => ^id,
        "inserted_at" => inserted_at,
        "updated_at" => updated_at,
      } = json_response(conn, 200)["data"]

      new_conn = build_conn()
      new_conn = new_conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(api_video_path(new_conn, :show, id))
      assert json_response(new_conn, 200)["data"] == %{
        "id" => id,
        "title" => "vid",
        "inserted_at" => inserted_at,
        "updated_at" => updated_at,
      }
    end

    @tag login_as: "max"
    test "renders errors when data is invalid", %{conn: conn, jwt: jwt, video: video} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put(api_video_path(conn, :update, video), video: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  @tag login_as: "max"
  test "#delete delete existing video", %{conn: conn, user: _user, jwt: jwt} do
    video = insert(:video)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete(api_video_path(conn, :delete, video))
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      new_conn = build_conn()
      new_conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(api_video_path(new_conn, :show, video))
    end
  end

  defp create_video(_) do
    video = insert(:video)
    {:ok, video: video}
  end
end
