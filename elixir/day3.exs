import ExUnit.Assertions
Code.require_file("utils.exs")

defmodule Day3 do
  def find_all_muls(string) do
    ~r/mul\(\d{1,3},\d{1,3}\)/
    |> Regex.scan(string)
  end

  def find_all_muls_cond(string) do
    ~r/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/
    |> Regex.scan(string)
  end

  def execute_mul(mul) do
    mul
    #             mul(                    )
    |> String.slice(4, String.length(mul) - 1 - 4)
    |> String.split(",")
    |> Enum.reduce(1, fn d, acc -> acc * String.to_integer(d) end)
  end

  def reduce_cond("do()", {acc, _}) do
    {acc, true}
  end

  def reduce_cond("don't()", {acc, _}) do
    {acc, false}
  end

  def reduce_cond(line, {acc, true}) do
    {acc + execute_mul(line), true}
  end

  def reduce_cond(_, {acc, false}) do
    {acc, false}
  end

  def solve1(input) do
    input
    |> Day3.find_all_muls()
    |> List.flatten()
    |> Enum.reduce(0, fn m, acc -> acc + execute_mul(m) end)
  end

  def solve2(input) do
    input
    |> Day3.find_all_muls_cond()
    |> List.flatten()
    |> Enum.reduce({0, true}, &Day3.reduce_cond/2)
    |> (&elem(&1, 0)).()
  end
end

IO.puts("Testing examples pt 1")

assert(8 = Day3.solve1("xmul(2,4)"))

assert(
  161 = Day3.solve1("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
)

IO.puts("Ok")

input = Utils.read_string("day3.in")
result = Day3.solve1(input)
IO.puts("Result pt1: #{result}")

IO.puts("Testing examples pt 2")

assert(
  48 = Day3.solve2("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
)

IO.puts("Ok")

input = Utils.read_string("day3.in")
result = Day3.solve2(input)
IO.puts("Result pt2: #{result}")
