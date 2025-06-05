defmodule PurpleSkyAppWeb.Layouts.SwiftUI do
  use PurpleSkyAppNative, [:layout, format: :swiftui]

  embed_templates "layouts_swiftui/*"
end
