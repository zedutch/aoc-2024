defmodule Utils do
  def read_string(f) do
    case File.read(f) do
      {:error, msg} ->
        IO.puts("ERROR reading file '#{f}': #{msg}")
        exit(msg)

      {:ok, contents} ->
        contents
        |> String.trim_trailing()
    end
  end

  def read_lines(f) do
    f
    |> read_stream()
    |> Enum.to_list()
  end

  def read_stream(f) do
    File.stream!(f)
    |> Stream.map(&String.trim_trailing/1)
  end
end
