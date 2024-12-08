import ExUnit.Assertions
Code.require_file("utils.exs")

defmodule Day8 do
  def get_antinodes({{x1, y1}, {x2, y2}}, {xmax, ymax}) do
    {dx, dy} = {x2 - x1, y2 - y1}

    [
      {x1 + dx, y1 + dy},
      {x2 + dx, y2 + dy},
      {x1 - dx, y1 - dy},
      {x2 - dx, y2 - dy}
    ]
    |> Enum.filter(fn {x, y} -> (x != x1 || y != y1) && (x != x2 || y != y2) end)
    |> Enum.filter(fn {x, y} -> x >= 0 && x < xmax && y >= 0 && y < ymax end)
  end

  def get_antennas_in_line(line, y) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {c, _} -> c != "." end)
    |> Enum.reduce(%{}, fn {c, x}, map ->
      Map.update(map, c, [{x, y}], fn n -> [{x, y} | n] end)
    end)
  end

  def get_antennas(lines) do
    lines
    |> Enum.with_index()
    |> Enum.map(fn {l, y} -> get_antennas_in_line(l, y) end)
    |> Enum.reduce(%{}, fn map, acc ->
      map
      |> Map.merge(acc, fn _, l1, l2 -> l1 ++ l2 end)
    end)
  end

  def solve1(input) do
    bounds = {String.length(Enum.at(input, 0)), length(input)}

    map =
      input
      |> get_antennas()

    map
    |> Map.values()
    |> Enum.filter(fn l -> length(l) > 1 end)
    |> Enum.map(&Utils.pairwise_unique/1)
    |> List.flatten()
    |> Enum.map(fn n -> Day8.get_antinodes(n, bounds) end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  def get_resonant_antinodes({{x1, y1}, {x2, y2}}, {xmax, ymax}) do
    {dx, dy} = {x2 - x1, y2 - y1}

    for i <- 1..xmax do
      [
        {x1 + i * dx, y1 + i * dy},
        {x2 + i * dx, y2 + i * dy},
        {x1 - i * dx, y1 - i * dy},
        {x2 - i * dx, y2 - i * dy}
      ]
    end
    |> List.flatten()
    |> Enum.filter(fn {x, y} -> x >= 0 && x < xmax && y >= 0 && y < ymax end)
  end

  def solve2(input) do
    bounds = {String.length(Enum.at(input, 0)), length(input)}

    map =
      input
      |> get_antennas()

    map
    |> Map.values()
    |> Enum.filter(fn l -> length(l) > 1 end)
    |> Enum.map(&Utils.pairwise_unique/1)
    |> List.flatten()
    |> Enum.map(fn n -> Day8.get_resonant_antinodes(n, bounds) end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end
end

testinput1 = [
  "............",
  "........0...",
  ".....0......",
  ".......0....",
  "....0.......",
  "......A.....",
  "............",
  "............",
  "........A...",
  ".........A..",
  "............",
  "............"
]

testinput2 = [
  "..........",
  "..........",
  "..........",
  "....a.....",
  "..........",
  ".....a....",
  "..........",
  "..........",
  "..........",
  ".........."
]

IO.puts("Testing examples pt 1")

assert(
  %{"a" => [{8, 0}, {4, 0}]} =
    Day8.get_antennas_in_line("....a...a....", 0)
)

assert(
  %{"a" => [{5, 5}, {4, 3}]} =
    Day8.get_antennas(testinput2)
)

assert(
  [{3, 1}, {6, 7}] =
    Day8.get_antinodes({{5, 5}, {4, 3}}, {99, 99})
    |> Enum.sort()
)

assert(
  [{3, 1}, {6, 7}] =
    Day8.get_antinodes({{4, 3}, {5, 5}}, {99, 99})
    |> Enum.sort()
)

assert(2 = Day8.solve1(testinput2))

assert(
  2 =
    Day8.solve1([
      "..........",
      "..........",
      "..........",
      "....1.....",
      "..........",
      "....1.....",
      "..........",
      "..........",
      "..........",
      ".........."
    ])
)

assert(
  4 =
    Day8.solve1([
      "..........",
      "..........",
      "..........",
      "....a.....",
      "........a.",
      ".....a....",
      "..........",
      "..........",
      "..........",
      ".........."
    ])
)

assert(
  4 =
    Day8.solve1([
      "..........",
      "..........",
      "..........",
      "....a.....",
      "........a.",
      ".....a....",
      "..........",
      "........A.",
      "..........",
      ".........."
    ])
)

assert(
  6 =
    Day8.solve1([
      "..........",
      "..........",
      "..........",
      "....a.....",
      "........a.",
      "..2..a....",
      "..........",
      "..2.......",
      "..........",
      ".........."
    ])
)

assert(14 = Day8.solve1(testinput1))

IO.puts("Ok")

input = Utils.read_lines("day8.in")
result = Day8.solve1(input)
IO.puts("Result pt1: #{result}")

IO.puts("Testing examples pt 2")

assert(
  9 =
    Day8.solve2([
      "T.........",
      "...T......",
      ".T........",
      "..........",
      "..........",
      "..........",
      "..........",
      "..........",
      "..........",
      ".........."
    ])
)

assert(
  34 =
    Day8.solve2(testinput1)
)

IO.puts("Ok")

input = Utils.read_lines("day8.in")
result = Day8.solve2(input)
IO.puts("Result pt1: #{result}")
