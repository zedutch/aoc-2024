import ExUnit.Assertions
Code.require_file("utils.exs")

defmodule Day1 do
  def solve1(input) do
    comb =
      input
      |> Stream.map(fn l -> String.split(l, "   ") end)

    l1 =
      comb
      |> Stream.map(fn [a, _] -> String.to_integer(a) end)
      |> Enum.sort()

    l2 =
      comb
      |> Stream.map(fn [_, b] -> String.to_integer(b) end)
      |> Enum.sort()

    Stream.zip(l1, l2)
    |> Stream.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def solve2(input) do
    frequencies =
      input
      |> Stream.map(fn l -> String.split(l, "   ") end)
      |> Stream.map(fn [_, b] -> String.to_integer(b) end)
      |> Enum.reduce(%{}, fn x, acc ->
        Map.update(acc, x, 1, &(&1 + 1))
      end)

    input
    |> Stream.map(fn l -> String.split(l, "   ") end)
    |> Stream.map(fn [a, _] -> String.to_integer(a) end)
    |> Stream.map(fn x -> x * Map.get(frequencies, x, 0) end)
    |> Enum.sum()
  end
end

IO.puts("Testing examples pt 1")

assert(
  11 =
    Day1.solve1([
      "3   4",
      "4   3",
      "2   5",
      "1   3",
      "3   9",
      "3   3"
    ])
)

IO.puts("Ok")

input = Utils.read_stream("day1.in")
result = Day1.solve1(input)
IO.puts("Result pt1: #{result}")

IO.puts("Testing examples pt2")

assert(
  31 =
    Day1.solve2([
      "3   4",
      "4   3",
      "2   5",
      "1   3",
      "3   9",
      "3   3"
    ])
)

IO.puts("Ok")

input = Utils.read_stream("day1.in")
result = Day1.solve2(input)
IO.puts("Result pt2: #{result}")
