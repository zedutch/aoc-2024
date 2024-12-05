import ExUnit.Assertions
Code.require_file("utils.exs")

defmodule Day5 do
  def split_input(input) do
    input =
      input
      |> Enum.map(&String.trim/1)

    {first, second} =
      case Enum.find_index(input, fn x -> String.length(x) == 0 end) do
        nil -> raise "Invalid input: input should contain an empty line somewhere"
        idx -> Enum.split(input, idx)
      end

    {first,
     second
     |> Enum.filter(fn x -> String.length(x) > 0 end)}
  end

  def build_rules(lines) do
    lines
    |> Enum.map(fn l -> String.split(l, "|") end)
    |> Enum.reduce(%{}, fn [k, v], map ->
      Map.update(map, String.to_integer(k), [String.to_integer(v)], fn a ->
        [String.to_integer(v) | a]
      end)
    end)
  end

  def build_updates(lines) do
    lines
    |> Enum.map(fn l ->
      String.split(l, ",")
      |> Enum.map(fn v -> String.to_integer(v) end)
    end)
  end

  def is_member(map, key, value) do
    case Map.get(map, key) do
      nil -> false
      l -> Enum.member?(l, value)
    end
  end

  def is_correct([_], _) do
    true
  end

  def is_correct([hd | tl], rules) do
    count =
      tl
      |> Enum.filter(fn n -> is_member(rules, n, hd) end)
      |> Enum.count()

    count == 0 && is_correct(tl, rules)
  end

  def filter_correct(updates, rules, is_correct) do
    updates
    |> Enum.filter(fn l -> Day5.is_correct(l, rules) == is_correct end)
  end

  def get_middle(line) do
    middle =
      trunc(Enum.count(line) / 2)

    Enum.at(line, middle)
  end

  def solve1(input) do
    {input1, input2} =
      input
      |> split_input()

    rules =
      build_rules(input1)

    build_updates(input2)
    |> filter_correct(rules, true)
    |> Enum.map(&Day5.get_middle/1)
    |> Enum.sum()
  end

  def correct_line([hd], _, result) do
    [hd | result]
  end

  def correct_line([hd | tl], rules, result) do
    count =
      tl
      |> Enum.filter(fn n -> is_member(rules, n, hd) end)
      |> Enum.count()

    if count != 0 do
      # If this order is incorrect, move hd to back and try again
      correct_line(tl ++ [hd], rules, result)
    else
      # If this order is correct, prepend hd to the result
      correct_line(tl, rules, [hd | result])
    end
  end

  def correct_updates(updates, rules) do
    updates
    |> Enum.map(fn l -> correct_line(l, rules, []) end)
  end

  def solve2(input) do
    {input1, input2} =
      input
      |> split_input()

    rules =
      build_rules(input1)

    build_updates(input2)
    |> filter_correct(rules, false)
    |> correct_updates(rules)
    |> Enum.map(&Day5.get_middle/1)
    |> Enum.sum()
  end
end

# IO.puts("Testing examples pt 1")
#
# assert(
#   143 =
#     Day5.solve1([
#       "47|53",
#       "97|13",
#       "97|61",
#       "97|47",
#       "75|29",
#       "61|13",
#       "75|53",
#       "29|13",
#       "97|29",
#       "53|29",
#       "61|53",
#       "97|53",
#       "61|29",
#       "47|13",
#       "75|47",
#       "97|75",
#       "47|61",
#       "75|61",
#       "47|29",
#       "75|13",
#       "53|13",
#       "",
#       "75,47,61,53,29",
#       "97,61,53,29,13",
#       "75,29,13",
#       "75,97,47,61,53",
#       "61,13,29",
#       "97,13,75,29,47"
#     ])
# )
#
# IO.puts("Ok")
#
# input = Utils.read_lines("day5.in")
# result = Day5.solve1(input)
# IO.puts("Result pt1: #{result}")

IO.puts("Testing examples pt 2")

assert(
  123 =
    Day5.solve2([
      "47|53",
      "97|13",
      "97|61",
      "97|47",
      "75|29",
      "61|13",
      "75|53",
      "29|13",
      "97|29",
      "53|29",
      "61|53",
      "97|53",
      "61|29",
      "47|13",
      "75|47",
      "97|75",
      "47|61",
      "75|61",
      "47|29",
      "75|13",
      "53|13",
      "",
      "75,47,61,53,29",
      "97,61,53,29,13",
      "75,29,13",
      "75,97,47,61,53",
      "61,13,29",
      "97,13,75,29,47"
    ])
)

IO.puts("Ok")

input = Utils.read_lines("day5.in")
result = Day5.solve2(input)
IO.puts("Result pt2: #{result}")
