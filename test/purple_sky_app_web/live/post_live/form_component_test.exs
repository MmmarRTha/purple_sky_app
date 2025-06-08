defmodule PurpleSkyAppWeb.PostLive.FormComponentTest do
  use PurpleSkyAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import PurpleSkyApp.TimelineFixtures

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  describe "Form Component" do
    test "renders form with empty post for new post", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts/new")

      assert view
             |> element("form")
             |> render() =~ "Save Post"
    end

    test "renders form with existing post for edit", %{conn: conn} do
      post = post_fixture()
      {:ok, view, _html} = live(conn, ~p"/posts/#{post}/edit")

      assert view
             |> element("form")
             |> render() =~ "Save Post"

      assert view
             |> element("form")
             |> render() =~ post.body
    end

    test "validates required fields", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts/new")

      assert view
             |> form("#post-form", post: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"
    end

    test "creates post with valid data", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts/new")

      assert view
             |> form("#post-form", post: @create_attrs)
             |> render_submit()

      assert_patch(view, ~p"/posts")
      assert render(view) =~ "Post created successfully"
      assert render(view) =~ "some body"
    end

    test "updates post with valid data", %{conn: conn} do
      post = post_fixture()
      {:ok, view, _html} = live(conn, ~p"/posts/#{post}/edit")

      assert view
             |> form("#post-form", post: @update_attrs)
             |> render_submit()

      assert_patch(view, ~p"/posts")
      assert render(view) =~ "Post updated successfully"
      assert render(view) =~ "some updated body"
    end

    test "handles concurrent updates", %{conn: conn} do
      post = post_fixture()
      {:ok, view1, _html} = live(conn, ~p"/posts/#{post}/edit")
      {:ok, view2, _html} = live(conn, ~p"/posts/#{post}/edit")

      assert view1
             |> form("#post-form", post: @update_attrs)
             |> render_submit()

      assert view2
             |> form("#post-form", post: %{body: "conflicting update"})
             |> render_submit()

      assert_patch(view2, ~p"/posts")
      assert render(view2) =~ "Post updated successfully"
    end
  end
end
