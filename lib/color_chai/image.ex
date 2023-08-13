defmodule Image do
  import Mogrify

  alias Mogrify.Image

  def temp_file(file_name, fun) do
    file_path = "#{to_string(:rand.uniform(1_000_000_000))}.png"
    fun.(file_path)

    file = %{
      name: "#{file_name}.png",
      body: File.read!(file_path)
    }

    File.rm!(file_path)
    file
  end

  def create_image(hex_code: hex_code) do
    temp_file(hex_code, fn path ->
      %Image{path: path}
      |> custom("size", "50x50")
      |> canvas("#" <> hex_code)
      |> custom("gravity", "center")
      |> create(path: ".")
    end)
  end

  def create_image(rgba: rgba) do
    matches = Regex.run(~r/(\d+)\,\s*(\d+)\,\s*(\d+)(?:\,\s*(.+))?\)/, rgba)
    destructure([_, r, g, b, a], matches)

    a = a || "1"

    temp_file(rgba, fn path ->
      %Image{path: path}
      |> custom("size", "50x50")
      |> canvas("rgba(" <> r <> "," <> g <> "," <> b <> "," <> a <> ")")
      |> custom("gravity", "center")
      |> create(path: ".")
    end)
  end

  def create_image(hsla: hsla) do
    matches = Regex.run(~r/([^,]+)\,\s*([^,]+)\,\s*([^,]+)\,?(?:\s*(.+))?\)/, hsla)
    destructure([_, h, s, l, a], matches)

    a = a || "1"

    temp_file(hsla, fn path ->
      %Image{path: path}
      |> custom("size", "50x50")
      |> canvas("hsla(" <> h <> "," <> s <> "," <> l <> "," <> a <> ")")
      |> custom("gravity", "center")
      |> create(path: ".")
    end)
  end
end
