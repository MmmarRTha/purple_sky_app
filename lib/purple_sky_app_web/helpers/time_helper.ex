defmodule PurpleSkyAppWeb.Helpers.TimeHelper do
  @moduledoc """
  Helper functions for time-related operations.
  """

  @doc """
  Returns a human-readable relative time string for a given datetime.
  """
  def relative_time(datetime) do
    now = DateTime.utc_now()
    diff = DateTime.diff(now, datetime, :second)

    cond do
      diff < 60 ->
        "just now"

      diff < 3600 ->
        "#{div(diff, 60)}m"

      diff < 86400 ->
        "#{div(diff, 3600)}h"

      diff < 2_592_000 ->
        "#{div(diff, 86400)}d"

      diff < 31_536_000 ->
        "#{div(diff, 2_592_000)}m"

      true ->
        "#{div(diff, 31_536_000)}y"
    end
  end
end
