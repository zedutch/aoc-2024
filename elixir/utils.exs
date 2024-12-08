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

  def pairwise_unique(list) do
    for x <- list do
      for y <- Enum.take(list, -(length(list) - 1)) do
        {x, y}
      end
    end
    |> List.flatten()
    |> Enum.filter(fn {p1, p2} -> p1 != p2 end)
    |> Enum.map(fn {p1, p2} ->
      [q1, q2] = Enum.sort([p1, p2])
      {q1, q2}
    end)
    |> Enum.uniq()
  end
end
