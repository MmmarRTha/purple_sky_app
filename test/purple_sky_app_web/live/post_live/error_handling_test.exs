defmodule PurpleSkyAppWeb.PostLive.ErrorHandlingTest do
  use PurpleSkyAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import PurpleSkyApp.TimelineFixtures

  @invalid_attrs %{body: nil}

  describe "Error Handling" do
    test "handles invalid post creation", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts/new")

      assert view
             |> form("#post-form", post: @invalid_attrs)
             |> render_submit()

      assert render(view) =~ "can&#39;t be blank"
    end

    test "handles invalid post update", %{conn: conn} do
      post = post_fixture()
      {:ok, view, _html} = live(conn, ~p"/posts/#{post}/edit")

      assert view
             |> form("#post-form", post: @invalid_attrs)
             |> render_submit()

      assert render(view) =~ "can&#39;t be blank"
    end

    test "handles non-existent post", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        live(conn, ~p"/posts/999999/edit")
      end
    end

    test "handles concurrent deletion", %{conn: conn} do
      post = post_fixture()
      {:ok, view1, _html} = live(conn, ~p"/posts")
      {:ok, view2, _html} = live(conn, ~p"/posts")

      # Wait for post to be rendered
      assert render(view1) =~ post.body
      assert render(view2) =~ post.body

      # Directly trigger the delete event from the first view
      assert view1 |> render_click("delete", %{id: post.id})

      # Verify first deletion succeeds
      refute has_element?(view1, "#post-#{post.id}")

      # Try deletion from second view (should fail gracefully)
      assert view2 |> render_click("delete", %{id: post.id})

      # Verify post is removed from both views
      refute has_element?(view1, "#post-#{post.id}")
      refute has_element?(view2, "#post-#{post.id}")
    end
  end

  describe "Real-time Updates" do
    test "updates post list in real-time", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      post = post_fixture()

      assert render(view) =~ post.body
    end

    test "handles real-time post updates", %{conn: conn} do
      post = post_fixture()
      {:ok, view1, _html} = live(conn, ~p"/posts")
      {:ok, view2, _html} = live(conn, ~p"/posts")

      assert view1
             |> element("#post-#{post.id} a", "Update Post")
             |> render_click()

      assert view1
             |> form("#post-form", post: %{body: "Updated in real-time"})
             |> render_submit()

      assert render(view2) =~ "Updated in real-time"
    end
  end
end
