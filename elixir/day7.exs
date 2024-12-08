import ExUnit.Assertions
Code.require_file("utils.exs")

defmodule Day7 do
  def find_all_options([], curr, result, _) do
    if(curr == result) do
      [true]
    else
      [false]
    end
  end

  def find_all_options([hd | tl], curr, result, doconcat) do
    sumprod =
      find_all_options(tl, curr + hd, result, doconcat) ++
        find_all_options(tl, curr * hd, result, doconcat)

    if doconcat do
      next = String.to_integer(inspect(curr) <> inspect(hd))
      sumprod ++ find_all_options(tl, next, result, doconcat)
    else
      sumprod
    end
  end

  def is_solvable(line, doconcat) do
    [result, sum] =
      line
      |> String.split(":")

    result = String.to_integer(result)

    [hd | tl] =
      sum
      |> String.split()
      |> Enum.map(fn c -> String.to_integer(c) end)

    if find_all_options(tl, hd, result, doconcat)
       |> Enum.any?() do
      result
    else
      0
    end
  end

  def solve1(lines) do
    lines
    |> Enum.map(fn l -> Day7.is_solvable(l, false) end)
    |> Enum.sum()
  end

  def solve2(lines) do
    lines
    |> Enum.map(fn l -> Day7.is_solvable(l, true) end)
    |> Enum.sum()
  end
end

testinput = [
  "190: 10 19",
  "3267: 81 40 27",
  "83: 17 5",
  "156: 15 6",
  "7290: 6 8 6 15",
  "161011: 16 10 13",
  "192: 17 8 14",
  "21037: 9 7 18 13",
  "292: 11 6 16 20"
]

IO.puts("Testing examples pt 1")

assert(
  2 =
    Day7.find_all_options([1, 2], 0, 2, false)
    |> Enum.count(& &1)
)

assert(
  1 =
    Day7.find_all_options([2], 1, 2, false)
    |> Enum.count(& &1)
)

assert(3749 = Day7.solve1(testinput))

IO.puts("Ok")

input = Utils.read_lines("day7.in")
result = Day7.solve1(input)
IO.puts("Result pt1: #{result}")

IO.puts("Testing examples pt 2")

assert(11387 = Day7.solve2(testinput))

IO.puts("Ok")

input = Utils.read_lines("day7.in")
result = Day7.solve2(input)
IO.puts("Result pt1: #{result}")
