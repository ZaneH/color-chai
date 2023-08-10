defmodule Image do
  import Mogrify

  alias Mogrify.Image

  def create_image(hex_code: hex_code) do
    file_path = "#{to_string(:rand.uniform(1_000_000_000))}.png"

    %Image{path: file_path}
    |> custom("size", "50x50")
    |> canvas("#" <> hex_code)
    |> custom("gravity", "center")
    |> create(path: ".")

    file = %{
      name: hex_code <> ".png",
      body: File.read!(file_path)
    }

    File.rm!(file_path)

    file
  end

  def create_image(rgb: rgb) do
    file_path = "#{to_string(:rand.uniform(1_000_000_000))}.png"
    matches = Regex.run(~r/(\d+)\,\s*(\d+)\,\s*(\d+)/, rgb)
    destructure([_, r, g, b], matches)

    %Image{path: file_path}
    |> custom("size", "50x50")
    |> canvas("rgb(" <> r <> "," <> g <> "," <> b <> ")")
    |> custom("gravity", "center")
    |> create(path: ".")

    file = %{
      name: rgb <> ".png",
      body: File.read!(file_path)
    }

    File.rm!(file_path)

    file
  end

  def create_image(rgba: rgba) do
    file_path = "#{to_string(:rand.uniform(1_000_000_000))}.png"
    matches = Regex.run(~r/(\d+)\,\s*(\d+)\,\s*(\d+),\s*(.+)\)/, rgba)
    destructure([_, r, g, b, a], matches)

    %Image{path: file_path}
    |> custom("size", "50x50")
    |> canvas("rgba(" <> r <> "," <> g <> "," <> b <> "," <> a <> ")")
    |> custom("gravity", "center")
    |> create(path: ".")

    file = %{
      name: rgba <> ".png",
      body: File.read!(file_path)
    }

    File.rm!(file_path)

    file
  end
end
