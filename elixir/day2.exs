import ExUnit.Assertions
Code.require_file("utils.exs")

defmodule Day2 do
  def check_values(prev, curr) do
    abs(prev - curr) > 0 && abs(prev - curr) < 4
  end

  def is_safe([], _, _, _) do
    true
  end

  def is_safe([n | tl], prev, asc, joker_used) do
    # IO.puts("#{prev} -> #{n} (asc: #{asc}): #{check_values(prev, n)} (joker? #{joker_used})")

    result =
      cond do
        n == prev -> false
        asc && n < prev -> false
        !asc && n > prev -> false
        true -> check_values(prev, n)
      end

    cond do
      !result && !joker_used -> is_safe(tl, prev, asc, true)
      result -> is_safe(tl, n, asc, joker_used)
      true -> result
    end
  end

  def is_safe([n | [o | tl]]) do
    is_safe([o | tl], n, n < o, true)
  end

  # 4, 1, 5, 7, 9

  def is_safe_dampened([n | [o | tl]]) do
    result = is_safe([o | tl], n, n < o, false)

    result =
      if !result do
        # Check without joker and first number removed
        is_safe([o | tl])
      else
        result
      end

    if !result do
      # Check without joker and second number removed instead
      is_safe([n | tl])
    else
      result
    end
  end

  def parse_line(line) do
    line
    |> String.split(" ")
    |> Enum.map(fn n -> String.to_integer(n) end)
  end

  def solve1(input) do
    input
    |> Enum.map(fn l -> Day2.parse_line(l) end)
    |> Enum.map(fn l -> is_safe(l) end)
    |> Enum.count(fn l -> l end)
  end

  def solve2(input) do
    input
    |> Enum.map(fn l -> Day2.parse_line(l) end)
    |> Enum.map(fn l -> is_safe_dampened(l) end)
    |> Enum.count(fn l -> l end)
  end
end

IO.puts("Testing examples pt 1")

assert(Day2.is_safe([7, 6, 4, 2, 1]))
assert(!Day2.is_safe([1, 2, 7, 8, 9]))
assert(!Day2.is_safe([9, 7, 6, 2, 1]))
assert(!Day2.is_safe([1, 3, 2, 4, 5]))
assert(!Day2.is_safe([8, 6, 4, 4, 1]))
assert(Day2.is_safe([1, 3, 6, 7, 9]))

assert(
  2 =
    Day2.solve1([
      "7 6 4 2 1",
      "1 2 7 8 9",
      "9 7 6 2 1",
      "1 3 2 4 5",
      "8 6 4 4 1",
      "1 3 6 7 9"
    ])
)

IO.puts("Ok")

input = Utils.read_lines("day2.in")
result = Day2.solve1(input)
IO.puts("Result pt1: #{result}")

IO.puts("Testing examples pt2")
assert(Day2.is_safe_dampened([7, 6, 4, 2, 1]))
assert(!Day2.is_safe_dampened([1, 2, 7, 8, 9]))
assert(!Day2.is_safe_dampened([9, 7, 6, 2, 1]))
assert(Day2.is_safe_dampened([1, 3, 2, 4, 5]))
assert(Day2.is_safe_dampened([8, 6, 4, 4, 1]))
assert(Day2.is_safe_dampened([1, 3, 6, 7, 9]))

# Some more edge cases for testing
assert(Day2.is_safe_dampened([1, 3, 6, 7, 10]))
assert(Day2.is_safe_dampened([1, 3, 6, 7, 7]))
assert(Day2.is_safe_dampened([1, 3, 6, 7, 6]))
assert(Day2.is_safe_dampened([1, 1, 3, 6, 7, 9]))
assert(Day2.is_safe_dampened([2, 1, 4, 5, 6, 7, 9]))

# These cases got me very confused for a second, lol
assert(Day2.is_safe_dampened([4, 3, 6, 7, 9]))
assert(Day2.is_safe_dampened([4, 1, 5, 7, 9]))

assert(
  4 =
    Day2.solve2([
      "7 6 4 2 1",
      "1 2 7 8 9",
      "9 7 6 2 1",
      "1 3 2 4 5",
      "8 6 4 4 1",
      "1 3 6 7 9"
    ])
)

IO.puts("Ok")

result = Day2.solve2(input)
IO.puts("Result pt2: #{result}")
