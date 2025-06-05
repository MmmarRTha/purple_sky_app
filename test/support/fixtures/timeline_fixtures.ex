defmodule PurpleSkyApp.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PurpleSkyApp.Timeline` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> PurpleSkyApp.Timeline.create_post()

    post
  end
end
