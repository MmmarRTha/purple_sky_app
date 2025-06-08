defmodule PurpleSkyAppWeb.PostLive.PostComponentTest do
  use PurpleSkyAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import PurpleSkyApp.TimelineFixtures

  defp create_post(_) do
    post = post_fixture()
    %{post: post}
  end

  describe "Post Component" do
    setup [:create_post]

    test "renders post with correct content", %{conn: conn, post: post} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      assert view
             |> element("#post-#{post.id}")
             |> render() =~ post.body
    end

    test "displays edit and delete buttons", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      html = render(view)
      assert html =~ "Edit Post"
      assert html =~ "Delete Post"
    end

    test "handles post deletion", %{conn: conn, post: post} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      assert view
             |> element("#post-#{post.id} a", "Delete Post")
             |> render_click()

      refute has_element?(view, "#post-#{post.id}")
    end

    test "navigates to edit page", %{conn: conn, post: post} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      assert view
             |> element("#post-#{post.id} a", "Edit Post")
             |> render_click()

      assert_patch(view, ~p"/posts/#{post}/edit")
    end

    test "displays post creation time", %{conn: conn, post: post} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      assert view
             |> element("#post-#{post.id}")
             |> render() =~ "just now"
    end

    test "handles multiple posts", %{conn: conn} do
      post1 = post_fixture(%{body: "First post"})
      post2 = post_fixture(%{body: "Second post"})

      {:ok, view, _html} = live(conn, ~p"/posts")

      html = render(view)
      assert html =~ post1.body
      assert html =~ post2.body
    end
  end
end
